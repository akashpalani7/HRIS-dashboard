import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/login_screen.dart';
import '../services/app_state.dart';
import '../screens/inbox_screen.dart';

class DashboardScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? floatingActionButton;
  final bool disableScroll;

  const DashboardScaffold({
    super.key, 
    required this.title, 
    required this.body,
    this.floatingActionButton,
    this.disableScroll = false,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    
    return Scaffold(
      appBar: AppBar(
        title: Text(title == 'Home' ? 'Nexus HRIS' : title),
        actions: [
          IconButton(
            icon: const Icon(Icons.inbox),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const InboxScreen()));
            },
          ),
          IconButton(
             icon: const Icon(Icons.logout),
             onPressed: () {
                appState.logout();
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
             }
          )
        ],
      ),
      floatingActionButton: floatingActionButton,
      body: disableScroll ? body : SingleChildScrollView(child: Padding(padding: const EdgeInsets.all(16.0), child: body)),
    );
  }
}
