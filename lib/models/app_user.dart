enum UserRole { hr, manager, employee }

UserRole roleFromString(String value) {
  switch (value) {
    case 'hr':
      return UserRole.hr;
    case 'manager':
      return UserRole.manager;
    default:
      return UserRole.employee;
  }
}

String roleToString(UserRole role) {
  switch (role) {
    case UserRole.hr:
      return 'hr';
    case UserRole.manager:
      return 'manager';
    case UserRole.employee:
      return 'employee';
  }
}

class AppUser {
  final int id;
  final String name;
  final String email;
  final UserRole role;
  
  final String? department;
  final int? managerId;
  final String? joinDate;
  final String? address;
  final String? workType;
  final String? lastPayrollDate;

  final String? webLoginId;
  final String? webPassword;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.department,
    this.managerId,
    this.joinDate,
    this.address,
    this.workType,
    this.lastPayrollDate,
    this.webLoginId,
    this.webPassword,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] is int ? json['id'] as int : int.parse(json['id'].toString()),
      name: json['name'] as String,
      email: json['email'] as String,
      role: roleFromString(json['role'] as String),
      department: json['department'] as String?,
      managerId: json['manager_id'] as int?,
      joinDate: json['join_date'] as String?,
      address: json['address'] as String?,
      workType: json['work_type'] as String?,
      lastPayrollDate: json['last_payroll_date'] as String?,
      webLoginId: json['web_login_id'] as String?,
      webPassword: json['web_password'] as String?,
    );
  }
}
