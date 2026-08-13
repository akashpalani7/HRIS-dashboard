import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/payslip.dart';
import '../services/app_state.dart';
import '../services/service_locator.dart';
import '../widgets/dashboard_scaffold.dart';
import '../widgets/app_card.dart';
import '../widgets/app_button.dart';

class PayrollScreen extends StatefulWidget {
  const PayrollScreen({super.key});

  @override
  State<PayrollScreen> createState() => _PayrollScreenState();
}

class _PayrollScreenState extends State<PayrollScreen> {
  List<Payslip> _payslips = [];
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
      final payslips = await api.getPayslips(appState.currentUser!.id);
      if (mounted) {
        setState(() {
          _payslips = payslips;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DashboardScaffold(
      title: 'Payroll',
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Your Payslips', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                if (_payslips.isEmpty)
                  const Text('No payslips found.')
                else
                  ..._payslips.map(
                    (p) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: AppCard(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: Row(
                          children: [
                            const Icon(Icons.payments, color: Colors.green),
                            const SizedBox(width: 16),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                               Text('Date: ${p.date}', style: const TextStyle(fontWeight: FontWeight.bold)),
                               const SizedBox(height: 4),
                               Text('Status: ${p.status}', style: const TextStyle(color: Colors.grey)),
                            ])),
                            Text(
                              '\$${p.amount.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF5A72A0)),
                            ),
                          ]
                        )
                      )
                    ),
                  ),
              ],
            ),
    );
  }
}
