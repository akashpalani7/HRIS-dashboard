import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'services/app_state.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const HrisApp());
}

class HrisApp extends StatelessWidget {
  const HrisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        title: 'HRIS Portal',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const LoginScreen(),
      ),
    );
  }
}
