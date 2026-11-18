import 'package:flutter/material.dart';
import '../models/quiz_model.dart';
import '../models/member_model.dart';
import '../controllers/quiz_controller.dart';
import '../controllers/member_controller.dart';

class TakeQuizPage extends StatefulWidget {
  final Quiz quiz;
  final QuizController quizController;
  final MemberController memberController;

  const TakeQuizPage({
    super.key,
    required this.quiz,
    required this.quizController,
    required this.memberController,
  });

  @override
  State<TakeQuizPage> createState() => _TakeQuizPageState();
}

class _TakeQuizPageState extends State<TakeQuizPage> {
  Member? _selectedMember;
  final Map<int, String> _userAnswers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Taking: ${widget.quiz.title}')),
      body: Column(
        children: [
          // Member Selector Header
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: DropdownButtonFormField<Member>(
              value: _selectedMember,
              decoration: const InputDecoration(labelText: 'Select Member Taking Quiz *', border: OutlineInputBorder()),
              items: widget.memberController.members
                  .map((m) => DropdownMenuItem(value: m, child: Text(m.name)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedMember = val),
            ),
          ),
          Expanded(
            child: ListView.builder(
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
                        Text('Q${index + 1}: ${q.text}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),

                        // Multiple Choice Input
                        if (q.type == QuestionType.multipleChoice)
                          ...q.options.map((opt) => RadioListTile<String>(
                                title: Text(opt),
                                value: opt,
                                groupValue: _userAnswers[index],
                                onChanged: (val) => setState(() => _userAnswers[index] = val!),
                              )),

                        // True or False Input
                        if (q.type == QuestionType.trueOrFalse)
                          Row(
                            children: ['True', 'False'].map((opt) {
                              return Expanded(
                                child: RadioListTile<String>(
                                  title: Text(opt),
                                  value: opt,
                                  groupValue: _userAnswers[index],
                                  onChanged: (val) => setState(() => _userAnswers[index] = val!),
                                ),
                              );
                            }).toList(),
                          ),

                        // Identification Input
                        if (q.type == QuestionType.identification)
                          TextField(
                            decoration: const InputDecoration(labelText: 'Your Answer', border: OutlineInputBorder()),
                            onChanged: (val) => _userAnswers[index] = val.trim(),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
              onPressed: _selectedMember == null ? null : _submitQuiz,
              child: const Text('Submit Quiz'),
            ),
          ),
        ],
      ),
    );
  }

  void _submitQuiz() {
    int score = 0;
    for (int i = 0; i < widget.quiz.questions.length; i++) {
      final q = widget.quiz.questions[i];
      final userAns = (_userAnswers[i] ?? '').trim().toLowerCase();
      final correctAns = q.correctAnswer.trim().toLowerCase();

      if (userAns == correctAns) {
        score++;
      }
    }

    final record = QuizScoreRecord(
      memberId: _selectedMember!.id,
      memberName: _selectedMember!.name,
      score: score,
      totalQuestions: widget.quiz.questions.length,
    );

    widget.quizController.recordScore(widget.quiz.id, record);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quiz Complete!'),
        content: Text('${_selectedMember!.name} scored $score / ${widget.quiz.questions.length}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}