import 'package:flutter/material.dart';
import '../models/quiz_model.dart';

class QuizViewPage extends StatefulWidget {
  final Quiz quiz;

  const QuizViewPage({super.key, required this.quiz});

  @override
  State<QuizViewPage> createState() => _QuizViewPageState();
}

class _QuizViewPageState extends State<QuizViewPage> {
  bool _showAnswers = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quiz.title),
        actions: [
          IconButton(
            icon: Icon(_showAnswers ? Icons.visibility_off : Icons.visibility),
            tooltip: _showAnswers ? 'Hide Answers' : 'Show Answers',
            onPressed: () => setState(() => _showAnswers = !_showAnswers),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: widget.quiz.questions.length,
        itemBuilder: (context, index) {
          final q = widget.quiz.questions[index];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Q${index + 1}: ${q.text}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text('Type: ${q.type.name}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  if (q.type == QuestionType.multipleChoice) ...[
                    const SizedBox(height: 8),
                    ...q.options.map((opt) => Text('• $opt')),
                  ],
                  if (_showAnswers) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.green.shade50,
                      child: Text(
                        'Correct Answer: ${q.correctAnswer}',
                        style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}