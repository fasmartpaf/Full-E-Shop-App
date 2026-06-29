import 'package:flutter/material.dart';

import '../models/product.dart';

/// Seeded, realistic catalog. Local-only mock data (no backend connected yet).
/// Replace this repository with Shopify / Supabase calls later — the rest of
/// the app only depends on [Product] / [Category].
class MockCatalog {
  static const categories = <Category>[
    Category(id: 'all', name: 'All', icon: Icons.grid_view_rounded, tintIndex: 0),
    Category(id: 'tech', name: 'Tech', icon: Icons.headphones_rounded, tintIndex: 0),
    Category(id: 'home', name: 'Home', icon: Icons.chair_alt_rounded, tintIndex: 2),
    Category(id: 'apparel', name: 'Apparel', icon: Icons.checkroom_rounded, tintIndex: 1),
    Category(id: 'beauty', name: 'Beauty', icon: Icons.spa_rounded, tintIndex: 4),
    Category(id: 'fitness', name: 'Fitness', icon: Icons.fitness_center_rounded, tintIndex: 5),
  ];

  static Category categoryById(String id) =>
      categories.firstWhere((c) => c.id == id, orElse: () => categories.first);

  static const products = <Product>[
    Product(
      id: 'p1',
      name: 'Aurora Wireless Headphones',
      brand: 'Lumen Audio',
      categoryId: 'tech',
      price: 179.00,
      compareAt: 229.00,
      rating: 4.8,
      reviewCount: 1284,
      description:
          'Adaptive noise cancellation, 40-hour battery, and plush memory-foam '
          'cups. Tuned for warm bass and crisp highs whether you are commuting '
          'or deep in focus.',
      tintIndex: 0,
      icon: Icons.headphones_rounded,
      colors: ['Graphite', 'Sand', 'Sky'],
      badge: 'Best seller',
    ),
    Product(
      id: 'p2',
      name: 'Pulse Smart Watch 2',
      brand: 'Lumen Audio',
      categoryId: 'tech',
      price: 219.00,
      rating: 4.6,
      reviewCount: 642,
      description:
          'A bright AMOLED display, multi-day battery, and 100+ workout modes. '
          'Tracks heart rate, sleep, and recovery with on-device insights.',
      tintIndex: 5,
      icon: Icons.watch_rounded,
      colors: ['Midnight', 'Silver'],
      badge: 'New',
    ),
    Product(
      id: 'p3',
      name: 'Drift Bluetooth Speaker',
      brand: 'Lumen Audio',
      categoryId: 'tech',
      price: 64.00,
      compareAt: 89.00,
      rating: 4.5,
      reviewCount: 938,
      description:
          'Pocket-sized, IP67 waterproof, and surprisingly loud. 18 hours of '
          'playback and a strap that clips anywhere.',
      tintIndex: 2,
      icon: Icons.speaker_rounded,
      colors: ['Coral', 'Forest', 'Black'],
    ),
    Product(
      id: 'p4',
      name: 'Linen Lounge Chair',
      brand: 'Norr Living',
      categoryId: 'home',
      price: 349.00,
      compareAt: 429.00,
      rating: 4.7,
      reviewCount: 211,
      description:
          'A low-slung accent chair with a solid oak frame and natural linen '
          'upholstery. Built to be the quiet centrepiece of a room.',
      tintIndex: 3,
      icon: Icons.chair_alt_rounded,
      colors: ['Oat', 'Charcoal'],
      badge: 'Best seller',
    ),
    Product(
      id: 'p5',
      name: 'Glow Ceramic Table Lamp',
      brand: 'Norr Living',
      categoryId: 'home',
      price: 78.00,
      rating: 4.4,
      reviewCount: 156,
      description:
          'Hand-finished ceramic base with a dimmable warm-white bulb and a '
          'linen shade. Soft, even light for evenings in.',
      tintIndex: 4,
      icon: Icons.light_rounded,
      colors: ['Clay', 'Cream'],
    ),
    Product(
      id: 'p6',
      name: 'Terra Stoneware Mug Set',
      brand: 'Norr Living',
      categoryId: 'home',
      price: 42.00,
      compareAt: 56.00,
      rating: 4.9,
      reviewCount: 503,
      description:
          'Set of four reactive-glaze stoneware mugs. Microwave and dishwasher '
          'safe, with a comfortable curved handle.',
      tintIndex: 1,
      icon: Icons.coffee_rounded,
    ),
    Product(
      id: 'p7',
      name: 'Everyday Oversized Tee',
      brand: 'Field & Form',
      categoryId: 'apparel',
      price: 32.00,
      rating: 4.3,
      reviewCount: 874,
      description:
          'Heavyweight organic cotton with a relaxed drape and a ribbed neck '
          'that keeps its shape wash after wash.',
      tintIndex: 1,
      icon: Icons.checkroom_rounded,
      colors: ['Bone', 'Olive', 'Navy', 'Black'],
      sizes: ['XS', 'S', 'M', 'L', 'XL'],
    ),
    Product(
      id: 'p8',
      name: 'Trail Runner Sneakers',
      brand: 'Field & Form',
      categoryId: 'apparel',
      price: 118.00,
      compareAt: 145.00,
      rating: 4.6,
      reviewCount: 421,
      description:
          'A responsive foam midsole and grippy outsole for road-to-trail days. '
          'Breathable knit upper with a locked-in heel.',
      tintIndex: 5,
      icon: Icons.directions_run_rounded,
      colors: ['Slate', 'Sand'],
      sizes: ['7', '8', '9', '10', '11', '12'],
      badge: 'New',
    ),
    Product(
      id: 'p9',
      name: 'Daily Glow Vitamin C Serum',
      brand: 'Botanica',
      categoryId: 'beauty',
      price: 38.00,
      rating: 4.7,
      reviewCount: 1592,
      description:
          'A lightweight 15% vitamin C serum with hyaluronic acid. Brightens '
          'and hydrates without stickiness. Vegan and cruelty-free.',
      tintIndex: 4,
      icon: Icons.spa_rounded,
      badge: 'Best seller',
    ),
    Product(
      id: 'p10',
      name: 'Cloud Whip Moisturiser',
      brand: 'Botanica',
      categoryId: 'beauty',
      price: 29.00,
      compareAt: 36.00,
      rating: 4.5,
      reviewCount: 688,
      description:
          'An airy gel-cream with niacinamide and ceramides for a soft, '
          'plump finish. Fragrance-free and non-comedogenic.',
      tintIndex: 0,
      icon: Icons.water_drop_rounded,
    ),
    Product(
      id: 'p11',
      name: 'Pro Grip Yoga Mat',
      brand: 'Apex Move',
      categoryId: 'fitness',
      price: 58.00,
      rating: 4.8,
      reviewCount: 932,
      description:
          'A 6mm cushioned mat with a sweat-wicking, no-slip top layer and '
          'alignment guides. Comes with a carry strap.',
      tintIndex: 2,
      icon: Icons.self_improvement_rounded,
      colors: ['Sage', 'Plum', 'Charcoal'],
    ),
    Product(
      id: 'p12',
      name: 'Adjustable Dumbbell Set',
      brand: 'Apex Move',
      categoryId: 'fitness',
      price: 289.00,
      compareAt: 349.00,
      rating: 4.7,
      reviewCount: 274,
      description:
          'Dial from 5 to 52.5 lbs per hand in seconds. Replaces 15 pairs of '
          'dumbbells and stores in a single footprint.',
      tintIndex: 3,
      icon: Icons.fitness_center_rounded,
      badge: 'Best seller',
    ),
  ];

  static List<Product> get featured =>
      products.where((p) => p.badge == 'Best seller').toList();

  static List<Product> get deals => products.where((p) => p.onSale).toList();

  static List<Product> get newArrivals =>
      products.where((p) => p.badge == 'New').toList();

  static Product byId(String id) =>
      products.firstWhere((p) => p.id == id, orElse: () => products.first);

  static List<Product> byCategory(String categoryId) => categoryId == 'all'
      ? products
      : products.where((p) => p.categoryId == categoryId).toList();
}
