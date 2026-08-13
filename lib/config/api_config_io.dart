import 'dart:io';

// The Android emulator can't reach the host machine's "localhost" directly -
// it needs the special alias 10.0.2.2. Windows (and any other non-web,
// non-Android target) just uses localhost since it IS the host machine.
String platformBaseUrl() {
  if (Platform.isAndroid) {
    return 'http://10.0.2.2:3000/api';
  }
  return 'http://localhost:3000/api';
}
