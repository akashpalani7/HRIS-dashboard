import '../models/app_user.dart';
import '../models/leave_request.dart';
import '../models/payslip.dart';
import '../models/performance_review.dart';

/// Every screen in the app talks to this interface, never directly to
/// MockApiService or RealApiService. That's what lets the same dashboard
/// code work identically whether the toggle is set to Mock or Live.
abstract class ApiService {
  Future<AppUser?> login(String email, String password);

  Future<int> getLeaveBalance(int userId);

  Future<int> applyLeave({
    required int employeeId,
    required String employeeName,
    required int managerId,
    required String startDate,
    required String endDate,
    required String reason,
  });

  Future<List<LeaveRequest>> requestsForManager(int managerId);

  Future<List<LeaveRequest>> requestsForEmployee(int employeeId);

  Future<List<LeaveRequest>> allRequests();

  Future<void> updateLeaveStatus(int requestId, String status);

  Future<Map<String, int>> hrSummary();

  Future<void> updateWebCredentials(int userId, String loginId, String password);

  Future<List<AppUser>> getDirectory();

  Future<List<Payslip>> getPayslips(int userId);

  Future<List<PerformanceReview>> getReviews(int employeeId);

  Future<void> submitReviewFeedback(int reviewId, String feedback);

  Future<void> runPayroll();

  Future<void> launchReviewCycle();
}
