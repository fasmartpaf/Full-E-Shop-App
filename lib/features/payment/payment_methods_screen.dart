import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/payment_method.dart';
import '../../state/payment_methods_provider.dart';
import '../../theme/app_theme.dart';

class PaymentMethodsScreen extends ConsumerWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cards = ref.watch(paymentMethodsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Methods'),
      ),
      body: cards.isEmpty
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
                      onPressed: () => _openForm(context, ref),
                      style: FilledButton.styleFrom(minimumSize: const Size(180, 50)),
                      child: const Text('Add card'),
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: cards.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _PaymentMethodTile(
                method: cards[i],
                onDelete: () => _deleteCard(context, ref, cards[i]),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _openForm(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => _PaymentFormDialog(onSubmit: (method) {
        ref.read(paymentMethodsProvider.notifier).add(method);
        Navigator.pop(ctx);
      }),
    );
  }

  void _deleteCard(BuildContext context, WidgetRef ref, PaymentMethod method) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete card?'),
        content: Text('Remove ${method.brandLabel} ending in ${method.last4}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(paymentMethodsProvider.notifier).remove(method.id);
              Navigator.pop(ctx);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  final PaymentMethod method;
  final VoidCallback onDelete;

  const _PaymentMethodTile({
    required this.method,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.credit_card, color: method.brandColor, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(method.brandLabel, style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text(method.masked, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              if (method.isDefault)
                Chip(
                  label: const Text('Default'),
                  backgroundColor: AppColors.accentSoft,
                  labelStyle: const TextStyle(color: AppColors.ink, fontSize: 12),
                ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: onDelete,
                color: AppColors.accent,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text('Expires ${method.expiry}', style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _PaymentFormDialog extends StatefulWidget {
  final Function(PaymentMethod) onSubmit;

  const _PaymentFormDialog({required this.onSubmit});

  @override
  State<_PaymentFormDialog> createState() => _PaymentFormDialogState();
}

class _PaymentFormDialogState extends State<_PaymentFormDialog> {
  late final _numberController = TextEditingController();
  late final _nameController = TextEditingController();
  late final _expiryController = TextEditingController();
  bool _isDefault = false;

  @override
  void dispose() {
    _numberController.dispose();
    _nameController.dispose();
    _expiryController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_numberController.text.isEmpty ||
        _nameController.text.isEmpty ||
        _expiryController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final expParts = _expiryController.text.split('/');
    if (expParts.length != 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expiry must be MM/YY')),
      );
      return;
    }

    final method = PaymentMethod(
      id: '',
      holder: _nameController.text,
      last4: _numberController.text.replaceAll(RegExp(r'\s+'), '').substring(12),
      expMonth: int.tryParse(expParts[0]) ?? 0,
      expYear: int.tryParse(expParts[1]) ?? 0,
      brand: PaymentMethod.brandFromNumber(_numberController.text),
      isDefault: _isDefault,
    );

    widget.onSubmit(method);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Payment Method'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _numberController,
              decoration: const InputDecoration(
                hintText: 'Card number',
                prefixIcon: Icon(Icons.credit_card),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Cardholder name',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _expiryController,
              decoration: const InputDecoration(
                hintText: 'MM/YY',
                prefixIcon: Icon(Icons.calendar_today),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              value: _isDefault,
              onChanged: (v) => setState(() => _isDefault = v ?? false),
              title: const Text('Set as default'),
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submit,
          child: const Text('Add Card'),
        ),
      ],
    );
  }
}
