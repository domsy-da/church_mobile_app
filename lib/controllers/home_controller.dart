import 'package:flutter/material.dart';
import 'program_controller.dart';
import 'member_controller.dart'; // 1. Import MemberController
import '../views/program_page.dart';
import '../views/members_page.dart'; // 2. Import MembersPage
import '../views/attendance_page.dart'; // 3. Import AttendancePage
import '../models/feature_card_model.dart';
import 'board_controller.dart';
import '../views/board_agreements_page.dart';
import 'quiz_controller.dart';
import '../views/quiz_list_page.dart';

class HomeController {
  final ProgramController programController = ProgramController();
  final MemberController memberController = MemberController(); // 4. Instantiate MemberController
  final BoardController boardController = BoardController();
  final QuizController quizController = QuizController();
  
  List<FeatureCardModel> getFeatureCards(BuildContext context) {
    return [
      // Feature 1: Church Program
      FeatureCardModel(
        title: 'Church Program',
        description: 'View and manage Sabbath School & Divine Worship program flow.',
        icon: Icons.auto_stories,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProgramPage(controller: programController),
            ),
          );
        },
      ),

      // Feature 2: Church Directory (CRUD)
      FeatureCardModel(
        title: 'Church Directory',
        description: 'Add, edit, or remove church members and assign roles.',
        icon: Icons.people_alt,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MembersPage(controller: memberController),
            ),
          );
        },
      ),

      // Feature 3: Sabbath Attendance
      FeatureCardModel(
        title: 'Sabbath Attendance',
        description: 'Track Sabbath attendance and view weekly reports.',
        icon: Icons.how_to_reg,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AttendancePage(controller: memberController),
            ),
          );
        },
      ),
      FeatureCardModel(
        title: 'Board Resolutions & Rules',
        description: 'View church policies, meeting agendas, and board agreements.',
        icon: Icons.gavel,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BoardAgreementsPage(
                controller: boardController,
              ),
            ),
          );
        },
      ),
      FeatureCardModel(
        title: 'Bible Quizzes & Leaderboard',
        description: 'Take quizzes, view answers, and track member scores.',
        icon: Icons.quiz,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizListPage(
                quizController: quizController,
                memberController: memberController,
              ),
            ),
          );
        },
      ),
    ];
  }
}