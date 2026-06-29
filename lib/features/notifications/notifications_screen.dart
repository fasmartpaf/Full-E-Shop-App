import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/notifications_provider.dart';
import '../../theme/app_theme.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(notificationPrefsProvider);
    final notifier = ref.read(notificationPrefsProvider.notifier);
    final feed = ref.watch(notificationsListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          const _Heading('Recent'),
          for (final n in feed) ...[
            _NotificationTile(n: n),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 12),
          const _Heading('Preferences'),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppTheme.radius),
              border: Border.all(color: AppColors.line),
            ),
            child: Column(
              children: [
                _toggle('Push notifications', 'On-device alerts', prefs.push,
                    (v) => notifier.toggle('push', v)),
                const Divider(height: 1),
                _toggle('Order updates', 'Shipping & delivery status',
                    prefs.orderUpdates,
                    (v) => notifier.toggle('orderUpdates', v)),
                const Divider(height: 1),
                _toggle('Price drops', 'Wishlist items on sale',
                    prefs.priceDrops, (v) => notifier.toggle('priceDrops', v)),
                const Divider(height: 1),
                _toggle('Promotions', 'Deals & offers', prefs.promotions,
                    (v) => notifier.toggle('promotions', v)),
                const Divider(height: 1),
                _toggle('Email', 'Receipts & newsletters', prefs.email,
                    (v) => notifier.toggle('email', v)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggle(String title, String sub, bool value, ValueChanged<bool> on) {
    return SwitchListTile(
      value: value,
      onChanged: on,
      activeColor: AppColors.brand,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(sub,
          style: const TextStyle(color: AppColors.inkMuted, fontSize: 12.5)),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(2, 6, 0, 10),
        child: Text(text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
      );
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.n});
  final AppNotification n;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: n.unread ? AppColors.brand.withValues(alpha: 0.05) : AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.brand.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(n.icon, color: AppColors.brand, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(n.title,
                          style:
                              const TextStyle(fontWeight: FontWeight.w700)),
                    ),
                    Text(n.ago,
                        style: const TextStyle(
                            color: AppColors.inkMuted, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 2),
                Text(n.body,
                    style: const TextStyle(
                        color: AppColors.inkMuted, height: 1.35)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
