class WalletModel {
  final double available;
  final double pending;
  final double lifetimeEarned;
  final double lifetimePaidOut;
  final String currency;

  const WalletModel({
    this.available = 0,
    this.pending = 0,
    this.lifetimeEarned = 0,
    this.lifetimePaidOut = 0,
    this.currency = 'gbp',
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) => WalletModel(
        available: _d(json['available']),
        pending: _d(json['pending']),
        lifetimeEarned: _d(json['lifetimeEarned']),
        lifetimePaidOut: _d(json['lifetimePaidOut']),
        currency: json['currency']?.toString() ?? 'gbp',
      );

  static double _d(dynamic v) {
    if (v == null) return 0.0;
    if (v is int) return v.toDouble();
    if (v is double) return v;
    return double.tryParse(v.toString()) ?? 0.0;
  }
}
