import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/order.dart';
import '../../shared/format.dart';
import '../../shared/widgets/product_image.dart';
import '../../state/orders_provider.dart';
import '../../theme/app_theme.dart';

class OrderDetailScreen extends ConsumerWidget {
  const OrderDetailScreen({super.key, required this.orderId});

  final String orderId;

  Order? _find(WidgetRef ref) {
    final all = [...ref.watch(orderHistoryProvider), ...ref.watch(ordersProvider)];
    for (final o in all) {
      if (o.id == orderId) return o;
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = _find(ref);

    return Scaffold(
      appBar: AppBar(title: Text(order?.id ?? 'Order')),
      body: order == null
          ? const Center(child: Text('Order not found'))
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              children: [
                _StatusTimeline(status: order.status),
                const SizedBox(height: 20),
                _Section(
                  title: 'Items (${order.itemCount})',
                  child: Column(
                    children: [
                      for (final item in order.items)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 56,
                                height: 56,
                                child: ProductImage(
                                    icon: item.product.icon,
                                    tintIndex: item.product.tintIndex,
                                    imageUrl: item.product.imageUrl,
                                    iconSize: 24,
                                    radius: 12),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.product.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700)),
                                    Text('Qty ${item.quantity}',
                                        style: const TextStyle(
                                            color: AppColors.inkMuted,
                                            fontSize: 12.5)),
                                  ],
                                ),
                              ),
                              Text(money(item.lineTotal),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                _Section(
                  title: 'Delivery address',
                  child: Text(order.address,
                      style: const TextStyle(height: 1.45)),
                ),
                const SizedBox(height: 14),
                _Section(
                  title: 'Payment summary',
                  child: Column(
                    children: [
                      _row('Subtotal', money(order.subtotal)),
                      if (order.discount > 0)
                        _row('Discount', '-${money(order.discount)}',
                            color: AppColors.success),
                      _row('Shipping',
                          order.shipping == 0 ? 'Free' : money(order.shipping)),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Divider(height: 1),
                      ),
                      _row('Total', money(order.total), bold: true),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                OutlinedButton.icon(
                  onPressed: () => context.go('/'),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Buy again'),
                ),
              ],
            ),
    );
  }

  Widget _row(String l, String v, {bool bold = false, Color? color}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          children: [
            Text(l,
                style: TextStyle(
                    color: bold ? AppColors.ink : AppColors.inkMuted,
                    fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
                    fontSize: bold ? 16 : 14)),
            const Spacer(),
            Text(v,
                style: TextStyle(
                    color: color ?? AppColors.ink,
                    fontWeight: bold ? FontWeight.w800 : FontWeight.w700,
                    fontSize: bold ? 17 : 14)),
          ],
        ),
      );
}

class _StatusTimeline extends StatelessWidget {
  const _StatusTimeline({required this.status});
  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    const steps = [
      ('Placed', Icons.receipt_long_rounded),
      ('Processing', Icons.inventory_2_outlined),
      ('Shipped', Icons.local_shipping_outlined),
      ('Delivered', Icons.check_circle_outline_rounded),
    ];
    final activeIndex = switch (status) {
      OrderStatus.processing => 1,
      OrderStatus.shipped => 2,
      OrderStatus.delivered => 3,
    };

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          for (var i = 0; i < steps.length; i++) ...[
            Expanded(
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: i <= activeIndex
                          ? AppColors.brand
                          : AppColors.brand.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(steps[i].$2,
                        size: 20,
                        color:
                            i <= activeIndex ? Colors.white : AppColors.inkMuted),
                  ),
                  const SizedBox(height: 6),
                  Text(steps[i].$1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: i <= activeIndex
                              ? AppColors.ink
                              : AppColors.inkMuted)),
                ],
              ),
            ),
            if (i < steps.length - 1)
              Container(
                width: 18,
                height: 2,
                margin: const EdgeInsets.only(bottom: 18),
                color: i < activeIndex ? AppColors.brand : AppColors.line,
              ),
          ],
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
