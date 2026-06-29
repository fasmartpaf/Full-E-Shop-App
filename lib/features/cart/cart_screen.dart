import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/cart_item.dart';
import '../../shared/format.dart';
import '../../shared/widgets/product_image.dart';
import '../../shared/widgets/quantity_selector.dart';
import '../../state/cart_provider.dart';
import '../../theme/app_theme.dart';
import '../home/home_screen.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          if (!cart.isEmpty)
            TextButton(
              onPressed: () => ref.read(cartProvider.notifier).clear(),
              child: const Text('Clear'),
            ),
        ],
      ),
      body: cart.isEmpty
          ? EmptyState(
              icon: Icons.shopping_bag_outlined,
              title: 'Your cart is empty',
              message: 'Browse the store and add items you love.',
              action: FilledButton(
                onPressed: () => context.go('/'),
                style: FilledButton.styleFrom(
                    minimumSize: const Size(180, 50)),
                child: const Text('Start shopping'),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: cart.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) =>
                        _CartTile(item: cart.items[i]),
                  ),
                ),
                _CouponField(cart: cart),
                _Summary(cart: cart),
              ],
            ),
    );
  }
}

class _CartTile extends ConsumerWidget {
  const _CartTile({required this.item});
  final CartItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(cartProvider.notifier);
    final variant = [item.color, item.size].whereType<String>().join(' · ');

    return Dismissible(
      key: ValueKey(item.key),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => notifier.remove(item.key),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 22),
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(AppTheme.radius),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppTheme.radius),
          border: Border.all(color: AppColors.line),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 76,
              height: 76,
              child: ProductImage(
                  icon: item.product.icon,
                  tintIndex: item.product.tintIndex,
                  iconSize: 30,
                  radius: 12),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14)),
                  if (variant.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(variant,
                        style: const TextStyle(
                            color: AppColors.inkMuted, fontSize: 12.5)),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(money(item.product.price),
                          style: const TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 15)),
                      const Spacer(),
                      QuantitySelector(
                        compact: true,
                        quantity: item.quantity,
                        onChanged: (v) => notifier.setQuantity(item.key, v),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CouponField extends ConsumerStatefulWidget {
  const _CouponField({required this.cart});
  final CartState cart;

  @override
  ConsumerState<_CouponField> createState() => _CouponFieldState();
}

class _CouponFieldState extends ConsumerState<_CouponField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final coupon = widget.cart.coupon;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
      child: coupon != null
          ? Row(
              children: [
                const Icon(Icons.local_offer_rounded,
                    color: AppColors.success, size: 18),
                const SizedBox(width: 8),
                Text('Coupon "$coupon" applied',
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.success)),
                const Spacer(),
                TextButton(
                  onPressed: () =>
                      ref.read(cartProvider.notifier).removeCoupon(),
                  child: const Text('Remove'),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textCapitalization: TextCapitalization.characters,
                    decoration: const InputDecoration(
                      hintText: 'Promo code (try ARA10)',
                      prefixIcon: Icon(Icons.local_offer_outlined),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 52,
                  child: OutlinedButton(
                    onPressed: () {
                      final ok = ref
                          .read(cartProvider.notifier)
                          .applyCoupon(_controller.text);
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text(
                              ok ? 'Coupon applied' : 'Invalid promo code'),
                        ));
                    },
                    style: OutlinedButton.styleFrom(
                        minimumSize: const Size(88, 52)),
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.cart});
  final CartState cart;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _row('Subtotal', money(cart.subtotal)),
            if (cart.discount > 0)
              _row('Discount', '-${money(cart.discount)}',
                  color: AppColors.success),
            _row('Shipping',
                cart.shipping == 0 ? 'Free' : money(cart.shipping)),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Divider(),
            ),
            _row('Total', money(cart.total), bold: true),
            const SizedBox(height: 14),
            FilledButton(
              onPressed: () => context.push('/checkout'),
              child: Text('Checkout · ${money(cart.total)}'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value,
      {bool bold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: bold ? 17 : 14,
                  color: bold ? AppColors.ink : AppColors.inkMuted,
                  fontWeight: bold ? FontWeight.w800 : FontWeight.w600)),
          const Spacer(),
          Text(value,
              style: TextStyle(
                  fontSize: bold ? 19 : 14,
                  color: color ?? AppColors.ink,
                  fontWeight: bold ? FontWeight.w800 : FontWeight.w700)),
        ],
      ),
    );
  }
}
