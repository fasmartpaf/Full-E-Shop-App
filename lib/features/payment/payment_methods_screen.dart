import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/payment_method.dart';
import '../../state/payment_methods_provider.dart';
import '../../theme/app_theme.dart';
import '../home/home_screen.dart' show EmptyState;

class PaymentMethodsScreen extends ConsumerWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cards = ref.watch(paymentMethodsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Payment methods')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context),
        backgroundColor: AppColors.brand,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Add card',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      body: cards.isEmpty
          ? EmptyState(
              icon: Icons.credit_card_off_outlined,
              title: 'No saved cards',
              message: 'Add a card for faster checkout.',
              action: FilledButton(
                onPressed: () => _openForm(context),
                style:
                    FilledButton.styleFrom(minimumSize: const Size(180, 50)),
                child: const Text('Add card'),
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 90),
              children: [
                for (final c in cards) ...[
                  _CardTile(card: c),
                  const SizedBox(height: 14),
                ],
                const SizedBox(height: 8),
                Row(
                  children: const [
                    Icon(Icons.lock_outline_rounded,
                        size: 15, color: AppColors.inkMuted),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Demo only — no real card data is stored or charged.',
                        style:
                            TextStyle(color: AppColors.inkMuted, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  static void _openForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => const _CardForm(),
    );
  }
}

class _CardTile extends ConsumerWidget {
  const _CardTile({required this.card});
  final PaymentMethod card;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [card.brandColor, card.brandColor.withValues(alpha: 0.78)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(card.brandLabel,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800)),
              if (card.isDefault) ...[
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: const Text('Default',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700)),
                ),
              ],
              const Spacer(),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_horiz_rounded, color: Colors.white),
                onSelected: (v) {
                  final n = ref.read(paymentMethodsProvider.notifier);
                  if (v == 'default') n.setDefault(card.id);
                  if (v == 'delete') n.remove(card.id);
                },
                itemBuilder: (_) => [
                  if (!card.isDefault)
                    const PopupMenuItem(
                        value: 'default', child: Text('Set as default')),
                  const PopupMenuItem(value: 'delete', child: Text('Remove')),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(card.masked,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(card.holder.toUpperCase(),
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
              const Spacer(),
              Text(card.expiry,
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}

class _CardForm extends ConsumerStatefulWidget {
  const _CardForm();

  @override
  ConsumerState<_CardForm> createState() => _CardFormState();
}

class _CardFormState extends ConsumerState<_CardForm> {
  final _formKey = GlobalKey<FormState>();
  final _holder = TextEditingController();
  final _number = TextEditingController();
  final _exp = TextEditingController();
  final _cvc = TextEditingController();
  bool _isDefault = false;

  @override
  void dispose() {
    for (final c in [_holder, _number, _exp, _cvc]) {
      c.dispose();
    }
    super.dispose();
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final digits = _number.text.replaceAll(RegExp(r'\s+'), '');
    final parts = _exp.text.split('/');
    ref.read(paymentMethodsProvider.notifier).add(PaymentMethod(
          id: '',
          holder: _holder.text.trim(),
          last4: digits.substring(digits.length - 4),
          expMonth: int.tryParse(parts.first) ?? 1,
          expYear: int.tryParse(parts.length > 1 ? parts[1] : '') ?? 28,
          brand: PaymentMethod.brandFromNumber(digits),
          isDefault: _isDefault,
        ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + bottom),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
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
                      borderRadius: BorderRadius.circular(4)),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Add card',
                  style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TextFormField(
                  controller: _holder,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(labelText: 'Cardholder name'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TextFormField(
                  controller: _number,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(16),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Card number',
                    hintText: '4242 4242 4242 4242',
                  ),
                  validator: (v) {
                    final d = (v ?? '').replaceAll(RegExp(r'\s+'), '');
                    return d.length < 13 ? 'Enter a valid card number' : null;
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _exp,
                      keyboardType: TextInputType.datetime,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(5),
                      ],
                      decoration: const InputDecoration(
                          labelText: 'Expiry', hintText: 'MM/YY'),
                      validator: (v) => (v == null || !v.contains('/'))
                          ? 'MM/YY'
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _cvc,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      decoration: const InputDecoration(labelText: 'CVC'),
                      validator: (v) =>
                          (v == null || v.length < 3) ? 'CVC' : null,
                    ),
                  ),
                ],
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeColor: AppColors.brand,
                value: _isDefault,
                onChanged: (v) => setState(() => _isDefault = v),
                title: const Text('Set as default'),
              ),
              const SizedBox(height: 8),
              FilledButton(onPressed: _save, child: const Text('Save card')),
            ],
          ),
        ),
      ),
    );
  }
}
