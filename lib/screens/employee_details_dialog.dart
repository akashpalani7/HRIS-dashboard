import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_user.dart';
import '../services/app_state.dart';
import '../services/service_locator.dart';
import '../widgets/app_card.dart';
import '../widgets/app_button.dart';

class EmployeeDetailsDialog extends StatefulWidget {
  final AppUser initialUser;
  const EmployeeDetailsDialog({super.key, required this.initialUser});

  @override
  State<EmployeeDetailsDialog> createState() => _EmployeeDetailsDialogState();
}

class _EmployeeDetailsDialogState extends State<EmployeeDetailsDialog> {
  late AppUser _currentUser;
  List<AppUser> _allDirectory = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.initialUser;
    _loadDirectory();
  }

  Future<void> _loadDirectory() async {
    final appState = context.read<AppState>();
    try {
      final list = await resolveApiService(appState).getDirectory();
      if(mounted) {
        setState(() {
          _allDirectory = list;
          _loading = false;
        });
      }
    } catch (_) {}
  }

  void _switchUser(AppUser user) {
    setState(() => _currentUser = user);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 800),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F3F8),
          borderRadius: BorderRadius.circular(30),
        ),
        child: _loading ? const Center(child: CircularProgressIndicator()) : _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    AppUser? manager;
    if (_currentUser.managerId != null) {
      try {
        manager = _allDirectory.firstWhere((u) => u.id == _currentUser.managerId);
      } catch (_) {}
    }
    
    final reports = _allDirectory.where((u) => u.managerId == _currentUser.id).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Employee Profile', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF5A72A0))),
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, color: Colors.grey))
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppCard(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: const Color(0xFF5A72A0),
                         child: Text(_currentUser.name.substring(0, 1), style: const TextStyle(color: Colors.white, fontSize: 24)),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_currentUser.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                            Text(_currentUser.email, style: const TextStyle(color: Colors.grey)),
                            const SizedBox(height: 4),
                            Chip(
                              label: Text(roleToString(_currentUser.role)),
                              backgroundColor: Colors.white.withAlpha(150),
                              side: BorderSide.none,
                            ),
                          ],
                        )
                      )
                    ],
                  )
                ),
                const SizedBox(height: 24),
                const Text('Demographics', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                
                Row(
                  children: [
                    Expanded(child: _infoSquare('Department', _currentUser.department ?? 'N/A')),
                    const SizedBox(width: 12),
                    Expanded(child: _infoSquare('Work Model', _currentUser.workType ?? 'N/A')),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _infoSquare('Join Date', _currentUser.joinDate ?? 'N/A')),
                    const SizedBox(width: 12),
                    Expanded(child: _infoSquare('Last Payroll', _currentUser.lastPayrollDate ?? 'N/A')),
                  ],
                ),
                const SizedBox(height: 12),
                _infoSquare('Registered Address', _currentUser.address ?? 'Not recorded'),
                
                const SizedBox(height: 32),
                const Text('Org Graph', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                if (manager != null) ...[
                  const Text('Reports to:', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 4),
                  _userClickableTile(manager),
                  const SizedBox(height: 12),
                  const Center(child: Icon(Icons.arrow_downward, color: Colors.grey, size: 20)),
                  const SizedBox(height: 12),
                ],
                const Text('Current Profile:', style: TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 4),
                AppCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  baseColor: Colors.blue.withAlpha(20),
                  child: Row(
                    children: [
                      const Icon(Icons.person, color: Color(0xFF5A72A0)),
                      const SizedBox(width: 12),
                      Text(_currentUser.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    ]
                  )
                ),
                if (reports.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Center(child: Icon(Icons.arrow_downward, color: Colors.grey, size: 20)),
                  const SizedBox(height: 12),
                  const Text('Direct Reports:', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 4),
                  ...reports.map((r) => Padding(padding: const EdgeInsets.only(bottom: 8), child: _userClickableTile(r))),
                ]
              ],
            ),
          )
        ),
      ],
    );
  }

  Widget _infoSquare(String title, String val) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          Text(val, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _userClickableTile(AppUser u) {
    return AppButton(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      onPressed: () => _switchUser(u),
      child: Row(
        children: [
           CircleAvatar(radius: 12, child: Text(u.name.substring(0, 1), style: const TextStyle(fontSize: 10))),
           const SizedBox(width: 12),
           Text(u.name, style: const TextStyle(fontWeight: FontWeight.bold)),
           const Spacer(),
           const Icon(Icons.swap_vert, color: Colors.grey)
        ],
      )
    );
  }
}
