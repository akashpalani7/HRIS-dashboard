// Conditional import: uses api_config_io.dart (dart:io, Platform checks) by
// default, and swaps in api_config_web.dart automatically when compiled for
// web, where dart:io isn't available. This is what lets one codebase target
// Android, Windows AND Web without any manual switching.
import 'api_config_io.dart' if (dart.library.html) 'api_config_web.dart' as platform_impl;

class ApiConfig {
  /// Base URL of the local Express server, e.g. http://localhost:3000/api
  static String get baseUrl => platform_impl.platformBaseUrl();
}
