import 'package:flutter/material.dart';
import '../controllers/board_controller.dart';
import '../models/board_agreement_model.dart';

class BoardAdminPage extends StatefulWidget {
  final BoardController controller;

  const BoardAdminPage({super.key, required this.controller});

  @override
  State<BoardAdminPage> createState() => _BoardAdminPageState();
}

class _BoardAdminPageState extends State<BoardAdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Board Resolutions Admin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.import_export),
            tooltip: 'Import / Export JSON',
            onPressed: () => _openImportExportSheet(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAgreementForm(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Item'),
      ),
      body: ListenableBuilder(
        listenable: widget.controller,
        builder: (context, _) {
          final items = widget.controller.agreements;

          if (items.isEmpty) {
            return const Center(child: Text('No board items present. Tap + to create one.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                child: ListTile(
                  title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${item.category} • ${item.dateAgreed.toLocal().toString().split(' ')[0]}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _openAgreementForm(context, item: item),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => widget.controller.deleteAgreement(item.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _openAgreementForm(BuildContext context, {BoardAgreement? item}) {
    final formKey = GlobalKey<FormState>();
    final titleCtrl = TextEditingController(text: item?.title ?? '');
    final detailsCtrl = TextEditingController(text: item?.details ?? '');
    String category = item?.category ?? 'Agreement';
    DateTime dateAgreed = item?.dateAgreed ?? DateTime.now();

    final categories = ['Agreement', 'Policy / Rule', 'Meeting Agenda', 'Resolution'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item == null ? 'Add New Decision / Agenda' : 'Edit Item',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: titleCtrl,
                        decoration: const InputDecoration(labelText: 'Title / Subject *', border: OutlineInputBorder()),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: category,
                        decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
                        items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                        onChanged: (val) => setModalState(() => category = val ?? 'Agreement'),
                      ),
                      const SizedBox(height: 12),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Agreed Date: ${dateAgreed.toLocal().toString().split(' ')[0]}'),
                        trailing: const Icon(Icons.calendar_month),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: dateAgreed,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) setModalState(() => dateAgreed = picked);
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: detailsCtrl,
                        maxLines: 4,
                        decoration: const InputDecoration(labelText: 'Full Description / Policy Rules', border: OutlineInputBorder()),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            if (item == null) {
                              widget.controller.addAgreement(BoardAgreement(
                                id: DateTime.now().millisecondsSinceEpoch.toString(),
                                title: titleCtrl.text.trim(),
                                category: category,
                                details: detailsCtrl.text.trim(),
                                dateAgreed: dateAgreed,
                              ));
                            } else {
                              widget.controller.updateAgreement(
                                item.id,
                                BoardAgreement(
                                  id: item.id,
                                  title: titleCtrl.text.trim(),
                                  category: category,
                                  details: detailsCtrl.text.trim(),
                                  dateAgreed: dateAgreed,
                                  dateCreated: item.dateCreated,
                                ),
                              );
                            }
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Save Record'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _openImportExportSheet(BuildContext context) {
    final jsonCtrl = TextEditingController(text: widget.controller.exportToJson());

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
            children: [
              const Text('Import / Export Board Data (JSON)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: jsonCtrl,
                maxLines: 8,
                decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Paste JSON array...'),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.download),
                label: const Text('Import JSON'),
                onPressed: () {
                  if (widget.controller.importFromJson(jsonCtrl.text)) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Imported successfully!')));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid JSON format!')));
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}