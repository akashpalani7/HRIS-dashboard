/// Holds all "fake backend" data in memory for the lifetime of the app
/// process. Because this is a singleton (one shared instance), data you
/// create in mock mode - e.g. an employee applying for leave, or a manager
/// approving it - is visible immediately when you log out and log back in
/// as a different persona. Closing the app fully (not just logging out)
/// resets everything back to the seed data below, since nothing is written
/// to disk on purpose - this is meant purely for trying out the flow
/// without needing Express or MySQL running at all.
import 'package:flutter/foundation.dart';

class MockDataStore {
  MockDataStore._internal();
  static final MockDataStore instance = MockDataStore._internal();
  
  final ValueNotifier<int> revision = ValueNotifier(0);
  void _notify() => revision.value++;

  final List<Map<String, dynamic>> users = [
    // CEO / C-Level
    {
      'id': 1,
      'name': 'Victoria Manaswini',
      'email': 'victoria@nexus.com',
      'role': 'manager',
      'department': 'Executive',
      'manager_id': null,
      'join_date': '2019-01-10',
      'address': '101 Summit Ave, NY',
      'work_type': 'On-site',
      'last_payroll_date': '2026-07-31'
    },

    // HR & Admin
    {
      'id': 2,
      'name': 'Anita Sharma',
      'email': 'hr@demo.com',
      'role': 'hr',
      'department': 'Human Resources',
      'manager_id': 1,
      'join_date': '2020-03-15',
      'address': '22 Baker St, NY',
      'work_type': 'Hybrid',
      'last_payroll_date': '2026-07-31'
    },
    {
      'id': 3,
      'name': 'Marcus Vance',
      'email': 'marcus@nexus.com',
      'role': 'hr',
      'department': 'Human Resources',
      'manager_id': 2,
      'join_date': '2023-05-11',
      'address': '333 Maple Dr, NJ',
      'work_type': 'WFH',
      'last_payroll_date': '2026-07-31'
    },

    // Engineering Leadership
    {
      'id': 4,
      'name': 'Rahul Verma',
      'email': 'manager@demo.com',
      'role': 'manager',
      'department': 'Engineering',
      'manager_id': 1,
      'join_date': '2020-01-20',
      'address': '840 tech blvd, NY',
      'work_type': 'On-site',
      'last_payroll_date': '2026-07-31'
    },
    {
      'id': 5,
      'name': 'Elisa Torres',
      'email': 'elisa@nexus.com',
      'role': 'manager',
      'department': 'Engineering',
      'manager_id': 4,
      'join_date': '2021-08-01',
      'address': '1701 River Rd, NJ',
      'work_type': 'Hybrid',
      'last_payroll_date': '2026-07-31'
    },

    // Engineers reporting to Rahul (Manager 4)
    {
      'id': 6,
      'name': 'Kuruvila Khan',
      'email': 'kuruvila@demo.com',
      'role': 'employee',
      'department': 'Engineering',
      'manager_id': 4,
      'join_date': '2022-11-20',
      'address': '45 Elm Street, NY',
      'work_type': 'WFH',
      'last_payroll_date': '2026-07-31'
    },
    {
      'id': 7,
      'name': 'James Miller',
      'email': 'james@nexus.com',
      'role': 'employee',
      'department': 'Engineering',
      'manager_id': 4,
      'join_date': '2024-02-15',
      'address': '99 Cherry Ln, NY',
      'work_type': 'On-site',
      'last_payroll_date': '2026-07-31'
    },

    // Engineers reporting to Elisa (Manager 5)
    {
      'id': 8,
      'name': 'Chloe Zhu',
      'email': 'chloe@nexus.com',
      'role': 'employee',
      'department': 'Engineering',
      'manager_id': 5,
      'join_date': '2025-01-14',
      'address': '201 Code Ave, NJ',
      'work_type': 'Hybrid',
      'last_payroll_date': '2026-07-31'
    },
    {
      'id': 9,
      'name': 'David Kim',
      'email': 'david@nexus.com',
      'role': 'employee',
      'department': 'Engineering',
      'manager_id': 5,
      'join_date': '2023-09-01',
      'address': '842 Willow Rd, NY',
      'work_type': 'WFH',
      'last_payroll_date': '2026-07-31'
    },

    // Product Team
    {
      'id': 10,
      'name': 'Sarah Jenkins',
      'email': 'sjenkins@nexus.com',
      'role': 'manager',
      'department': 'Product',
      'manager_id': 1,
      'join_date': '2019-11-01',
      'address': '300 Design Pl, NY',
      'work_type': 'Hybrid',
      'last_payroll_date': '2026-07-31'
    },
    {
      'id': 11,
      'name': 'Liam O\'Connor',
      'email': 'liam@nexus.com',
      'role': 'employee',
      'department': 'Product',
      'manager_id': 10,
      'join_date': '2022-03-22',
      'address': '44 Vision St, NJ',
      'work_type': 'On-site',
      'last_payroll_date': '2026-07-31'
    },
    {
      'id': 12,
      'name': 'Maya Patel',
      'email': 'maya@nexus.com',
      'role': 'employee',
      'department': 'Product',
      'manager_id': 10,
      'join_date': '2023-01-10',
      'address': '998 Maker Wy, NY',
      'work_type': 'WFH',
      'last_payroll_date': '2026-07-31'
    },

    // Sales & Marketing
    {
      'id': 13,
      'name': 'Alexander Hunt',
      'email': 'alex@nexus.com',
      'role': 'manager',
      'department': 'Sales',
      'manager_id': 1,
      'join_date': '2020-04-18',
      'address': '700 Dollar Ave, NY',
      'work_type': 'On-site',
      'last_payroll_date': '2026-07-31'
    },
    {
      'id': 14,
      'name': 'Nina Ricci',
      'email': 'nina@nexus.com',
      'role': 'employee',
      'department': 'Sales',
      'manager_id': 13,
      'join_date': '2021-07-07',
      'address': '88 Deal St, NY',
      'work_type': 'Hybrid',
      'last_payroll_date': '2026-07-31'
    },
    {
      'id': 15,
      'name': 'Tom Banks',
      'email': 'tom@nexus.com',
      'role': 'employee',
      'department': 'Sales',
      'manager_id': 13,
      'join_date': '2025-06-05',
      'address': '22 Closer Cir, NJ',
      'work_type': 'WFH',
      'last_payroll_date': '2026-07-31'
    },
  ];

