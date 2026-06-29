import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../shared/format.dart';
import '../../shared/widgets/product_image.dart';
import '../../shared/widgets/quantity_selector.dart';
import '../../shared/widgets/rating_stars.dart';
import '../../state/cart_provider.dart';
import '../../state/catalog_providers.dart';
import '../../state/wishlist_provider.dart';
import '../../theme/app_theme.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final String productId;

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int _qty = 1;
  String? _color;
  String? _size;

  @override
  Widget build(BuildContext context) {
    final product = ref.watch(productByIdProvider(widget.productId));
    final liked = ref.watch(wishlistProvider).contains(product.id);

    _color ??= product.colors.isNotEmpty ? product.colors.first : null;
    _size ??= product.sizes.isNotEmpty ? product.sizes.first : null;

    void addToCart({bool buyNow = false}) {
      ref.read(cartProvider.notifier).add(
            product,
            quantity: _qty,
            color: _color,
            size: _size,
          );
      if (buyNow) {
        context.go('/cart');
      } else {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Added to cart'),
          ));
      }
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 320,
            backgroundColor: AppColors.canvas,
            leading: const _RoundIcon(icon: Icons.arrow_back_rounded, pop: true),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _RoundIcon(
                  icon: liked
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: liked ? AppColors.accent : null,
                  onTap: () =>
                      ref.read(wishlistProvider.notifier).toggle(product.id),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.fromLTRB(16, 70, 16, 12),
                child: ProductImage(
                  icon: product.icon,
                  tintIndex: product.tintIndex,
                  iconSize: 96,
                  radius: 24,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.brand.toUpperCase(),
                      style: const TextStyle(
                          color: AppColors.inkMuted,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                          fontSize: 12)),
                  const SizedBox(height: 6),
                  Text(product.name,
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          height: 1.15)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      RatingStars(
                          rating: product.rating,
                          reviewCount: product.reviewCount),
                      const Spacer(),
                      if (product.inStock)
                        const _Pill(
                            label: 'In stock', color: AppColors.success)
                      else
                        const _Pill(
                            label: 'Out of stock', color: AppColors.inkMuted),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(money(product.price),
                          style: const TextStyle(
                              fontSize: 28, fontWeight: FontWeight.w800)),
                      if (product.onSale) ...[
                        const SizedBox(width: 10),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(money(product.compareAt!),
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.inkMuted,
                                  decoration: TextDecoration.lineThrough)),
                        ),
                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: _Pill(
                              label: 'Save ${product.discountPercent}%',
                              color: AppColors.accent),
                        ),
                      ],
                    ],
                  ),
                  if (product.colors.isNotEmpty) ...[
                    const SizedBox(height: 22),
                    _OptionGroup(
                      label: 'Color',
                      options: product.colors,
                      selected: _color,
                      onSelect: (v) => setState(() => _color = v),
                    ),
                  ],
                  if (product.sizes.isNotEmpty) ...[
                    const SizedBox(height: 18),
                    _OptionGroup(
                      label: 'Size',
                      options: product.sizes,
                      selected: _size,
                      onSelect: (v) => setState(() => _size = v),
                    ),
                  ],
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      const Text('Quantity',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w700)),
                      const Spacer(),
                      QuantitySelector(
                        quantity: _qty,
                        onChanged: (v) =>
                            setState(() => _qty = v.clamp(1, 9)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  const Text('Description',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  Text(product.description,
                      style: const TextStyle(
                          height: 1.5, color: Color(0xFF40434D))),
                  const SizedBox(height: 18),
                  const _PerksRow(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: product.inStock ? () => addToCart() : null,
                  child: const Text('Add to cart'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed:
                      product.inStock ? () => addToCart(buyNow: true) : null,
                  child: const Text('Buy now'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionGroup extends StatelessWidget {
  const _OptionGroup({
    required this.label,
    required this.options,
    required this.selected,
    required this.onSelect,
  });

  final String label;
  final List<String> options;
  final String? selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final o in options)
              ChoiceChip(
                label: Text(o),
                selected: o == selected,
                showCheckmark: false,
                labelStyle: TextStyle(
                  color: o == selected ? Colors.white : AppColors.ink,
                  fontWeight: FontWeight.w600,
                ),
                onSelected: (_) => onSelect(o),
              ),
          ],
        ),
      ],
    );
  }
}

class _PerksRow extends StatelessWidget {
  const _PerksRow();

  @override
  Widget build(BuildContext context) {
    Widget perk(IconData i, String t) => Expanded(
          child: Column(
            children: [
              Icon(i, color: AppColors.brand, size: 24),
              const SizedBox(height: 6),
              Text(t,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 11.5, color: AppColors.inkMuted)),
            ],
          ),
        );
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          perk(Icons.local_shipping_outlined, 'Free over \$75'),
          perk(Icons.autorenew_rounded, '30-day returns'),
          perk(Icons.verified_user_outlined, '2-year warranty'),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label,
          style: TextStyle(
              color: color, fontSize: 12, fontWeight: FontWeight.w800)),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({
    required this.icon,
    this.onTap,
    this.pop = false,
    this.color,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final bool pop;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: onTap ?? (pop ? () => context.pop() : null),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          margin: const EdgeInsets.all(6),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.line),
          ),
          child: Icon(icon, size: 20, color: color ?? AppColors.ink),
        ),
      ),
    );
  }
}
