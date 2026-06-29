import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/auth_screen.dart';
import '../features/cart/cart_screen.dart';
import '../features/category/category_screen.dart';
import '../features/checkout/checkout_screen.dart';
import '../features/home/home_screen.dart';
import '../features/product/product_detail_screen.dart';
import '../features/search/search_screen.dart';
import '../features/wishlist/wishlist_screen.dart';
import '../features/shell/scaffold_with_nav.dart';
import '../features/orders/order_detail_screen.dart';
import '../features/orders/order_confirmation_screen.dart';
import '../features/addresses/addresses_screen.dart';
import '../features/payment/payment_methods_screen.dart';
import '../features/notifications/notifications_screen.dart';
import '../features/help/help_screen.dart';
import '../features/profile/profile_screen.dart';

final _rootKey = GlobalKey<NavigatorState>();
final _shellKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/',
    routes: [
      ShellRoute(
        navigatorKey: _shellKey,
        builder: (context, state, child) => ScaffoldWithNav(child: child),
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            builder: (_, __) => const HomeScreen(),
          ),
          GoRoute(
            path: '/search',
            name: 'search',
            builder: (_, __) => const SearchScreen(),
          ),
          GoRoute(
            path: '/wishlist',
            name: 'wishlist',
            builder: (_, __) => const WishlistScreen(),
          ),
          GoRoute(
            path: '/cart',
            name: 'cart',
            builder: (_, __) => const CartScreen(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (_, __) => const ProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const AuthScreen(),
      ),
      GoRoute(
        path: '/product/:id',
        name: 'product-detail',
        parentNavigatorKey: _rootKey,
        builder: (_, state) =>
            ProductDetailScreen(productId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/category/:id',
        name: 'category',
        parentNavigatorKey: _rootKey,
        builder: (_, state) =>
            CategoryScreen(categoryId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/checkout',
        name: 'checkout',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const CheckoutScreen(),
      ),
      GoRoute(
        path: '/order-confirmation',
        name: 'order-confirmation',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const OrderConfirmationScreen(),
      ),
      GoRoute(
        path: '/order/:id',
        name: 'order-detail',
        parentNavigatorKey: _rootKey,
        builder: (_, state) =>
            OrderDetailScreen(orderId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/addresses',
        name: 'addresses',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const AddressesScreen(),
      ),
      GoRoute(
        path: '/payment-methods',
        name: 'payment-methods',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const PaymentMethodsScreen(),
      ),
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/help',
        name: 'help',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const HelpScreen(),
      ),
    ],
  );
});