  final Map<int, int> leaveBalances = {6: 12, 11: 15, 2: 24, 4: 9};

  final List<Map<String, dynamic>> leaveRequests = [
    {
      'id': 1,
      'employee_id': 6,
      'employee_name': 'Kuruvila Khan',
      'manager_id': 4,
      'start_date': '2026-08-20',
      'end_date': '2026-08-22',
      'reason': 'Family function',
      'status': 'pending',
    },
  ];

  int _nextRequestId = 2;

  Map<String, dynamic>? findUserByRole(String role) {
    if (role == 'manager') return users.firstWhere((u) => u['id'] == 4, orElse: () => users.first);
    if (role == 'employee') return users.firstWhere((u) => u['id'] == 6, orElse: () => users.first);
    if (role == 'hr') return users.firstWhere((u) => u['id'] == 2, orElse: () => users.first);
    
    for (final u in users) {
      if (u['role'] == role) return u;
    }
    return null;
  }

  int applyLeave({
    required int employeeId,
    required String employeeName,
    required int managerId,
    required String startDate,
    required String endDate,
    required String reason,
  }) {
    final id = _nextRequestId++;

    final s = DateTime.parse(startDate);
    final e = DateTime.parse(endDate);
    final days = e.difference(s).inDays + 1;

    if (leaveBalances.containsKey(employeeId)) {
      leaveBalances[employeeId] = (leaveBalances[employeeId] ?? 0) - days;
    }

    leaveRequests.add({
      'id': id,
      'employee_id': employeeId,
      'employee_name': employeeName,
      'manager_id': managerId,
      'start_date': startDate,
      'end_date': endDate,
      'reason': reason,
      'status': 'pending',
    });
    return id;
  }

