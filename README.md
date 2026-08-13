# Nexus HRIS

A **Human Resource Information System (HRIS)** is a software solution that connects human resource management and information technology. It provides a centralized platform for managing employee data and streamlining core HR processes, such as leave tracking, directory management, and administrative services.

**Figma Prototype:** https://www.figma.com/proto/AFF5bp3qMoNRJsbACy8oVe/HRIS?node-id=1-69&t=WkeWRR2jObUQTgTE-1&scaling=scale-down&content-scaling=responsive&page-id=0%3A1&starting-point-node-id=1%3A69

**Nexus HRIS** targets Android and Web from one codebase.

- **Mock mode** (default) - no backend or database needed. Pick a persona (HR / Manager / Employee) and try the full flow. Data lives in memory and stays consistent while you switch personas, but resets when the app is fully closed and reopened.

## First-time setup

This folder contains only the app's source code (`lib/` and `pubspec.yaml`) - not the native Android/Windows/Web scaffolding, since that's auto-generated and machine-specific. Set it up like this:

1. **Install the Flutter SDK** (if you haven't already), and make sure these platforms are enabled:
   ```
   flutter config --enable-windows-desktop
   ```
   (Web and Android are enabled by default in modern Flutter installs.)

2. **Create a fresh Flutter project** and pull in this app's code:
   ```
   flutter create --platforms=android,windows,web hris_app
   cd hris_app
   ```
   Now copy this folder's `lib/` directory and `pubspec.yaml` into the new project, overwriting the generated defaults.

3. **Get packages**
   ```
   flutter pub get
   ```

4. **Run it**
   - Web: `flutter run -d chrome`
   - Windows: `flutter run -d windows` (requires Visual Studio with the "Desktop development with C++" workload installed)
   - Android: `flutter run` with an emulator running, or a device connected

## Using Mock Mode (no setup needed)

The "Use mock data" switch is ON by default on the login screen. Tap "Continue as HR / Manager / Employee" to jump straight into any dashboard. Try this flow to see the connected system:

1. Continue as **Employee** -> Apply Leave -> submit a request
2. Logout -> Continue as **Manager** -> see that request waiting -> Approve or Reject it
3. Logout -> Continue as **HR** -> see the updated counts and the decided request in the full list
4. Logout -> Continue as **Employee** again -> see the status has changed

All of this works with zero backend or database - it's held in memory, so the mock data works connectedly across all views until you refresh the app or close it.

## Project structure

```
lib/
  main.dart                      - entry point
  config/                        - platform-aware backend URL (Android/Windows/Web)
  models/                        - AppUser, LeaveRequest
  services/
    app_state.dart               - current mode + logged-in user
    api_service.dart             - the interface both modes implement
    mock_api_service.dart        - mock mode, backed by...
    mock_data_store.dart         - ...this in-memory singleton
    real_api_service.dart        - live mode, calls the Express API
    service_locator.dart         - picks mock or real based on app state
  screens/                       - login + 3 persona dashboards
  widgets/                       - shared dashboard shell, status chip, etc.
  theme/                         - app-wide styling
```

## NOTE

- Only the Leave Management feature is wired up end-to-end as per requirement. Payroll, Performance, Recruitment, and Directory show as placeholder cards on each dashboard to represent the full Problem 1 design.
