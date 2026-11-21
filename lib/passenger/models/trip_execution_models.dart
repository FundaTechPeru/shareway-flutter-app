/// Modelo de pasajero dentro de un viaje en curso.
class TripPassenger {
  const TripPassenger({
    required this.id,
    required this.name,
    required this.pickupLabel,
    this.status,
  });

  factory TripPassenger.fromJson(Map<String, dynamic> json) {
    return TripPassenger(
      id:
          json['id']?.toString() ??
          json['Id']?.toString() ??
          json['passengerId']?.toString() ??
          '',
      name:
          json['name']?.toString() ??
          json['Name']?.toString() ??
          json['fullName']?.toString() ??
          'Pasajero',
      pickupLabel:
          json['pickupLabel']?.toString() ??
          json['PickupLabel']?.toString() ??
          '',
      status: json['status']?.toString() ?? json['Status']?.toString(),
    );
  }

  final String id;
  final String name;
  final String pickupLabel;
  final String? status;
}

/// Detalle del viaje retornado por GET /trips/{id} (gateway reescribe a /api/viajes).
/// Soporta nombres de campos en camelCase y PascalCase.
class TripExecutionDetail {
  const TripExecutionDetail({
    required this.id,
    required this.groupId,
    required this.driverId,
    required this.driverName,
    required this.status,
    required this.originLabel,
    required this.destinationLabel,
    this.estimatedArrival,
    this.passengers = const [],
  });

  factory TripExecutionDetail.fromJson(Map<String, dynamic> json) {
    List<TripPassenger> passList = [];
    final passRaw =
        json['passengers'] ??
        json['Passengers'] ??
        json['pasajeros'] ??
        json['Pasajeros'];
    if (passRaw is List) {
      passList = passRaw
          .whereType<Map<String, dynamic>>()
          .map((e) => TripPassenger.fromJson(e))
          .toList();
    }

    final driverObj =
        json['driver'] ??
        json['Driver'] ??
        json['conductor'] ??
        json['Conductor'];
    String dName = 'Carlos H.';
    if (driverObj is Map<String, dynamic>) {
      dName =
          driverObj['name']?.toString() ??
          driverObj['Name']?.toString() ??
          driverObj['fullName']?.toString() ??
          dName;
    } else if (json['driverName'] != null || json['DriverName'] != null) {
      dName =
          json['driverName']?.toString() ??
          json['DriverName']?.toString() ??
          dName;
    }

    return TripExecutionDetail(
      id:
          json['id']?.toString() ??
          json['Id']?.toString() ??
          json['tripId']?.toString() ??
          '',
      groupId: json['groupId']?.toString() ?? json['GrupoId']?.toString() ?? '',
      driverId:
          json['driverId']?.toString() ?? json['ConductorId']?.toString() ?? '',
      driverName: dName,
      status:
          json['status']?.toString() ??
          json['Status']?.toString() ??
          'IN_PROGRESS',
      originLabel:
          json['originLabel']?.toString() ??
          json['OriginLabel']?.toString() ??
          json['origen']?.toString() ??
          '',
      destinationLabel:
          json['destinationLabel']?.toString() ??
          json['DestinationLabel']?.toString() ??
          json['destino']?.toString() ??
          '',
      estimatedArrival:
          json['estimatedArrival']?.toString() ??
          json['EstimatedArrival']?.toString() ??
          json['eta']?.toString(),
      passengers: passList,
    );
  }

  final String id;
  final String groupId;
  final String driverId;
  final String driverName;
  final String status;
  final String originLabel;
  final String destinationLabel;
  final String? estimatedArrival;
  final List<TripPassenger> passengers;
}
