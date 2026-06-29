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
        title: const Text('Payment methods'),
      ),
      body: cards.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.brand.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.credit_card_outlined,
                        size: 36,
                        color: AppColors.brand,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'No saved cards',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Add a card for faster checkout. Demo only — no real charges.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.inkMuted, height: 1.4),
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: () => _openForm(context, ref),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(180, 50),
                      ),
                      child: const Text('Add card'),
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 90),
              itemCount: cards.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (_, i) => _PaymentCardTile(
                method: cards[i],
                onDelete: () => _deleteCard(context, ref, cards[i]),
                onSetDefault: cards[i].isDefault
                    ? null
                    : () => ref
                        .read(paymentMethodsProvider.notifier)
                        .setDefault(cards[i].id),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context, ref),
        backgroundColor: AppColors.brand,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'Add card',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  void _openForm(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _PaymentFormSheet(
        onSubmit: (method) {
          ref.read(paymentMethodsProvider.notifier).add(method);
          Navigator.pop(ctx);
        },
      ),
    );
  }

  void _deleteCard(BuildContext context, WidgetRef ref, PaymentMethod method) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove card?'),
        content: Text(
          'Remove ${method.brandLabel} ending in ${method.last4}?',
        ),
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
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}

class _PaymentCardTile extends StatelessWidget {
  const _PaymentCardTile({
    required this.method,
    required this.onDelete,
    this.onSetDefault,
  });

  final PaymentMethod method;
  final VoidCallback onDelete;
  final VoidCallback? onSetDefault;

  List<Color> _gradient() => switch (method.brand) {
        CardBrand.visa => [const Color(0xFF1A1F71), const Color(0xFF2D3A8C)],
        CardBrand.mastercard => [const Color(0xFFEB001B), const Color(0xFFF79E1B)],
        CardBrand.amex => [const Color(0xFF2E77BC), const Color(0xFF006FCF)],
        CardBrand.other => [AppColors.brand, const Color(0xFF6C5CE7)],
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _gradient(),
        ),
        borderRadius: BorderRadius.circular(AppTheme.radius + 2),
        boxShadow: [
          BoxShadow(
            color: _gradient().first.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Icon(
              Icons.circle,
              size: 120,
              color: Colors.white.withValues(alpha: 0.06),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      method.brandLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const Spacer(),
                    if (method.isDefault)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Default',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_horiz_rounded, color: Colors.white),
                      color: AppColors.surface,
                      onSelected: (value) {
                        if (value == 'default') onSetDefault?.call();
                        if (value == 'delete') onDelete();
                      },
                      itemBuilder: (_) => [
                        if (onSetDefault != null)
                          const PopupMenuItem(
                            value: 'default',
                            child: Text('Set as default'),
                          ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text(
                            'Remove',
                            style: TextStyle(color: AppColors.accent),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  method.masked,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CARDHOLDER',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            method.holder,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'EXPIRES',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          method.expiry,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentFormSheet extends StatefulWidget {
  const _PaymentFormSheet({required this.onSubmit});

  final ValueChanged<PaymentMethod> onSubmit;

  @override
  State<_PaymentFormSheet> createState() => _PaymentFormSheetState();
}

class _PaymentFormSheetState extends State<_PaymentFormSheet> {
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
    final digits = _numberController.text.replaceAll(RegExp(r'\s+'), '');
    if (digits.length < 13 ||
        _nameController.text.trim().isEmpty ||
        _expiryController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Please fill in all fields'),
        ),
      );
      return;
    }

    final expParts = _expiryController.text.split('/');
    if (expParts.length != 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Expiry must be MM/YY'),
        ),
      );
      return;
    }

    widget.onSubmit(PaymentMethod(
      id: '',
      holder: _nameController.text.trim(),
      last4: digits.substring(digits.length - 4),
      expMonth: int.tryParse(expParts[0]) ?? 0,
      expYear: int.tryParse(expParts[1]) ?? 0,
      brand: PaymentMethod.brandFromNumber(digits),
      isDefault: _isDefault,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 20 + bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.line,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Add payment method',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Demo only — card data is not stored or charged.',
            style: TextStyle(color: AppColors.inkMuted),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _numberController,
            decoration: const InputDecoration(
              hintText: 'Card number',
              prefixIcon: Icon(Icons.credit_card_outlined),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              hintText: 'Cardholder name',
              prefixIcon: Icon(Icons.person_outline_rounded),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _expiryController,
            decoration: const InputDecoration(
              hintText: 'MM/YY',
              prefixIcon: Icon(Icons.calendar_today_outlined),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            value: _isDefault,
            onChanged: (v) => setState(() => _isDefault = v),
            activeThumbColor: AppColors.brand,
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Set as default',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _submit,
            child: const Text('Save card'),
          ),
        ],
      ),
    );
  }
}
