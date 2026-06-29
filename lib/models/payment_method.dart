import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

enum CardBrand { visa, mastercard, amex, other }

class PaymentMethod {
  const PaymentMethod({
    required this.id,
    required this.holder,
    required this.last4,
    required this.expMonth,
    required this.expYear,
    required this.brand,
    this.isDefault = false,
  });

  final String id;
  final String holder;
  final String last4;
  final int expMonth;
  final int expYear;
  final CardBrand brand;
  final bool isDefault;

  String get masked => '•••• •••• •••• $last4';
  String get expiry =>
      '${expMonth.toString().padLeft(2, '0')}/${expYear.toString().padLeft(2, '0')}';

  String get brandLabel => switch (brand) {
        CardBrand.visa => 'Visa',
        CardBrand.mastercard => 'Mastercard',
        CardBrand.amex => 'Amex',
        CardBrand.other => 'Card',
      };

  Color get brandColor => switch (brand) {
        CardBrand.visa => const Color(0xFF1A1F71),
        CardBrand.mastercard => const Color(0xFFEB001B),
        CardBrand.amex => const Color(0xFF2E77BC),
        CardBrand.other => AppColors.brand,
      };

  PaymentMethod copyWith({bool? isDefault}) => PaymentMethod(
        id: id,
        holder: holder,
        last4: last4,
        expMonth: expMonth,
        expYear: expYear,
        brand: brand,
        isDefault: isDefault ?? this.isDefault,
      );

  /// Infers brand from the first digit of a card number (demo heuristic).
  static CardBrand brandFromNumber(String number) {
    final digits = number.replaceAll(RegExp(r'\s+'), '');
    if (digits.startsWith('4')) return CardBrand.visa;
    if (digits.startsWith('5') || digits.startsWith('2')) {
      return CardBrand.mastercard;
    }
    if (digits.startsWith('3')) return CardBrand.amex;
    return CardBrand.other;
  }
}
