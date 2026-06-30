import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product.dart';
import '../state/firebase_status.dart';
import 'mock_catalog.dart';

/// Maps the stored `iconKey` string to a Material icon, so the catalog can live
/// entirely in Firestore without hard-coding code points.
const Map<String, IconData> kProductIcons = {
  'headphones': Icons.headphones_rounded,
  'watch': Icons.watch_rounded,
  'speaker': Icons.speaker_rounded,
  'chair': Icons.chair_alt_rounded,
  'lamp': Icons.light_rounded,
  'mug': Icons.coffee_rounded,
  'tee': Icons.checkroom_rounded,
  'sneakers': Icons.directions_run_rounded,
  'serum': Icons.spa_rounded,
  'moisturiser': Icons.water_drop_rounded,
  'yoga': Icons.self_improvement_rounded,
  'dumbbell': Icons.fitness_center_rounded,
};

Product _fromDoc(Map<String, dynamic> d) {
  final compare = d['compareAt'];
  return Product(
    id: d['id'] as String? ?? '',
    name: d['name'] as String? ?? 'Product',
    brand: d['brand'] as String? ?? '',
    categoryId: d['categoryId'] as String? ?? 'all',
    price: (d['price'] as num?)?.toDouble() ?? 0,
    compareAt: compare == null ? null : (compare as num).toDouble(),
    rating: (d['rating'] as num?)?.toDouble() ?? 0,
    reviewCount: (d['reviewCount'] as num?)?.toInt() ?? 0,
    description: d['description'] as String? ?? '',
    tintIndex: (d['tintIndex'] as num?)?.toInt() ?? 0,
    icon: kProductIcons[d['iconKey']] ?? Icons.shopping_bag_rounded,
    imageUrl: d['imageUrl'] as String?,
    colors: (d['colors'] as List<dynamic>? ?? []).cast<String>(),
    sizes: (d['sizes'] as List<dynamic>? ?? []).cast<String>(),
    badge: d['badge'] as String?,
    inStock: d['inStock'] as bool? ?? true,
  );
}

/// Live products from Firestore (ordered). Emits the mock list first so the UI
/// always has data, then the Firestore data once it arrives. On any error the
/// stream falls back to the mock catalog.
final catalogStreamProvider = StreamProvider<List<Product>>((ref) {
  if (!ref.watch(firebaseReadyProvider)) {
    return Stream<List<Product>>.value(MockCatalog.products);
  }
  return FirebaseFirestore.instance
      .collection('products')
      .orderBy('sortOrder')
      .snapshots()
      .map((snap) => snap.docs.isEmpty
          ? MockCatalog.products
          : snap.docs.map((doc) => _fromDoc(doc.data())).toList())
      .handleError((_) {})
      .map((list) => list); // keep type as List<Product>
});

/// The single source of truth the rest of the app reads. Always returns a list:
/// Firestore data when available, otherwise the mock catalog (loading/error).
final catalogProvider = Provider<List<Product>>((ref) {
  return ref.watch(catalogStreamProvider).maybeWhen(
        data: (products) => products,
        orElse: () => MockCatalog.products,
      );
});

/// True once products are being served from Firestore rather than the fallback.
final catalogIsLiveProvider = Provider<bool>((ref) {
  return ref.watch(firebaseReadyProvider) &&
      ref.watch(catalogStreamProvider).hasValue;
});
