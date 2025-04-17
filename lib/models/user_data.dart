class UserData {
  final int userId;
  final String username;
  final String email;
  final String fullName;
  final List<String> permissions;
  final String jobTitle;
  final int employeeId;

  UserData({
    required this.userId,
    required this.username,
    required this.email,
    required this.fullName,
    required this.permissions,
    required this.jobTitle,
    required this.employeeId
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      userId: json['user_id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      fullName: json['full_name'] ?? '',
      jobTitle: json['job_title'] ?? '',
      permissions: List<String>.from(json['permissions'] ?? []),
      employeeId: json['employee_id'] ?? 0

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'username': username,
      'email': email,
      'full_name': fullName,
      'permissions': permissions,
      'employee_id': employeeId,
      'job_title': jobTitle,
    };
  }
}