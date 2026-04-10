import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'exercise_list_screen.dart';
import '../widgets/tr_text.dart'; // ✅ Added for translations

class PainQuestionnaireScreen extends StatefulWidget {
  final Set<String> selectedParts;
  final Set<String> selectedSymptoms;
  final Set<String> selectedConditions;
  final int painScore;

  const PainQuestionnaireScreen({
    super.key,
    required this.selectedParts,
    required this.selectedSymptoms,
    required this.selectedConditions,
    required this.painScore,
  });

  @override
  State<PainQuestionnaireScreen> createState() => _PainQuestionnaireScreenState();
}

class _PainQuestionnaireScreenState extends State<PainQuestionnaireScreen> {
  bool _acceptedDisclaimer = false;
  String _selectedDuration = "";
  String _selectedTrigger = "";
  String _selectedHistory = "";

  // ✅ Strings kept as keys for TrText to translate
  final List<String> durations = ["Less than a week", "1-4 weeks", "1-3 months", "Chronic (> 3 months)"];
  final List<String> triggers = ["Sudden Injury", "Gradual Onset", "Overwork / Strain", "Unknown"];
  final List<String> histories = ["No past issues", "Previous injury here", "Past surgery", "Arthritis / Joint issues"];

  @override
  Widget build(BuildContext context) {
    // ✅ Requirement 1: Responsive width detection
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(
        // ✅ Requirement 2: Translated AppBar
        title: const TrText("Final Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: screenWidth > 600 ? 40 : 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Mandatory Medical Disclaimer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(LucideIcons.alertOctagon, color: Colors.red, size: 20),
                      const SizedBox(width: 8),
                      TrText("Medical Disclaimer", style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // ✅ Requirement 2: Translated Disclaimer Text
                  const TrText(
                    "This app provides general exercise suggestions and is NOT a substitute for professional medical advice, diagnosis, or treatment. Stop immediately if you experience sharp pain.",
                    style: TextStyle(color: Color(0xFFB71C1C), fontSize: 12, height: 1.5),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: _acceptedDisclaimer,
                          activeColor: Colors.red,
                          onChanged: (val) => setState(() => _acceptedDisclaimer = val ?? false),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: TrText("I understand and accept these terms", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      )
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 32),

            // 2. Clinical Questions
            const TrText("Help us understand your pain", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            TrText("This helps us build your health history.", style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
            const SizedBox(height: 24),

            _buildQuestionSection("How long have you had this pain?", durations, _selectedDuration, (val) => setState(() => _selectedDuration = val)),
            const SizedBox(height: 24),

            _buildQuestionSection("What triggered the pain?", triggers, _selectedTrigger, (val) => setState(() => _selectedTrigger = val)),
            const SizedBox(height: 24),

            _buildQuestionSection("Any past history in this area?", histories, _selectedHistory, (val) => setState(() => _selectedHistory = val)),
            const SizedBox(height: 40),

            // 3. Generate Exercises Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _acceptedDisclaimer ? () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExerciseListScreen(
                        rawBodyParts: widget.selectedParts.toList(),
                        painScore: widget.painScore,
                      ),
                    ),
                  );
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00796B),
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const TrText(
                  "View My Exercises",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionSection(String title, List<String> options, String selectedValue, Function(String) onSelect) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ✅ Requirement 2: Translated Question Title
        TrText(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 12),
        // ✅ Requirement 1: Responsive Wrap for ChoiceChips
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            bool isSelected = selectedValue == option;
            return ChoiceChip(
              // ✅ Requirement 2: Translated Chip Option
              label: TrText(option, style: TextStyle(
                color: isSelected ? const Color(0xFF00796B) : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              )),
              selected: isSelected,
              onSelected: (val) => onSelect(option),
              selectedColor: const Color(0xFFE0F2F1),
              backgroundColor: Colors.white,
              side: BorderSide(color: isSelected ? const Color(0xFF4DB6AC) : Colors.grey.shade300),
            );
          }).toList(),
        ),
      ],
    );
  }
}