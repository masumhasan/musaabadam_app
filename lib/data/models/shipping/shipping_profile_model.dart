class ShippingRateTier {
  final String? label;
  final double? maxWeightKg;
  final double price;

  const ShippingRateTier({this.label, this.maxWeightKg, required this.price});

  factory ShippingRateTier.fromJson(Map<String, dynamic> json) => ShippingRateTier(
        label: json['label']?.toString(),
        maxWeightKg: json['maxWeightKg'] == null ? null : _d(json['maxWeightKg']),
        price: _d(json['price']),
      );

  Map<String, dynamic> toJson() => {
        'label': ?label,
        'maxWeightKg': ?maxWeightKg,
        'price': price,
      };

  static double _d(dynamic v) =>
      v is int ? v.toDouble() : (v is double ? v : double.tryParse('$v') ?? 0.0);
}

class ShippingProfileModel {
  final String id;
  final String name;
  final String carrier;
  final double flatRate;
  final double? freeShippingThreshold;
  final List<ShippingRateTier> rateTiers;
  final int handlingDays;
  final bool domesticOnly;
  final double? internationalRate;
  final bool isDefault;

  const ShippingProfileModel({
    required this.id,
    required this.name,
    required this.carrier,
    this.flatRate = 0,
    this.freeShippingThreshold,
    this.rateTiers = const [],
    this.handlingDays = 1,
    this.domesticOnly = true,
    this.internationalRate,
    this.isDefault = false,
  });

  factory ShippingProfileModel.fromJson(Map<String, dynamic> json) => ShippingProfileModel(
        id: (json['_id'] ?? json['id']).toString(),
        name: json['name']?.toString() ?? '',
        carrier: json['carrier']?.toString() ?? 'royal_mail',
        flatRate: ShippingRateTier._d(json['flatRate']),
        freeShippingThreshold:
            json['freeShippingThreshold'] == null ? null : ShippingRateTier._d(json['freeShippingThreshold']),
        rateTiers: (json['rateTiers'] as List? ?? [])
            .map((e) => ShippingRateTier.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
        handlingDays: json['handlingDays'] is int ? json['handlingDays'] as int : int.tryParse('${json['handlingDays']}') ?? 1,
        domesticOnly: json['domesticOnly'] != false,
        internationalRate:
            json['internationalRate'] == null ? null : ShippingRateTier._d(json['internationalRate']),
        isDefault: json['isDefault'] == true,
      );
}
