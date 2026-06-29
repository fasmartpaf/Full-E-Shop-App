class Address {
  const Address({
    required this.id,
    required this.label,
    required this.fullName,
    required this.line1,
    required this.city,
    required this.zip,
    required this.phone,
    this.isDefault = false,
  });

  final String id;
  final String label; // Home, Work…
  final String fullName;
  final String line1;
  final String city;
  final String zip;
  final String phone;
  final bool isDefault;

  String get oneLine => '$line1, $city $zip';

  Address copyWith({bool? isDefault}) => Address(
        id: id,
        label: label,
        fullName: fullName,
        line1: line1,
        city: city,
        zip: zip,
        phone: phone,
        isDefault: isDefault ?? this.isDefault,
      );
}
