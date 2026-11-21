import 'package:flutter/foundation.dart';

import '../data/demo_driver_repository.dart';
import '../domain/driver_models.dart';

class DriverController extends ChangeNotifier {
  DriverController(this._repository);

  final DemoDriverRepository _repository;
  String? _emergencyMessage;
  bool _emergencySent = false;

  List<DriverTrip> get trips => _repository.trips;
  List<DriverProposal> get proposals => _repository.proposals;
  bool get isSharing => _repository.isSharing;
  String? get emergencyMessage => _emergencyMessage;
  bool get emergencySent => _emergencySent;

  DriverTrip? get nextTrip {
    for (final trip in trips) {
      if (trip.status == DriverTripStatus.upcoming ||
          trip.status == DriverTripStatus.active) {
        return trip;
      }
    }
    return null;
  }

  void respondToProposal(String proposalId, ProposalStatus response) {
    _repository.respondToProposal(proposalId, response);
    notifyListeners();
  }

  void setTripSharing(String tripId, bool enabled) {
    _repository.setTripSharing(tripId, enabled);
    notifyListeners();
  }

  void updateTripStatus(String tripId, DriverTripStatus status) {
    _repository.updateTripStatus(tripId, status);
    notifyListeners();
  }

  void simulatePassengerCancellation(String tripId) {
    _repository.simulatePassengerCancellation(tripId);
    notifyListeners();
  }

  void markPassengerBoarded(String tripId, String passengerName) {
    _repository.markPassengerBoarded(tripId, passengerName);
    notifyListeners();
  }

  void sendEmergencyAlert() {
    _emergencySent = true;
    _emergencyMessage = 'Tu alerta fue enviada a Marta y al equipo ShareWay.';
    notifyListeners();
  }

  void resetEmergencyAlert() {
    _emergencySent = false;
    _emergencyMessage = null;
    notifyListeners();
  }
}
