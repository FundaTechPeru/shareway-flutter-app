/// Estados conocidos de la reserva (BookingStatus).
enum BookingStatus {
  requested,
  confirmed,
  cancelled,
  boarded,
  completed,
  rejected,
  unknown;

  static BookingStatus fromString(String? value) {
    if (value == null) return BookingStatus.unknown;
    switch (value.toUpperCase()) {
      case 'REQUESTED':
        return BookingStatus.requested;
      case 'CONFIRMED':
        return BookingStatus.confirmed;
      case 'CANCELLED':
        return BookingStatus.cancelled;
      case 'BOARDED':
        return BookingStatus.boarded;
      case 'COMPLETED':
        return BookingStatus.completed;
      case 'REJECTED':
        return BookingStatus.rejected;
      default:
        return BookingStatus.unknown;
    }
  }

  String toApiString() {
    switch (this) {
      case BookingStatus.requested:
        return 'REQUESTED';
      case BookingStatus.confirmed:
        return 'CONFIRMED';
      case BookingStatus.cancelled:
        return 'CANCELLED';
      case BookingStatus.boarded:
        return 'BOARDED';
      case BookingStatus.completed:
        return 'COMPLETED';
      case BookingStatus.rejected:
        return 'REJECTED';
      case BookingStatus.unknown:
        return 'UNKNOWN';
    }
  }
}

/// Respuesta de creación o consulta de reserva (Booking).
class BookingResponse {
  const BookingResponse({
    required this.bookingId,
    required this.status,
    this.rawStatus,
    this.groupId,
    this.requestId,
    this.passengerId,
    this.createdAt,
  });

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    final rawStatusStr = json['status']?.toString() ?? 'REQUESTED';
    return BookingResponse(
      bookingId: json['bookingId']?.toString() ?? json['id']?.toString() ?? '',
      status: BookingStatus.fromString(rawStatusStr),
      rawStatus: rawStatusStr,
      groupId: json['groupId']?.toString(),
      requestId: json['requestId']?.toString(),
      passengerId:
          json['passengerId']?.toString() ?? json['userId']?.toString(),
      createdAt: json['createdAt']?.toString(),
    );
  }

  final String bookingId;
  final BookingStatus status;
  final String? rawStatus;
  final String? groupId;
  final String? requestId;
  final String? passengerId;
  final String? createdAt;
}

/// Respuesta de cancelación de reserva.
class BookingCancellationResponse {
  const BookingCancellationResponse({
    required this.bookingId,
    required this.status,
    required this.penaltyAmount,
    required this.currency,
  });

  factory BookingCancellationResponse.fromJson(Map<String, dynamic> json) {
    return BookingCancellationResponse(
      bookingId: json['bookingId']?.toString() ?? json['id']?.toString() ?? '',
      status: BookingStatus.fromString(json['status']?.toString()),
      penaltyAmount: (json['penaltyAmount'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency']?.toString() ?? 'PEN',
    );
  }

  final String bookingId;
  final BookingStatus status;
  final double penaltyAmount;
  final String currency;

  String get formattedPenalty =>
      '$currency ${penaltyAmount.toStringAsFixed(2)}';
}
