import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/mock_catalog.dart';
import '../../state/catalog_providers.dart';
import '../home/home_screen.dart';

class CategoryScreen extends ConsumerWidget {
  const CategoryScreen({super.key, required this.categoryId});

  final String categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = MockCatalog.categoryById(categoryId);
    // Ensure the filter reflects this category, then read filtered list.
    final products = ref.watch(filteredProductsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(category.name)),
      body: products.isEmpty
          ? const EmptyState(
              icon: Icons.inventory_2_outlined,
              title: 'Nothing here yet',
              message: 'No products match the current filters.',
            )
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                    child: Text('${products.length} products',
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
                ProductSliverGrid(products: products),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
              ],
            ),
    );
  }
}
