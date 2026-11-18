import 'package:flutter/material.dart';
import '../controllers/board_controller.dart';
import 'board_admin_page.dart';

class BoardAgreementsPage extends StatefulWidget {
  final BoardController controller;

  const BoardAgreementsPage({super.key, required this.controller});

  @override
  State<BoardAgreementsPage> createState() => _BoardAgreementsPageState();
}

class _BoardAgreementsPageState extends State<BoardAgreementsPage> {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Agreement',
    'Policy / Rule',
    'Meeting Agenda',
    'Resolution'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Board Resolutions & Policies'),
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            tooltip: 'Admin Access',
            onPressed: () => _promptAdminPasskey(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Search rules, agendas, or resolutions...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories.map((cat) {
                      final isSelected = _selectedCategory == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text(cat),
                          selected: isSelected,
                          onSelected: (_) => setState(() => _selectedCategory = cat),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // List View
          Expanded(
            child: ListenableBuilder(
              listenable: widget.controller,
              builder: (context, _) {
                final filtered = widget.controller.agreements.where((item) {
                  final matchesQuery = item.title.toLowerCase().contains(_searchQuery) ||
                      item.details.toLowerCase().contains(_searchQuery);
                  final matchesCat =
                      _selectedCategory == 'All' || item.category == _selectedCategory;
                  return matchesQuery && matchesCat;
                }).toList();

                if (filtered.isEmpty) {
                  return const Center(
                    child: Text('No matching resolutions or agreements found.'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ExpansionTile(
                        leading: Chip(
                          label: Text(
                            item.category,
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),
                        title: Text(
                          item.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Agreed Date: ${item.dateAgreed.toLocal().toString().split(' ')[0]}',
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                item.details,
                                style: const TextStyle(fontSize: 14, height: 1.4),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _promptAdminPasskey(BuildContext context) {
    final passkeyCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Admin Authentication'),
          content: TextField(
            controller: passkeyCtrl,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Enter Admin Passkey',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (widget.controller.verifyPasskey(passkeyCtrl.text)) {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BoardAdminPage(
                        controller: widget.controller,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Incorrect Passkey! Access Denied.')),
                  );
                }
              },
              child: const Text('Login'),
            ),
          ],
        );
      },
    );
  }
}