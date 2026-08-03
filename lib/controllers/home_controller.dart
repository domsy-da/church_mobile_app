import 'package:flutter/material.dart';
import '../models/feature_card_model.dart';
import '../views/program_page.dart';
import 'program_controller.dart';

class HomeController {
  final ProgramController programController = ProgramController();
  // Fetch available feature navigation cards
  List<FeatureCardModel> getFeatureCards(BuildContext context) {
    return [
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
      FeatureCardModel(
        title: 'Feature Two',
        description: 'Manage settings or perform actions.',
        icon: Icons.settings_rounded,
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Feature 2 clicked')),
          );
        },
      ),
      FeatureCardModel(
        title: 'Analytics',
        description: 'View dashboard metrics and progress.',
        icon: Icons.analytics_rounded,
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Analytics clicked')),
          );
        },
      ),
      FeatureCardModel(
        title: 'Profile Settings',
        description: 'Update user info and app preferences.',
        icon: Icons.person_rounded,
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile clicked')),
          );
        },
      ),
    ];
  }
}