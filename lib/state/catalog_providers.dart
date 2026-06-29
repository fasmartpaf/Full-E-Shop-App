import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/catalog_repository.dart';
import '../data/mock_catalog.dart';
import '../models/product.dart';

enum SortOption { featured, priceLow, priceHigh, rating }

final categoriesProvider = Provider<List<Category>>((_) => MockCatalog.categories);

/// All products from the Firestore-backed catalog (mock fallback).
final allProductsProvider =
    Provider<List<Product>>((ref) => ref.watch(catalogProvider));

final productByIdProvider = Provider.family<Product, String>((ref, id) {
  final list = ref.watch(catalogProvider);
  return list.firstWhere((p) => p.id == id, orElse: () => MockCatalog.byId(id));
});

/// Home-screen rails, derived from the live catalog.
final featuredProductsProvider = Provider<List<Product>>((ref) =>
    ref.watch(catalogProvider).where((p) => p.badge == 'Best seller').toList());

final dealProductsProvider = Provider<List<Product>>(
    (ref) => ref.watch(catalogProvider).where((p) => p.onSale).toList());

final newArrivalsProvider = Provider<List<Product>>((ref) =>
    ref.watch(catalogProvider).where((p) => p.badge == 'New').toList());

/// Search query (used on the Search screen).
final searchQueryProvider = StateProvider<String>((_) => '');

/// Selected category filter (used on Search / Category screens).
final selectedCategoryProvider = StateProvider<String>((_) => 'all');

final sortOptionProvider = StateProvider<SortOption>((_) => SortOption.featured);

/// Max price filter; null = no cap.
final maxPriceProvider = StateProvider<double?>((_) => null);

/// Catalog filtered + sorted by the active query/category/sort/price.
final filteredProductsProvider = Provider<List<Product>>((ref) {
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();
  final category = ref.watch(selectedCategoryProvider);
  final sort = ref.watch(sortOptionProvider);
  final maxPrice = ref.watch(maxPriceProvider);
  final all = ref.watch(catalogProvider);

  var list = category == 'all'
      ? all
      : all.where((p) => p.categoryId == category).toList();

  if (query.isNotEmpty) {
    list = list
        .where((p) =>
            p.name.toLowerCase().contains(query) ||
            p.brand.toLowerCase().contains(query) ||
            p.description.toLowerCase().contains(query))
        .toList();
  }

  if (maxPrice != null) {
    list = list.where((p) => p.price <= maxPrice).toList();
  }

  final sorted = [...list];
  switch (sort) {
    case SortOption.priceLow:
      sorted.sort((a, b) => a.price.compareTo(b.price));
    case SortOption.priceHigh:
      sorted.sort((a, b) => b.price.compareTo(a.price));
    case SortOption.rating:
      sorted.sort((a, b) => b.rating.compareTo(a.rating));
    case SortOption.featured:
      sorted.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
  }
  return sorted;
});
