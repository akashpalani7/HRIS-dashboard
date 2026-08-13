class PerformanceReview {
  final int id;
  final int employeeId;
  final String employeeName;
  final int managerId;
  final String title;
  final String status;
  final String? feedback;

  PerformanceReview({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.managerId,
    required this.title,
    required this.status,
    this.feedback,
  });

  factory PerformanceReview.fromJson(Map<String, dynamic> json) {
    return PerformanceReview(
      id: json['id'] as int,
      employeeId: json['employee_id'] as int,
      employeeName: json['employee_name'] as String,
      managerId: json['manager_id'] as int,
      title: json['title'] as String,
      status: json['status'] as String,
      feedback: json['feedback'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_id': employeeId,
      'employee_name': employeeName,
      'manager_id': managerId,
      'title': title,
      'status': status,
      'feedback': feedback,
    };
  }
}
