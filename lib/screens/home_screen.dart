import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../models/app_user.dart';
import '../widgets/dashboard_scaffold.dart';
import '../widgets/app_card.dart';
import '../widgets/app_button.dart';
import 'directory_screen.dart';
import 'payroll_screen.dart';
import 'performance_review_screen.dart';
import 'personal_info_screen.dart';
import 'time_off_screen.dart';
import 'my_team_screen.dart';
import 'admin_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final user = appState.currentUser;
    if (user == null) return const SizedBox.shrink();

    final apps = [
       _AppDef('Personal Information', Icons.person, Colors.blue, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PersonalInfoScreen()))),
       _AppDef('Time Off', Icons.flight_takeoff, Colors.orange, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TimeOffScreen()))),
       _AppDef('Pay', Icons.attach_money, Colors.green, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PayrollScreen()))),
       _AppDef('Performance', Icons.star, Colors.purple, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PerformanceReviewScreen()))),
    ];
    
    if (user.role != UserRole.employee) {
       apps.add(_AppDef('Directory', Icons.menu_book, Colors.teal, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DirectoryScreen()))));
    }
    
    if (user.role == UserRole.manager || user.role == UserRole.hr) {
       apps.add(_AppDef('My Team', Icons.groups, Colors.indigo, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MyTeamScreen()))));
    }

    if (user.role == UserRole.hr) {
       apps.add(_AppDef('System Admin', Icons.settings, Colors.red, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminScreen()))));
    }

    return DashboardScaffold(
      title: 'Home',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           // Welcome Banner
           AppCard(
             padding: const EdgeInsets.all(32),
             borderRadius: 20,
             child: Row(
               children: [
                 Expanded(
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text('Welcome, ${user.name}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF2365B0))),
                       const SizedBox(height: 8),
                       Text('It\'s a great day to do great work.', style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                     ]
                   )
                 ),
                 Icon(Icons.workspace_premium, size: 60, color: Colors.blue.withAlpha(100))
               ]
             )
           ),
           
           const SizedBox(height: 32),
           
           const Text('Your Applications', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2365B0))),
           const SizedBox(height: 16),
           
           Wrap(
             spacing: 24,
             runSpacing: 24,
             children: apps.map((app) => _buildAppCard(app)).toList(),
           )
        ]
      )
    );
  }

  Widget _buildAppCard(_AppDef app) {
     return SizedBox(
       width: 140,
       height: 140,
       child: AppButton(
         onPressed: app.onTap,
         padding: const EdgeInsets.all(16),
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
              Icon(app.icon, size: 40, color: app.color),
              const SizedBox(height: 16),
              Text(app.label, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF5A72A0))),
           ]
         )
       )
     );
  }
}

class _AppDef {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  _AppDef(this.label, this.icon, this.color, this.onTap);
}
