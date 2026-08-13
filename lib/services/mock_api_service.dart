import '../models/app_user.dart';
import '../models/leave_request.dart';
import '../models/payslip.dart';
import '../models/performance_review.dart';
import 'api_service.dart';
import 'mock_data_store.dart';

/// Implements the same ApiService contract as RealApiService, but reads and
/// writes to the in-memory MockDataStore instead of making network calls.
/// A small artificial delay is added so loading states in the UI behave the
/// same way they would against a real network call.
class MockApiService implements ApiService {
  final _store = MockDataStore.instance;
  static const _fakeDelay = Duration(milliseconds: 300);

  /// Used by the login screen's persona buttons to fetch the demo user for
  /// a given role directly, without needing an email/password step.
  AppUser userForRole(String role) {
    final match = _store.findUserByRole(role);
    if (match == null) {
      throw StateError('No mock user found for role "$role"');
    }
    return AppUser.fromJson(match);
  }

  @override
  Future<AppUser?> login(String email, String password) async {
    await Future.delayed(_fakeDelay);
    for (final u in _store.users) {
      if (u['email'] == email) return AppUser.fromJson(u);
    }
    return null;
  }

  @override
  Future<int> getLeaveBalance(int userId) async {
    await Future.delayed(_fakeDelay);
    return _store.leaveBalances[userId] ?? 0;
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
    await Future.delayed(_fakeDelay);
    return _store.applyLeave(
      employeeId: employeeId,
      employeeName: employeeName,
      managerId: managerId,
      startDate: startDate,
      endDate: endDate,
      reason: reason,
    );
  }

  @override
  Future<List<LeaveRequest>> requestsForManager(int managerId) async {
    await Future.delayed(_fakeDelay);
    return _store.requestsForManager(managerId).map(LeaveRequest.fromJson).toList();
  }

  @override
  Future<List<LeaveRequest>> requestsForEmployee(int employeeId) async {
    await Future.delayed(_fakeDelay);
    return _store.requestsForEmployee(employeeId).map(LeaveRequest.fromJson).toList();
  }

  @override
  Future<List<LeaveRequest>> allRequests() async {
    await Future.delayed(_fakeDelay);
    return _store.allRequests().map(LeaveRequest.fromJson).toList();
  }

  @override
  Future<void> updateLeaveStatus(int requestId, String status) async {
    await Future.delayed(_fakeDelay);
    _store.updateStatus(requestId, status);
  }

  @override
  Future<Map<String, int>> hrSummary() async {
    await Future.delayed(_fakeDelay);
    return _store.hrSummary();
  }

  @override
  Future<void> updateWebCredentials(int userId, String loginId, String password) async {
    await Future.delayed(_fakeDelay);
    _store.updateWebCredentials(userId, loginId, password);
  }

  @override
  Future<List<AppUser>> getDirectory() async {
    await Future.delayed(_fakeDelay);
    return _store.users.map((u) => AppUser.fromJson(u)).toList();
  }

  @override
  Future<List<Payslip>> getPayslips(int userId) async {
    await Future.delayed(_fakeDelay);
    return _store.getPayslips(userId).map((p) => Payslip.fromJson(p)).toList();
  }

  @override
  Future<List<PerformanceReview>> getReviews(int employeeId) async {
    await Future.delayed(_fakeDelay);
    return _store.getReviews(employeeId).map((r) => PerformanceReview.fromJson(r)).toList();
  }

  @override
  Future<void> submitReviewFeedback(int reviewId, String feedback) async {
    await Future.delayed(_fakeDelay);
    _store.submitReviewFeedback(reviewId, feedback);
  }

  @override
  Future<void> runPayroll() async {
    await Future.delayed(_fakeDelay);
    _store.runPayroll();
  }

  @override
  Future<void> launchReviewCycle() async {
    await Future.delayed(_fakeDelay);
    _store.launchReviewCycle();
  }
}
