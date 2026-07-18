class User {
  final String id;
  final String employeeId;
  final String fullName;
  final String department;
  final String role;
  final String gender;
  final bool isActive;
  final bool isFirstLogin;
  final bool accountLocked;
  final int loginAttempts;
  final String? supervisorId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastLogin;

  User({
    required this.id,
    required this.employeeId,
    required this.fullName,
    required this.department,
    required this.role,
    required this.gender,
    required this.isActive,
    required this.isFirstLogin,
    required this.accountLocked,
    required this.loginAttempts,
    this.supervisorId,
    required this.createdAt,
    required this.updatedAt,
    this.lastLogin,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["_id"],
      employeeId: json["employeeId"],
      fullName: json["fullName"],
      department: json["department"],
      role: json["role"],
      gender: json["gender"],
      isActive: json["isActive"],
      isFirstLogin: json["isFirstLogin"],
      accountLocked: json["accountLocked"],
      loginAttempts: json["loginAttempts"],
      supervisorId: json["supervisorId"],
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
      lastLogin: json["lastLogin"] == null
          ? null
          : DateTime.parse(json["lastLogin"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "employeeId": employeeId,
      "fullName": fullName,
      "department": department,
      "role": role,
      "gender": gender,
      "isActive": isActive,
      "isFirstLogin": isFirstLogin,
      "accountLocked": accountLocked,
      "loginAttempts": loginAttempts,
      "supervisorId": supervisorId,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
      "lastLogin": lastLogin?.toIso8601String(),
    };
  }
}
