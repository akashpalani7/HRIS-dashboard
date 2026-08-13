import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../services/service_locator.dart';
import '../models/app_user.dart';
import '../widgets/dashboard_scaffold.dart';
import '../widgets/app_card.dart';
import '../widgets/app_button.dart';
import '../models/leave_request.dart';
import '../models/performance_review.dart';

class InboxTask {
  final String title;
  final String subtitle;
  final String date;
  final String type; // 'leave' or 'review'
  final dynamic rawData;

  InboxTask({required this.title, required this.subtitle, required this.date, required this.type, required this.rawData});
}

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  List<InboxTask> _tasks = [];
  bool _loading = true;
  InboxTask? _selectedTask;

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

    final List<InboxTask> loaded = [];

    // Fetch Manager approvals
    if (user.role == UserRole.manager || user.role == UserRole.hr) {
       final reqs = await api.requestsForManager(user.id);
       for (var r in reqs) {
          if (r.status == 'pending') {
             loaded.add(InboxTask(
                title: 'Time Off Request: ${r.employeeName}',
                subtitle: '${r.startDate} to ${r.endDate} - ${r.reason}',
                date: r.startDate,
                type: 'leave',
                rawData: r,
             ));
          }
       }
    }

    // Fetch Employee actions
    final revs = await api.getReviews(user.id);
    for (var r in revs) {
       if (r.status == 'pending_employee') {
          loaded.add(InboxTask(
             title: 'Provide Self-Evaluation',
             subtitle: 'Review Cycle: ${r.title}',
             date: 'Due Soon',
             type: 'review',
             rawData: r,
          ));
       }
    }

    if (mounted) {
       setState(() {
          _tasks = loaded;
          if (_tasks.isNotEmpty) _selectedTask = _tasks.first;
          _loading = false;
       });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DashboardScaffold(
      title: 'Inbox',
      disableScroll: true,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _tasks.isEmpty
              ? const Center(child: Text('You are all caught up!', style: TextStyle(fontSize: 18, color: Colors.grey)))
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final bool isMobile = constraints.maxWidth < 800;
                    
                    final listWidget = SizedBox(
                      width: isMobile ? double.infinity : 350,
                      height: isMobile ? 300 : null,
                      child: ListView.builder(
                        itemCount: _tasks.length,
                        itemBuilder: (ctx, i) {
                           final t = _tasks[i];
                           final isSelected = _selectedTask == t;
                           return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: AppButton(
                                 onPressed: () => setState(() => _selectedTask = t),
                                 baseColor: isSelected ? Colors.blue.withAlpha(20) : const Color(0xFFF0F3F8),
                                 padding: const EdgeInsets.all(20),
                                 child: SizedBox(
                                    width: double.infinity,
                                    child: Column(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                         Text(t.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isSelected ? const Color(0xFF2365B0) : Colors.black87)),
                                         const SizedBox(height: 6),
                                         Text(t.subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                       ]
                                    ),
                                 )
                              )
                           );
                        }
                      )
                    );
                    
                    final detailWidget = AppCard(
                       padding: const EdgeInsets.all(40),
                       child: _buildDetailPanel(),
                    );
                    
                    if (isMobile) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            listWidget,
                            const SizedBox(height: 24),
                            detailWidget,
                          ]
                        )
                      );
                    }
                    
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        listWidget,
                        const SizedBox(width: 32),
                        Expanded(child: detailWidget),
                      ]
                    );
                  }
                )
    );
  }

  Widget _buildDetailPanel() {
     if (_selectedTask == null) return const SizedBox.shrink();
     final t = _selectedTask!;

     if (t.type == 'leave') {
        final r = t.rawData as LeaveRequest;
        return Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
              const Text('Time Off Request', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2365B0))),
              const SizedBox(height: 32),
              _DetailRow('Employee Name', r.employeeName),
              _DetailRow('Dates Requested', '${r.startDate} to ${r.endDate}'),
              _DetailRow('Comments/Reason', r.reason),
              const Spacer(),
              Row(
                 mainAxisAlignment: MainAxisAlignment.end,
                 children: [
                    TextButton(onPressed: () => _handleLeave(r.id, 'rejected'), child: const Text('Deny', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
                    const SizedBox(width: 24),
                    AppButton(
                       onPressed: () => _handleLeave(r.id, 'approved'),
                       child: const Text('Approve', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))
                    )
                 ]
              )
           ]
        );
     } else if (t.type == 'review') {
        final r = t.rawData as PerformanceReview;
        return Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
              const Text('Performance Self-Evaluation', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2365B0))),
              const SizedBox(height: 32),
              _DetailRow('Review Cycle', r.title),
              _DetailRow('Current Status', 'Awaiting your feedback'),
              const Spacer(),
              Row(
                 mainAxisAlignment: MainAxisAlignment.end,
                 children: [
                     AppButton(
                        onPressed: () {
                           _submitFeedback(r);
                        },
                        child: const Text('Submit Evaluation', style: TextStyle(color: Color(0xFF2365B0), fontWeight: FontWeight.bold))
                     )
                 ]
              )
           ]
        );
     }
     return const SizedBox.shrink();
  }

  Future<void> _handleLeave(int id, String status) async {
     final api = resolveApiService(context.read<AppState>());
     await api.updateLeaveStatus(id, status);
     _load();
  }

  Future<void> _submitFeedback(PerformanceReview review) async {
    final ctrl = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Self-Assessment for ${review.title}'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(labelText: 'Feedback'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (ctrl.text.trim().isEmpty) return;
              Navigator.pop(context, ctrl.text.trim());
            }, 
            child: const Text('Submit')
          )
        ],
      )
    );
    if (result == null || !mounted) return;
    
    final api = resolveApiService(context.read<AppState>());
    await api.submitReviewFeedback(review.id, result);
    _load();
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String val;
  const _DetailRow(this.label, this.val);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w600)),
           const SizedBox(height: 6),
           Text(val, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF333333))),
        ]
      )
    );
  }
}
