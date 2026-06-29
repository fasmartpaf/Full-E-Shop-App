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
      appBar: AppBar(title: const Text('Addresses')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context, ref),
        backgroundColor: AppColors.brand,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Add address',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      body: addresses.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on_outlined, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text('No addresses', style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    const Text('Add a delivery address to speed up checkout.'),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: () => _openForm(context, ref),
                      style: FilledButton.styleFrom(minimumSize: const Size(180, 50)),
                      child: const Text('Add address'),
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 90),
              itemCount: addresses.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _AddressTile(address: addresses[i]),
            ),
    );
  }

  void _openForm(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (_) => const _AddressForm(),
    );
  }
}

class _AddressTile extends StatelessWidget {
  const _AddressTile({required this.address});
  final Address address;

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
          Text(address.fullName, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(address.line1, style: const TextStyle(color: AppColors.inkMuted)),
          Text(address.oneLine, style: const TextStyle(color: AppColors.inkMuted)),
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
  late TextEditingController _fullNameCtrl;
  late TextEditingController _line1Ctrl;
  late TextEditingController _cityCtrl;
  late TextEditingController _zipCtrl;
  late TextEditingController _phoneCtrl;

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
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _fullNameCtrl,
            decoration: const InputDecoration(hintText: 'Full Name'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _line1Ctrl,
            decoration: const InputDecoration(hintText: 'Address Line 1'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _cityCtrl,
            decoration: const InputDecoration(hintText: 'City'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _zipCtrl,
            decoration: const InputDecoration(hintText: 'ZIP'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _phoneCtrl,
            decoration: const InputDecoration(hintText: 'Phone'),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                ref.read(addressesProvider.notifier).add(Address(
                  id: DateTime.now().toString(),
                  label: 'Home',
                  fullName: _fullNameCtrl.text,
                  line1: _line1Ctrl.text,
                  city: _cityCtrl.text,
                  zip: _zipCtrl.text,
                  phone: _phoneCtrl.text,
                ));
                Navigator.pop(context);
              },
              child: const Text('Add address'),
            ),
          ),
        ],
      ),
    );
  }
}
