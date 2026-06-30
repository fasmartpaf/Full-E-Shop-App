import 'package:flutter/material.dart';

class Category {
  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.tintIndex,
  });

  final String id;
  final String name;
  final IconData icon;
  final int tintIndex;
}

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.categoryId,
    required this.price,
    this.compareAt,
    required this.rating,
    required this.reviewCount,
    required this.description,
    required this.tintIndex,
    required this.icon,
    this.imageUrl,
    this.colors = const [],
    this.sizes = const [],
    this.badge,
    this.inStock = true,
  });

  final String id;
  final String name;
  final String brand;
  final String categoryId;
  final double price;
  final double? compareAt; // original price when on sale
  final double rating;
  final int reviewCount;
  final String description;
  final int tintIndex;
  final IconData icon;
  final String? imageUrl;
  final List<String> colors;
  final List<String> sizes;
  final String? badge; // "New", "Best seller", etc.
  final bool inStock;

  bool get onSale => compareAt != null && compareAt! > price;

  int get discountPercent =>
      onSale ? (((compareAt! - price) / compareAt!) * 100).round() : 0;
}
