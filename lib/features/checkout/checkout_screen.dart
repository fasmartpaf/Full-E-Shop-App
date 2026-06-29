import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../state/cart_provider.dart';
import '../../state/orders_provider.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  late TextEditingController _nameCtrl;
  late TextEditingController _addressCtrl;
  late TextEditingController _cityCtrl;
  bool _placing = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _addressCtrl = TextEditingController();
    _cityCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Delivery Address', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              TextField(
                controller: _nameCtrl,
                decoration: const InputDecoration(hintText: 'Full Name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _addressCtrl,
                decoration: const InputDecoration(hintText: 'Address'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _cityCtrl,
                decoration: const InputDecoration(hintText: 'City'),
              ),
              const SizedBox(height: 32),
              Text('Order Summary', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Subtotal'),
                trailing: Text('\$${cart.subtotal.toStringAsFixed(2)}'),
              ),
              ListTile(
                title: const Text('Shipping'),
                trailing: Text('\$${cart.shipping.toStringAsFixed(2)}'),
              ),
              const Divider(),
              ListTile(
                title: const Text('Total'),
                trailing: Text('\$${cart.total.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _placing ? null : _placeOrder,
                  child: _placing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Place Order'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _placeOrder() async {
    final name = _nameCtrl.text.trim();
    final addressLine = _addressCtrl.text.trim();
    final city = _cityCtrl.text.trim();
    if (name.isEmpty || addressLine.isEmpty || city.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in your delivery details')),
      );
      return;
    }

    final cart = ref.read(cartProvider);
    if (cart.isEmpty) {
      context.go('/');
      return;
    }

    setState(() => _placing = true);
    try {
      final address = '$name, $addressLine, $city';
      await placeOrder(ref, cart, address);
      ref.read(cartProvider.notifier).clear();
      if (mounted) context.go('/order-confirmation');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not place order: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _placing = false);
    }
  }
}
