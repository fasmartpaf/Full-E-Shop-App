  Future<void> _placeOrder() async {
    final cart = ref.read(cartProvider);
    final address = '${_name.text}, ${_address.text}, ${_city.text}';
    final order = await placeOrder(ref, cart, address);
    ref.read(cartProvider.notifier).clear();
    if (mounted) context.go('/order/${order.id}');
  }