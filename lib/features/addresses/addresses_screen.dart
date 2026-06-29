import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/address.dart';
import '../../state/addresses_provider.dart';
import '../../theme/app_theme.dart';

class AddressesScreen extends ConsumerWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addresses = ref.watch(addressesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Addresses'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context, ref),
        backgroundColor: AppColors.brand,
        elevation: 2,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'Add address',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      body: addresses.isEmpty
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
                        Icons.location_on_outlined,
                        size: 36,
                        color: AppColors.brand,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'No addresses saved',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Add a delivery address to speed up checkout.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.inkMuted, height: 1.4),
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: () => _openForm(context, ref),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(180, 50),
                      ),
                      child: const Text('Add address'),
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 90),
              itemCount: addresses.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _AddressTile(address: addresses[i]),
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
      builder: (_) => const _AddressForm(),
    );
  }
}

class _AddressTile extends ConsumerWidget {
  const _AddressTile({required this.address});
  final Address address;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(addressesProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(
          color: address.isDefault ? AppColors.brand : AppColors.line,
          width: address.isDefault ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.brand.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      address.label == 'Work'
                          ? Icons.work_outline_rounded
                          : Icons.home_outlined,
                      size: 14,
                      color: AppColors.brand,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      address.label,
                      style: const TextStyle(
                        color: AppColors.brand,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (address.isDefault) ...[
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Default',
                    style: TextStyle(
                      color: AppColors.success,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
              const Spacer(),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_horiz_rounded, color: AppColors.inkMuted),
                onSelected: (value) {
                  if (value == 'default') {
                    notifier.setDefault(address.id);
                  } else if (value == 'delete') {
                    notifier.remove(address.id);
                  }
                },
                itemBuilder: (_) => [
                  if (!address.isDefault)
                    const PopupMenuItem(
                      value: 'default',
                      child: Text('Set as default'),
                    ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Remove', style: TextStyle(color: AppColors.accent)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            address.fullName,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
          const SizedBox(height: 6),
          Text(
            address.line1,
            style: const TextStyle(color: AppColors.inkMuted, height: 1.35),
          ),
          Text(
            address.oneLine,
            style: const TextStyle(color: AppColors.inkMuted, height: 1.35),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.phone_outlined, size: 16, color: AppColors.inkMuted),
              const SizedBox(width: 6),
              Text(
                address.phone,
                style: const TextStyle(color: AppColors.inkMuted, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AddressForm extends ConsumerStatefulWidget {
  const _AddressForm();

  @override
  ConsumerState<_AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends ConsumerState<_AddressForm> {
  late final TextEditingController _fullNameCtrl;
  late final TextEditingController _line1Ctrl;
  late final TextEditingController _cityCtrl;
  late final TextEditingController _zipCtrl;
  late final TextEditingController _phoneCtrl;
  String _label = 'Home';

  @override
  void initState() {
    super.initState();
    _fullNameCtrl = TextEditingController();
    _line1Ctrl = TextEditingController();
    _cityCtrl = TextEditingController();
    _zipCtrl = TextEditingController();
    _phoneCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _line1Ctrl.dispose();
    _cityCtrl.dispose();
    _zipCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
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
            'New address',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Where should we deliver your orders?',
            style: TextStyle(color: AppColors.inkMuted),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _LabelChip(
                label: 'Home',
                selected: _label == 'Home',
                onTap: () => setState(() => _label = 'Home'),
              ),
              const SizedBox(width: 8),
              _LabelChip(
                label: 'Work',
                selected: _label == 'Work',
                onTap: () => setState(() => _label = 'Work'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _fullNameCtrl,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(hintText: 'Full name'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _line1Ctrl,
            decoration: const InputDecoration(hintText: 'Street address'),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _cityCtrl,
                  decoration: const InputDecoration(hintText: 'City'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _zipCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: 'ZIP'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _phoneCtrl,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(hintText: 'Phone number'),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              if (_fullNameCtrl.text.trim().isEmpty ||
                  _line1Ctrl.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: Text('Please fill in name and address'),
                  ),
                );
                return;
              }
              ref.read(addressesProvider.notifier).add(Address(
                    id: DateTime.now().toString(),
                    label: _label,
                    fullName: _fullNameCtrl.text.trim(),
                    line1: _line1Ctrl.text.trim(),
                    city: _cityCtrl.text.trim(),
                    zip: _zipCtrl.text.trim(),
                    phone: _phoneCtrl.text.trim(),
                  ));
              Navigator.pop(context);
            },
            child: const Text('Save address'),
          ),
        ],
      ),
    );
  }
}

class _LabelChip extends StatelessWidget {
  const _LabelChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      selectedColor: AppColors.brand.withValues(alpha: 0.12),
      labelStyle: TextStyle(
        fontWeight: FontWeight.w700,
        color: selected ? AppColors.brand : AppColors.inkMuted,
      ),
      side: BorderSide(color: selected ? AppColors.brand : AppColors.line),
    );
  }
}
