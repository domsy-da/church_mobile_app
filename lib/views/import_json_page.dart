import 'dart:convert';
import 'package:flutter/material.dart';
import '../controllers/program_controller.dart';

class ImportJsonPage extends StatefulWidget {
  final ProgramController controller;

  const ImportJsonPage({super.key, required this.controller});

  @override
  State<ImportJsonPage> createState() => _ImportJsonPageState();
}

class _ImportJsonPageState extends State<ImportJsonPage> {
  final TextEditingController _jsonController = TextEditingController();
  String? _errorMessage;

  // SAMPLE JSON TEMPLATE FOR EASY COPY/PASTE
  final String _sampleJson = '''
[
  { "id": "ss_1", "person": "Brother John" },
  { "title": "Opening Prayer", "person": "Sister Mary" },
  { "title": "Presider", "person": "Elder David" }
]
''';

  void _processImport() async {
    setState(() {
      _errorMessage = null;
    });

    final input = _jsonController.text.trim();
    if (input.isEmpty) {
      setState(() {
        _errorMessage = 'Please paste a JSON array or object before importing.';
      });
      return;
    }

    try {
      final decoded = jsonDecode(input);
      List<dynamic> itemsToUpdate = [];

      if (decoded is List) {
        itemsToUpdate = decoded;
      } else if (decoded is Map<String, dynamic>) {
        itemsToUpdate = [decoded];
      } else {
        throw const FormatException('JSON must be a list or object');
      }

      int updatedCount = 0;
      final currentList = widget.controller.programList;

      for (var entry in itemsToUpdate) {
        if (entry is Map<String, dynamic>) {
          final targetId = entry['id']?.toString().toLowerCase();
          final targetTitle = entry['title']?.toString().toLowerCase();
          final newPerson = entry['person']?.toString();

          if (newPerson != null) {
            for (var item in currentList) {
              bool matches = false;

              // Match by explicit ID first, or by Title second
              if (targetId != null && item.id.toLowerCase() == targetId) {
                matches = true;
              } else if (targetTitle != null &&
                  item.title.toLowerCase().contains(targetTitle)) {
                matches = true;
              }

              if (matches) {
                item.person = newPerson;
                updatedCount++;
              }
            }
          }
        }
      }

      // Save updated program list into SharedPreferences local storage
      await widget.controller.saveSettings(
        currentList,
        widget.controller.announcements,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully updated $updatedCount participant(s)!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Invalid JSON format: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Import Participants (JSON)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Paste your JSON data below. You can map by "id" or "title".',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.copy, size: 18),
                  label: const Text('Insert Sample JSON'),
                  onPressed: () {
                    _jsonController.text = _sampleJson.trim();
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: TextField(
                controller: _jsonController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: '[\n  { "id": "ss_1", "person": "Juan Dela Cruz" }\n]',
                  border: const OutlineInputBorder(),
                  errorText: _errorMessage,
                ),
                style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              onPressed: _processImport,
              icon: const Icon(Icons.download_done),
              label: const Text(
                'UPDATE PARTICIPANTS',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}