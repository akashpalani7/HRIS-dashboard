import 'package:flutter/material.dart';
import '../models/app_user.dart';

enum AppMode { mock, live }

/// Holds the two things every screen needs to know: are we in mock mode or
/// talking to the real backend, and who is currently logged in.
class AppState extends ChangeNotifier {
  AppMode _mode = AppMode.mock;
  AppUser? _currentUser;

  AppMode get mode => _mode;
  AppUser? get currentUser => _currentUser;
  bool get isMock => _mode == AppMode.mock;

  void setMode(AppMode mode) {
    _mode = mode;
    notifyListeners();
  }

  void login(AppUser user) {
    _currentUser = user;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
