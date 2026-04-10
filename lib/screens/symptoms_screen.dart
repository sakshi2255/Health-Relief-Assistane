import 'package:flutter/material.dart';
import 'package:flutter_projectt/screens/disease_screen.dart';
import '../widgets/tr_text.dart'; // ✅ Added for translations

class Symptom {
  final String id;
  final String label;
  final String emoji;
  final String description;

  Symptom({required this.id, required this.label, required this.emoji, required this.description});
}

class SymptomsScreen extends StatefulWidget {
  final Set<String> selectedParts;

  const SymptomsScreen({super.key, required this.selectedParts});

  @override
  State<SymptomsScreen> createState() => _SymptomsScreenState();
}

class _SymptomsScreenState extends State<SymptomsScreen> {
  final List<Symptom> symptoms = [
    Symptom(id: "swelling", label: "Swelling", emoji: "🔴", description: "Enlargement or puffiness in the area."),
    Symptom(id: "stiffness", label: "Stiffness", emoji: "🦴", description: "Difficulty moving the joint freely."),
    Symptom(id: "weakness", label: "Weakness", emoji: "💪", description: "Lack of strength or muscle power."),
    Symptom(id: "fatigue", label: "Fatigue", emoji: "😴", description: "Feeling tired or drained in the muscles."),
    Symptom(id: "cramps", label: "Cramps", emoji: "⚡", description: "Sudden involuntary muscle contractions."),
    Symptom(id: "numbness", label: "Numbness", emoji: "🫠", description: "Loss of sensation or feeling."),
    Symptom(id: "burning", label: "Burning", emoji: "🔥", description: "A hot or stinging painful sensation."),
    Symptom(id: "tingling", label: "Tingling", emoji: "✨", description: "A 'pins and needles' sensation."),
    Symptom(id: "sharp-pain", label: "Sharp Pain", emoji: "🔪", description: "Intense, sudden stabbing sensation."),
    Symptom(id: "dull-ache", label: "Dull Ache", emoji: "😣", description: "Persistent, low-level background pain."),
    Symptom(id: "limited-motion", label: "Limited Motion", emoji: "🚫", description: "Reduced range of physical movement."),
    Symptom(id: "clicking", label: "Clicking/Popping", emoji: "🫰", description: "Sounds or snapping during movement."),
  ];

  final Set<String> selectedSymptoms = {};

  void _toggleSymptom(String id) {
    setState(() {
      if (selectedSymptoms.contains(id)) {
        selectedSymptoms.remove(id);
      } else {
        selectedSymptoms.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Requirement 1: Responsive width and grid detection
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth > 600 ? 3 : 2;
    // Adjust aspect ratio based on width to prevent vertical overflow
    double aspectRatio = screenWidth < 360 ? 0.85 : 1.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(
        // ✅ Requirement 2: Translated Header
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TrText("Symptoms", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TrText("Select all symptoms you're experiencing", style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: aspectRatio,
              ),
              itemCount: symptoms.length,
              itemBuilder: (context, index) {
                final symptom = symptoms[index];
                final isSelected = selectedSymptoms.contains(symptom.id);

                return GestureDetector(
                  onTap: () => _toggleSymptom(symptom.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF00796B) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4)
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(symptom.emoji, style: const TextStyle(fontSize: 22)),
                            if (isSelected)
                              const Icon(Icons.check_circle, color: Colors.white, size: 18),
                          ],
                        ),
                        const Spacer(),
                        // ✅ Requirement 2: Translated Label
                        TrText(
                          symptom.label,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        // ✅ Requirement 2 & 3: Translated Description below name
                        TrText(
                          symptom.description,
                          style: TextStyle(
                            fontSize: 10,
                            color: isSelected ? Colors.white70 : Colors.grey.shade500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Action Button
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: selectedSymptoms.isEmpty ? null : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DiseaseScreen(
                          selectedParts: widget.selectedParts,
                          selectedSymptoms: selectedSymptoms,
                        )
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00796B),
                  disabledBackgroundColor: Colors.grey.shade200,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                // ✅ Requirement 2: Translated Button Text
                child: const TrText(
                    "Continue",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}