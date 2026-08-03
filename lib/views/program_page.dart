import 'package:flutter/material.dart';
import '../controllers/program_controller.dart';
import 'local_video_player.dart'; // <--- 1. Import your new video player screen
import 'program_settings_page.dart';

class ProgramPage extends StatefulWidget {
  final ProgramController controller;

  const ProgramPage({super.key, required this.controller});

  @override
  State<ProgramPage> createState() => _ProgramPageState();
}

class _ProgramPageState extends State<ProgramPage> {
  late ProgramController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Church Program'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Module Settings',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProgramSettingsPage(controller: _controller),
                ),
              );
              setState(() {});
            },
          )
        ],
      ),
      body: ValueListenableBuilder<int>(
        valueListenable: _controller,
        builder: (context, currentIndex, child) {
          final activeItem = _controller.programList[currentIndex];

          return Column(
            children: [
              // --- HIGHLIGHTED BIG CURRENT STEP CARD ---
              Card(
                margin: const EdgeInsets.all(16.0),
                elevation: 6,
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        activeItem.section.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        activeItem.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      if (activeItem.person.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          activeItem.person,
                          style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                        ),
                      ],
                      const SizedBox(height: 16),

                      // LANGUAGE SELECTION CHIPS FOR [VP]
                      if (activeItem.hasVP) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ChoiceChip(
                              label: const Text('Tagalog'),
                              selected: _controller.selectedLanguage == 'Tagalog',
                              onSelected: (selected) {
                                if (selected) _controller.setLanguage('Tagalog');
                              },
                            ),
                            const SizedBox(width: 8),
                            ChoiceChip(
                              label: const Text('English'),
                              selected: _controller.selectedLanguage == 'English',
                              onSelected: (selected) {
                                if (selected) _controller.setLanguage('English');
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],

                      // ACTION BUTTONS (UPDATED PLAY BUTTON LOGIC HERE)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (activeItem.hasVP) ...[
                            ElevatedButton.icon(
                              onPressed: () {
                                final activeFilePath = _controller.selectedLanguage == 'Tagalog'
                                    ? activeItem.tagalogVideoUrl
                                    : activeItem.englishVideoUrl;

                                // 2. Check if a local video was uploaded & open video player screen
                                if (activeFilePath != null && activeFilePath.isNotEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LocalVideoPlayerScreen(filePath: activeFilePath),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('No ${_controller.selectedLanguage} video uploaded yet.'),
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.play_arrow),
                              label: Text('Play (${_controller.selectedLanguage})'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                foregroundColor: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                          ElevatedButton.icon(
                            onPressed: _controller.nextStep,
                            icon: const Icon(Icons.arrow_forward),
                            label: const Text('Next'),
                          ),
                        ],
                      ),

                      // EVENT POSTURE BADGE
                      if (activeItem.event.isNotEmpty)
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            margin: const EdgeInsets.only(top: 12),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Event: ${activeItem.event}',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const Divider(height: 1),

              // --- PROGRAM LIST VIEW ---
              Expanded(
                child: ListView.builder(
                  itemCount: _controller.programList.length,
                  itemBuilder: (context, index) {
                    final item = _controller.programList[index];
                    final isSelected = index == currentIndex;

                    return Container(
                      color: isSelected ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1) : null,
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 14,
                          backgroundColor: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey[300],
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(fontSize: 12, color: isSelected ? Colors.white : Colors.black),
                          ),
                        ),
                        title: Text(
                          item.title,
                          style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
                        ),
                        subtitle: Text(item.person.isNotEmpty ? item.person : item.section),
                        trailing: item.event.isNotEmpty
                            ? Text(item.event, style: const TextStyle(fontSize: 10, color: Colors.grey))
                            : null,
                        onTap: () => _controller.selectStep(index),
                      ),
                    );
                  },
                ),
              ),

              // ANNOUNCEMENTS BOTTOM BAR
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Announcements:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(_controller.announcements, style: const TextStyle(fontSize: 13)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}