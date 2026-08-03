import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/program_controller.dart';
import '../models/program_item_model.dart';

class ProgramSettingsPage extends StatefulWidget {
  final ProgramController controller;

  const ProgramSettingsPage({super.key, required this.controller});

  @override
  State<ProgramSettingsPage> createState() => _ProgramSettingsPageState();
}

class _ProgramSettingsPageState extends State<ProgramSettingsPage> {
  late List<ProgramItem> _editableList;
  late TextEditingController _announcementsController;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _editableList = widget.controller.programList.map((item) => item.copyWith()).toList();
    _announcementsController = TextEditingController(text: widget.controller.announcements);
  }

  @override
  void dispose() {
    _announcementsController.dispose();
    super.dispose();
  }

  Future<void> _pickVideo(ProgramItem item, bool isTagalog) async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      setState(() {
        if (isTagalog) {
          item.tagalogVideoUrl = video.path; // Local file path on phone
        } else {
          item.englishVideoUrl = video.path; // Local file path on phone
        }
      });
    }
  }

  void _saveSettings() {
    widget.controller.saveSettings(_editableList, _announcementsController.text);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Program Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save Settings',
            onPressed: _saveSettings,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Announcements Inputs',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _announcementsController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Type church announcements here...',
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Program Participants & Offline Video Files',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _editableList.length,
              itemBuilder: (context, index) {
                final item = _editableList[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${index + 1}. ${item.title}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          initialValue: item.person,
                          decoration: const InputDecoration(
                            labelText: 'Participant / Person / Group',
                            isDense: true,
                          ),
                          onChanged: (val) => item.person = val,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          initialValue: item.event,
                          decoration: const InputDecoration(
                            labelText: 'Event Posture (e.g. Luhod, Tayo, Upo)',
                            isDense: true,
                          ),
                          onChanged: (val) => item.event = val,
                        ),

                        // OFFLINE VIDEO SELECTION
                        if (item.hasVP) ...[
                          const SizedBox(height: 12),
                          const Text(
                            'Select Downloaded Video File [VP]',
                            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blueGrey),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => _pickVideo(item, true),
                                  icon: const Icon(Icons.file_upload_outlined),
                                  label: Text(
                                    item.tagalogVideoUrl != null ? 'Tagalog Attached ✓' : 'Upload Tagalog',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => _pickVideo(item, false),
                                  icon: const Icon(Icons.file_upload_outlined),
                                  label: Text(
                                    item.englishVideoUrl != null ? 'English Attached ✓' : 'Upload English',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}