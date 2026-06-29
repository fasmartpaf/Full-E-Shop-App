import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/address.dart';

class AddressesNotifier extends StateNotifier<List<Address>> {
  AddressesNotifier()
      : super(const [
          Address(
            id: 'a1',
            label: 'Home',
            fullName: 'Alex Rivera',
            line1: '742 Market St, Apt 5',
            city: 'San Francisco, CA',
            zip: '94107',
            phone: '+1 415 555 0142',
            isDefault: true,
          ),
        ]);

  int _seq = 2;

  void add(Address a) {
    final id = a.id.isEmpty ? 'a${_seq++}' : a.id;
    var next = [...state, Address(
      id: id,
      label: a.label,
      fullName: a.fullName,
      line1: a.line1,
      city: a.city,
      zip: a.zip,
      phone: a.phone,
      isDefault: a.isDefault || state.isEmpty,
    )];
    if (a.isDefault) next = _applyDefault(next, id);
    state = next;
  }

  void update(Address a) {
    var next = [for (final x in state) if (x.id == a.id) a else x];
    if (a.isDefault) next = _applyDefault(next, a.id);
    state = next;
  }

  void remove(String id) {
    final next = state.where((a) => a.id != id).toList();
    // Ensure at least one default remains.
    if (next.isNotEmpty && !next.any((a) => a.isDefault)) {
      next[0] = next[0].copyWith(isDefault: true);
    }
    state = next;
  }

  void setDefault(String id) => state = _applyDefault(state, id);

  List<Address> _applyDefault(List<Address> list, String id) =>
      [for (final a in list) a.copyWith(isDefault: a.id == id)];
}

final addressesProvider =
    StateNotifierProvider<AddressesNotifier, List<Address>>(
        (_) => AddressesNotifier());

final defaultAddressProvider = Provider<Address?>((ref) {
  final list = ref.watch(addressesProvider);
  if (list.isEmpty) return null;
  return list.firstWhere((a) => a.isDefault, orElse: () => list.first);
});
