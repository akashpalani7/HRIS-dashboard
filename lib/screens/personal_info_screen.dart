import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../widgets/dashboard_scaffold.dart';
import '../widgets/app_card.dart';
import '../widgets/app_button.dart';

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AppState>().currentUser;
    if (user == null) return const DashboardScaffold(title: 'Personal Info', body: SizedBox.shrink());

    return DashboardScaffold(
      title: 'Personal Information',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppCard(
                padding: const EdgeInsets.all(32),
                borderRadius: 100,
                child: Center(
                  child: Text(user.name.substring(0, 1), style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Color(0xFF5A72A0))),
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.name, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF2365B0))),
                    const SizedBox(height: 8),
                    Text(user.role.name.toUpperCase(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey)),
                    const SizedBox(height: 8),
                    const Row(
                       children: [
                          Icon(Icons.check_circle, color: Colors.green, size: 16),
                          SizedBox(width: 8),
                          Text('Active Employee', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))
                       ]
                    )
                  ]
                )
              )
            ]
          ),
          const SizedBox(height: 48),
          const Text('Demographics Data', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2365B0))),
          const SizedBox(height: 16),
          Wrap(
             spacing: 24,
             runSpacing: 24,
             children: [
                _buildInfoCard('Department', user.department ?? 'N/A'),
                _buildInfoCard('Work Setup', user.workType ?? 'In-Office'),
                _buildInfoCard('Join Date', user.joinDate ?? 'N/A'),
             ]
          ),
          const SizedBox(height: 24),
          Wrap(
             spacing: 24,
             runSpacing: 24,
             children: [
                _buildInfoCard('Address', user.address ?? 'Not Provided'),
                _buildInfoCard('Manager ID', user.managerId?.toString() ?? 'None'),
             ]
          ),
        ]
      )
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return SizedBox(
      width: 250,
      child: AppCard(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF333333))),
          ]
        )
      )
    );
  }
}
