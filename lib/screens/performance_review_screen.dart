import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/performance_review.dart';
import '../services/app_state.dart';
import '../services/service_locator.dart';
import '../widgets/dashboard_scaffold.dart';
import '../widgets/app_card.dart';
import '../widgets/app_button.dart';

class PerformanceReviewScreen extends StatefulWidget {
  const PerformanceReviewScreen({super.key});

  @override
  State<PerformanceReviewScreen> createState() => _PerformanceReviewScreenState();
}

class _PerformanceReviewScreenState extends State<PerformanceReviewScreen> {
  List<PerformanceReview> _reviews = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final appState = context.read<AppState>();
    final api = resolveApiService(appState);
    try {
      final reviews = await api.getReviews(appState.currentUser!.id);
      if (mounted) {
        setState(() {
          _reviews = reviews;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
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
    
    final appState = context.read<AppState>();
    await resolveApiService(appState).submitReviewFeedback(review.id, result);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return DashboardScaffold(
      title: 'Performance Reviews',
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Your Assigned Reviews', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                if (_reviews.isEmpty)
                  const Text('No reviews found.')
                else
                  ..._reviews.map(
                    (r) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: AppCard(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(r.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                const SizedBox(height: 4),
                                Text('Status: ${r.status}${r.feedback != null ? '\nFeedback: ${r.feedback}' : ''}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                              ],
                            )),
                            r.status == 'pending_employee' 
                              ? AppButton(
                                  onPressed: () => _submitFeedback(r),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: const Text('Assess')
                                )
                              : const Icon(Icons.check_circle, color: Colors.green),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
