import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../services/service_locator.dart';
import '../widgets/dashboard_scaffold.dart';
import '../widgets/app_card.dart';
import '../widgets/app_button.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    
    return DashboardScaffold(
      title: 'System Actions',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           const Text('Global Processes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2365B0))),
           const SizedBox(height: 24),
           Row(
             children: [
               Expanded(
                 child: AppCard(
                   padding: const EdgeInsets.all(32),
                   child: Column(
                     children: [
                       const Icon(Icons.monetization_on, size: 64, color: Colors.green),
                       const SizedBox(height: 16),
                       const Text('Run Monthly Payroll', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF333333))),
                       const SizedBox(height: 8),
                       const Text('Automatically generates pay stubs for all active employees for the current cycle.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 13)),
                       const SizedBox(height: 24),
                       AppButton(
                         onPressed: () async {
                           final api = resolveApiService(appState);
                           await api.runPayroll();
                           if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payroll executed successfully for all active employees!')));
                           }
                         },
                         padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                         child: const Text('Execute Payroll', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))
                       )
                     ]
                   )
                 )
               ),
               const SizedBox(width: 32),
               Expanded(
                 child: AppCard(
                   padding: const EdgeInsets.all(32),
                   child: Column(
                     children: [
                       const Icon(Icons.star_rate, size: 64, color: Colors.purple),
                       const SizedBox(height: 16),
                       const Text('Launch Review Cycle', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF333333))),
                       const SizedBox(height: 8),
                       const Text('Creates a new set of self-evaluation forms in the inbox of every employee.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 13)),
                       const SizedBox(height: 24),
                       AppButton(
                         onPressed: () async {
                           final api = resolveApiService(appState);
                           await api.launchReviewCycle();
                           if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Review cycle launched for all active employees!')));
                           }
                         },
                         padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                         child: const Text('Trigger Cycle', style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold))
                       )
                     ]
                   )
                 )
               )
             ]
           ),
        ]
      )
    );
  }
}
