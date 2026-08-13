class LeaveRequest {
  final int id;
  final int employeeId;
  final String employeeName;
  final int managerId;
  final String startDate;
  final String endDate;
  final String reason;
  final String status; // pending | approved | rejected

  LeaveRequest({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.managerId,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.status,
  });

  // Accepts both the snake_case keys the Express/MySQL API returns and the
  // camelCase keys the in-memory mock store uses, so the same model works
  // for both API implementations without extra mapping code.
  factory LeaveRequest.fromJson(Map<String, dynamic> json) {
    return LeaveRequest(
      id: json['id'] as int,
      employeeId: (json['employee_id'] ?? json['employeeId']) as int,
      employeeName: (json['employee_name'] ?? json['employeeName'] ?? '') as String,
      managerId: (json['manager_id'] ?? json['managerId']) as int,
      startDate: (json['start_date'] ?? json['startDate'] ?? '').toString(),
      endDate: (json['end_date'] ?? json['endDate'] ?? '').toString(),
      reason: (json['reason'] ?? '') as String,
      status: (json['status'] ?? 'pending') as String,
    );
  }
}
