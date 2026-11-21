/// Método de pago / Tarjeta registrada por el pasajero.
class PaymentMethodItem {
  const PaymentMethodItem({
    required this.id,
    required this.brand,
    required this.last4,
    this.expMonth,
    this.expYear,
    this.isDefault = false,
  });

  factory PaymentMethodItem.fromJson(Map<String, dynamic> json) {
    return PaymentMethodItem(
      id: json['id']?.toString() ?? '',
      brand: json['brand']?.toString() ?? 'Visa',
      last4: json['last4']?.toString() ?? '0000',
      expMonth: (json['expMonth'] as num?)?.toInt(),
      expYear: (json['expYear'] as num?)?.toInt(),
      isDefault: json['isDefault'] == true || json['default'] == true,
    );
  }

  final String id;
  final String brand;
  final String last4;
  final int? expMonth;
  final int? expYear;
  final bool isDefault;

  String get displayTitle => '$brand •••• $last4';
  String get displayExpiry => (expMonth != null && expYear != null)
      ? 'Vence ${expMonth.toString().padLeft(2, '0')}/${expYear.toString().substring(expYear.toString().length - 2)}'
      : '';
}

/// Registro de pago retornado por GET /payments/me.
class PaymentItem {
  const PaymentItem({
    required this.id,
    required this.bookingId,
    required this.amount,
    required this.currency,
    required this.status,
    required this.createdAt,
    this.paymentMethodBrand,
    this.paymentMethodLast4,
  });

  factory PaymentItem.fromJson(Map<String, dynamic> json) {
    return PaymentItem(
      id: json['id']?.toString() ?? '',
      bookingId: json['bookingId']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency']?.toString() ?? 'PEN',
      status: json['status']?.toString() ?? 'PAID',
      createdAt: json['createdAt']?.toString() ?? '',
      paymentMethodBrand:
          json['paymentMethodBrand']?.toString() ?? json['brand']?.toString(),
      paymentMethodLast4:
          json['paymentMethodLast4']?.toString() ?? json['last4']?.toString(),
    );
  }

  final String id;
  final String bookingId;
  final double amount;
  final String currency;
  final String status;
  final String createdAt;
  final String? paymentMethodBrand;
  final String? paymentMethodLast4;

  String get formattedAmount => '$currency ${amount.toStringAsFixed(2)}';
}
