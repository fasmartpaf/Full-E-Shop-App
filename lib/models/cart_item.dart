import 'product.dart';

class CartItem {
  const CartItem({
    required this.product,
    required this.quantity,
    this.color,
    this.size,
  });

  final Product product;
  final int quantity;
  final String? color;
  final String? size;

  double get lineTotal => product.price * quantity;

  /// Identity of a cart line = product + chosen variant.
  String get key => '${product.id}|${color ?? ''}|${size ?? ''}';

  CartItem copyWith({int? quantity}) => CartItem(
        product: product,
        quantity: quantity ?? this.quantity,
        color: color,
        size: size,
      );
}
