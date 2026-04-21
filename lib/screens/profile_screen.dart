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
  bool isGoogleUser = false; // Added to check if we should show 'Change Password'
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
      if (mounted) {
        setState(() {
          userEmail = currentUser.email ?? "No Email";
          isGoogleUser = currentUser.providerData.any((p) => p.providerId == 'google.com');
        });
      }
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

  // ==========================================
  // NEW FEATURE DIALOGS
  // ==========================================

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(LucideIcons.info, color: Color(0xFF00796B)),
            SizedBox(width: 10),
            TrText("About"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Added College Logo
            Center(
              child: Image.asset(
                'assets/mu-logo.png',
                height: 70,
                errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
              ),
            ),
            const SizedBox(height: 16),
            const TrText("Health Relief Assistant", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            const TrText("Developer:", style: TextStyle(color: Colors.grey, fontSize: 12)),
            const Text("Sakshi Parikh", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            const SizedBox(height: 4),
            // ✅ Added Developer Description
            const TrText(
              "Computer Engineering undergraduate and full-stack developer passionate about building scalable, aesthetic, and impactful applications.",
              style: TextStyle(fontSize: 12, color: Colors.blueGrey),
            ),
            const SizedBox(height: 12),
            const TrText("Project Guide:", style: TextStyle(color: Colors.grey, fontSize: 12)),
            const Text("Prof. Jigar Dave", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const TrText("Close", style: TextStyle(color: Color(0xFF00796B))),
          )
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    final currentPasswordCtrl = TextEditingController();
    final newPasswordCtrl = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const TrText("Change Password"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: currentPasswordCtrl,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Current Password",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: newPasswordCtrl,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "New Password",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const TrText("Cancel", style: TextStyle(color: Colors.grey)),
                ),
                isLoading
                    ? const Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator())
                    : ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00796B), foregroundColor: Colors.white),
                  onPressed: () async {
                    if (currentPasswordCtrl.text.isEmpty || newPasswordCtrl.text.isEmpty) return;
                    setState(() => isLoading = true);

                    // Call the AuthService
                    String? res = await _authService.changePassword(
                        currentPassword: currentPasswordCtrl.text,
                        newPassword: newPasswordCtrl.text
                    );

                    setState(() => isLoading = false);

                    if (res == "success") {
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: TrText("Password updated successfully!", style: TextStyle(color: Colors.white))));
                      }
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res ?? "Error", style: const TextStyle(color: Colors.white)), backgroundColor: Colors.red));
                      }
                    }
                  },
                  child: const TrText("Update"),
                )
              ],
            );
          }
      ),
    );
  }
  void _showDeleteAccountDialog() {
    final passwordCtrl = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Row(
                children: [
                  Icon(LucideIcons.alertTriangle, color: Colors.red),
                  SizedBox(width: 8),
                  TrText("Delete Account", style: TextStyle(color: Colors.red)),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TrText("This action is permanent and cannot be undone. All your data will be erased."),
                  const SizedBox(height: 16),
                  if (!isGoogleUser) ...[
                    const TrText("Please enter your password to confirm:", style: TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: passwordCtrl,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ]
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const TrText("Cancel", style: TextStyle(color: Colors.grey)),
                ),
                isLoading
                    ? const Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator(color: Colors.red))
                    : ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                  onPressed: () async {
                    if (!isGoogleUser && passwordCtrl.text.isEmpty) return;
                    setState(() => isLoading = true);

                    String? res = await _authService.deleteAccount(password: passwordCtrl.text);

                    setState(() => isLoading = false);
                    if (res == "success") {
                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (r) => false);
                      }
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res ?? "Error", style: const TextStyle(color: Colors.white)), backgroundColor: Colors.red));
                      }
                    }
                  },
                  child: const TrText("Delete Permanently"),
                )
              ],
            );
          }
      ),
    );
  }

  // ==========================================
  // BUILD METHOD
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double screenWidth = constraints.maxWidth;
      bool isWide = screenWidth > 600;

      return Scaffold(
        backgroundColor: const Color(0xFFF8FAF9),
        appBar: AppBar(
          title: const TrText("My Profile", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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

              // Language Toggle Section
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
                          const TrText("Daily Hydration", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                          Row(
                            children: [
                              Text("$todayWater ", style: const TextStyle(color: Colors.white, fontSize: 12)),
                              TrText("glasses reached", style: TextStyle(color: Colors.white, fontSize: 12)),
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



              _menuItem(LucideIcons.info, "About", const Color(0xFF00796B), _showAboutDialog),

              // Only show change password if they registered with Email/Password
              if (!isGoogleUser)
                _menuItem(LucideIcons.lock, "Change Password", Colors.blueGrey, _showChangePasswordDialog),

              _menuItem(LucideIcons.userX, "Delete Account", Colors.red, _showDeleteAccountDialog),

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
                  label: const TrText("Sign Out", style: TextStyle(fontWeight: FontWeight.bold)),
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
          const TrText("App Language", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.blueGrey)),
          const SizedBox(height: 12),
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
      title: TrText(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      trailing: const Icon(LucideIcons.chevronRight, size: 16, color: Colors.grey),
    ),
  );
}