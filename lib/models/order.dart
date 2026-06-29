import 'cart_item.dart';

enum OrderStatus { processing, shipped, delivered }

class Order {
  const Order({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.shipping,
    required this.discount,
    required this.total,
    required this.placedAt,
    required this.status,
    required this.address,
  });

  final String id;
  final List<CartItem> items;
  final double subtotal;
  final double shipping;
  final double discount;
  final double total;
  final DateTime placedAt;
  final OrderStatus status;
  final String address;

  int get itemCount => items.fold(0, (sum, i) => sum + i.quantity);

  String get statusLabel => switch (status) {
        OrderStatus.processing => 'Processing',
        OrderStatus.shipped => 'Shipped',
        OrderStatus.delivered => 'Delivered',
      };
}
