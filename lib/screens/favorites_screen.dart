import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/exercise_model.dart';
import 'exercise_detail_screen.dart';
import '../widgets/tr_text.dart'; // ✅ Added import
import '../services/translation_controller.dart'; // ✅ Added for language logic

class FavoriteExercise {
  final int id;
  final String name;
  final String category;
  final String duration;
  final int calories;
  final String difficulty;

  FavoriteExercise({
    required this.id,
    required this.name,
    required this.category,
    required this.duration,
    required this.calories,
    required this.difficulty,
  });
}

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final List<FavoriteExercise> _favs = [
    FavoriteExercise(id: 2, name: "Cat-Cow Pose", category: "Yoga", duration: "8 min", calories: 25, difficulty: "Beginner"),
    FavoriteExercise(id: 5, name: "Knee-to-Chest Stretch", category: "Stretching", duration: "5 min", calories: 20, difficulty: "Beginner"),
    FavoriteExercise(id: 8, name: "Seated Spinal Twist", category: "Yoga", duration: "7 min", calories: 20, difficulty: "Beginner"),
  ];

  void _removeFavorite(int id) {
    setState(() {
      _favs.removeWhere((item) => item.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Requirement 1: Responsive Width Detection
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(
        // ✅ Requirement 2: Translated AppBar Title
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TrText("Favorites", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Row(
              children: [
                Text("${_favs.length} ", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                TrText("saved exercises", style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        automaticallyImplyLeading: false,
      ),
      body: _favs.isEmpty ? _buildEmptyState() : _buildList(screenWidth),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.heart, size: 64, color: Colors.grey.withOpacity(0.3)),
            const SizedBox(height: 16),
            TrText("No favorites yet", style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            TrText(
              "Tap the heart icon on any exercise to save it",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(double screenWidth) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: screenWidth > 600 ? 40 : 20, vertical: 20),
      itemCount: _favs.length,
      itemBuilder: (context, index) {
        final ex = _favs[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(LucideIcons.heart, color: Color(0xFFFF7F50), size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExerciseDetailScreen(
                          exercise: ExerciseModel(
                            id: ex.id.toString(),
                            targetBodyPart: "General",
                            category: ex.category,
                            level: ex.difficulty,
                            maxPainScore: 10,
                            youtubeId: "CEQMx4zFwYs",
                            titles: {'en': ex.name},
                            descriptions: {'en': 'A saved favorite exercise.'},
                            targetSymptoms: [],
                            clinicalBenefit: 'Improves overall mobility.',
                            reps: '12',
                            sets: '3',
                            holdTime: ex.duration,
                            caution: 'Perform within a comfortable range of motion.',
                          ),
                        ),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ✅ Requirement 2: Translated Name (if present in local strings)
                      TrText(ex.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 4),
                      // ✅ Requirement 1: Responsive Wrap for stats
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Icon(LucideIcons.clock, size: 10, color: Colors.grey.shade400),
                          const SizedBox(width: 4),
                          TrText(ex.duration, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                          const SizedBox(width: 12),
                          Icon(LucideIcons.flame, size: 10, color: Colors.grey.shade400),
                          const SizedBox(width: 4),
                          Text("${ex.calories} ", style: const TextStyle(fontSize: 10, color: Colors.grey)),
                          TrText("cal", style: const TextStyle(fontSize: 10, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _removeFavorite(ex.id),
                icon: const Icon(LucideIcons.trash2, size: 18, color: Colors.grey),
              )
            ],
          ),
        );
      },
    );
  }
}