import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_projectt/screens/body_select_screen.dart';
import 'package:flutter_projectt/screens/profile_screen.dart';
import 'package:flutter_projectt/screens/emergency_screen.dart';
import 'package:flutter_projectt/screens/nearby_screen.dart';
import 'package:flutter_projectt/screens/water_reminder_screen.dart';
import 'package:flutter_projectt/screens/reminders_screen.dart';
import '../widgets/tr_text.dart';
import '../services/upload_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "Loading...";
  String initials = "";

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          userName = userDoc['name'] ?? "User";
          initials = _getInitials(userName);
        });
      } else {
        setState(() {
          userName = "User";
          initials = "U";
        });
      }
    }
  }

  String _getInitials(String name) {
    List<String> nameParts = name.trim().split(' ');
    if (nameParts.isEmpty) return "U";
    if (nameParts.length == 1) return nameParts[0][0].toUpperCase();
    return "${nameParts[0][0]}${nameParts[1][0]}".toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Requirement 1: Get screen width for dynamic padding
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallScreen = screenWidth < 360;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),

            // 1. Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ✅ Requirement 2: Translated Greeting
                        const TrText("Good Morning", style: TextStyle(fontSize: 22)),
                        Text(userName,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen())),
                    borderRadius: BorderRadius.circular(22),
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: const Color(0xFF4DB6AC),
                      child: Text(initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🚨 THE TEMPORARY UPLOAD BUTTON


            // 2. Hero Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF4DB6AC), Color(0xFF00796B)]),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(LucideIcons.flame, color: Colors.white70, size: 16),
                        const SizedBox(width: 8),
                        TrText("Today's Goal", style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const TrText("Start Pain Relief", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    const TrText("Select your pain area and get personalized exercises", style: TextStyle(color: Colors.white70, fontSize: 13)),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BodySelectScreen())),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const TrText("Get Started →", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 3. Quick Actions
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TrText("Quick Actions", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),

            // ✅ Requirement 1: Responsive Grid for Quick Actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _quickActionItem(LucideIcons.target, "Find\nExercises", const Color(0xFFE0F2F1), const Color(0xFF4DB6AC), () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const BodySelectScreen()));
                  }),
                  _quickActionItem(LucideIcons.droplets, "Water\nReminder", const Color(0xFFE3F2FD), Colors.blue, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const WaterReminderScreen()));
                  }),
                  _quickActionItem(LucideIcons.bell, "Daily\nReminder", const Color(0xFFFFF3E0), Colors.orange, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const RemindersScreen()));
                  }),
                  _quickActionItem(LucideIcons.phone, "Emergency\nContact", const Color(0xFFFFEBEE), Colors.red, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const EmergencyScreen()));
                  }),
                ],
              ),
            ),


            const SizedBox(height: 24),

            // 5. Nearby Medical Help Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NearbyScreen())),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: const Color(0xFFF3E5F5), borderRadius: BorderRadius.circular(12)),
                        child: const Icon(LucideIcons.mapPin, color: Colors.purple, size: 20),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TrText("Nearby Medical Help", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            TrText("Hospitals, Clinics & Stores", style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                      const Icon(LucideIcons.chevronRight, color: Colors.grey, size: 20),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 6. Suggested Workouts
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const TrText("Suggested Workouts", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  TextButton(onPressed: () {}, child: const TrText("See All", style: TextStyle(color: Color(0xFF4DB6AC)))),
                ],
              ),
            ),

            _workoutCard("Neck Pain Relief", "15 min", "8 exercises", const Color(0xFF4DB6AC), "Beginner"),
            _workoutCard("Lower Back Stretch", "20 min", "12 exercises", const Color(0xFF00796B), "Intermediate"),
            _workoutCard("Knee Mobility", "10 min", "6 exercises", Colors.orange, "Beginner"),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _statCard(IconData icon, String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8)],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            // ✅ Requirement 2: Translated Stat Label
            TrText(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _quickActionItem(IconData icon, String label, Color bgColor, Color iconColor, VoidCallback onTap) {
    return Expanded( // Added Expanded to ensure equal distribution
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20)),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(height: 8),
            // ✅ Requirement 2: Translated Quick Action Label
            TrText(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, height: 1.2)),
          ],
        ),
      ),
    );
  }

  Widget _workoutCard(String title, String time, String exCount, Color color, String level) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
            child: const Icon(LucideIcons.activity, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TrText(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    const Text(" · ", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    TrText(exCount, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: const Color(0xFFE0F2F1), borderRadius: BorderRadius.circular(8)),
            child: TrText(level, style: const TextStyle(color: Color(0xFF00796B), fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}