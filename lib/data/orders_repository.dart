import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/cart_item.dart';
import '../models/order.dart';
import 'mock_catalog.dart';

/// Persists orders to Firestore under `users/{uid}/orders`.
/// Product details are reconstructed from the local catalog by id, so the
/// stored document stays small (ids + quantities + variant + totals).
class OrdersRepository {
  OrdersRepository(this._uid);

  final String _uid;

  CollectionReference<Map<String, dynamic>> get _col => FirebaseFirestore
      .instance
      .collection('users')
      .doc(_uid)
      .collection('orders');

  Future<void> add(Order order) async {
    await _col.doc(order.id).set({
      'id': order.id,
      'subtotal': order.subtotal,
      'shipping': order.shipping,
      'discount': order.discount,
      'total': order.total,
      'placedAt': Timestamp.fromDate(order.placedAt),
      'status': order.status.name,
      'address': order.address,
      'items': order.items
          .map((i) => {
                'productId': i.product.id,
                'quantity': i.quantity,
                'color': i.color,
                'size': i.size,
              })
          .toList(),
    });
  }

  Stream<List<Order>> watch() {
    return _col
        .orderBy('placedAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => _fromDoc(d.data())).toList());
  }

  Order _fromDoc(Map<String, dynamic> data) {
    final items = (data['items'] as List<dynamic>? ?? [])
        .map((raw) {
          final m = raw as Map<String, dynamic>;
          return CartItem(
            product: MockCatalog.byId(m['productId'] as String? ?? ''),
            quantity: (m['quantity'] as num?)?.toInt() ?? 1,
            color: m['color'] as String?,
            size: m['size'] as String?,
          );
        })
        .toList();

    return Order(
      id: data['id'] as String? ?? '—',
      items: items,
      subtotal: (data['subtotal'] as num?)?.toDouble() ?? 0,
      shipping: (data['shipping'] as num?)?.toDouble() ?? 0,
      discount: (data['discount'] as num?)?.toDouble() ?? 0,
      total: (data['total'] as num?)?.toDouble() ?? 0,
      placedAt: (data['placedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: OrderStatus.values.firstWhere(
        (s) => s.name == data['status'],
        orElse: () => OrderStatus.processing,
      ),
      address: data['address'] as String? ?? '',
    );
  }
}
