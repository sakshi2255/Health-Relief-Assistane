import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'exercise_detail_screen.dart';

import 'nearby_screen.dart';
import '../models/exercise_model.dart';
import '../services/translation_controller.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  final ExerciseModel featuredExercise = ExerciseModel(
      id: "featured_01",
      targetBodyPart: "Full Body",
      category: "Wellness",
      level: "Beginner",
      maxPainScore: 10,
      youtubeId: "CEQMx4zFwYs",
      titles: {'en': 'Daily Wellness Stretch', 'hi': 'दैनिक स्वास्थ्य खिंचाવ', 'gu': 'દૈનિક સુખાકારી ખેંચાણ'},
      descriptions: {'en': 'A gentle routine...', 'hi': 'एक कोमल दिनचर्या...', 'gu': 'એક નમ્ર દિનચર્યા...'},
      clinicalBenefit: "Promotes blood flow.",
      reps: "12",
      sets: "3",
      holdTime: "15s",
      caution: "Breathe deeply.",
      targetSymptoms: ["Stiffness"]
  );

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // ✅ Helper to build labels asynchronously
  Widget _buildAsyncLabel(String key, double fontSize) {
    return FutureBuilder<String>(
      future: TranslationController.translate(key),
      builder: (context, snapshot) {
        // Show English while loading or the translated text once ready
        return Text(
          snapshot.data ?? key,
          style: TextStyle(fontSize: fontSize),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      const HomeScreen(),

      ExerciseDetailScreen(exercise: featuredExercise),
      const NearbyScreen(),
      const ProfileScreen(),
    ];

    double screenWidth = MediaQuery.of(context).size.width;
    double iconSize = screenWidth < 360 ? 20 : 22;
    double labelSize = screenWidth < 360 ? 9 : 10;

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF00796B),
        unselectedItemColor: Colors.grey.shade400,
        // We use empty strings for labels and use custom widgets for better control
        items: [
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.home, size: iconSize),
            label: 'Home', // ✅ To fix the error quickly, use plain strings
          ),

          BottomNavigationBarItem(
            icon: Icon(LucideIcons.flame, size: iconSize),
            label: 'Exercise',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.mapPin, size: iconSize),
            label: 'Nearby',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.user, size: iconSize),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}