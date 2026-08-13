import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_user.dart';
import '../services/app_state.dart';
import '../services/mock_api_service.dart';
import 'home_screen.dart';
import '../widgets/app_card.dart';
import '../widgets/app_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _loading = false;
  String _statusMessage = '';

  Future<void> _loginAsMock(BuildContext context, String role) async {
    setState(() {
      _loading = true;
      _statusMessage = 'Populating automated $role credentials...';
    });
    
    // Simulate typing/filling credentials securely
    await Future.delayed(const Duration(milliseconds: 700));
    
    if(!mounted) return;
    setState(() => _statusMessage = 'Authenticating connection...');
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (!context.mounted) return;

    final mockApi = MockApiService();
    final user = mockApi.userForRole(role);
    context.read<AppState>().login(user);
    _navigateToDashboard(context, user);
  }

  void _navigateToDashboard(BuildContext context, AppUser user) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: _loading 
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(color: Color(0xFF5A72A0)),
                    const SizedBox(height: 24),
                    Text(_statusMessage, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF5A72A0))),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const AppCard(
                      padding: EdgeInsets.all(24),
                      borderRadius: 100,
                      child: Icon(Icons.blur_on, size: 56, color: Color(0xFF5A72A0)),
                    ),
                    const SizedBox(height: 24),
                    const Text('NEXUS HRIS', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF5A72A0), letterSpacing: 2)),
                    const SizedBox(height: 12),
                    const Text(
                      'Select a portal access level to continue. The system will securely auto-fill credentials for this demo.',
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    AppButton(
                      onPressed: () => _loginAsMock(context, 'hr'),
                      child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.admin_panel_settings, color: Color(0xFF5A72A0)), SizedBox(width: 8), Text('HR Portal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))]),
                    ),
                    const SizedBox(height: 16),
                    AppButton(
                      onPressed: () => _loginAsMock(context, 'manager'),
                      child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.groups, color: Color(0xFF5A72A0)), SizedBox(width: 8), Text('Manager Portal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))]),
                    ),
                    const SizedBox(height: 16),
                    AppButton(
                      onPressed: () => _loginAsMock(context, 'employee'),
                      child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.person, color: Color(0xFF5A72A0)), SizedBox(width: 8), Text('Employee Portal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))]),
                    ),
                  ],
                ),
          ),
        ),
      ),
    );
  }
}
