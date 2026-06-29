import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/cart_item.dart';
import '../models/order.dart';
import 'mock_catalog.dart';

class OrdersRepository {
  OrdersRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _orders(String uid) =>
      _firestore.collection('users').doc(uid).collection('orders');

  Future<void> saveOrder(String uid, Order order) async {
    await _orders(uid).doc(order.id).set(_toMap(order));
  }

  Stream<List<Order>> watchOrders(String uid) {
    return _orders(uid)
        .orderBy('placedAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(_fromDoc).toList());
  }

  Map<String, dynamic> _toMap(Order order) => {
        'id': order.id,
        'items': order.items.map(_itemToMap).toList(),
        'subtotal': order.subtotal,
        'shipping': order.shipping,
        'discount': order.discount,
        'total': order.total,
        'placedAt': Timestamp.fromDate(order.placedAt),
        'status': order.status.name,
        'address': order.address,
      };

  Map<String, dynamic> _itemToMap(CartItem item) => {
        'productId': item.product.id,
        'quantity': item.quantity,
        'color': item.color,
        'size': item.size,
      };

  Order _fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    final items = (data['items'] as List<dynamic>? ?? [])
        .map((raw) => _itemFromMap(raw as Map<String, dynamic>))
        .toList();
    return Order(
      id: data['id'] as String? ?? doc.id,
      items: items,
      subtotal: (data['subtotal'] as num?)?.toDouble() ?? 0,
      shipping: (data['shipping'] as num?)?.toDouble() ?? 0,
      discount: (data['discount'] as num?)?.toDouble() ?? 0,
      total: (data['total'] as num?)?.toDouble() ?? 0,
      placedAt: (data['placedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: _parseStatus(data['status'] as String?),
      address: data['address'] as String? ?? '',
    );
  }

  CartItem _itemFromMap(Map<String, dynamic> data) {
    final productId = data['productId'] as String? ?? '';
    return CartItem(
      product: MockCatalog.byId(productId),
      quantity: (data['quantity'] as num?)?.toInt() ?? 1,
      color: data['color'] as String?,
      size: data['size'] as String?,
    );
  }

  OrderStatus _parseStatus(String? raw) => switch (raw) {
        'shipped' => OrderStatus.shipped,
        'delivered' => OrderStatus.delivered,
        _ => OrderStatus.processing,
      };
}

final ordersRepositoryProvider = Provider<OrdersRepository>(
  (_) => OrdersRepository(FirebaseFirestore.instance),
);
