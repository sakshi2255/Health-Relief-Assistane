import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../services/data_service.dart';
import '../models/exercise_model.dart';
import 'exercise_detail_screen.dart';
import '../widgets/tr_text.dart';
import '../services/translation_controller.dart';

class ExerciseListScreen extends StatefulWidget {
  final List<String> rawBodyParts;
  final int painScore;

  const ExerciseListScreen({super.key, required this.rawBodyParts, required this.painScore});

  @override
  State<ExerciseListScreen> createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen> {
  final DataService _dataService = DataService();
  late Future<List<ExerciseModel>> _exercisesFuture;

  List<String> _mapBodyParts(List<String> rawIds) {
    Set<String> mapped = {};
    for (String id in rawIds) {
      if (id.contains('shoulder')) mapped.add('Shoulder');
      else if (id.contains('arm')) mapped.add('Arms');
      else if (id.contains('wrist')) mapped.add('Wrist');
      else if (id.contains('knee')) mapped.add('Knee');
      else if (id.contains('ankle')) mapped.add('Ankle');
      else if (id == 'head' || id == 'neck') mapped.add('Head & Neck');
      else if (id == 'chest') mapped.add('Chest');
      else if (id == 'upper-back') mapped.add('Upper Back');
      else if (id == 'lower-back') mapped.add('Lower Back');
    }
    return mapped.toList();
  }

  @override
  void initState() {
    super.initState();
    List<String> dbCategories = _mapBodyParts(widget.rawBodyParts);
    _exercisesFuture = _dataService.fetchSafeExercises(dbCategories, widget.painScore);
  }

  Map<String, List<ExerciseModel>> _groupAndLimitExercises(List<ExerciseModel> allExercises) {
    Map<String, List<ExerciseModel>> grouped = {};
    for (var ex in allExercises) {
      if (!grouped.containsKey(ex.targetBodyPart)) {
        grouped[ex.targetBodyPart] = [];
      }
      if (grouped[ex.targetBodyPart]!.length < 4) {
        grouped[ex.targetBodyPart]!.add(ex);
      }
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(
        title: TrText("Your Relief Plan", style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // ✅ Requirement 1: Responsive Padding
          double horizontalPadding = constraints.maxWidth > 600 ? 40 : 20;

          return FutureBuilder<List<ExerciseModel>>(
            future: _exercisesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFF00796B)));
              }

              if (snapshot.hasError) {
                return Center(child: TrText("Failed to load exercises. Please check your connection."));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return _buildEmptyState();
              }

              Map<String, List<ExerciseModel>> groupedExercises = _groupAndLimitExercises(snapshot.data!);

              return ListView.builder(
                padding: EdgeInsets.all(horizontalPadding),
                itemCount: groupedExercises.keys.length,
                itemBuilder: (context, index) {
                  String bodyPart = groupedExercises.keys.elementAt(index);
                  List<ExerciseModel> exercisesForPart = groupedExercises[bodyPart]!;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))
                      ],
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        initiallyExpanded: false,
                        tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        iconColor: const Color(0xFF00796B),
                        collapsedIconColor: Colors.grey,
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0F2F1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(LucideIcons.target, color: Color(0xFF00796B), size: 22),
                        ),
                        // ✅ Requirement 1 & 2: Responsive Translated Title
                        title: Row(
                          children: [
                            Flexible(
                              child: Wrap(
                                children: [
                                  TrText(bodyPart, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  const SizedBox(width: 4),
                                  TrText("Focus", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        subtitle: Row(
                          children: [
                            Text("${exercisesForPart.length} ", style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                            TrText("Exercises", style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                          ],
                        ),
                        children: exercisesForPart.map((ex) => _buildVerticalExerciseItem(context, ex)).toList(),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildVerticalExerciseItem(BuildContext context, ExerciseModel exercise) {
    String lang = TranslationController.currentLang;
    String displayTitle = exercise.titles[lang] ?? exercise.titles['en'] ?? "Exercise";

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ExerciseDetailScreen(exercise: exercise))
          );
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)],
                ),
                child: const Icon(LucideIcons.playCircle, color: Color(0xFF00796B), size: 20),
              ),
              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ Requirement 2: Translated Title
                    TrText(
                      displayTitle,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(LucideIcons.repeat, size: 10, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        // ✅ Requirement 1: Responsive Wrap
                        Flexible(
                          child: Wrap(
                            children: [
                              Text("${exercise.sets} ", style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
                              TrText("sets", style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
                              Text(" • ${exercise.reps}", style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TrText(
                  exercise.level,
                  style: TextStyle(color: Colors.orange.shade700, fontSize: 9, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.alertCircle, size: 60, color: Colors.orange),
            const SizedBox(height: 16),
            TrText("No safe exercises found", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TrText(
              "With a pain score of ${widget.painScore}, it may not be safe to perform exercises right now. Please rest or consult a doctor.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}