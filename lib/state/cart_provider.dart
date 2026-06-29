import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

/// Simple coupon table for the simulated checkout.
const _coupons = <String, double>{
  'ARA10': 0.10,
  'WELCOME': 0.15,
};

class CartState {
  const CartState({this.items = const [], this.coupon});

  final List<CartItem> items;
  final String? coupon;

  int get count => items.fold(0, (sum, i) => sum + i.quantity);

  double get subtotal => items.fold(0, (sum, i) => sum + i.lineTotal);

  double get discountRate => coupon == null ? 0 : (_coupons[coupon] ?? 0);

  double get discount => subtotal * discountRate;

  /// Free shipping over $75, otherwise a flat fee. Free when empty.
  double get shipping => items.isEmpty || subtotal - discount >= 75 ? 0 : 6.99;

  double get total => subtotal - discount + shipping;

  bool get isEmpty => items.isEmpty;

  CartState copyWith({List<CartItem>? items, Object? coupon = _sentinel}) =>
      CartState(
        items: items ?? this.items,
        coupon: coupon == _sentinel ? this.coupon : coupon as String?,
      );

  static const _sentinel = Object();
}

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(const CartState());

  void add(Product product, {int quantity = 1, String? color, String? size}) {
    final item = CartItem(
      product: product,
      quantity: quantity,
      color: color,
      size: size,
    );
    final items = [...state.items];
    final idx = items.indexWhere((i) => i.key == item.key);
    if (idx >= 0) {
      items[idx] = items[idx].copyWith(quantity: items[idx].quantity + quantity);
    } else {
      items.add(item);
    }
    state = state.copyWith(items: items);
  }

  void setQuantity(String key, int quantity) {
    if (quantity <= 0) {
      remove(key);
      return;
    }
    final items = [
      for (final i in state.items)
        if (i.key == key) i.copyWith(quantity: quantity) else i
    ];
    state = state.copyWith(items: items);
  }

  void increment(String key) {
    final item = state.items.firstWhere((i) => i.key == key);
    setQuantity(key, item.quantity + 1);
  }

  void decrement(String key) {
    final item = state.items.firstWhere((i) => i.key == key);
    setQuantity(key, item.quantity - 1);
  }

  void remove(String key) {
    state = state.copyWith(items: state.items.where((i) => i.key != key).toList());
  }

  /// Returns true if the code was valid.
  bool applyCoupon(String code) {
    final normalized = code.trim().toUpperCase();
    if (_coupons.containsKey(normalized)) {
      state = state.copyWith(coupon: normalized);
      return true;
    }
    return false;
  }

  void removeCoupon() => state = state.copyWith(coupon: null);

  void clear() => state = const CartState();
}

final cartProvider =
    StateNotifierProvider<CartNotifier, CartState>((_) => CartNotifier());

final cartCountProvider = Provider<int>((ref) => ref.watch(cartProvider).count);
