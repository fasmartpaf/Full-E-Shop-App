import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../state/addresses_provider.dart';
import '../../state/auth_provider.dart';
import '../../state/notifications_provider.dart';
import '../../state/orders_provider.dart';
import '../../state/wishlist_provider.dart';
import '../../shared/widgets/settings_tile.dart';
import '../../theme/app_theme.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    final profile = ref.watch(userProfileProvider).value;
    final orders = ref.watch(userOrdersProvider);
    final wishlistCount = ref.watch(wishlistProvider).length;
    final addressCount = ref.watch(addressesProvider).length;
    final unreadCount = ref
        .watch(notificationsListProvider)
        .where((n) => n.unread)
        .length;

    final displayName = user == null
        ? 'Guest shopper'
        : (profile?['name'] as String?) ??
            user.displayName ??
            user.email?.split('@').first ??
            'Ara member';
    final email = user?.email ?? 'Sign in to sync orders & wishlist';

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Account',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.3,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user == null
                                ? 'Manage your Ara Store profile'
                                : 'Welcome back, ${displayName.split(' ').first}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: AppColors.inkMuted),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => context.push('/notifications'),
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.surface,
                        side: const BorderSide(color: AppColors.line),
                      ),
                      icon: Badge(
                        isLabelVisible: unreadCount > 0,
                        label: Text('$unreadCount'),
                        child: const Icon(Icons.notifications_none_rounded),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: _ProfileHeroCard(
                  displayName: displayName,
                  email: email,
                  isGuest: user == null,
                  onSignIn: () => context.push('/login'),
                  onSignOut: user == null
                      ? null
                      : () async {
                          await ref.read(authControllerProvider).signOut();
                        },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    _StatChip(
                      icon: Icons.receipt_long_outlined,
                      value: '${orders.length}',
                      label: 'Orders',
                      onTap: () => context.push('/orders'),
                    ),
                    const SizedBox(width: 10),
                    _StatChip(
                      icon: Icons.favorite_border_rounded,
                      value: '$wishlistCount',
                      label: 'Saved',
                      onTap: () => context.go('/wishlist'),
                    ),
                    const SizedBox(width: 10),
                    _StatChip(
                      icon: Icons.location_on_outlined,
                      value: '$addressCount',
                      label: 'Addresses',
                      onTap: () => context.push('/addresses'),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: SettingsGroup(
                  title: 'Shopping',
                  children: [
                    SettingsTile(
                      icon: Icons.local_shipping_outlined,
                      title: 'My orders',
                      subtitle: orders.isEmpty
                          ? 'Track purchases & returns'
                          : '${orders.length} order${orders.length == 1 ? '' : 's'} placed',
                      badge: orders.isNotEmpty ? '${orders.length}' : null,
                      onTap: () => context.push('/orders'),
                    ),
                    SettingsTile(
                      icon: Icons.favorite_border_rounded,
                      title: 'Wishlist',
                      subtitle: wishlistCount == 0
                          ? 'Save items for later'
                          : '$wishlistCount saved item${wishlistCount == 1 ? '' : 's'}',
                      iconColor: AppColors.accent,
                      iconBg: AppColors.accentSoft,
                      onTap: () => context.go('/wishlist'),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: SettingsGroup(
                  title: 'Account',
                  children: [
                    SettingsTile(
                      icon: Icons.location_on_outlined,
                      title: 'Addresses',
                      subtitle: 'Delivery & billing locations',
                      onTap: () => context.push('/addresses'),
                    ),
                    SettingsTile(
                      icon: Icons.credit_card_outlined,
                      title: 'Payment methods',
                      subtitle: 'Cards saved for checkout',
                      onTap: () => context.push('/payment-methods'),
                    ),
                    SettingsTile(
                      icon: Icons.notifications_none_rounded,
                      title: 'Notifications',
                      subtitle: unreadCount > 0
                          ? '$unreadCount unread alert${unreadCount == 1 ? '' : 's'}'
                          : 'Alerts, deals & order updates',
                      badge: unreadCount > 0 ? '$unreadCount' : null,
                      onTap: () => context.push('/notifications'),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: SettingsGroup(
                  title: 'Support',
                  children: [
                    SettingsTile(
                      icon: Icons.help_outline_rounded,
                      title: 'Help & support',
                      subtitle: 'FAQ, chat & contact options',
                      iconColor: AppColors.success,
                      iconBg: const Color(0xFFE7F8F1),
                      onTap: () => context.push('/help'),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                child: user == null
                    ? FilledButton.icon(
                        onPressed: () => context.push('/login'),
                        icon: const Icon(Icons.login_rounded),
                        label: const Text('Sign in to Ara Store'),
                      )
                    : OutlinedButton.icon(
                        onPressed: () async {
                          await ref.read(authControllerProvider).signOut();
                        },
                        icon: const Icon(Icons.logout_rounded),
                        label: const Text('Sign out'),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeroCard extends StatelessWidget {
  const _ProfileHeroCard({
    required this.displayName,
    required this.email,
    required this.isGuest,
    required this.onSignIn,
    this.onSignOut,
  });

  final String displayName;
  final String email;
  final bool isGuest;
  final VoidCallback onSignIn;
  final VoidCallback? onSignOut;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.brand, Color(0xFF6C5CE7)],
        ),
        borderRadius: BorderRadius.circular(AppTheme.radius + 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.brand.withValues(alpha: 0.28),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
            ),
            child: Icon(
              isGuest ? Icons.person_outline_rounded : Icons.person_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 13.5,
                  ),
                ),
                if (isGuest) ...[
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: onSignIn,
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.brand,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Sign in'),
                  ),
                ],
              ],
            ),
          ),
          if (!isGuest)
            IconButton(
              onPressed: onSignOut,
              style: IconButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.15),
              ),
              icon: const Icon(Icons.logout_rounded, color: Colors.white),
            ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.value,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String value;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.radius),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.radius),
              border: Border.all(color: AppColors.line),
            ),
            child: Column(
              children: [
                Icon(icon, color: AppColors.brand, size: 22),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.inkMuted,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
