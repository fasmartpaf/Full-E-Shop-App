import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/payment_method.dart';

class PaymentMethodsNotifier extends StateNotifier<List<PaymentMethod>> {
  PaymentMethodsNotifier()
      : super(const [
          PaymentMethod(
            id: 'c1',
            holder: 'Alex Rivera',
            last4: '4242',
            expMonth: 8,
            expYear: 27,
            brand: CardBrand.visa,
            isDefault: true,
          ),
        ]);

  int _seq = 2;

  void add(PaymentMethod c) {
    final id = c.id.isEmpty ? 'c${_seq++}' : c.id;
    final card = PaymentMethod(
      id: id,
      holder: c.holder,
      last4: c.last4,
      expMonth: c.expMonth,
      expYear: c.expYear,
      brand: c.brand,
      isDefault: c.isDefault || state.isEmpty,
    );
    var next = [...state, card];
    if (card.isDefault) next = _applyDefault(next, id);
    state = next;
  }

  void remove(String id) {
    final next = state.where((c) => c.id != id).toList();
    if (next.isNotEmpty && !next.any((c) => c.isDefault)) {
      next[0] = next[0].copyWith(isDefault: true);
    }
    state = next;
  }

  void setDefault(String id) => state = _applyDefault(state, id);

  List<PaymentMethod> _applyDefault(List<PaymentMethod> list, String id) =>
      [for (final c in list) c.copyWith(isDefault: c.id == id)];
}

final paymentMethodsProvider =
    StateNotifierProvider<PaymentMethodsNotifier, List<PaymentMethod>>(
        (_) => PaymentMethodsNotifier());
