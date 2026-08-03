import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../controllers/program_controller.dart';
import 'local_video_player.dart';

class FullScreenCardPage extends StatefulWidget {
  final ProgramController controller;

  const FullScreenCardPage({super.key, required this.controller});

  @override
  State<FullScreenCardPage> createState() => _FullScreenCardPageState();
}

class _FullScreenCardPageState extends State<FullScreenCardPage> {
  @override
  void initState() {
    super.initState();
    // Force landscape mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    // Revert orientation when exiting
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ValueListenableBuilder<int>(
        valueListenable: widget.controller,
        builder: (context, currentIndex, child) {
          final activeItem = widget.controller.programList[currentIndex];
          final isAnnouncements = activeItem.title == 'Announcements';

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Stack(
                  children: [
                    // EXIT FULLSCREEN BUTTON
                    Positioned(
                      top: 12,
                      right: 12,
                      child: IconButton(
                        icon: const Icon(Icons.fullscreen_exit, size: 28),
                        tooltip: 'Exit Full Screen',
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),

                    // PREVIOUS STEP BUTTON
                    Positioned(
                      left: 12,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: IconButton(
                          iconSize: 40,
                          icon: const Icon(Icons.arrow_back_ios),
                          onPressed: currentIndex > 0 ? widget.controller.previousStep : null,
                        ),
                      ),
                    ),

                    // NEXT STEP BUTTON
                    Positioned(
                      right: 12,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: IconButton(
                          iconSize: 40,
                          icon: const Icon(Icons.arrow_forward_ios),
                          onPressed: currentIndex < widget.controller.programList.length - 1
                              ? widget.controller.nextStep
                              : null,
                        ),
                      ),
                    ),

                    // MAIN CONTENT AREA
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              activeItem.section.toUpperCase(),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              activeItem.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                            ),
                            if (activeItem.person.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Text(
                                activeItem.person,
                                style: TextStyle(fontSize: 20, color: Colors.grey[800]),
                              ),
                            ],

                            // ANNOUNCEMENT CONTENT DISPLAY
                            if (isAnnouncements) ...[
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  widget.controller.announcements,
                                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],

                            // LANGUAGE TOGGLES
                            if (activeItem.hasVP) ...[
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ChoiceChip(
                                    label: const Text('Tagalog'),
                                    selected: widget.controller.selectedLanguage == 'Tagalog',
                                    onSelected: (selected) {
                                      if (selected) widget.controller.setLanguage('Tagalog');
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  ChoiceChip(
                                    label: const Text('English'),
                                    selected: widget.controller.selectedLanguage == 'English',
                                    onSelected: (selected) {
                                      if (selected) widget.controller.setLanguage('English');
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton.icon(
                                onPressed: () {
                                  final activeFilePath = widget.controller.selectedLanguage == 'Tagalog'
                                      ? activeItem.tagalogVideoUrl
                                      : activeItem.englishVideoUrl;

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
                                        content: Text(
                                          'No ${widget.controller.selectedLanguage} video uploaded yet.',
                                        ),
                                      ),
                                    );
                                  }
                                },
                                icon: const Icon(Icons.play_arrow),
                                label: Text('Play (${widget.controller.selectedLanguage})'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),

                    // POSTURE EVENT BADGE
                    if (activeItem.event.isNotEmpty)
                      Positioned(
                        bottom: 12,
                        right: 20,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Event: ${activeItem.event}',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}