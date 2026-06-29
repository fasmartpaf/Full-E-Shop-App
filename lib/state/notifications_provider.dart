import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationPrefs {
  const NotificationPrefs({
    this.push = true,
    this.orderUpdates = true,
    this.promotions = false,
    this.priceDrops = true,
    this.email = true,
  });

  final bool push;
  final bool orderUpdates;
  final bool promotions;
  final bool priceDrops;
  final bool email;

  NotificationPrefs copyWith({
    bool? push,
    bool? orderUpdates,
    bool? promotions,
    bool? priceDrops,
    bool? email,
  }) =>
      NotificationPrefs(
        push: push ?? this.push,
        orderUpdates: orderUpdates ?? this.orderUpdates,
        promotions: promotions ?? this.promotions,
        priceDrops: priceDrops ?? this.priceDrops,
        email: email ?? this.email,
      );
}

class NotificationPrefsNotifier extends StateNotifier<NotificationPrefs> {
  NotificationPrefsNotifier() : super(const NotificationPrefs());

  void toggle(String key, bool value) {
    state = switch (key) {
      'push' => state.copyWith(push: value),
      'orderUpdates' => state.copyWith(orderUpdates: value),
      'promotions' => state.copyWith(promotions: value),
      'priceDrops' => state.copyWith(priceDrops: value),
      'email' => state.copyWith(email: value),
      _ => state,
    };
  }
}

final notificationPrefsProvider =
    StateNotifierProvider<NotificationPrefsNotifier, NotificationPrefs>(
        (_) => NotificationPrefsNotifier());

class AppNotification {
  const AppNotification({
    required this.title,
    required this.body,
    required this.icon,
    required this.ago,
    this.unread = false,
  });

  final String title;
  final String body;
  final IconData icon;
  final String ago;
  final bool unread;
}

/// Sample notification feed.
final notificationsListProvider = Provider<List<AppNotification>>((_) => const [
      AppNotification(
        title: 'Order ARA-1042 shipped',
        body: 'Your order is on the way — arriving in 2–3 days.',
        icon: Icons.local_shipping_outlined,
        ago: '2h',
        unread: true,
      ),
      AppNotification(
        title: 'Flash deal: 40% off audio',
        body: 'Lumen Audio headphones & speakers are on sale today.',
        icon: Icons.local_offer_outlined,
        ago: '1d',
        unread: true,
      ),
      AppNotification(
        title: 'Price drop on your wishlist',
        body: 'Linen Lounge Chair is now \$349 (was \$429).',
        icon: Icons.trending_down_rounded,
        ago: '3d',
      ),
      AppNotification(
        title: 'Welcome to Ara',
        body: 'Use code WELCOME for 15% off your first order.',
        icon: Icons.celebration_outlined,
        ago: '1w',
      ),
    ]);
