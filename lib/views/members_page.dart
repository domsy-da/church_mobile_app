import 'package:flutter/material.dart';
import '../controllers/member_controller.dart';
import '../models/member_model.dart';
import 'member_form_page.dart';

class MembersPage extends StatefulWidget {
  final MemberController controller;

  const MembersPage({super.key, required this.controller});

  @override
  State<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  @override
  Widget build(BuildContext context) {
    final members = widget.controller.members;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Church Directory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.import_export),
            tooltip: 'Import / Export JSON',
            onPressed: () => _openImportExportDialog(context),
          ),
        ],
      ),
      body: members.isEmpty
          ? const Center(child: Text('No members found. Tap + to add or import JSON.'))
          : ListView.builder(
              itemCount: members.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final member = members[index];
                return Card(
                  child: ListTile(
                    title: Text(member.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      'Position: ${member.position} | Age: ${member.age} | Phone: ${member.phoneNumber.isEmpty ? "N/A" : member.phoneNumber}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _openMemberFormPage(context, member: member),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() => widget.controller.deleteMember(member.id));
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openMemberFormPage(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Member'),
      ),
    );
  }

  // Navigates to a dedicated Form Page for Adding/Editing
  void _openMemberFormPage(BuildContext context, {Member? member}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MemberFormPage(
          controller: widget.controller,
          member: member,
          onSave: () => setState(() {}),
        ),
      ),
    );
  }

  // JSON Import / Export Sheet
  void _openImportExportDialog(BuildContext context) {
    final jsonController = TextEditingController(text: widget.controller.exportToJson());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Import / Export Member Data (JSON)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: jsonController,
                maxLines: 8,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Paste JSON array here to import...',
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.download),
                      label: const Text('Import JSON'),
                      onPressed: () {
                        final success = widget.controller.importFromJson(jsonController.text, overwrite: false);
                        if (success) {
                          setState(() {});
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Members imported successfully!')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Invalid JSON format!')),
                          );
                        }
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}