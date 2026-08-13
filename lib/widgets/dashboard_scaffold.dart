import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/login_screen.dart';
import '../services/app_state.dart';
import '../screens/inbox_screen.dart';
import '../screens/home_screen.dart';
import '../screens/personal_info_screen.dart';
import '../services/mock_data_store.dart';
import '../models/app_user.dart';

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
    final user = appState.currentUser;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF0F3F8),
      floatingActionButton: floatingActionButton,
      body: Column(
        children: [
          // Workday-style Top Navigation Bar
          Container(
             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
             decoration: const BoxDecoration(
               color: Colors.white,
               boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
             ),
             child: Row(
               children: [
                 // Logo / Home button
                 InkWell(
                   onTap: () {
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomeScreen()), (route) => false);
                   },
                   child: const Row(
                     children: [
                        Icon(Icons.work_outline, color: Color(0xFF2365B0), size: 28),
                        SizedBox(width: 8),
                        Text('Nexus HRIS', style: TextStyle(color: Color(0xFF2365B0), fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
                     ]
                   )
                 ),
                 const Spacer(),
                 // Global Search
                 Container(
                    width: 400,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F3F8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const Row(
                      children: [
                         Icon(Icons.search, color: Colors.grey, size: 20),
                         SizedBox(width: 8),
                         Expanded(child: TextField(decoration: InputDecoration(hintText: 'Search', border: InputBorder.none, isDense: true))),
                      ]
                    )
                 ),
                 const Spacer(),
                 
                 // Inbox Icon
                 Stack(
                   clipBehavior: Clip.none,
                   children: [
                     IconButton(
                       icon: const Icon(Icons.inbox, color: Colors.grey),
                       onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const InboxScreen()));
                       },
                     ),
                     if (user != null)
                       ValueListenableBuilder<int>(
                         valueListenable: MockDataStore.instance.revision,
                         builder: (context, _, child) {
                           int count = 0;
                           final store = MockDataStore.instance;
                           count += store.getReviews(user.id).where((r) => r['status'] == 'pending_employee').length;
                           if (user.role == UserRole.manager || user.role == UserRole.hr) {
                              count += store.requestsForManager(user.id).where((r) => r['status'] == 'pending').length;
                           }
                           
                           if (count == 0) return const SizedBox.shrink();
                           return Positioned(
                             right: 8,
                             top: 8,
                             child: Container(
                               padding: const EdgeInsets.all(4),
                               decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                               child: Text('$count', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                             )
                           );
                         }
                       )
                   ]
                 ),
                 const SizedBox(width: 16),
                 // Profile Icon
                 InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PersonalInfoScreen())),
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: const Color(0xFF2365B0),
                      child: Text(appState.currentUser?.name.substring(0,1) ?? 'U', style: const TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                 ),
                 const SizedBox(width: 16),
                 // Logout
                 IconButton(
                    icon: const Icon(Icons.logout, color: Colors.grey),
                    tooltip: 'Sign Out',
                    onPressed: () {
                       appState.logout();
                       Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
                    }
                 )
               ]
             )
          ),
          
          // Page Title Banner
          if (title != 'Home')
             Container(
               width: double.infinity,
               color: Colors.white,
               padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
               child: Row(
                  children: [
                     IconButton(
                        icon: const Icon(Icons.arrow_back, color: Color(0xFF2365B0)), 
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                     ),
                     const SizedBox(width: 16),
                     Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF2365B0))),
                  ]
               )
             ),
             
          // Main Body
          Expanded(
            child: disableScroll 
               ? body
               : SingleChildScrollView(
                   padding: const EdgeInsets.all(32),
                   child: body,
                 )
          )
        ]
      )
    );
  }
}
