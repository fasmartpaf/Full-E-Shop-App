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
    final unread = feed.where((n) => n.unread).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (unread > 0)
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: Text('All notifications marked as read'),
                  ),
                );
              },
              child: const Text('Mark all read'),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          if (unread > 0)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.brand.withValues(alpha: 0.12),
                    AppColors.brand.withValues(alpha: 0.04),
                  ],
                ),
                borderRadius: BorderRadius.circular(AppTheme.radius),
                border: Border.all(color: AppColors.brand.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.brand.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.notifications_active_rounded,
                      color: AppColors.brand,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'You have $unread unread notification${unread == 1 ? '' : 's'}',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
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
                _toggle(
                  Icons.notifications_outlined,
                  'Push notifications',
                  'On-device alerts',
                  prefs.push,
                  (v) => notifier.toggle('push', v),
                ),
                const Divider(height: 1, indent: 56),
                _toggle(
                  Icons.local_shipping_outlined,
                  'Order updates',
                  'Shipping & delivery status',
                  prefs.orderUpdates,
                  (v) => notifier.toggle('orderUpdates', v),
                ),
                const Divider(height: 1, indent: 56),
                _toggle(
                  Icons.trending_down_rounded,
                  'Price drops',
                  'Wishlist items on sale',
                  prefs.priceDrops,
                  (v) => notifier.toggle('priceDrops', v),
                ),
                const Divider(height: 1, indent: 56),
                _toggle(
                  Icons.local_offer_outlined,
                  'Promotions',
                  'Deals & offers',
                  prefs.promotions,
                  (v) => notifier.toggle('promotions', v),
                ),
                const Divider(height: 1, indent: 56),
                _toggle(
                  Icons.mail_outline_rounded,
                  'Email',
                  'Receipts & newsletters',
                  prefs.email,
                  (v) => notifier.toggle('email', v),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggle(
    IconData icon,
    String title,
    String sub,
    bool value,
    ValueChanged<bool> on,
  ) {
    return SwitchListTile(
      value: value,
      onChanged: on,
      activeThumbColor: AppColors.brand,
      secondary: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.brand.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.brand, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(
        sub,
        style: const TextStyle(color: AppColors.inkMuted, fontSize: 12.5),
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(2, 6, 0, 10),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
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
        color: n.unread
            ? AppColors.brand.withValues(alpha: 0.05)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(
          color: n.unread
              ? AppColors.brand.withValues(alpha: 0.25)
              : AppColors.line,
        ),
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
                      child: Text(
                        n.title,
                        style: TextStyle(
                          fontWeight: n.unread ? FontWeight.w800 : FontWeight.w700,
                        ),
                      ),
                    ),
                    if (n.unread)
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(right: 6),
                        decoration: const BoxDecoration(
                          color: AppColors.brand,
                          shape: BoxShape.circle,
                        ),
                      ),
                    Text(
                      n.ago,
                      style: const TextStyle(
                        color: AppColors.inkMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  n.body,
                  style: const TextStyle(
                    color: AppColors.inkMuted,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
