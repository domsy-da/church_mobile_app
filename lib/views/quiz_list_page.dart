import 'package:flutter/material.dart';
import '../controllers/quiz_controller.dart';
import '../controllers/member_controller.dart';
import 'create_quiz_page.dart';
import 'quiz_view_page.dart';
import 'take_quiz_page.dart';

class QuizListPage extends StatefulWidget {
  final QuizController quizController;
  final MemberController memberController;

  const QuizListPage({
    super.key,
    required this.quizController,
    required this.memberController,
  });

  @override
  State<QuizListPage> createState() => _QuizListPageState();
}

class _QuizListPageState extends State<QuizListPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bible & Sabbath Quizzes'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.quiz), text: 'Quizzes'),
              Tab(icon: Icon(Icons.leaderboard), text: 'Leaderboard Stats'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.file_upload),
              tooltip: 'Import Quiz JSON',
              onPressed: () => _showJsonImportSheet(context),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.add),
          label: const Text('Create Quiz'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateQuizPage(
                  quizController: widget.quizController,
                ),
              ),
            );
          },
        ),
        body: TabBarView(
          children: [
            // TAB 1: Quiz List
            ListenableBuilder(
              listenable: widget.quizController,
              builder: (context, _) {
                final quizzes = widget.quizController.quizzes;
                if (quizzes.isEmpty) {
                  return const Center(
                    child: Text('No quizzes created yet. Tap + Create Quiz or Import.'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: quizzes.length,
                  itemBuilder: (context, index) {
                    final quiz = quizzes[index];
                    return Card(
                      child: ListTile(
                        title: Text(
                          quiz.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${quiz.questions.length} Questions • ${quiz.scores.length} Attempts',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.visibility, color: Colors.blue),
                              tooltip: 'View Questions & Answers',
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => QuizViewPage(quiz: quiz),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              child: const Text('Take'),
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TakeQuizPage(
                                    quiz: quiz,
                                    quizController: widget.quizController,
                                    memberController: widget.memberController,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            // TAB 2: Global Leaderboard
            ListenableBuilder(
              listenable: widget.quizController,
              builder: (context, _) {
                final leaderboard = widget.quizController.getLeaderboard();
                if (leaderboard.isEmpty) {
                  return const Center(child: Text('No recorded scores yet.'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: leaderboard.length,
                  itemBuilder: (context, index) {
                    final record = leaderboard[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: index == 0
                            ? Colors.amber
                            : (index == 1 ? Colors.grey : Colors.brown),
                        child: Text(
                          '#${index + 1}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        record.memberName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Score: ${record.score} / ${record.totalQuestions}',
                      ),
                      trailing: Text(
                        '${record.percentage.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showJsonImportSheet(BuildContext context) {
    final jsonCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          top: 20,
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Import Quiz JSON',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: jsonCtrl,
              maxLines: 8,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Paste full quiz JSON...',
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                if (widget.quizController.importFromJson(jsonCtrl.text)) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Quiz imported successfully!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid JSON!')),
                  );
                }
              },
              child: const Text('Import'),
            ),
          ],
        ),
      ),
    );
  }
}