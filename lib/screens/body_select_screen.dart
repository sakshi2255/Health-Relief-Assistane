import 'package:flutter/material.dart';
import 'package:flutter_projectt/screens/symptoms_screen.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../widgets/tr_text.dart'; // ✅ Added import

class BodyPart {
  final String id;
  final String label;
  final double top;
  final double left;

  BodyPart({required this.id, required this.label, required this.top, required this.left});
}

class BodySelectScreen extends StatefulWidget {
  const BodySelectScreen({super.key});

  @override
  State<BodySelectScreen> createState() => _BodySelectScreenState();
}

class _BodySelectScreenState extends State<BodySelectScreen> {
  final Set<String> selectedParts = {};

  final List<BodyPart> bodyParts = [
    BodyPart(id: "head", label: "Head", top: 0.05, left: 0.50),
    BodyPart(id: "neck", label: "Neck", top: 0.15, left: 0.50),
    BodyPart(id: "left-shoulder", label: "L. Shoulder", top: 0.20, left: 0.30),
    BodyPart(id: "right-shoulder", label: "R. Shoulder", top: 0.20, left: 0.70),
    BodyPart(id: "chest", label: "Chest", top: 0.26, left: 0.50),
    BodyPart(id: "upper-back", label: "Upper Back", top: 0.32, left: 0.50),
    BodyPart(id: "left-arm", label: "L. Arm", top: 0.35, left: 0.25),
    BodyPart(id: "right-arm", label: "R. Arm", top: 0.35, left: 0.75),
    BodyPart(id: "lower-back", label: "Lower Back", top: 0.42, left: 0.50),
    BodyPart(id: "left-wrist", label: "L. Wrist", top: 0.48, left: 0.23),
    BodyPart(id: "right-wrist", label: "R. Wrist", top: 0.48, left: 0.77),
    BodyPart(id: "left-knee", label: "L. Knee", top: 0.65, left: 0.38),
    BodyPart(id: "right-knee", label: "R. Knee", top: 0.65, left: 0.62),
    BodyPart(id: "left-ankle", label: "L. Ankle", top: 0.85, left: 0.38),
    BodyPart(id: "right-ankle", label: "R. Ankle", top: 0.85, left: 0.62),
  ];

  void _togglePart(String id) {
    setState(() {
      selectedParts.contains(id) ? selectedParts.remove(id) : selectedParts.add(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // ✅ Requirement 2: Wrapped in TrText
        title: TrText("Select Pain Area", style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // ✅ Requirement 1: Responsive Scaling logic
                double w = constraints.maxWidth;
                double h = constraints.maxHeight;

                return Stack(
                  alignment: Alignment.center,
                  children: [
                    _buildSingleSilhouette(w, h),
                    ...bodyParts.map((part) {
                      bool isSelected = selectedParts.contains(part.id);
                      return Positioned(
                        top: h * part.top,
                        left: w * part.left,
                        child: FractionalTranslation(
                          translation: const Offset(-0.5, -0.5),
                          child: GestureDetector(
                            onTap: () => _togglePart(part.id),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // ✅ Requirement 2: Wrapped Label in TrText
                                TrText(
                                  part.label,
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected ? Colors.red : Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: isSelected ? Colors.red.withOpacity(0.4) : const Color(0xFF4DB6AC).withOpacity(0.1),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected ? Colors.red : const Color(0xFF4DB6AC),
                                      width: 2,
                                    ),
                                  ),
                                  child: isSelected ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                );
              },
            ),
          ),
          _buildBottomActionPanel(),
        ],
      ),
    );
  }

  Widget _buildSingleSilhouette(double w, double h) {
    Color bodyColor = Colors.grey.withOpacity(0.1);
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(top: h * 0.02, child: Container(width: w * 0.15, height: h * 0.1, decoration: BoxDecoration(color: bodyColor, borderRadius: BorderRadius.circular(25)))),
        Positioned(top: h * 0.18, child: Container(width: w * 0.35, height: h * 0.3, decoration: BoxDecoration(color: bodyColor, borderRadius: BorderRadius.circular(20)))),
        Positioned(top: h * 0.2, left: w * 0.22, child: _limb(w * 0.1, h * 0.3, bodyColor, -0.1)),
        Positioned(top: h * 0.2, right: w * 0.22, child: _limb(w * 0.1, h * 0.3, bodyColor, 0.1)),
        Positioned(top: h * 0.52, left: w * 0.35, child: _limb(w * 0.12, h * 0.4, bodyColor, 0)),
        Positioned(top: h * 0.52, right: w * 0.35, child: _limb(w * 0.12, h * 0.4, bodyColor, 0)),
      ],
    );
  }

  Widget _limb(double w, double h, Color color, double rotate) {
    return Transform.rotate(angle: rotate, child: Container(width: w, height: h, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(15))));
  }

  Widget _buildBottomActionPanel() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ✅ Requirement 2: Responsive row for areas selected
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("${selectedParts.length} ", style: const TextStyle(fontWeight: FontWeight.bold)),
              const TrText("Areas Selected", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: selectedParts.isEmpty ? null : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SymptomsScreen(selectedParts: selectedParts)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00796B),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const TrText("Continue", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}