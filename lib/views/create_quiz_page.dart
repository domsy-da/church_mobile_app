import 'package:flutter/material.dart';
import '../models/quiz_model.dart';
import '../controllers/quiz_controller.dart';

class CreateQuizPage extends StatefulWidget {
  final QuizController quizController;

  const CreateQuizPage({super.key, required this.quizController});

  @override
  State<CreateQuizPage> createState() => _CreateQuizPageState();
}

class _CreateQuizPageState extends State<CreateQuizPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  final List<Question> _questions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Quiz'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Quiz Info Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Quiz Title *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _descCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Description (Optional)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Questions (${_questions.length})',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Add Question'),
                  onPressed: () => _openQuestionDialog(context),
                ),
              ],
            ),
            const SizedBox(height: 8),

            if (_questions.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    'No questions added yet. Tap "Add Question".',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),

            // Question List
            ..._questions.asMap().entries.map((entry) {
              final idx = entry.key;
              final q = entry.value;
              return Card(
                key: ValueKey(q.id),
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text('Q${idx + 1}: ${q.text}'),
                  subtitle: Text('Type: ${q.type.name} | Answer: ${q.correctAnswer}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() => _questions.removeAt(idx));
                    },
                  ),
                ),
              );
            }),

            const SizedBox(height: 24),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: _saveQuiz,
              child: const Text('Save Full Quiz'),
            ),
          ],
        ),
      ),
    );
  }

  void _openQuestionDialog(BuildContext context) {
    final qTextCtrl = TextEditingController();
    final ansCtrl = TextEditingController();
    QuestionType selectedType = QuestionType.multipleChoice;

    // Controllers for MC options
    final opt1Ctrl = TextEditingController();
    final opt2Ctrl = TextEditingController();
    final opt3Ctrl = TextEditingController();
    final opt4Ctrl = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add Individual Question'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<QuestionType>(
                      value: selectedType,
                      decoration: const InputDecoration(
                        labelText: 'Question Type',
                        border: OutlineInputBorder(),
                      ),
                      items: QuestionType.values.map((t) {
                        return DropdownMenuItem(
                          value: t,
                          child: Text(t.name.toUpperCase()),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() => selectedType = val);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: qTextCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Question Text',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Multiple Choice Fields
                    if (selectedType == QuestionType.multipleChoice) ...[
                      TextField(
                        controller: opt1Ctrl,
                        decoration: const InputDecoration(
                          labelText: 'Option 1',
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: opt2Ctrl,
                        decoration: const InputDecoration(
                          labelText: 'Option 2',
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: opt3Ctrl,
                        decoration: const InputDecoration(
                          labelText: 'Option 3',
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: opt4Ctrl,
                        decoration: const InputDecoration(
                          labelText: 'Option 4',
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: ansCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Correct Answer (Must match option text)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],

                    // True/False Fields
                    if (selectedType == QuestionType.trueOrFalse) ...[
                      DropdownButtonFormField<String>(
                        value: 'True',
                        decoration: const InputDecoration(
                          labelText: 'Correct Answer',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'True', child: Text('True')),
                          DropdownMenuItem(value: 'False', child: Text('False')),
                        ],
                        onChanged: (val) => ansCtrl.text = val ?? 'True',
                      ),
                    ],

                    // Identification Fields
                    if (selectedType == QuestionType.identification) ...[
                      TextField(
                        controller: ansCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Correct Answer Keyword/Phrase',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogCtx),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (qTextCtrl.text.trim().isEmpty) return;

                    List<String> options = [];
                    String finalAnswer = ansCtrl.text.trim();

                    if (selectedType == QuestionType.multipleChoice) {
                      options = [
                        opt1Ctrl.text.trim(),
                        opt2Ctrl.text.trim(),
                        opt3Ctrl.text.trim(),
                        opt4Ctrl.text.trim(),
                      ].where((opt) => opt.isNotEmpty).toList();
                    } else if (selectedType == QuestionType.trueOrFalse) {
                      options = ['True', 'False'];
                      if (finalAnswer.isEmpty) finalAnswer = 'True';
                    }

                    setState(() {
                      _questions.add(
                        Question(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          text: qTextCtrl.text.trim(),
                          type: selectedType,
                          options: options,
                          correctAnswer: finalAnswer,
                        ),
                      );
                    });

                    Navigator.pop(dialogCtx);
                  },
                  child: const Text('Add Question'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _saveQuiz() {
    if (!_formKey.currentState!.validate()) return;

    if (_questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one question.')),
      );
      return;
    }

    final newQuiz = Quiz(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      questions: _questions,
    );

    widget.quizController.addQuiz(newQuiz);
    Navigator.pop(context);
  }
}