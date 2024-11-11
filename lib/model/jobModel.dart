class JobData {
  final int userid;
  final String fullName;
  final String email;
  final String category;
  final double price;
  final String contactNumber;
  final String details;

  JobData({
    required this.userid,
    required this.fullName,
    required this.email,
    required this.category,
    required this.price,
    required this.contactNumber,
    required this.details,
  });

  Map<String, dynamic> toMap() {
    final map = {
      'userid': userid,
      'fullName': fullName,
      'email': email,
      'category': category,
      'price': price,
      'contactNumber': contactNumber,
      'details': details,
    };
    print("Converting to map: $map");
    return map;
  }

  factory JobData.fromMap(Map<String, dynamic> map) {
    return JobData(
      userid: map['userid'],
      fullName: map['fullName'],
      contactNumber: map['contactNumber'],
      email: map['email'],
      category: map['category'],
      price: map['price'],
      details: map['details'],
    );
  }
}

class JobDataList {
  final int userid;
  final String fullName;
  final String email;
  final String category;
  final double price;
  final String contactNumber;
  final String details;

  JobDataList({
    required this.userid,
    required this.fullName,
    required this.email,
    required this.category,
    required this.price,
    required this.contactNumber,
    required this.details,
  });

  Map<String, dynamic> toMap() {
    final map = {
      'userid': userid,
      'fullName': fullName,
      'email': email,
      'category': category,
      'price': price,
      'contactNumber': contactNumber,
      'details': details,
    };
    print("Converting to map: $map");
    return map;
  }

  factory JobDataList.fromMap(Map<String, dynamic> map) {
    return JobDataList(
      userid: map['userid'],
      fullName: map['fullName'],
      contactNumber: map['contactNumber'],
      email: map['email'],
      category: map['category'],
      price: map['price'],
      details: map['details'],
    );
  }
}
