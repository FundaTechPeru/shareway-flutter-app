import 'driver_map_models.dart';

enum DriverTripStatus { upcoming, active, completed }

enum ProposalStatus { pending, accepted, declined, expired }

class DriverPassenger {
  const DriverPassenger({
    required this.name,
    required this.initials,
    required this.pickup,
    this.boarded = false,
  });

  final String name;
  final String initials;
  final String pickup;
  final bool boarded;

  DriverPassenger copyWith({bool? boarded}) => DriverPassenger(
    name: name,
    initials: initials,
    pickup: pickup,
    boarded: boarded ?? this.boarded,
  );
}

class TripStop {
  const TripStop({
    required this.address,
    required this.time,
    required this.passengerName,
    this.isDestination = false,
  });

  final String address;
  final String time;
  final String passengerName;
  final bool isDestination;
}

class DriverTrip {
  const DriverTrip({
    required this.id,
    required this.origin,
    required this.destination,
    required this.dateLabel,
    required this.timeLabel,
    required this.estimatedFare,
    required this.passengers,
    required this.stops,
    required this.status,
    required this.distanceLabel,
    required this.durationLabel,
    this.mapPoints = const [],
    this.routeChanged = false,
  });

  final String id;
  final String origin;
  final String destination;
  final String dateLabel;
  final String timeLabel;
  final double estimatedFare;
  final List<DriverPassenger> passengers;
  final List<TripStop> stops;
  final DriverTripStatus status;
  final String distanceLabel;
  final String durationLabel;
  final List<DriverMapPoint> mapPoints;
  final bool routeChanged;

  DriverTrip copyWith({
    List<DriverPassenger>? passengers,
    List<TripStop>? stops,
    List<DriverMapPoint>? mapPoints,
    DriverTripStatus? status,
    bool? routeChanged,
  }) {
    return DriverTrip(
      id: id,
      origin: origin,
      destination: destination,
      dateLabel: dateLabel,
      timeLabel: timeLabel,
      estimatedFare: estimatedFare,
      passengers: passengers ?? this.passengers,
      stops: stops ?? this.stops,
      status: status ?? this.status,
      distanceLabel: distanceLabel,
      durationLabel: durationLabel,
      mapPoints: mapPoints ?? this.mapPoints,
      routeChanged: routeChanged ?? this.routeChanged,
    );
  }
}

class DriverProposal {
  const DriverProposal({
    required this.id,
    required this.origin,
    required this.destination,
    required this.dateLabel,
    required this.timeLabel,
    required this.estimatedFare,
    required this.passengerCount,
    required this.stopCount,
    required this.distanceLabel,
    required this.durationLabel,
    required this.expiresIn,
    this.mapPoints = const [],
    this.status = ProposalStatus.pending,
  });

  final String id;
  final String origin;
  final String destination;
  final String dateLabel;
  final String timeLabel;
  final double estimatedFare;
  final int passengerCount;
  final int stopCount;
  final String distanceLabel;
  final String durationLabel;
  final String expiresIn;
  final List<DriverMapPoint> mapPoints;
  final ProposalStatus status;

  DriverProposal copyWith({ProposalStatus? status}) => DriverProposal(
    id: id,
    origin: origin,
    destination: destination,
    dateLabel: dateLabel,
    timeLabel: timeLabel,
    estimatedFare: estimatedFare,
    passengerCount: passengerCount,
    stopCount: stopCount,
    distanceLabel: distanceLabel,
    durationLabel: durationLabel,
    expiresIn: expiresIn,
    mapPoints: mapPoints,
    status: status ?? this.status,
  );
}

abstract interface class DriverRepository {
  List<DriverTrip> get trips;
  List<DriverProposal> get proposals;

  void respondToProposal(String proposalId, ProposalStatus response);
  void setTripSharing(String tripId, bool isSharing);
  void updateTripStatus(String tripId, DriverTripStatus status);
  void simulatePassengerCancellation(String tripId);
  void markPassengerBoarded(String tripId, String passengerName);
}
