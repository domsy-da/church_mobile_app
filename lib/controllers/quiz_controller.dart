import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quiz_model.dart';

class QuizController extends ChangeNotifier {
  List<Quiz> quizzes = [];

  QuizController() {
    loadData();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('church_quizzes');
    if (jsonStr != null) {
      final List decoded = jsonDecode(jsonStr);
      quizzes = decoded.map((e) => Quiz.fromJson(e)).toList();
    }
    notifyListeners();
  }

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(quizzes.map((q) => q.toJson()).toList());
    await prefs.setString('church_quizzes', encoded);
    notifyListeners();
  }

  void addQuiz(Quiz quiz) {
    quizzes.add(quiz);
    saveData();
  }

  void deleteQuiz(String id) {
    quizzes.removeWhere((q) => q.id == id);
    saveData();
  }

  void recordScore(String quizId, QuizScoreRecord record) {
    final index = quizzes.indexWhere((q) => q.id == quizId);
    if (index != -1) {
      quizzes[index].scores.add(record);
      saveData();
    }
  }

  // Get overall leaderboard across all quizzes or for a single quiz
  List<QuizScoreRecord> getLeaderboard({String? quizId}) {
    List<QuizScoreRecord> allScores = [];
    if (quizId != null) {
      final quiz = quizzes.firstWhere((q) => q.id == quizId, orElse: () => Quiz(id: '', title: '', questions: []));
      allScores = List.from(quiz.scores);
    } else {
      for (var q in quizzes) {
        allScores.addAll(q.scores);
      }
    }
    allScores.sort((a, b) => b.percentage.compareTo(a.percentage));
    return allScores;
  }

  // Import a single quiz or array of quizzes from JSON
  bool importFromJson(String jsonString) {
    try {
      final decoded = jsonDecode(jsonString);
      if (decoded is List) {
        for (var item in decoded) {
          quizzes.add(Quiz.fromJson(item));
        }
      } else if (decoded is Map<String, dynamic>) {
        quizzes.add(Quiz.fromJson(decoded));
      }
      saveData();
      return true;
    } catch (_) {
      return false;
    }
  }
}