class Payslip {
  final int id;
  final int employeeId;
  final String date;
  final double amount;
  final String status;

  Payslip({
    required this.id,
    required this.employeeId,
    required this.date,
    required this.amount,
    required this.status,
  });

  factory Payslip.fromJson(Map<String, dynamic> json) {
    return Payslip(
      id: json['id'] as int,
      employeeId: json['employee_id'] as int,
      date: json['date'] as String,
      amount: (json['amount'] as num).toDouble(),
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_id': employeeId,
      'date': date,
      'amount': amount,
      'status': status,
    };
  }
}
