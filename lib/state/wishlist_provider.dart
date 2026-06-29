import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mock_catalog.dart';
import '../models/product.dart';

class WishlistNotifier extends StateNotifier<Set<String>> {
  WishlistNotifier() : super({'p4', 'p9'});

  void toggle(String productId) {
    final next = {...state};
    if (!next.add(productId)) next.remove(productId);
    state = next;
  }

  void add(String productId) {
    state = {...state, productId};
  }

  void remove(String productId) {
    state = {...state}..remove(productId);
  }

  bool contains(String id) => state.contains(id);
}

final wishlistProvider =
    StateNotifierProvider<WishlistNotifier, Set<String>>((_) => WishlistNotifier());

final wishlistProductsProvider = Provider<List<Product>>((ref) {
  final ids = ref.watch(wishlistProvider);
  return ids.map(MockCatalog.byId).toList();
});
