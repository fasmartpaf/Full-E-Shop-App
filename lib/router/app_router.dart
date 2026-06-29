      GoRoute(
        path: '/orders',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const OrdersScreen(),
      ),
      GoRoute(
        path: '/login',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const AuthScreen(),
      ),