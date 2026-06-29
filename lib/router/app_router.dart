      GoRoute(
        path: '/login',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const AuthScreen(),
      ),
      GoRoute(
        path: '/order/:id/detail',
        parentNavigatorKey: _rootKey,
        builder: (_, state) =>
            OrderDetailScreen(orderId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/addresses',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const AddressesScreen(),
      ),
      GoRoute(
        path: '/payment-methods',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const PaymentMethodsScreen(),
      ),
      GoRoute(
        path: '/notifications',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/help',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const HelpScreen(),
      ),