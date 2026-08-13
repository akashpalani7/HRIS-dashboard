import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/app_user.dart';
import '../models/leave_request.dart';
import '../models/payslip.dart';
import '../models/performance_review.dart';
import 'api_service.dart';

/// Talks to the local Express + MySQL backend over plain HTTP.
/// See lib/config/api_config.dart for how the base URL is picked per platform.
class RealApiService implements ApiService {
  String get _base => ApiConfig.baseUrl;

  @override
  Future<AppUser?> login(String email, String password) async {
    final res = await http.post(
      Uri.parse('$_base/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (res.statusCode == 200) {
      return AppUser.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  @override
  Future<int> getLeaveBalance(int userId) async {
    final res = await http.get(Uri.parse('$_base/leave/balance/$userId'));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      return (data['balance'] ?? 0) as int;
    }
    throw Exception('Failed to load leave balance (${res.statusCode})');
  }

  @override
  Future<int> applyLeave({
    required int employeeId,
    required String employeeName,
    required int managerId,
    required String startDate,
    required String endDate,
    required String reason,
  }) async {
    final res = await http.post(
      Uri.parse('$_base/leave/apply'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'employeeId': employeeId,
        'managerId': managerId,
        'startDate': startDate,
        'endDate': endDate,
        'reason': reason,
      }),
    );
    if (res.statusCode == 201) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      return data['id'] as int;
    }
    throw Exception('Failed to submit leave request (${res.statusCode})');
  }

  @override
  Future<List<LeaveRequest>> requestsForManager(int managerId) async {
    final res = await http.get(Uri.parse('$_base/leave/requests?managerId=$managerId'));
    return _parseList(res);
  }

  @override
  Future<List<LeaveRequest>> requestsForEmployee(int employeeId) async {
    final res = await http.get(Uri.parse('$_base/leave/requests?employeeId=$employeeId'));
    return _parseList(res);
  }

  @override
  Future<List<LeaveRequest>> allRequests() async {
    final res = await http.get(Uri.parse('$_base/leave/requests'));
    return _parseList(res);
  }

  List<LeaveRequest> _parseList(http.Response res) {
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body) as List<dynamic>;
      return data.map((e) => LeaveRequest.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Failed to load leave requests (${res.statusCode})');
  }

  @override
  Future<void> updateLeaveStatus(int requestId, String status) async {
    final res = await http.put(
      Uri.parse('$_base/leave/requests/$requestId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'status': status}),
    );
    if (res.statusCode != 200) {
      throw Exception('Failed to update request (${res.statusCode})');
    }
  }

  @override
  Future<Map<String, int>> hrSummary() async {
    final res = await http.get(Uri.parse('$_base/dashboard/hr-summary'));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      return {
        'total': (data['total'] ?? 0) as int,
        'pending': (data['pending'] ?? 0) as int,
        'approved': (data['approved'] ?? 0) as int,
        'headcount': (data['headcount'] ?? 0) as int,
      };
    }
    throw Exception('Failed to load HR summary (${res.statusCode})');
  }

  @override
  Future<void> updateWebCredentials(int userId, String loginId, String password) async {
    throw UnimplementedError('Real backend not required for credentials in mock-focused project.');
  }

  @override
  Future<List<AppUser>> getDirectory() async {
    throw UnimplementedError();
  }

  @override
  Future<List<Payslip>> getPayslips(int userId) async {
    throw UnimplementedError();
  }

  @override
  Future<List<PerformanceReview>> getReviews(int employeeId) async {
    throw UnimplementedError();
  }

  @override
  Future<void> submitReviewFeedback(int reviewId, String feedback) async {
    throw UnimplementedError();
  }

  @override
  Future<void> runPayroll() async {
    throw UnimplementedError();
  }

  @override
  Future<void> launchReviewCycle() async {
    throw UnimplementedError();
  }
}
