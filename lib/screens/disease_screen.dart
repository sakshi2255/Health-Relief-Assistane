import 'package:flutter/material.dart';
import 'package:flutter_projectt/screens/pain_level_screen.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../widgets/tr_text.dart';

class Disease {
  final String id;
  final String label;
  final String icon;
  final String description;

  Disease({required this.id, required this.label, required this.icon, required this.description});
}

class DiseaseScreen extends StatefulWidget {
  final Set<String> selectedParts;
  final Set<String> selectedSymptoms;

  const DiseaseScreen({
    super.key,
    required this.selectedParts,
    required this.selectedSymptoms,
  });

  @override
  State<DiseaseScreen> createState() => _DiseaseScreenState();
}

class _DiseaseScreenState extends State<DiseaseScreen> {
  final List<Disease> allDiseases = [
    Disease(id: "pcod", label: "PCOD/PCOS", icon: "🩺", description: "Hormonal imbalance affecting reproductive health."),
    Disease(id: "arthritis", label: "Arthritis", icon: "🦴", description: "Inflammation and stiffness in the joints."),
    Disease(id: "obesity", label: "Obesity", icon: "⚖️", description: "Excessive body weight affecting joint pressure."),
    Disease(id: "posture", label: "Posture Issues", icon: "🧍", description: "Alignment problems causing muscle strain."),
    Disease(id: "diabetes", label: "Diabetes", icon: "💉", description: "High blood sugar levels affecting nerve health."),
    Disease(id: "sciatica", label: "Sciatica", icon: "⚡", description: "Pain radiating along the sciatic nerve path."),
    Disease(id: "spondylitis", label: "Spondylitis", icon: "🔩", description: "Inflammation of the spinal vertebrae."),
    Disease(id: "migraine", label: "Migraine", icon: "🤕", description: "Severe recurring headaches with sensitivity."),
    Disease(id: "hypertension", label: "Hypertension", icon: "❤️‍🩹", description: "High blood pressure impacting circulation."),
    Disease(id: "thyroid", label: "Thyroid", icon: "🦋", description: "Glandular issues affecting metabolism/energy."),
    Disease(id: "fibromyalgia", label: "Fibromyalgia", icon: "😰", description: "Widespread musculoskeletal pain and fatigue."),
    Disease(id: "none", label: "None / Not Sure", icon: "✅", description: "No chronic conditions to report."),
  ];

  List<Disease> filteredDiseases = [];
  final Set<String> selectedIds = {};
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredDiseases = allDiseases;
  }

  void _filterDiseases(String query) {
    setState(() {
      filteredDiseases = allDiseases
          .where((d) => d.label.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _toggleDisease(String id) {
    setState(() {
      if (id == "none") {
        selectedIds.clear();
        selectedIds.add("none");
      } else {
        selectedIds.remove("none");
        if (selectedIds.contains(id)) {
          selectedIds.remove(id);
        } else {
          selectedIds.add(id);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Requirement 1: Responsive width detection
    double screenWidth = MediaQuery.of(context).size.width;
    bool isWide = screenWidth > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(
        // ✅ Requirement 2: Wrapped AppBar Text in TrText
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TrText("Health Conditions", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TrText("Select any known conditions", style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: isWide ? 40 : 20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // --- Search Bar ---
            TextField(
              controller: _searchController,
              onChanged: _filterDiseases,
              decoration: InputDecoration(
                // Note: Standard hintText doesn't support widgets, but we ensure the label is clear
                hintText: "Search conditions...",
                prefixIcon: const Icon(LucideIcons.search, size: 18),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
            const SizedBox(height: 20),

            // --- List of Conditions ---
            Expanded(
              child: ListView.builder(
                itemCount: filteredDiseases.length,
                itemBuilder: (context, index) {
                  final disease = filteredDiseases[index];
                  final isSelected = selectedIds.contains(disease.id);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: InkWell(
                      onTap: () => _toggleDisease(disease.id),
                      borderRadius: BorderRadius.circular(12),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF00796B) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(disease.icon, style: const TextStyle(fontSize: 22)),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // ✅ Requirement 2: Translated Label
                                  TrText(
                                    disease.label,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  // ✅ Requirement 2: Translated Description
                                  TrText(
                                    disease.description,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isSelected ? Colors.white70 : Colors.grey.shade600,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              const Icon(Icons.check_circle, color: Colors.white, size: 20),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // --- Action Button ---
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: selectedIds.isEmpty ? null : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PainLevelScreen(
                            selectedParts: widget.selectedParts,
                            selectedSymptoms: widget.selectedSymptoms,
                            selectedConditions: selectedIds,
                          )
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00796B),
                    disabledBackgroundColor: Colors.grey.shade200,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  // ✅ Requirement 2: Translated Button Text
                  child: const TrText(
                    "Continue",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}