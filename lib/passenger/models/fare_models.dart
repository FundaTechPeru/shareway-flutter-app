/// Estimación de tarifa retornado por GET /fares/estimate?groupId={uuid}.
class FareEstimate {
  const FareEstimate({
    required this.amount,
    required this.currency,
    this.ruleVersion,
  });

  factory FareEstimate.fromJson(Map<String, dynamic> json) {
    return FareEstimate(
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency']?.toString() ?? 'PEN',
      ruleVersion: json['ruleVersion']?.toString(),
    );
  }

  final double amount;
  final String currency;
  final String? ruleVersion;

  String get formattedPrice => '$currency ${amount.toStringAsFixed(2)}';
}
