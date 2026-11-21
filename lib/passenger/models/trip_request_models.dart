/// Solicitud de viaje del pasajero.
class TripRequest {
  const TripRequest({
    required this.id,
    required this.passengerId,
    required this.originLabel,
    required this.destinationLabel,
    required this.operationZone,
    required this.travelDate,
    required this.earliestDeparture,
    required this.latestDeparture,
    required this.seatsRequested,
    this.status = 'PENDING',
    this.originLat,
    this.originLng,
    this.destLat,
    this.destLng,
  });

  factory TripRequest.fromJson(Map<String, dynamic> json) {
    return TripRequest(
      id: json['id']?.toString() ?? json['requestId']?.toString() ?? '',
      passengerId: json['passengerId']?.toString() ?? '',
      originLabel:
          json['originLabel']?.toString() ?? json['origin']?.toString() ?? '',
      destinationLabel:
          json['destinationLabel']?.toString() ??
          json['destination']?.toString() ??
          '',
      operationZone: json['operationZone']?.toString() ?? 'LIMA_METROPOLITANA',
      travelDate: json['travelDate']?.toString() ?? '',
      earliestDeparture: json['earliestDeparture']?.toString() ?? '',
      latestDeparture: json['latestDeparture']?.toString() ?? '',
      seatsRequested: (json['seatsRequested'] as num?)?.toInt() ?? 1,
      status: json['status']?.toString() ?? 'PENDING',
      originLat: (json['originLat'] as num?)?.toDouble(),
      originLng: (json['originLng'] as num?)?.toDouble(),
      destLat: (json['destLat'] as num?)?.toDouble(),
      destLng: (json['destLng'] as num?)?.toDouble(),
    );
  }

  final String id;
  final String passengerId;
  final String originLabel;
  final String destinationLabel;
  final String operationZone;
  final String travelDate;
  final String earliestDeparture;
  final String latestDeparture;
  final int seatsRequested;
  final String status;
  final double? originLat;
  final double? originLng;
  final double? destLat;
  final double? destLng;
}

/// Propuesta de coincidencia (MatchProposal) generada por el backend.
class MatchProposal {
  const MatchProposal({
    required this.id,
    required this.requestId,
    required this.groupId,
    required this.driverId,
    required this.driverName,
    required this.driverRating,
    required this.estimatedFare,
    required this.estimatedDurationMinutes,
    required this.departureTime,
    required this.seatsAvailable,
    required this.seatsTotal,
    this.vehicleInfo,
    this.originLabel,
    this.destinationLabel,
  });

  factory MatchProposal.fromJson(Map<String, dynamic> json) {
    final driverObj = json['driver'] is Map<String, dynamic>
        ? json['driver'] as Map<String, dynamic>
        : null;

    return MatchProposal(
      id: json['id']?.toString() ?? json['proposalId']?.toString() ?? '',
      requestId: json['requestId']?.toString() ?? '',
      groupId:
          json['groupId']?.toString() ?? json['tripGroupId']?.toString() ?? '',
      driverId:
          json['driverId']?.toString() ?? driverObj?['id']?.toString() ?? '',
      driverName:
          json['driverName']?.toString() ??
          driverObj?['name']?.toString() ??
          driverObj?['fullName']?.toString() ??
          'Conductor',
      driverRating:
          (json['driverRating'] as num?)?.toDouble() ??
          (driverObj?['rating'] as num?)?.toDouble() ??
          4.8,
      estimatedFare:
          (json['estimatedFare'] as num?)?.toDouble() ??
          (json['amount'] as num?)?.toDouble() ??
          7.50,
      estimatedDurationMinutes:
          (json['estimatedDurationMinutes'] as num?)?.toInt() ??
          (json['durationMinutes'] as num?)?.toInt() ??
          25,
      departureTime:
          json['departureTime']?.toString() ??
          json['time']?.toString() ??
          '07:10',
      seatsAvailable: (json['seatsAvailable'] as num?)?.toInt() ?? 1,
      seatsTotal: (json['seatsTotal'] as num?)?.toInt() ?? 4,
      vehicleInfo:
          json['vehicleInfo']?.toString() ?? driverObj?['vehicle']?.toString(),
      originLabel: json['originLabel']?.toString(),
      destinationLabel: json['destinationLabel']?.toString(),
    );
  }

  final String id;
  final String requestId;
  final String groupId;
  final String driverId;
  final String driverName;
  final double driverRating;
  final double estimatedFare;
  final int estimatedDurationMinutes;
  final String departureTime;
  final int seatsAvailable;
  final int seatsTotal;
  final String? vehicleInfo;
  final String? originLabel;
  final String? destinationLabel;
}
