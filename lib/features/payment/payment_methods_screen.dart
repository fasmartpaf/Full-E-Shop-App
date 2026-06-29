import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/payment_method.dart';
import '../../state/payment_methods_provider.dart';

class PaymentMethodsScreen extends ConsumerStatefulWidget {
  const PaymentMethodsScreen();

  @override
  ConsumerState<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends ConsumerState<PaymentMethodsScreen> {
  void _openForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => _PaymentMethodForm(
        onSave: (method) {
          ref.read(paymentMethodsProvider.notifier).add(method);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final methods = ref.watch(paymentMethodsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Payment Methods')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(context),
        child: const Icon(Icons.add),
      ),
      body: methods.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.credit_card_off_outlined, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text('No saved cards', style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    const Text('Add a card for faster checkout.'),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: () => _openForm(context),
                      style: FilledButton.styleFrom(minimumSize: const Size(180, 50)),
                      child: const Text('Add card'),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: methods.length,
              itemBuilder: (context, index) {
                final method = methods[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.credit_card, color: Theme.of(context).primaryColor),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                method.cardHolder,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                '**** **** **** ${method.lastFour}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () {
                            ref.read(paymentMethodsProvider.notifier).remove(method.id);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _PaymentMethodForm extends StatefulWidget {
  final void Function(PaymentMethod) onSave;

  const _PaymentMethodForm({required this.onSave});

  @override
  State<_PaymentMethodForm> createState() => _PaymentMethodFormState();
}

class _PaymentMethodFormState extends State<_PaymentMethodForm> {
  late TextEditingController cardHolderController;
  late TextEditingController cardNumberController;
  late TextEditingController expiryController;
  late TextEditingController cvvController;

  @override
  void initState() {
    super.initState();
    cardHolderController = TextEditingController();
    cardNumberController = TextEditingController();
    expiryController = TextEditingController();
    cvvController = TextEditingController();
  }

  @override
  void dispose() {
    cardHolderController.dispose();
    cardNumberController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Add payment method', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 24),
          TextField(
            controller: cardHolderController,
            decoration: const InputDecoration(hintText: 'Cardholder name'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: cardNumberController,
            decoration: const InputDecoration(hintText: 'Card number'),
            maxLength: 16,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: expiryController,
                  decoration: const InputDecoration(hintText: 'MM/YY'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: cvvController,
                  decoration: const InputDecoration(hintText: 'CVV'),
                  maxLength: 3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                final lastFour = cardNumberController.text.substring(
                  cardNumberController.text.length - 4,
                );
                widget.onSave(
                  PaymentMethod(
                    id: DateTime.now().toString(),
                    cardHolder: cardHolderController.text,
                    lastFour: lastFour,
                    expiry: expiryController.text,
                  ),
                );
              },
              child: const Text('Save card'),
            ),
          ),
        ],
      ),
    );
  }
}
