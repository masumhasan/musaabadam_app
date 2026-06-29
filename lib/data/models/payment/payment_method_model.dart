class PaymentMethodModel {
  final String id;
  final String? brand;
  final String? last4;
  final int? expMonth;
  final int? expYear;
  final bool isDefault;

  const PaymentMethodModel({
    required this.id,
    this.brand,
    this.last4,
    this.expMonth,
    this.expYear,
    this.isDefault = false,
  });

  String get displayLabel {
    final b = (brand ?? 'Card');
    final l = last4 != null ? ' •••• $last4' : '';
    return '${b[0].toUpperCase()}${b.substring(1)}$l';
  }

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) => PaymentMethodModel(
        id: (json['_id'] ?? json['id']).toString(),
        brand: json['brand']?.toString(),
        last4: json['last4']?.toString(),
        expMonth: json['expMonth'] is int ? json['expMonth'] as int : int.tryParse('${json['expMonth']}'),
        expYear: json['expYear'] is int ? json['expYear'] as int : int.tryParse('${json['expYear']}'),
        isDefault: json['isDefault'] == true,
      );
}
