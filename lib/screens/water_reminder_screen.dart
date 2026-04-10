import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/tr_text.dart'; // ✅ Added for translations

class WaterReminderScreen extends StatefulWidget {
  const WaterReminderScreen({super.key});

  @override
  State<WaterReminderScreen> createState() => _WaterReminderScreenState();
}

class _WaterReminderScreenState extends State<WaterReminderScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final int goal = 8;
  int glasses = 0;

  @override
  void initState() {
    super.initState();
    _listenToWaterIntake();
  }

  void _listenToWaterIntake() {
    if (user == null) return;

    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);

    FirebaseFirestore.instance
        .collection('water_logs')
        .where('userId', isEqualTo: user!.uid)
        .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .snapshots()
        .listen((snapshot) {
      if (mounted) {
        setState(() => glasses = snapshot.docs.length);
      }
    });
  }

  Future<void> _addWater() async {
    if (user == null) return;
    await FirebaseFirestore.instance.collection('water_logs').add({
      'userId': user!.uid,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _removeWater() async {
    if (user == null || glasses <= 0) return;

    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);

    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('water_logs')
          .where('userId', isEqualTo: user!.uid)
          .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .get();

      if (snapshot.docs.isNotEmpty) {
        final lastDoc = snapshot.docs.last;
        await lastDoc.reference.delete();
      }
    } catch (e) {
      debugPrint("Error removing water: $e");
      var fallbackSnapshot = await FirebaseFirestore.instance
          .collection('water_logs')
          .where('userId', isEqualTo: user!.uid)
          .limit(1)
          .get();

      if (fallbackSnapshot.docs.isNotEmpty) {
        await fallbackSnapshot.docs.first.reference.delete();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Requirement 1: Responsive dimension detection
    double screenWidth = MediaQuery.of(context).size.width;
    double circleSize = screenWidth * 0.55; // Circle is 55% of screen width

    double percentage = (glasses / goal).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // ✅ Requirement 2: Translated Header
        title: const TrText("Water Tracker", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Progress Circle (Responsive Scaling)
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                      width: circleSize,
                      height: circleSize,
                      child: CircularProgressIndicator(value: 1.0, strokeWidth: 10, color: Colors.blue.shade50)
                  ),
                  SizedBox(
                      width: circleSize,
                      height: circleSize,
                      child: CircularProgressIndicator(
                          value: percentage,
                          strokeWidth: 10,
                          strokeCap: StrokeCap.round,
                          color: Colors.blue.shade400
                      )
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(LucideIcons.droplets, color: Colors.blue, size: 32),
                      Text("$glasses", style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                      // ✅ Requirement 2: Translated Subtext
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const TrText("of", style: TextStyle(color: Colors.grey, fontSize: 12)),
                          Text(" $goal ", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          const TrText("glasses", style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Add/Remove Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _actionButton(LucideIcons.minus, Colors.grey.shade100, Colors.black87, _removeWater),
                const SizedBox(width: 40),
                _actionButton(LucideIcons.plus, Colors.blue.shade400, Colors.white, _addWater),
              ],
            ),

            const SizedBox(height: 40),

            // Grid View (Responsive Columns)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: screenWidth > 600 ? 6 : 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12
              ),
              itemCount: goal,
              itemBuilder: (context, index) {
                bool filled = index < glasses;
                return Container(
                  decoration: BoxDecoration(
                      color: filled ? Colors.blue.shade50 : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16)
                  ),
                  child: Icon(
                    LucideIcons.droplets,
                    color: filled ? Colors.blue.shade400 : Colors.grey.shade300,
                    size: 20,
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(IconData icon, Color bg, Color iconCol, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
          width: 65,
          height: 65,
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
          child: Icon(icon, color: iconCol, size: 24)
      ),
    );
  }
}