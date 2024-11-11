class UserModel {
  final int userid;
  final String fullName;
  final String userName;
  final String email;
  final String password;
  final String contactNumber;
  final String type;

  // Constructor
  UserModel({
    required this.userid,
    required this.fullName,
    required this.userName,
    required this.email,
    required this.password,
    required this.contactNumber,
    required this.type,
  });

  // Convert a UserModel object to a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': userid,
      'fullName': fullName,
      'userName': userName,
      'email': email,
      'password': password,
      'contactNumber': contactNumber,
      'type': type,
    };
  }

  // Convert a Map object to a UserModel object
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userid: map['userid'],
      fullName: map['fullName'],
      userName: map['userName'],
      email: map['email'],
      password: map['password'],
      contactNumber: map['contactNumber'],
      type: map['type'],
    );
  }
}
