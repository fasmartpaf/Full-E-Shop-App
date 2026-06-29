import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../state/wishlist_provider.dart';
import '../home/home_screen.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(wishlistProductsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist')),
      body: products.isEmpty
          ? EmptyState(
              icon: Icons.favorite_border_rounded,
              title: 'No saved items',
              message: 'Tap the heart on any product to save it here.',
              action: FilledButton(
                onPressed: () => context.go('/'),
                style:
                    FilledButton.styleFrom(minimumSize: const Size(180, 50)),
                child: const Text('Browse products'),
              ),
            )
          : CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: SizedBox(height: 12)),
                ProductSliverGrid(products: products),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
              ],
            ),
    );
  }
}
