import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../services/service_locator.dart';
import '../widgets/dashboard_scaffold.dart';
import '../widgets/app_card.dart';
import '../widgets/app_button.dart';
import '../models/leave_request.dart';
import '../widgets/status_chip.dart';

class TimeOffScreen extends StatefulWidget {
  const TimeOffScreen({super.key});

  @override
  State<TimeOffScreen> createState() => _TimeOffScreenState();
}

class _TimeOffScreenState extends State<TimeOffScreen> {
  int _balance = 0;
  List<LeaveRequest> _requests = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final appState = context.read<AppState>();
    final api = resolveApiService(appState);
    final user = appState.currentUser;
    if (user == null) return;

    try {
      final balance = await api.getLeaveBalance(user.id);
      final reqs = await api.requestsForEmployee(user.id);
      if (mounted) {
        setState(() {
          _balance = balance;
          _requests = reqs;
          _loading = false;
        });
      }
    } catch (_) { if (mounted) setState(() => _loading = false); }
  }

  void _applyLeave() async {
    final appState = context.read<AppState>();
    final api = resolveApiService(appState);
    final user = appState.currentUser;
    if (user == null) return;
    
    if (_balance <= 0) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No leave balance available.', style: TextStyle(color: Colors.white)), backgroundColor: Colors.red));
      return;
    }

    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final oneYearAhead = DateTime(now.year + 1, now.month, now.day);

    final picked = await showDateRangePicker(
      context: context,
      firstDate: tomorrow,
      lastDate: oneYearAhead,
      helpText: 'Select Leave Range (Max $_balance days)',
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          platform: TargetPlatform.windows,
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF2365B0),
            onPrimary: Colors.white,
            surface: Color(0xFFF0F3F8),
          ),
        ),
        child: child!,
      ),
    );

    if (picked == null) return;

    final daysRequested = picked.end.difference(picked.start).inDays + 1;
    if (daysRequested > _balance) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You requested $daysRequested days, but only have $_balance available!', style: const TextStyle(color: Colors.white)), backgroundColor: Colors.red));
      return;
    }

    if (mounted) setState(() => _loading = true);

    await api.applyLeave(
       employeeId: user.id,
       employeeName: user.name,
       managerId: user.managerId ?? 1,
       startDate: picked.start.toString().split(' ')[0],
       endDate: picked.end.toString().split(' ')[0],
       reason: 'Requested via App Portal ($daysRequested Days)',
    );
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return DashboardScaffold(
      title: 'Time Off',
      body: _loading
         ? const Center(child: CircularProgressIndicator())
         : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               AppCard(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                       Expanded(
                          child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                                const Text('Available Balance', style: TextStyle(color: Colors.grey)),
                                Text('$_balance Days', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF2365B0)))
                             ]
                          )
                       ),
                       AppButton(
                          onPressed: _applyLeave,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          child: const Text('Request Time Off', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2365B0)))
                       )
                    ]
                  )
               ),
               const SizedBox(height: 32),
               const Text('Recent Requests', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2365B0))),
               const SizedBox(height: 16),
               if (_requests.isEmpty)
                  const Text('No previous time off requests.', style: TextStyle(color: Colors.grey))
               else
                  ..._requests.map((r) => Padding(
                     padding: const EdgeInsets.only(bottom: 12),
                     child: AppCard(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                           children: [
                              const Icon(Icons.beach_access, color: Colors.orange),
                              const SizedBox(width: 16),
                              Expanded(
                                 child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                       Text('${r.startDate} to ${r.endDate}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                       const SizedBox(height: 4),
                                       Text(r.reason, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                                    ]
                                 )
                              ),
                              StatusChip(status: r.status),
                           ]
                        )
                     )
                  )),
            ]
         )
    );
  }
}
