enum QuestionType { multipleChoice, identification, trueOrFalse }

class Question {
  final String id;
  final String text;
  final QuestionType type;
  final List<String> options; // Used for multiple choice
  final String correctAnswer; // Exact answer or option text

  Question({
    required this.id,
    required this.text,
    required this.type,
    this.options = const [],
    required this.correctAnswer,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'type': type.name,
        'options': options,
        'correctAnswer': correctAnswer,
      };

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
        text: json['text'] ?? '',
        type: QuestionType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => QuestionType.multipleChoice,
        ),
        options: List<String>.from(json['options'] ?? []),
        correctAnswer: json['correctAnswer'] ?? '',
      );
}

class QuizScoreRecord {
  final String memberId;
  final String memberName;
  final int score;
  final int totalQuestions;
  final DateTime dateTaken;

  QuizScoreRecord({
    required this.memberId,
    required this.memberName,
    required this.score,
    required this.totalQuestions,
    DateTime? dateTaken,
  }) : dateTaken = dateTaken ?? DateTime.now();

  double get percentage =>
      totalQuestions > 0 ? (score / totalQuestions) * 100 : 0;

  Map<String, dynamic> toJson() => {
        'memberId': memberId,
        'memberName': memberName,
        'score': score,
        'totalQuestions': totalQuestions,
        'dateTaken': dateTaken.toIso8601String(),
      };

  factory QuizScoreRecord.fromJson(Map<String, dynamic> json) => QuizScoreRecord(
        memberId: json['memberId'] ?? '',
        memberName: json['memberName'] ?? 'Anonymous',
        score: json['score'] ?? 0,
        totalQuestions: json['totalQuestions'] ?? 0,
        dateTaken: json['dateTaken'] != null
            ? DateTime.parse(json['dateTaken'])
            : DateTime.now(),
      );
}

class Quiz {
  final String id;
  String title;
  String description;
  List<Question> questions;
  List<QuizScoreRecord> scores;

  Quiz({
    required this.id,
    required this.title,
    this.description = '',
    required this.questions,
    List<QuizScoreRecord>? scores,
  }) : scores = scores ?? [];

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'questions': questions.map((q) => q.toJson()).toList(),
        'scores': scores.map((s) => s.toJson()).toList(),
      };

  factory Quiz.fromJson(Map<String, dynamic> json) => Quiz(
        id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        questions: (json['questions'] as List? ?? [])
            .map((q) => Question.fromJson(q))
            .toList(),
        scores: (json['scores'] as List? ?? [])
            .map((s) => QuizScoreRecord.fromJson(s))
            .toList(),
      );
}