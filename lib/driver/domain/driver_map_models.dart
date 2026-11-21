enum DriverMapPointKind { origin, pickup, destination }

class DriverMapPoint {
  const DriverMapPoint({
    required this.label,
    required this.latitude,
    required this.longitude,
    required this.kind,
    this.passengerName,
  });

  final String label;
  final double latitude;
  final double longitude;
  final DriverMapPointKind kind;
  final String? passengerName;
}

/// Fictional coordinates used only to render ShareWay's academic prototype.
abstract final class DriverDemoMapRoutes {
  static const linceToSanIsidro = <DriverMapPoint>[
    DriverMapPoint(
      label: 'Lince',
      latitude: -12.08800,
      longitude: -77.04300,
      kind: DriverMapPointKind.origin,
    ),
    DriverMapPoint(
      label: 'Av. Arequipa con Risso',
      latitude: -12.08375,
      longitude: -77.03745,
      kind: DriverMapPointKind.pickup,
      passengerName: 'Lucía P.',
    ),
    DriverMapPoint(
      label: 'Av. Arenales con Canevaro',
      latitude: -12.07870,
      longitude: -77.03540,
      kind: DriverMapPointKind.pickup,
      passengerName: 'Andrea M.',
    ),
    DriverMapPoint(
      label: 'Av. Javier Prado con Arequipa',
      latitude: -12.09020,
      longitude: -77.03200,
      kind: DriverMapPointKind.pickup,
      passengerName: 'Luis T.',
    ),
    DriverMapPoint(
      label: 'Av. Rivera Navarrete 501',
      latitude: -12.09780,
      longitude: -77.02650,
      kind: DriverMapPointKind.pickup,
      passengerName: 'Rosa C.',
    ),
    DriverMapPoint(
      label: 'San Isidro',
      latitude: -12.10500,
      longitude: -77.02300,
      kind: DriverMapPointKind.destination,
    ),
  ];

  static const jesusMariaToSurco = <DriverMapPoint>[
    DriverMapPoint(
      label: 'Jesús María',
      latitude: -12.07740,
      longitude: -77.04830,
      kind: DriverMapPointKind.origin,
    ),
    DriverMapPoint(
      label: 'Av. Salaverry',
      latitude: -12.07910,
      longitude: -77.04920,
      kind: DriverMapPointKind.pickup,
      passengerName: 'Mariana R.',
    ),
    DriverMapPoint(
      label: 'San Borja Sur',
      latitude: -12.10610,
      longitude: -77.00220,
      kind: DriverMapPointKind.pickup,
      passengerName: 'Diego V.',
    ),
    DriverMapPoint(
      label: 'Surco',
      latitude: -12.13520,
      longitude: -76.99010,
      kind: DriverMapPointKind.destination,
    ),
  ];

  static const mirafloresToCentro = <DriverMapPoint>[
    DriverMapPoint(
      label: 'Miraflores',
      latitude: -12.11910,
      longitude: -77.03120,
      kind: DriverMapPointKind.origin,
    ),
    DriverMapPoint(
      label: 'Av. Larco',
      latitude: -12.12320,
      longitude: -77.03030,
      kind: DriverMapPointKind.pickup,
      passengerName: 'Camila G.',
    ),
    DriverMapPoint(
      label: 'Parque Kennedy',
      latitude: -12.12100,
      longitude: -77.02960,
      kind: DriverMapPointKind.pickup,
      passengerName: 'Pablo N.',
    ),
    DriverMapPoint(
      label: 'Lima Centro',
      latitude: -12.04640,
      longitude: -77.03220,
      kind: DriverMapPointKind.destination,
    ),
  ];
}
