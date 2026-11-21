import 'driver_map_models.dart';

class DriverApiTrip {
  const DriverApiTrip({
    required this.id,
    required this.status,
    required this.route,
  });

  final String id;
  final String status;
  final DriverApiTripRoute? route;

  bool get isCompleted => const {
    'FINALIZADO',
    'COMPLETED',
    'CANCELADO',
    'CANCELLED',
  }.contains(_normalizedStatus);

  bool get isActive => const {
    'EN CURSO',
    'ENCURSO',
    'IN_PROGRESS',
    'ACTIVE',
  }.contains(_normalizedStatus);

  bool get isCancelled =>
      const {'CANCELADO', 'CANCELLED'}.contains(_normalizedStatus);

  bool get isTestSimulation => route?.isTest ?? false;

  String get statusLabel => isCancelled
      ? 'Cancelado'
      : isCompleted
      ? 'Finalizado'
      : isActive
      ? 'En curso'
      : 'Confirmado';

  String get _normalizedStatus => status.trim().toUpperCase();

  factory DriverApiTrip.fromJson(Map<String, dynamic> json) => DriverApiTrip(
    id: json['id']?.toString() ?? '',
    status: json['estado']?.toString() ?? '',
    route: json['ruta'] is Map<String, dynamic>
        ? DriverApiTripRoute.fromJson(json['ruta'] as Map<String, dynamic>)
        : null,
  );
}

class DriverApiTripRoute {
  DriverApiTripRoute({
    required this.origin,
    required this.destination,
    required this.scheduledDeparture,
    required this.isTest,
    required List<DriverMapPoint> points,
  }) : points = List.unmodifiable(points);

  final String origin;
  final String destination;
  final String? scheduledDeparture;
  final bool isTest;
  final List<DriverMapPoint> points;

  bool get hasMapRoute => points.length >= 2;

  String get dateLabel {
    final raw = scheduledDeparture;
    if (raw == null || raw.length < 10) return 'Horario por confirmar';
    final date = DateTime.tryParse(raw.substring(0, 10));
    if (date == null) return 'Horario por confirmar';
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String get timeLabel {
    final raw = scheduledDeparture;
    if (raw == null) return 'Hora por confirmar';
    final match = RegExp(r'T(\d{2}:\d{2})').firstMatch(raw);
    return match?.group(1) ?? 'Hora por confirmar';
  }

  factory DriverApiTripRoute.fromJson(Map<String, dynamic> json) {
    final rawPoints = json['puntos'];
    final points = <DriverMapPoint>[];
    if (rawPoints is List) {
      for (final rawPoint in rawPoints) {
        if (rawPoint is! Map<String, dynamic>) continue;
        final latitude = _toDouble(rawPoint['latitud']);
        final longitude = _toDouble(rawPoint['longitud']);
        final label = rawPoint['etiqueta'];
        if (latitude == null ||
            longitude == null ||
            latitude < -90 ||
            latitude > 90 ||
            longitude < -180 ||
            longitude > 180 ||
            label is! String ||
            label.trim().isEmpty) {
          continue;
        }

        final type = rawPoint['tipo']?.toString().toUpperCase();
        final kind = switch (type) {
          'ORIGEN' || 'ORIGIN' => DriverMapPointKind.origin,
          'DESTINO' || 'DESTINATION' => DriverMapPointKind.destination,
          _ => DriverMapPointKind.pickup,
        };
        points.add(
          DriverMapPoint(
            label: label.trim(),
            latitude: latitude,
            longitude: longitude,
            kind: kind,
          ),
        );
      }
    }

    return DriverApiTripRoute(
      origin: _string(json['origen']) ?? 'Origen por confirmar',
      destination: _string(json['destino']) ?? 'Destino por confirmar',
      scheduledDeparture: _string(json['salidaProgramada']),
      isTest: json['esPrueba'] == true,
      points: points,
    );
  }
}

String? _string(dynamic value) {
  if (value is! String || value.trim().isEmpty) return null;
  return value.trim();
}

double? _toDouble(dynamic value) {
  if (value is num && value.isFinite) return value.toDouble();
  if (value is String) {
    final parsed = double.tryParse(value);
    if (parsed != null && parsed.isFinite) return parsed;
  }
  return null;
}
