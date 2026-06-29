    final matches =
        ref.watch(ordersProvider).where((o) => o.id == orderId).toList();
    final order = matches.isEmpty ? null : matches.first;