  void updateStatus(int id, String status) {
    bool changed = false;
    final index = leaveRequests.indexWhere((r) => r['id'] == id);
    if (index != -1) {
      leaveRequests[index]['status'] = status;
      changed = true;
    }
    if (changed) _notify();
  }

  List<Map<String, dynamic>> requestsForManager(int managerId) {
    return leaveRequests.where((r) => r['manager_id'] == managerId).toList();
  }

  List<Map<String, dynamic>> requestsForEmployee(int employeeId) {
    return leaveRequests.where((r) => r['employee_id'] == employeeId).toList();
  }

  List<Map<String, dynamic>> allRequests() => List.from(leaveRequests);

  Map<String, int> hrSummary() {
    final total = leaveRequests.length;
    final pending = leaveRequests.where((r) => r['status'] == 'pending').length;
    final approved =
        leaveRequests.where((r) => r['status'] == 'approved').length;
    return {
      'total': total,
      'pending': pending,
      'approved': approved,
      'headcount': users.length,
    };
  }

  void updateWebCredentials(int userId, String loginId, String password) {
    final index = users.indexWhere((u) => u['id'] == userId);
    if (index != -1) {
      users[index]['web_login_id'] = loginId;
      users[index]['web_password'] = password;
    }
  }

  final List<Map<String, dynamic>> payslips = [
    {
      'id': 1,
      'employee_id': 3,
      'date': '2026-07-31',
      'amount': 4500.00,
      'status': 'processed'
    },
    {
      'id': 2,
      'employee_id': 3,
      'date': '2026-08-15',
      'amount': 4500.00,
      'status': 'draft'
    },
  ];

  List<Map<String, dynamic>> getPayslips(int employeeId) {
    return payslips.where((p) => p['employee_id'] == employeeId).toList();
  }

  final List<Map<String, dynamic>> performanceReviews = [
    {
      'id': 1,
      'employee_id': 3,
      'employee_name': 'Sara Employee',
      'manager_id': 2,
      'title': 'Q2 Review',
      'status': 'pending_employee',
      'feedback': null
    },
    {
      'id': 2,
      'employee_id': 3,
      'employee_name': 'Sara Employee',
      'manager_id': 2,
      'title': 'Q1 Review',
      'status': 'completed',
      'feedback': 'Great work.'
    },
    {
      'id': 3,
      'employee_id': 1,
      'employee_name': 'Anita Sharma',
      'manager_id': 2,
      'title': 'Q2 Review',
      'status': 'pending_employee',
      'feedback': null
    },
  ];

  List<Map<String, dynamic>> getReviews(int employeeId) {
    return performanceReviews
        .where((r) => r['employee_id'] == employeeId)
        .toList();
  }

  void submitReviewFeedback(int reviewId, String feedback) {
    bool changed = false;
    final index = performanceReviews.indexWhere((r) => r['id'] == reviewId);
    if (index != -1) {
      performanceReviews[index]['feedback'] = feedback;
      performanceReviews[index]['status'] = 'completed';
      changed = true;
    }
    if (changed) _notify();
  }

  void runPayroll() {
    int newId = payslips.isNotEmpty
        ? payslips.map((p) => p['id'] as int).reduce((a, b) => a > b ? a : b) +
            1
        : 1;
    final String date = DateTime.now().toIso8601String().split('T')[0];

    for (final u in users) {
      payslips.add({
        'id': newId++,
        'employee_id': u['id'],
        'date': date,
        'amount': 4550.00 + (u['id'] * 150),
        'status': 'processed'
      });
      u['last_payroll_date'] = date;
    }
  }

  void launchReviewCycle() {
    int newId = performanceReviews.isNotEmpty
        ? performanceReviews
                .map((r) => r['id'] as int)
                .reduce((a, b) => a > b ? a : b) +
            1
        : 1;

    for (final u in users) {
      performanceReviews.add({
        'id': newId++,
        'employee_id': u['id'],
        'employee_name': u['name'],
        'manager_id': u['manager_id'] ?? 1,
        'title': 'Company-wide Review',
        'status': 'pending_employee',
        'feedback': null
      });
    }
  }
}
