import '../domain/driver_models.dart';
import '../domain/driver_map_models.dart';

class DemoDriverRepository implements DriverRepository {
  final List<DriverTrip> _trips = [
    const DriverTrip(
      id: 'SW-2026-071',
      origin: 'Lince',
      destination: 'San Isidro',
      dateLabel: 'Mañana, 19 nov',
      timeLabel: '7:10 a. m.',
      estimatedFare: 26.40,
      passengers: [
        DriverPassenger(
          name: 'Lucía P.',
          initials: 'LP',
          pickup: 'Av. Arequipa con Risso',
        ),
        DriverPassenger(
          name: 'Andrea M.',
          initials: 'AM',
          pickup: 'Av. Arenales con Canevaro',
        ),
        DriverPassenger(
          name: 'Luis T.',
          initials: 'LT',
          pickup: 'Av. Javier Prado con Arequipa',
        ),
        DriverPassenger(
          name: 'Rosa C.',
          initials: 'RC',
          pickup: 'Av. Rivera Navarrete 501',
        ),
      ],
      stops: [
        TripStop(
          address: 'Av. Arequipa con Risso',
          time: '7:10 a. m.',
          passengerName: 'Lucía P.',
        ),
        TripStop(
          address: 'Av. Arenales con Canevaro',
          time: '7:17 a. m.',
          passengerName: 'Andrea M.',
        ),
        TripStop(
          address: 'Av. Javier Prado con Arequipa',
          time: '7:24 a. m.',
          passengerName: 'Luis T.',
        ),
        TripStop(
          address: 'Av. Rivera Navarrete 501',
          time: '7:30 a. m.',
          passengerName: 'Rosa C.',
        ),
        TripStop(
          address: 'San Isidro',
          time: '7:38 a. m.',
          passengerName: 'Destino',
          isDestination: true,
        ),
      ],
      mapPoints: DriverDemoMapRoutes.linceToSanIsidro,
      status: DriverTripStatus.upcoming,
      distanceLabel: '9.2 km',
      durationLabel: '28 min',
    ),
    const DriverTrip(
      id: 'SW-2026-069',
      origin: 'Jesús María',
      destination: 'Surco',
      dateLabel: 'Jue, 20 nov',
      timeLabel: '7:20 a. m.',
      estimatedFare: 24.30,
      passengers: [
        DriverPassenger(
          name: 'Mariana R.',
          initials: 'MR',
          pickup: 'Av. Salaverry',
        ),
        DriverPassenger(
          name: 'Diego V.',
          initials: 'DV',
          pickup: 'San Borja Sur',
        ),
      ],
      stops: [
        TripStop(
          address: 'Av. Salaverry',
          time: '7:20 a. m.',
          passengerName: 'Mariana R.',
        ),
        TripStop(
          address: 'San Borja Sur',
          time: '7:31 a. m.',
          passengerName: 'Diego V.',
        ),
        TripStop(
          address: 'Surco',
          time: '7:48 a. m.',
          passengerName: 'Destino',
          isDestination: true,
        ),
      ],
      mapPoints: DriverDemoMapRoutes.jesusMariaToSurco,
      status: DriverTripStatus.upcoming,
      distanceLabel: '11.4 km',
      durationLabel: '32 min',
      routeChanged: true,
    ),
    const DriverTrip(
      id: 'SW-2026-061',
      origin: 'Miraflores',
      destination: 'Lima Centro',
      dateLabel: '10 nov',
      timeLabel: '8:05 a. m.',
      estimatedFare: 19.80,
      passengers: [
        DriverPassenger(
          name: 'Camila G.',
          initials: 'CG',
          pickup: 'Av. Larco',
          boarded: true,
        ),
        DriverPassenger(
          name: 'Pablo N.',
          initials: 'PN',
          pickup: 'Parque Kennedy',
          boarded: true,
        ),
      ],
      stops: [
        TripStop(
          address: 'Av. Larco',
          time: '8:05 a. m.',
          passengerName: 'Camila G.',
        ),
        TripStop(
          address: 'Parque Kennedy',
          time: '8:11 a. m.',
          passengerName: 'Pablo N.',
        ),
        TripStop(
          address: 'Lima Centro',
          time: '8:34 a. m.',
          passengerName: 'Destino',
          isDestination: true,
        ),
      ],
      mapPoints: DriverDemoMapRoutes.mirafloresToCentro,
      status: DriverTripStatus.completed,
      distanceLabel: '7.8 km',
      durationLabel: '29 min',
    ),
  ];

  final List<DriverProposal> _proposals = [
    const DriverProposal(
      id: 'PROP-101',
      origin: 'Lince',
      destination: 'San Isidro',
      dateLabel: 'Jue, 19 nov',
      timeLabel: '7:05 a. m.',
      estimatedFare: 26.40,
      passengerCount: 4,
      stopCount: 3,
      distanceLabel: '9.2 km',
      durationLabel: '28 min',
      expiresIn: '04:32',
      mapPoints: DriverDemoMapRoutes.linceToSanIsidro,
    ),
    const DriverProposal(
      id: 'PROP-102',
      origin: 'Jesús María',
      destination: 'Surco',
      dateLabel: 'Vie, 20 nov',
      timeLabel: '7:20 a. m.',
      estimatedFare: 24.30,
      passengerCount: 3,
      stopCount: 2,
      distanceLabel: '11.4 km',
      durationLabel: '32 min',
      expiresIn: '11:05',
      mapPoints: DriverDemoMapRoutes.jesusMariaToSurco,
    ),
  ];

  bool _isSharing = true;

  @override
  List<DriverTrip> get trips => List.unmodifiable(_trips);

  @override
  List<DriverProposal> get proposals => List.unmodifiable(_proposals);

  bool get isSharing => _isSharing;

  @override
  void respondToProposal(String proposalId, ProposalStatus response) {
    final index = _proposals.indexWhere(
      (proposal) => proposal.id == proposalId,
    );
    if (index == -1) return;
    _proposals[index] = _proposals[index].copyWith(status: response);
  }

  @override
  void setTripSharing(String tripId, bool isSharing) {
    _isSharing = isSharing;
  }

  @override
  void updateTripStatus(String tripId, DriverTripStatus status) {
    final index = _trips.indexWhere((trip) => trip.id == tripId);
    if (index == -1) return;
    _trips[index] = _trips[index].copyWith(status: status);
  }

  @override
  void simulatePassengerCancellation(String tripId) {
    final index = _trips.indexWhere((trip) => trip.id == tripId);
    if (index == -1) return;
    final trip = _trips[index];
    if (trip.passengers.isEmpty) return;
    final remainingPassengers = trip.passengers.sublist(
      0,
      trip.passengers.length - 1,
    );
    final remainingStops = trip.stops
        .where((stop) => stop.passengerName != trip.passengers.last.name)
        .toList();
    _trips[index] = trip.copyWith(
      passengers: remainingPassengers,
      stops: remainingStops,
      mapPoints: trip.mapPoints
          .where((point) => point.passengerName != trip.passengers.last.name)
          .toList(growable: false),
      routeChanged: true,
    );
  }

  @override
  void markPassengerBoarded(String tripId, String passengerName) {
    final tripIndex = _trips.indexWhere((trip) => trip.id == tripId);
    if (tripIndex == -1) return;
    final trip = _trips[tripIndex];
    final passengers = trip.passengers
        .map(
          (passenger) => passenger.name == passengerName
              ? passenger.copyWith(boarded: true)
              : passenger,
        )
        .toList();
    _trips[tripIndex] = trip.copyWith(passengers: passengers);
  }
}
