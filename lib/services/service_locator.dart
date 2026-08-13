import 'api_service.dart';
import 'app_state.dart';
import 'mock_api_service.dart';
import 'real_api_service.dart';

/// The single place that decides which implementation a screen gets.
/// Every dashboard screen calls this instead of constructing a service
/// directly, so flipping the Mock/Live switch on the login screen changes
/// the data source for the entire app.
ApiService resolveApiService(AppState appState) {
  return appState.isMock ? MockApiService() : RealApiService();
}
