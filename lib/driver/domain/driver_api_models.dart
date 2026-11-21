class DriverAccountSnapshot {
  const DriverAccountSnapshot({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    required this.driverStatus,
    required this.licenseNumber,
    required this.emergencyContact,
  });

  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String role;
  final String driverStatus;
  final String licenseNumber;
  final EmergencyContactData? emergencyContact;

  bool get isDriver => role == 'DRIVER';
  bool get isVerified => driverStatus == 'VERIFIED';

  String get initials {
    final names = fullName.trim().split(RegExp(r'\s+'));
    if (names.isEmpty || names.first.isEmpty) return 'SW';
    return names.take(2).map((name) => name[0].toUpperCase()).join();
  }

  factory DriverAccountSnapshot.fromJson(
    Map<String, dynamic> user,
    Map<String, dynamic>? driver,
  ) {
    final contact = driver?['emergencyContact'];
    return DriverAccountSnapshot(
      id: '${user['id'] ?? driver?['userId'] ?? ''}',
      fullName: '${user['fullName'] ?? driver?['fullName'] ?? ''}',
      email: '${user['email'] ?? driver?['email'] ?? ''}',
      phone: '${user['phone'] ?? ''}',
      role: '${user['role'] ?? (driver == null ? '' : 'DRIVER')}',
      driverStatus:
          '${driver?['driverStatus'] ?? user['driverStatus'] ?? 'PENDING_VERIFICATION'}',
      licenseNumber: '${driver?['licenseNumber'] ?? ''}',
      emergencyContact: contact is Map<String, dynamic>
          ? EmergencyContactData.fromJson(contact)
          : null,
    );
  }
}

class EmergencyContactData {
  const EmergencyContactData({
    required this.name,
    required this.phone,
    required this.relationship,
  });

  final String name;
  final String phone;
  final String relationship;

  Map<String, Object?> toJson() => {
    'name': name,
    'phone': phone,
    'relationship': relationship,
  };

  factory EmergencyContactData.fromJson(Map<String, dynamic> json) =>
      EmergencyContactData(
        name: '${json['name'] ?? ''}',
        phone: '${json['phone'] ?? ''}',
        relationship: '${json['relationship'] ?? ''}',
      );
}

class DriverVehicleData {
  const DriverVehicleData({
    this.id,
    required this.plate,
    required this.brand,
    required this.model,
    required this.year,
    required this.color,
    required this.seats,
  });

  final String? id;
  final String plate;
  final String brand;
  final String model;
  final int year;
  final String color;
  final int seats;

  Map<String, Object?> toJson() => {
    'plate': plate,
    'brand': brand,
    'model': model,
    'year': year,
    'color': color,
    'seats': seats,
  };

  factory DriverVehicleData.fromJson(Map<String, dynamic> json) =>
      DriverVehicleData(
        id: json['id']?.toString(),
        plate: '${json['plate'] ?? ''}',
        brand: '${json['brand'] ?? ''}',
        model: '${json['model'] ?? ''}',
        year: _toInt(json['year']),
        color: '${json['color'] ?? ''}',
        seats: _toInt(json['seats']),
      );
}

class DriverDocumentData {
  const DriverDocumentData({
    required this.id,
    required this.type,
    required this.status,
    required this.filename,
    this.rejectionReason,
  });

  final String id;
  final String type;
  final String status;
  final String filename;
  final String? rejectionReason;

  factory DriverDocumentData.fromJson(Map<String, dynamic> json) =>
      DriverDocumentData(
        id: '${json['id'] ?? ''}',
        type: '${json['type'] ?? ''}',
        status: '${json['status'] ?? 'PENDING'}',
        filename: '${json['originalFilename'] ?? ''}',
        rejectionReason: json['rejectionReason']?.toString(),
      );
}

class WeeklyAvailabilitySlot {
  const WeeklyAvailabilitySlot({
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
  });

  final String dayOfWeek;
  final String startTime;
  final String endTime;

  Map<String, Object?> toJson() => {
    'dayOfWeek': dayOfWeek,
    'startTime': _timeOnly(startTime),
    'endTime': _timeOnly(endTime),
  };

  factory WeeklyAvailabilitySlot.fromJson(Map<String, dynamic> json) =>
      WeeklyAvailabilitySlot(
        dayOfWeek: '${json['dayOfWeek'] ?? ''}',
        startTime: '${json['startTime'] ?? ''}',
        endTime: '${json['endTime'] ?? ''}',
      );
}

int _toInt(dynamic value) =>
    value is num ? value.toInt() : int.tryParse('$value') ?? 0;

String _timeOnly(String value) =>
    value.length >= 5 ? value.substring(0, 5) : value;
