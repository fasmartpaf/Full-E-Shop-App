import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/address.dart';
import '../../state/addresses_provider.dart';
import '../../theme/app_theme.dart';
import '../home/home_screen.dart' show EmptyState;

class AddressesScreen extends ConsumerWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addresses = ref.watch(addressesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Addresses')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context, ref),
        backgroundColor: AppColors.brand,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Add address',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      body: addresses.isEmpty
          ? EmptyState(
              icon: Icons.location_on_outlined,
              title: 'No addresses',
              message: 'Add a delivery address to speed up checkout.',
              action: FilledButton(
                onPressed: () => _openForm(context, ref),
                style:
                    FilledButton.styleFrom(minimumSize: const Size(180, 50)),
                child: const Text('Add address'),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 90),
              itemCount: addresses.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _AddressCard(address: addresses[i]),
            ),
    );
  }

  static void _openForm(BuildContext context, WidgetRef ref, [Address? edit]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => _AddressForm(edit: edit),
    );
  }
}

class _AddressCard extends ConsumerWidget {
  const _AddressCard({required this.address});
  final Address address;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(
            color: address.isDefault ? AppColors.brand : AppColors.line,
            width: address.isDefault ? 1.5 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                address.label.toLowerCase() == 'work'
                    ? Icons.work_outline_rounded
                    : Icons.home_outlined,
                size: 18,
                color: AppColors.brand,
              ),
              const SizedBox(width: 8),
              Text(address.label,
                  style: const TextStyle(fontWeight: FontWeight.w800)),
              if (address.isDefault) ...[
                const SizedBox(width: 8),
                const _Badge(label: 'Default'),
              ],
              const Spacer(),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_horiz_rounded),
                onSelected: (v) {
                  final n = ref.read(addressesProvider.notifier);
                  switch (v) {
                    case 'default':
                      n.setDefault(address.id);
                    case 'edit':
                      AddressesScreen._openForm(context, ref, address);
                    case 'delete':
                      n.remove(address.id);
                  }
                },
                itemBuilder: (_) => [
                  if (!address.isDefault)
                    const PopupMenuItem(
                        value: 'default', child: Text('Set as default')),
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  const PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(address.fullName,
              style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text('${address.line1}\n${address.city} ${address.zip}',
              style: const TextStyle(color: AppColors.inkMuted, height: 1.4)),
          const SizedBox(height: 2),
          Text(address.phone,
              style: const TextStyle(color: AppColors.inkMuted)),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.brand.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Text(label,
            style: const TextStyle(
                color: AppColors.brand,
                fontSize: 11,
                fontWeight: FontWeight.w800)),
      );
}

class _AddressForm extends ConsumerStatefulWidget {
  const _AddressForm({this.edit});
  final Address? edit;

  @override
  ConsumerState<_AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends ConsumerState<_AddressForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _label;
  late final TextEditingController _name;
  late final TextEditingController _line1;
  late final TextEditingController _city;
  late final TextEditingController _zip;
  late final TextEditingController _phone;
  late bool _isDefault;

  @override
  void initState() {
    super.initState();
    final e = widget.edit;
    _label = TextEditingController(text: e?.label ?? 'Home');
    _name = TextEditingController(text: e?.fullName ?? '');
    _line1 = TextEditingController(text: e?.line1 ?? '');
    _city = TextEditingController(text: e?.city ?? '');
    _zip = TextEditingController(text: e?.zip ?? '');
    _phone = TextEditingController(text: e?.phone ?? '');
    _isDefault = e?.isDefault ?? false;
  }

  @override
  void dispose() {
    for (final c in [_label, _name, _line1, _city, _zip, _phone]) {
      c.dispose();
    }
    super.dispose();
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final a = Address(
      id: widget.edit?.id ?? '',
      label: _label.text.trim(),
      fullName: _name.text.trim(),
      line1: _line1.text.trim(),
      city: _city.text.trim(),
      zip: _zip.text.trim(),
      phone: _phone.text.trim(),
      isDefault: _isDefault,
    );
    final n = ref.read(addressesProvider.notifier);
    widget.edit == null ? n.add(a) : n.update(a);
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
              Text(widget.edit == null ? 'Add address' : 'Edit address',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 16),
              _field(_label, 'Label (Home, Work…)'),
              _field(_name, 'Full name'),
              _field(_line1, 'Street address'),
              Row(
                children: [
                  Expanded(child: _field(_city, 'City, State')),
                  const SizedBox(width: 12),
                  SizedBox(width: 110, child: _field(_zip, 'ZIP')),
                ],
              ),
              _field(_phone, 'Phone', keyboard: TextInputType.phone),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeColor: AppColors.brand,
                value: _isDefault,
                onChanged: (v) => setState(() => _isDefault = v),
                title: const Text('Set as default address'),
              ),
              const SizedBox(height: 8),
              FilledButton(onPressed: _save, child: const Text('Save address')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String hint,
      {TextInputType? keyboard}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        keyboardType: keyboard,
        decoration: InputDecoration(labelText: hint),
        validator: (v) =>
            (v == null || v.trim().isEmpty) ? 'Required' : null,
      ),
    );
  }
}
