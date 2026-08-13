import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_user.dart';
import '../services/app_state.dart';
import '../services/service_locator.dart';
import '../widgets/dashboard_scaffold.dart';
import '../widgets/app_card.dart';
import '../widgets/app_button.dart';
import '../widgets/org_graph_view.dart';
import 'employee_details_dialog.dart';

class DirectoryScreen extends StatefulWidget {
  const DirectoryScreen({super.key});

  @override
  State<DirectoryScreen> createState() => _DirectoryScreenState();
}

class _DirectoryScreenState extends State<DirectoryScreen> {
  List<AppUser> _allUsers = [];
  List<AppUser> _filtered = [];
  bool _loading = true;
  bool _isListView = true;

  String _search = '';
  String? _filterDept;
  String? _filterRole;
  String? _filterWorkType;
  DateTime? _filterDate;
  String _filterDateOp = 'Before';
  
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final appState = context.read<AppState>();
    final api = resolveApiService(appState);
    try {
      final users = await api.getDirectory();
      if (mounted) {
        setState(() {
          _allUsers = users;
          _filtered = users;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _applyFilters() {
    setState(() {
      _filtered = _allUsers.where((u) {
        bool matchesSearch = u.name.toLowerCase().contains(_search.toLowerCase());
        bool matchesDept = _filterDept == null || u.department == _filterDept;
        bool matchesRole = _filterRole == null || roleToString(u.role) == _filterRole;
        bool matchesWork = _filterWorkType == null || u.workType == _filterWorkType;
        bool matchesDate = true;
        
        if (_filterDate != null && u.joinDate != null) {
           final userDate = DateTime.tryParse(u.joinDate!);
           if (userDate != null) {
              if (_filterDateOp == 'Before') {
                 matchesDate = userDate.isBefore(_filterDate!);
              } else {
                 matchesDate = userDate.isAfter(_filterDate!);
              }
           }
        }
        
        return matchesSearch && matchesDept && matchesRole && matchesWork && matchesDate;
      }).toList();
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Filter Directory'),
        content: StatefulBuilder(
          builder: (ctx, setModalState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   DropdownButtonFormField<String?>(
                      value: _filterDept,
                      decoration: const InputDecoration(labelText: 'Department'),
                      items: const [
                         DropdownMenuItem(value: null, child: Text('Any')),
                         DropdownMenuItem(value: 'Engineering', child: Text('Engineering')),
                         DropdownMenuItem(value: 'Sales', child: Text('Sales')),
                         DropdownMenuItem(value: 'Product', child: Text('Product')),
                         DropdownMenuItem(value: 'Human Resources', child: Text('Human Resources')),
                         DropdownMenuItem(value: 'Executive', child: Text('Executive')),
                      ],
                      onChanged: (v) => setModalState(() => _filterDept = v),
                   ),
                   const SizedBox(height: 16),
                   DropdownButtonFormField<String?>(
                      value: _filterRole,
                      decoration: const InputDecoration(labelText: 'Role Level'),
                      items: const [
                         DropdownMenuItem(value: null, child: Text('Any')),
                         DropdownMenuItem(value: 'employee', child: Text('Employee')),
                         DropdownMenuItem(value: 'manager', child: Text('Manager')),
                         DropdownMenuItem(value: 'hr', child: Text('HR Admin')),
                      ],
                      onChanged: (v) => setModalState(() => _filterRole = v),
                   ),
                   const SizedBox(height: 16),
                   DropdownButtonFormField<String?>(
                      value: _filterWorkType,
                      decoration: const InputDecoration(labelText: 'Work Setup'),
                      items: const [
                         DropdownMenuItem(value: null, child: Text('Any')),
                         DropdownMenuItem(value: 'WFH', child: Text('Remote (WFH)')),
                         DropdownMenuItem(value: 'Hybrid', child: Text('Hybrid')),
                         DropdownMenuItem(value: 'On-site', child: Text('On-site')),
                      ],
                      onChanged: (v) => setModalState(() => _filterWorkType = v),
                   ),
                   const SizedBox(height: 16),
                   const Text('Join Date Range', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                   const SizedBox(height: 8),
                   Row(
                     children: [
                        Expanded(
                          flex: 2,
                          child: DropdownButtonFormField<String>(
                             value: _filterDateOp,
                             decoration: const InputDecoration(isDense: true),
                             items: const [
                                DropdownMenuItem(value: 'Before', child: Text('Before')),
                                DropdownMenuItem(value: 'After', child: Text('After')),
                             ],
                             onChanged: (v) => setModalState(() => _filterDateOp = v!),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                           flex: 3,
                           child: ElevatedButton.icon(
                             onPressed: () async {
                                final d = await showDatePicker(
                                   context: context,
                                   initialDate: _filterDate ?? DateTime.now(),
                                   firstDate: DateTime(2000),
                                   lastDate: DateTime.now(),
                                );
                                if (d != null) setModalState(() => _filterDate = d);
                             },
                             icon: const Icon(Icons.calendar_month, size: 18),
                             label: Text(
                               _filterDate == null 
                                ? 'Select Date' 
                                : '${_filterDate!.year}-${_filterDate!.month.toString().padLeft(2, '0')}-${_filterDate!.day.toString().padLeft(2, '0')}',
                               style: const TextStyle(fontSize: 12),
                             ),
                           ),
                        )
                     ],
                   ),
                ]
              )
            );
          }
        ),
        actions: [
          TextButton(
            onPressed: () {
               setState(() {
                  _filterDept = null;
                  _filterRole = null;
                  _filterWorkType = null;
                  _filterDate = null;
                  _filterDateOp = 'Before';
               });
               _applyFilters();
               Navigator.pop(ctx);
            },
            child: const Text('Clear')
          ),
          ElevatedButton(
            onPressed: () {
               _applyFilters();
               Navigator.pop(ctx);
            },
            child: const Text('Apply')
          )
        ]
      )
    );
  }

  void _showDetails(AppUser user) {
    showDialog(
      context: context,
      builder: (_) => EmployeeDetailsDialog(initialUser: user)
    );
  }

  @override
  Widget build(BuildContext context) {
    return DashboardScaffold(
      title: 'Employee Directory',
      disableScroll: !_isListView,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search and view toggle row
                Row(
                  children: [
                    Expanded(
                      child: AppCard(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          onChanged: (v) {
                            _search = v;
                            _applyFilters();
                          },
                          decoration: const InputDecoration(
                            labelText: 'Search employees via name',
                            prefixIcon: Icon(Icons.search, color: Color(0xFF5A72A0)),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    AppButton(
                      padding: const EdgeInsets.all(22),
                      onPressed: _showFilterDialog,
                      child: const Icon(Icons.filter_list, color: Color(0xFF5A72A0)),
                    ),
                    const SizedBox(width: 8),
                    AppButton(
                      padding: const EdgeInsets.all(22),
                      onPressed: () => setState(() => _isListView = !_isListView),
                      child: Icon(_isListView ? Icons.account_tree : Icons.view_list, color: const Color(0xFF5A72A0)),
                    )
                  ],
                ),
                const SizedBox(height: 24),
                
                if (_filtered.isEmpty)
                   const Text('No employees found matching filters.', style: TextStyle(color: Colors.grey))
                else if (_isListView)
                  ..._filtered.map((u) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: AppButton(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      onPressed: () => _showDetails(u),
                      child: Row(
                        children: [
                          CircleAvatar(backgroundColor: const Color(0xFF5A72A0), child: Text(u.name.substring(0, 1), style: const TextStyle(color: Colors.white))),
                          const SizedBox(width: 16),
                          Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(u.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(height: 4),
                              Text('${u.department ?? 'No Dept'} • ${u.email}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                            ],
                          )),
                          Icon(Icons.open_in_new, color: Colors.grey.withAlpha(150), size: 18),
                        ],
                      ),
                    ),
                  ))
                else
                  Expanded(
                    child: OrgGraphView(
                      allUsers: _allUsers, // Shows entire mapped tree, filters don't apply to graph directly to maintain structural integrity
                      onUserTap: _showDetails,
                    ),
                  ),
              ],
            ),
    );
  }

}
