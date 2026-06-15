class AddressModel {
  final String id;
  final String type; // 'shipping' | 'pickup'
  final String? label;
  final String fullName;
  final String line1;
  final String? line2;
  final String city;
  final String? state;
  final String postalCode;
  final String country;
  final String? phone;
  final bool isDefault;

  const AddressModel({
    required this.id,
    required this.type,
    this.label,
    required this.fullName,
    required this.line1,
    this.line2,
    required this.city,
    this.state,
    required this.postalCode,
    required this.country,
    this.phone,
    required this.isDefault,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: (json['_id'] ?? json['id']) as String,
      type: json['type'] as String? ?? 'shipping',
      label: json['label'] as String?,
      fullName: json['fullName'] as String,
      line1: json['line1'] as String,
      line2: json['line2'] as String?,
      city: json['city'] as String,
      state: json['state'] as String?,
      postalCode: json['postalCode'] as String,
      country: json['country'] as String,
      phone: json['phone'] as String?,
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        if (label != null) 'label': label,
        'fullName': fullName,
        'line1': line1,
        if (line2 != null) 'line2': line2,
        'city': city,
        if (state != null) 'state': state,
        'postalCode': postalCode,
        'country': country,
        if (phone != null) 'phone': phone,
        'isDefault': isDefault,
      };

  String get fullAddress {
    final parts = [line1, if (line2 != null) line2, city, if (state != null) state, postalCode, country];
    return parts.join(', ');
  }

  AddressModel copyWith({
    String? type,
    String? label,
    String? fullName,
    String? line1,
    String? line2,
    String? city,
    String? state,
    String? postalCode,
    String? country,
    String? phone,
    bool? isDefault,
  }) {
    return AddressModel(
      id: id,
      type: type ?? this.type,
      label: label ?? this.label,
      fullName: fullName ?? this.fullName,
      line1: line1 ?? this.line1,
      line2: line2 ?? this.line2,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      phone: phone ?? this.phone,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
