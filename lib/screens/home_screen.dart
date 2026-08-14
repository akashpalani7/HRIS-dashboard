import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../models/app_user.dart';
import '../widgets/dashboard_scaffold.dart';
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
       _AppDef('Personal Information', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PersonalInfoScreen()))),
       _AppDef('Time Off', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TimeOffScreen()))),
       _AppDef('Pay', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PayrollScreen()))),
       _AppDef('Performance', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PerformanceReviewScreen()))),
    ];
    
    if (user.role != UserRole.employee) {
       apps.add(_AppDef('Directory', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DirectoryScreen()))));
    }
    
    if (user.role == UserRole.manager || user.role == UserRole.hr) {
       apps.add(_AppDef('My Team', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MyTeamScreen()))));
    }

    if (user.role == UserRole.hr) {
       apps.add(_AppDef('System Admin', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminScreen()))));
    }

    return DashboardScaffold(
      title: 'Home',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome, ${user.name}', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            ...apps.map((app) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: app.onTap,
                  child: Text(app.label),
                ),
              ),
            ))
          ]
        ),
      )
    );
  }
}

class _AppDef {
  final String label;
  final VoidCallback onTap;
  _AppDef(this.label, this.onTap);
}
