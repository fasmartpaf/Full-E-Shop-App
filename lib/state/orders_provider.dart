import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mock_catalog.dart';
import '../data/orders_repository.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import 'auth_provider.dart';
import 'cart_provider.dart';
import 'firebase_status.dart';

class OrdersNotifier extends StateNotifier<List<Order>> {
  OrdersNotifier() : super([]);

  int _seq = 1042;

  /// Turns the current cart into a placed order and returns it (in-memory).
  Order placeFrom(CartState cart, String address) {
    final order = Order(
      id: 'ARA-${_seq++}',
      items: List<CartItem>.from(cart.items),
      subtotal: cart.subtotal,
      shipping: cart.shipping,
      discount: cart.discount,
      total: cart.total,
      placedAt: DateTime.now(),
      status: OrderStatus.processing,
      address: address,
    );
    state = [order, ...state];
    return order;
  }
}

/// In-memory orders (guest sessions / Firebase-off fallback).
final ordersProvider =
    StateNotifierProvider<OrdersNotifier, List<Order>>((_) => OrdersNotifier());

/// Live orders from Firestore for the signed-in user.
final firestoreOrdersProvider = StreamProvider.autoDispose<List<Order>>((ref) {
  return Stream<List<Order>>.value(const []);
});

/// What the UI reads: Firestore when signed in, in-memory otherwise.
final orderHistoryProvider = Provider<List<Order>>((ref) {
  final user = ref.watch(currentUserProvider);
  final ready = ref.watch(firebaseReadyProvider);
  if (ready && user != null) {
    return ref.watch(firestoreOrdersProvider).asData?.value ?? const [];
  }
  return ref.watch(ordersProvider);
});

/// Alias for common usage.
final userOrdersProvider = Provider<List<Order>>((ref) {
  return ref.watch(orderHistoryProvider);
});

/// Places an order from the cart: records locally (so the confirmation screen works).
Future<Order> placeOrder(WidgetRef ref, CartState cart, String address) async {
  final order = ref.read(ordersProvider.notifier).placeFrom(cart, address);
  return order;
}
