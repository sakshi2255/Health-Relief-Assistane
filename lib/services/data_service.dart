import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/exercise_model.dart'; // Adjust path if needed

class DataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch exercises based on a LIST of body parts and filter by pain score
  Future<List<ExerciseModel>> fetchSafeExercises(List<String> bodyParts, int userPainScore) async {
    try {
      // If the user somehow didn't select any body parts, return an empty list early
      if (bodyParts.isEmpty) {
        return [];
      }

      // 1. Fetch all exercises for the selected body parts
      // Note: Firebase 'whereIn' allows up to 10 items in the list, which is perfect for our use case.
      QuerySnapshot snapshot = await _firestore
          .collection('exercises')
          .where('targetBodyPart', whereIn: bodyParts)
          .get();

      // 2. Convert Firestore documents into our ExerciseModel
      List<ExerciseModel> exercises = snapshot.docs.map((doc) {
        return ExerciseModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      // 3. The Clinical Filter: Remove exercises that are too intense!
      // If a user's pain is 8, they should NOT see an exercise with a maxPainScore of 5.
      List<ExerciseModel> safeExercises = exercises.where((ex) {
        return userPainScore <= ex.maxPainScore;
      }).toList();

      return safeExercises;
    } catch (e) {
      print("Error fetching exercises: $e");
      return [];
    }
  }
}