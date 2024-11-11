class OrderData {
  final int? id;
  final int jobid;
  final String fullName;
  final String contactNumber;
  final String details;
  final String timestamp;
  final int? userId;

  OrderData({
    this.id,
    required this.jobid,
    required this.fullName,
    required this.contactNumber,
    required this.details,
    required this.timestamp,
    this.userId,
  });

  // Converts an OrderData object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'jobid': jobid,
      'fullName': fullName,
      'contactNumber': contactNumber,
      'details': details,
      'timestamp': timestamp,
      'userId': userId,
    };
  }

  // Converts a Map into an OrderData object
  static OrderData fromMap(Map<String, dynamic> map) {
    return OrderData(
      id: map['id'],
      jobid: map['jobid'],
      fullName: map['fullName'],
      contactNumber: map['contactNumber'],
      details: map['details'],
      timestamp: map['timestamp'],
      userId: map['userId'],
    );
  }

  OrderData copyWith({
    int? id,
    int? jobid,
    String? fullName,
    String? contactNumber,
    String? details,
    String? timestamp,
    int? userId,
  }) {
    return OrderData(
      id: id ?? this.id,
      jobid: jobid ?? this.jobid,
      fullName: fullName ?? this.fullName,
      contactNumber: contactNumber ?? this.contactNumber,
      details: details ?? this.details,
      timestamp: timestamp ?? this.timestamp,
      userId: userId ?? this.userId,
    );
  }
}

class ShowOrder {
  final int jobid;
  final String fullName;
  final String contactNumber;
  final String details;
  final String timestamp;
  final int userId; // Add userId to your OrderData

  ShowOrder({
    required this.jobid,
    required this.fullName,
    required this.contactNumber,
    required this.details,
    required this.timestamp,
    required this.userId, // Add userId to the constructor
  });

  factory ShowOrder.fromMap(Map<String, dynamic> map) {
    return ShowOrder(
      jobid: map['jobid'],
      fullName: map['fullName'],
      contactNumber: map['contactNumber'],
      details: map['details'],
      timestamp: map['timestamp'],
      userId: map['userId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'jobid': jobid,
      'fullName': fullName,
      'contactNumber': contactNumber,
      'details': details,
      'timestamp': timestamp,
      'userId': userId, // Add userId to map
    };
  }
}
