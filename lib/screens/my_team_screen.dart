import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../services/service_locator.dart';
import '../widgets/dashboard_scaffold.dart';
import '../widgets/app_card.dart';
import '../widgets/app_button.dart';
import '../models/app_user.dart';
import '../models/leave_request.dart';

class MyTeamScreen extends StatefulWidget {
  const MyTeamScreen({super.key});

  @override
  State<MyTeamScreen> createState() => _MyTeamScreenState();
}

class _MyTeamScreenState extends State<MyTeamScreen> {
  List<AppUser> _directReports = [];
  bool _loading = true;
  List<LeaveRequest> _pendingLeaves = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final appState = context.read<AppState>();
    final api = resolveApiService(appState);
    final user = appState.currentUser;
    if (user == null) return;

    final all = await api.getDirectory();
    final reports = all.where((u) => u.managerId == user.id).toList();
    
    final allReqs = await api.requestsForManager(user.id);
    final pendingLeaves = allReqs.where((r) => r.status == 'pending').toList();

    if (mounted) {
      setState(() {
        _directReports = reports;
        _pendingLeaves = pendingLeaves;
        _loading = false;
      });
    }
  }

  Future<void> _updateLeave(int reqId, String status) async {
     final api = resolveApiService(context.read<AppState>());
     await api.updateLeaveStatus(reqId, status);
     _load();
     if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Leave request $status!')));
  }

  @override
  Widget build(BuildContext context) {
    return DashboardScaffold(
      title: 'My Team',
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppCard(
                   padding: const EdgeInsets.all(32),
                   baseColor: Colors.indigo.withAlpha(20),
                   child: Row(
                     children: [
                        const Icon(Icons.groups, size: 64, color: Colors.indigo),
                        const SizedBox(width: 24),
                        Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                              const Text('Team Overview', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo)),
                              const SizedBox(height: 8),
                              Text('You have ${_directReports.length} direct reports managing daily activities.', style: const TextStyle(color: Colors.grey)),
                           ]
                        )
                     ]
                   )
                ),
                
                if (_pendingLeaves.isNotEmpty) ...[
                   const SizedBox(height: 40),
                   const Text('Action Required: Leave Approvals', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange)),
                   const SizedBox(height: 16),
                   ..._pendingLeaves.map((r) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AppCard(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                             children: [
                                const Icon(Icons.flight_takeoff, color: Colors.orange),
                                const SizedBox(width: 16),
                                Expanded(child: Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                      Text('${r.employeeName} requests Time Off', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                      const SizedBox(height: 4),
                                      Text('${r.startDate} to ${r.endDate} - ${r.reason}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                                   ]
                                )),
                                TextButton(
                                   onPressed: () => _updateLeave(r.id, 'rejected'),
                                   child: const Text('Reject', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                   onPressed: () => _updateLeave(r.id, 'approved'),
                                   style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, elevation: 1),
                                   child: const Text('Confirm'),
                                ),
                             ]
                          )
                      )
                   )),
                ],
                
                const SizedBox(height: 40),
                const Text('Direct Reports', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2365B0))),
                const SizedBox(height: 16),
                if (_directReports.isEmpty)
                   const Text('No direct reports found.', style: TextStyle(color: Colors.grey))
                else
                   GridView.builder(
                     shrinkWrap: true,
                     physics: const NeverScrollableScrollPhysics(),
                     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 24, mainAxisSpacing: 24, childAspectRatio: 2.5),
                     itemCount: _directReports.length,
                     itemBuilder: (ctx, i) {
                        final u = _directReports[i];
                        return AppCard(
                           padding: const EdgeInsets.all(16),
                           child: Row(
                              children: [
                                 CircleAvatar(
                                    backgroundColor: Colors.indigo,
                                    child: Text(u.name.substring(0, 1), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                                 ),
                                 const SizedBox(width: 16),
                                 Expanded(
                                    child: Column(
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                          Text(u.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                          Text(u.department ?? 'Employee', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                                       ]
                                    )
                                 )
                              ]
                           )
                        );
                     }
                   ),
              ]
          )
    );
  }
}
