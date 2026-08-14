import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_user.dart';
import '../services/app_state.dart';
import '../services/mock_api_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _loading = false;

  Future<void> _loginAsMock(BuildContext context, String role) async {
    setState(() {
      _loading = true;
    });
    
    await Future.delayed(const Duration(milliseconds: 700));
    if(!mounted) return;
    
    final mockApi = MockApiService();
    final user = mockApi.userForRole(role);
    
    final prefs = await SharedPreferences.getInstance();
    final bool useSaved = prefs.getBool('save_creds') ?? false;
    
    AppUser finalUser = user;
    if (useSaved) {
      final savedId = prefs.getString('saved_id') ?? '';
      if (savedId.isNotEmpty) {
        finalUser = AppUser(
          id: user.id,
          name: savedId, 
          email: user.email,
          role: user.role,
          department: user.department,
        );
      }
    }

    context.read<AppState>().login(finalUser);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  void _showSettingsDialog() async {
    final prefs = await SharedPreferences.getInstance();
    bool saveCreds = prefs.getBool('save_creds') ?? false;
    final idController = TextEditingController(text: prefs.getString('saved_id') ?? '');
    final passController = TextEditingController(text: prefs.getString('saved_pass') ?? '');

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setStateBuilder) {
            return AlertDialog(
              title: const Text('Settings'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
                    title: const Text('Enable Custom Login'),
                    value: saveCreds,
                    onChanged: (val) {
                      setStateBuilder(() => saveCreds = val);
                    },
                  ),
                  if (saveCreds) ...[
                    TextField(controller: idController, decoration: const InputDecoration(labelText: 'Login ID')),
                    TextField(controller: passController, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
                  ]
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                TextButton(
                  onPressed: () async {
                    await prefs.setBool('save_creds', saveCreds);
                    await prefs.setString('saved_id', idController.text);
                    await prefs.setString('saved_pass', passController.text);
                    if (mounted) Navigator.pop(ctx);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          }
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nexus HRIS Login'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettingsDialog,
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.business, size: 80, color: Colors.blueGrey),
              const SizedBox(height: 20),
              const Text('Welcome to HRIS', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
              const SizedBox(height: 10),
              const Text('Please select your portal.', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 30),
              if (_loading) 
                const CircularProgressIndicator()
              else ...[
                SizedBox(
                  width: 250,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () => _loginAsMock(context, 'hr'),
                    child: const Text('HR Portal'),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: 250,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () => _loginAsMock(context, 'manager'),
                    child: const Text('Manager Portal'),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: 250,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () => _loginAsMock(context, 'employee'),
                    child: const Text('Employee Portal'),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
