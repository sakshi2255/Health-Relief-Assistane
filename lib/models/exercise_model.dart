class ExerciseModel {
  final String id;
  final String targetBodyPart;
  final String category;
  final String level;
  final int maxPainScore;
  final String youtubeId; // NEW: The 11-character video ID
  final Map<String, String> titles;
  final Map<String, String> descriptions;
  final List<String> targetSymptoms;
  final String clinicalBenefit;
  final String reps;
  final String sets;
  final String holdTime;
  final String caution;

  ExerciseModel({
    required this.id,
    required this.targetBodyPart,
    required this.category,
    required this.level,
    required this.maxPainScore,
    required this.youtubeId,
    required this.titles,
    required this.descriptions,
    required this.targetSymptoms,
    required this.clinicalBenefit,
    required this.reps,
    required this.sets,
    required this.holdTime,
    required this.caution,
  });

  factory ExerciseModel.fromMap(Map<String, dynamic> map, String documentId) {
    return ExerciseModel(
      id: documentId,
      targetBodyPart: map['targetBodyPart'] ?? '',
      category: map['category'] ?? '',
      level: map['level'] ?? 'Beginner',
      maxPainScore: map['maxPainScore'] ?? 10,
      youtubeId: map['youtubeId'] ?? '', // Parses the YouTube ID
      titles: Map<String, String>.from(map['titles'] ?? {}),
      descriptions: Map<String, String>.from(map['descriptions'] ?? {}),
      targetSymptoms: List<String>.from(map['targetSymptoms'] ?? []),
      clinicalBenefit: map['clinicalBenefit'] ?? '',
      reps: map['reps'] ?? '',
      sets: map['sets'] ?? '',
      holdTime: map['holdTime'] ?? '',
      caution: map['caution'] ?? '',
    );
  }
}