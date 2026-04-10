import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_projectt/screens/login_screen.dart';
import 'package:flutter_projectt/screens/favorites_screen.dart';
import 'package:flutter_projectt/screens/reminders_screen.dart';
import 'package:flutter_projectt/screens/emergency_screen.dart';
import 'package:flutter_projectt/screens/history_screen.dart';
import '../services/auth_service.dart';
import '../services/translation_controller.dart';
import '../widgets/tr_text.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = "Loading...";
  String userEmail = "Loading...";
  String initials = "";
  int todayWater = 0;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _listenToWaterIntake();
  }

  Future<void> _fetchUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      if (mounted) setState(() => userEmail = currentUser.email ?? "No Email");
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
      if (mounted) {
        setState(() {
          userName = userDoc.exists ? (userDoc['name'] ?? "User") : (currentUser.displayName ?? "User");
          initials = _getInitials(userName);
        });
      }
    }
  }

  void _listenToWaterIntake() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);

    FirebaseFirestore.instance
        .collection('water_logs')
        .where('userId', isEqualTo: user.uid)
        .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .snapshots()
        .listen((snapshot) {
      if (mounted) setState(() => todayWater = snapshot.docs.length);
    });
  }

  Future<void> _addWaterGlass() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await FirebaseFirestore.instance.collection('water_logs').add({
      'userId': user.uid,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  String _getInitials(String name) {
    List<String> parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return "U";
    return parts.length == 1 ? parts[0][0].toUpperCase() : "${parts[0][0]}${parts[1][0]}".toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Requirement 1: Responsive Layout with constraints
    return LayoutBuilder(builder: (context, constraints) {
      double screenWidth = constraints.maxWidth;
      bool isWide = screenWidth > 600;

      return Scaffold(
        backgroundColor: const Color(0xFFF8FAF9),
        appBar: AppBar(
          // ✅ Requirement 2: Translated AppBar
          title: TrText("My Profile", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: isWide ? 40 : 20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Profile Header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15)],
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: const Color(0xFF00796B),
                      child: Text(initials, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 12),
                    Text(userName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(userEmail, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                    const SizedBox(height: 24),
                    // ✅ Requirement 1: Responsive Row for stats
                    Row(
                      children: [
                        _buildStat("28", "Exercises"),
                        const SizedBox(width: 10),
                        _buildStat("12", "Days Active"),
                        const SizedBox(width: 10),
                        _buildStat("3", "Favorites"),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ✅ Requirement 4: Language Toggle Section
              _buildLanguageSection(screenWidth),

              const SizedBox(height: 24),

              // 💧 DYNAMIC WATER TRACKER CARD
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.blue.shade400, Colors.blue.shade600]),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    const Icon(LucideIcons.droplet, color: Colors.white, size: 30),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TrText("Daily Hydration", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                          Row(
                            children: [
                              Text("$todayWater ", style: const TextStyle(color: Colors.white, fontSize: 12)),
                              TrText("glasses reached", style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: _addWaterGlass,
                      icon: const Icon(LucideIcons.plusCircle, color: Colors.white, size: 28),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Menu Items
              _menuItem(LucideIcons.scrollText, "Exercise History", Colors.teal, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryScreen()))),
              _menuItem(LucideIcons.bookmark, "Favorite Exercises", Colors.orange, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoritesScreen()))),
              _menuItem(LucideIcons.alarmClock, "Workout Reminders", Colors.blue, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RemindersScreen()))),
              _menuItem(LucideIcons.phoneCall, "Emergency Contacts", Colors.redAccent, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EmergencyScreen()))),

              const SizedBox(height: 32),

              // Sign Out
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () async {
                    await _authService.signOut();
                    if (context.mounted) Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (r) => false);
                  },
                  icon: const Icon(LucideIcons.logOut, size: 18),
                  label: TrText("Sign Out", style: const TextStyle(fontWeight: FontWeight.bold)),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red.shade50,
                    foregroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildLanguageSection(double screenWidth) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TrText("App Language", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.blueGrey)),
          const SizedBox(height: 12),
          // ✅ Requirement 1: Using Wrap for language chips to handle narrow screens
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.start,
            children: [
              _langChip("English", "en"),
              _langChip("हिन्दी", "hi"),
              _langChip("ગુજરાતી", "gu"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _langChip(String label, String code) {
    bool isSelected = TranslationController.currentLang == code;
    return ChoiceChip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      selected: isSelected,
      onSelected: (val) async {
        if (val) {
          await TranslationController.updateLanguage(code);
          setState(() {});
        }
      },
      selectedColor: const Color(0xFF00796B),
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
    );
  }

  Widget _buildStat(String value, String label) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          // ✅ Requirement 2: Translated Stat Label
          TrText(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
        ],
      ),
    ),
  );

  Widget _menuItem(IconData icon, String label, Color color, VoidCallback onTap) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
    child: ListTile(
      onTap: onTap,
      leading: Icon(icon, color: color, size: 20),
      // ✅ Requirement 2: Translated Menu Label
      title: TrText(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      trailing: const Icon(LucideIcons.chevronRight, size: 16, color: Colors.grey),
    ),
  );
}