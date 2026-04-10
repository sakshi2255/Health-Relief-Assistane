// import 'package:flutter/material.dart';
// import 'package:lucide_icons/lucide_icons.dart';
// import 'exercise_detail_screen.dart';
// import '../models/exercise_model.dart';
// import '../widgets/tr_text.dart'; // ✅ Added
// import '../services/translation_controller.dart'; // ✅ Added
//
// class Exercise {
//   final int id;
//   final String name;
//   final String category;
//   final String duration;
//   final String difficulty;
//   final int calories;
//
//   Exercise({
//     required this.id,
//     required this.name,
//     required this.category,
//     required this.duration,
//     required this.difficulty,
//     required this.calories,
//   });
// }
//
// class WorkoutsScreen extends StatefulWidget {
//   const WorkoutsScreen({super.key});
//
//   @override
//   State<WorkoutsScreen> createState() => _WorkoutsScreenState();
// }
//
// class _WorkoutsScreenState extends State<WorkoutsScreen> {
//   String selectedFilter = "all";
//   final Set<int> favorites = {2, 5};
//
//   final List<Exercise> exercises = [
//     Exercise(id: 1, name: "Gentle Neck Stretch", category: "Stretching", duration: "5 min", difficulty: "beginner", calories: 15),
//     Exercise(id: 2, name: "Cat-Cow Pose", category: "Yoga", duration: "8 min", difficulty: "beginner", calories: 25),
//     Exercise(id: 3, name: "Shoulder Rolls", category: "Mobility", duration: "3 min", difficulty: "beginner", calories: 10),
//     Exercise(id: 4, name: "Standing Forward Bend", category: "Yoga", duration: "6 min", difficulty: "intermediate", calories: 30),
//     Exercise(id: 5, name: "Knee-to-Chest Stretch", category: "Stretching", duration: "5 min", difficulty: "beginner", calories: 20),
//     Exercise(id: 6, name: "Bridge Exercise", category: "Strength", duration: "10 min", difficulty: "intermediate", calories: 45),
//     Exercise(id: 7, name: "Wall Push-ups", category: "Strength", duration: "8 min", difficulty: "intermediate", calories: 35),
//     Exercise(id: 8, name: "Seated Spinal Twist", category: "Yoga", duration: "7 min", difficulty: "beginner", calories: 20),
//   ];
//
//   final List<String> avoidExercises = [
//     "Heavy Deadlifts",
//     "Burpees",
//     "High-Impact Jumping",
//     "Heavy Overhead Press",
//   ];
//
//   Color _getDifficultyColor(String diff) {
//     switch (diff) {
//       case "beginner": return const Color(0xFF4DB6AC);
//       case "intermediate": return Colors.orange;
//       case "advanced": return Colors.red;
//       default: return Colors.grey;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     List<Exercise> filtered = selectedFilter == "all"
//         ? exercises
//         : exercises.where((e) => e.difficulty == selectedFilter).toList();
//
//     // ✅ Requirement 1: Responsive width detection
//     double screenWidth = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAF9),
//       appBar: AppBar(
//         // ✅ Requirement 2: Translated AppBar
//         title: const TrText("Workout Suggestions", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         foregroundColor: Colors.black,
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.symmetric(horizontal: screenWidth > 600 ? 40 : 20, vertical: 20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // 1. Filter Chips (Responsive horizontal list)
//             SizedBox(
//               height: 40,
//               child: ListView(
//                 scrollDirection: Axis.horizontal,
//                 children: ["all", "beginner", "intermediate", "advanced"].map((d) {
//                   bool isSelected = selectedFilter == d;
//                   return Padding(
//                     padding: const EdgeInsets.only(right: 8),
//                     child: ChoiceChip(
//                       // ✅ Requirement 2: Translated chip labels
//                       label: TrText(d[0].toUpperCase() + d.substring(1),
//                           style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontSize: 12)),
//                       selected: isSelected,
//                       onSelected: (val) => setState(() => selectedFilter = d),
//                       selectedColor: const Color(0xFF00796B),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//             const SizedBox(height: 20),
//
//             // 2. Precautions Banner
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.amber.shade50,
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(color: Colors.amber.shade100),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       const Icon(LucideIcons.alertTriangle, size: 16, color: Colors.amber),
//                       const SizedBox(width: 8),
//                       // ✅ Requirement 2: Translated Header
//                       TrText("Precautions", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   // ✅ Requirement 2: Translated Bulletin Points
//                   const TrText("• Start slowly and listen to your body\n• Stop if pain increases\n• Warm up before starting",
//                       style: TextStyle(fontSize: 12, color: Color(0xFF616161), height: 1.5)),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),
//
//             // 3. Exercise List
//             ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: filtered.length,
//               itemBuilder: (context, index) {
//                 final ex = filtered[index];
//                 bool isFav = favorites.contains(ex.id);
//
//                 return Padding(
//                   padding: const EdgeInsets.only(bottom: 12),
//                   child: InkWell(
//                     borderRadius: BorderRadius.circular(20),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ExerciseDetailScreen(
//                             exercise: ExerciseModel(
//                               id: ex.id.toString(),
//                               targetBodyPart: "General",
//                               category: ex.category,
//                               level: ex.difficulty,
//                               maxPainScore: 10,
//                               youtubeId: "CEQMx4zFwYs",
//                               titles: {'en': ex.name},
//                               descriptions: {'en': 'A generic workout suggestion.'},
//                               targetSymptoms: [],
//                               clinicalBenefit: 'Improves overall fitness.',
//                               reps: '15',
//                               sets: '3',
//                               holdTime: ex.duration,
//                               caution: 'Perform within a comfortable range of motion.',
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(20),
//                         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
//                       ),
//                       child: Row(
//                         children: [
//                           Container(
//                             width: 50, height: 50,
//                             decoration: BoxDecoration(color: const Color(0xFFE0F2F1), borderRadius: BorderRadius.circular(12)),
//                             child: const Icon(LucideIcons.flame, color: Color(0xFF00796B)),
//                           ),
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 // ✅ Requirement 2: Translated Name (if exists in JSON)
//                                 TrText(ex.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
//                                 TrText(ex.category, style: const TextStyle(color: Colors.grey, fontSize: 12)),
//                                 const SizedBox(height: 8),
//                                 Row(
//                                   children: [
//                                     Icon(LucideIcons.clock, size: 12, color: Colors.grey.shade400),
//                                     const SizedBox(width: 4),
//                                     TrText(ex.duration, style: const TextStyle(fontSize: 10, color: Colors.grey)),
//                                     const SizedBox(width: 12),
//                                     Container(
//                                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                                       decoration: BoxDecoration(
//                                         color: _getDifficultyColor(ex.difficulty).withOpacity(0.1),
//                                         borderRadius: BorderRadius.circular(8),
//                                       ),
//                                       child: TrText(ex.difficulty, style: TextStyle(color: _getDifficultyColor(ex.difficulty), fontSize: 10, fontWeight: FontWeight.bold)),
//                                     ),
//                                   ],
//                                 )
//                               ],
//                             ),
//                           ),
//                           IconButton(
//                             icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : Colors.grey),
//                             onPressed: () => setState(() => isFav ? favorites.remove(ex.id) : favorites.add(ex.id)),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//
//             const SizedBox(height: 24),
//
//             // 4. Avoid Section
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.red.shade50,
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(color: Colors.red.shade100),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       const Icon(LucideIcons.alertTriangle, size: 16, color: Colors.red),
//                       const SizedBox(width: 8),
//                       // ✅ Requirement 2: Translated Warning Header
//                       TrText("Avoid These Exercises", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.red)),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//                   // ✅ Requirement 1: Wrap for avoid tags to prevent horizontal overflow
//                   Wrap(
//                     spacing: 8,
//                     runSpacing: 8,
//                     children: avoidExercises.map((ex) => Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                       decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
//                       child: TrText(ex, style: const TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.w600)),
//                     )).toList(),
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }