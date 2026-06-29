import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../state/cart_provider.dart';
import '../../theme/app_theme.dart';

class ScaffoldWithNav extends ConsumerWidget {
  const ScaffoldWithNav({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(cartCountProvider);
    final i = navigationShell.currentIndex;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.line)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 62,
            child: Row(
              children: [
                _NavItem(
                  icon: Icons.home_outlined,
                  active: Icons.home_rounded,
                  label: 'Home',
                  selected: i == 0,
                  onTap: () => _go(0),
                ),
                _NavItem(
                  icon: Icons.search_rounded,
                  active: Icons.search_rounded,
                  label: 'Search',
                  selected: i == 1,
                  onTap: () => _go(1),
                ),
                _NavItem(
                  icon: Icons.shopping_bag_outlined,
                  active: Icons.shopping_bag_rounded,
                  label: 'Cart',
                  selected: i == 2,
                  badge: cartCount,
                  onTap: () => _go(2),
                ),
                _NavItem(
                  icon: Icons.favorite_border_rounded,
                  active: Icons.favorite_rounded,
                  label: 'Wishlist',
                  selected: i == 3,
                  onTap: () => _go(3),
                ),
                _NavItem(
                  icon: Icons.person_outline_rounded,
                  active: Icons.person_rounded,
                  label: 'Account',
                  selected: i == 4,
                  onTap: () => _go(4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _go(int index) => navigationShell.goBranch(
        index,
        initialLocation: index == navigationShell.currentIndex,
      );
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.active,
    required this.label,
    required this.selected,
    required this.onTap,
    this.badge = 0,
  });

  final IconData icon;
  final IconData active;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final int badge;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.brand : AppColors.inkMuted;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(selected ? active : icon, color: color, size: 25),
                if (badge > 0)
                  Positioned(
                    right: -8,
                    top: -6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      constraints:
                          const BoxConstraints(minWidth: 18, minHeight: 18),
                      decoration: const BoxDecoration(
                          color: AppColors.accent, shape: BoxShape.circle),
                      child: Text('$badge',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w800)),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            Text(label,
                style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
