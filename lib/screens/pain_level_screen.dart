import 'package:flutter/material.dart';
import 'package:flutter_projectt/screens/pain_questionnaire_screen.dart';
import '../widgets/tr_text.dart';

class PainLevel {
  final int value;
  final String label;
  final String emoji;
  final Color color;

  PainLevel({required this.value, required this.label, required this.emoji, required this.color});
}

class PainLevelScreen extends StatefulWidget {
  final Set<String> selectedParts;
  final Set<String> selectedSymptoms;
  final Set<String> selectedConditions;

  const PainLevelScreen({
    super.key,
    required this.selectedParts,
    required this.selectedSymptoms,
    required this.selectedConditions,
  });

  @override
  State<PainLevelScreen> createState() => _PainLevelScreenState();
}

class _PainLevelScreenState extends State<PainLevelScreen> {
  final List<PainLevel> levels = [
    PainLevel(value: 1, label: "No Pain", emoji: "😊", color: const Color(0xFF4DB6AC)),
    PainLevel(value: 2, label: "Mild", emoji: "🙂", color: const Color(0xFF4DB6AC)),
    PainLevel(value: 3, label: "Mild", emoji: "😐", color: Colors.amber),
    PainLevel(value: 4, label: "Moderate", emoji: "😕", color: Colors.amber),
    PainLevel(value: 5, label: "Moderate", emoji: "😟", color: Colors.amber),
    PainLevel(value: 6, label: "Moderate", emoji: "😣", color: const Color(0xFFFF7043)),
    PainLevel(value: 7, label: "Severe", emoji: "😫", color: const Color(0xFFFF7043)),
    PainLevel(value: 8, label: "Severe", emoji: "😩", color: Colors.redAccent),
    PainLevel(value: 9, label: "Very Severe", emoji: "😭", color: Colors.redAccent),
    PainLevel(value: 10, label: "Worst", emoji: "🤯", color: Colors.redAccent),
  ];

  double _currentLevel = 3;

  @override
  Widget build(BuildContext context) {
    final current = levels[_currentLevel.toInt() - 1];
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TrText("Pain Intensity", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TrText("How much pain are you feeling?", style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      // ✅ FIX: Using SingleChildScrollView + ConstrainedBox to prevent bottom overflow
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth > 600 ? 60 : 24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),

                      // --- Emoji and Level Display ---
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                        child: Column(
                          key: ValueKey(_currentLevel),
                          children: [
                            Text(current.emoji, style: const TextStyle(fontSize: 80)),
                            const SizedBox(height: 10),
                            Text(
                              "${_currentLevel.toInt()}/10",
                              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                            ),
                            TrText(
                              "${current.label} Pain",
                              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // --- Custom Gradient Slider ---
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 8,
                          activeTrackColor: Colors.transparent,
                          inactiveTrackColor: Colors.grey.shade200,
                          thumbColor: current.color,
                          overlayColor: current.color.withOpacity(0.2),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF4DB6AC), Colors.amber, Colors.redAccent],
                            ),
                          ),
                          child: Slider(
                            value: _currentLevel,
                            min: 1,
                            max: 10,
                            divisions: 9,
                            onChanged: (val) => setState(() => _currentLevel = val),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TrText("Low", style: TextStyle(fontSize: 10, color: Colors.grey)),
                            TrText("Medium", style: TextStyle(fontSize: 10, color: Colors.grey)),
                            TrText("High", style: TextStyle(fontSize: 10, color: Colors.grey)),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // --- Level Dots ---
                      Center(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: levels.map((l) {
                            bool isSelected = _currentLevel.toInt() == l.value;
                            return GestureDetector(
                              onTap: () => setState(() => _currentLevel = l.value.toDouble()),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: screenWidth < 360 ? 28 : 32,
                                height: screenWidth < 360 ? 28 : 32,
                                decoration: BoxDecoration(
                                  color: isSelected ? l.color : Colors.grey.shade100,
                                  shape: BoxShape.circle,
                                  boxShadow: isSelected ? [BoxShadow(color: l.color.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))] : [],
                                ),
                                child: Center(
                                  child: Text(
                                    "${l.value}",
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : Colors.grey.shade600,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      // ✅ Changed Spacer to an Expanded or flexible padding to avoid overflow
                      const Expanded(child: SizedBox(height: 40)),

                      // --- High Pain Warning ---
                      if (_currentLevel >= 8)
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.red.shade100),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const TrText("⚠️ High Pain Level", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14)),
                              const SizedBox(height: 4),
                              TrText(
                                "Please consult a doctor if pain persists. We'll suggest gentle exercises only.",
                                style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                              ),
                            ],
                          ),
                        ),

                      // --- Action Button ---
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PainQuestionnaireScreen(
                                    selectedParts: widget.selectedParts,
                                    selectedSymptoms: widget.selectedSymptoms,
                                    selectedConditions: widget.selectedConditions,
                                    painScore: _currentLevel.toInt(),
                                  )
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00796B),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: const TrText(
                            "Continue",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}