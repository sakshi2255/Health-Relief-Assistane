import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/tr_text.dart'; // ✅ Added

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  void _makeCall(String number) async {
    final Uri url = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      debugPrint("Could not launch $number");
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Requirement 1: Responsive Width Detection
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TrText("Emergency", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            TrText("Quick access to help", style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: screenWidth > 600 ? 40 : 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. SOS Button
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => _makeCall("108"),
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red.shade600,
                        boxShadow: [
                          BoxShadow(color: Colors.red.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))
                        ],
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(LucideIcons.phone, color: Colors.white, size: 32),
                          SizedBox(height: 4),
                          Text("SOS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TrText("Tap to call emergency services (108)", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // 2. Emergency Numbers
            TrText("Emergency Numbers", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 12),
            _buildEmergencyContact("Ambulance (108)", "108", LucideIcons.heartPulse, Colors.red.shade600),
            _buildEmergencyContact("Police (100)", "100", LucideIcons.shield, const Color(0xFF1E88E5)),

            const SizedBox(height: 32),

            // 3. Personal Contacts
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TrText("Personal Contacts", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                GestureDetector(
                  onTap: () => _showAddContactDialog(context),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: const Color(0xFF00796B), borderRadius: BorderRadius.circular(8)),
                    child: const Icon(LucideIcons.plus, color: Colors.white, size: 16),
                  ),
                )
              ],
            ),
            const SizedBox(height: 12),

            _buildDynamicPersonalContacts(),

            const SizedBox(height: 32),

            // 4. Warning Box
            _buildWarningBox(),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicPersonalContacts() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const TrText("Login to see contacts");

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('emergency_contacts')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const LinearProgressIndicator();

        final docs = snapshot.data!.docs;
        if (docs.isEmpty) {
          return TrText("No personal contacts added yet.", style: const TextStyle(color: Colors.grey, fontSize: 12));
        }

        return Column(
          children: docs.map((doc) {
            String name = doc['name'];
            String phone = doc['phone'];
            String role = doc['role'] ?? "Contact";
            String initials = name.isNotEmpty ? name[0].toUpperCase() : "?";

            return _buildPersonalContact(name, role, phone, initials);
          }).toList(),
        );
      },
    );
  }

  void _showAddContactDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final roleCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        // ✅ Requirement 2: Translated Dialog Text
        title: TrText("New Emergency Contact"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(hintText: "Full Name")),
            TextField(controller: roleCtrl, decoration: const InputDecoration(hintText: "Role (e.g. Mom, Doctor)")),
            TextField(controller: phoneCtrl, decoration: const InputDecoration(hintText: "Phone Number"), keyboardType: TextInputType.phone),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const TrText("Cancel")),
          ElevatedButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              if (user != null && nameCtrl.text.isNotEmpty) {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .collection('emergency_contacts')
                    .add({
                  'name': nameCtrl.text,
                  'phone': phoneCtrl.text,
                  'role': roleCtrl.text,
                });
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const TrText("Save"),
          )
        ],
      ),
    );
  }

  Widget _buildEmergencyContact(String title, String num, IconData icon, Color color) {
    return GestureDetector(
      onTap: () => _makeCall(num),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TrText(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(num, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            const Icon(LucideIcons.phone, color: Color(0xFF00796B), size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalContact(String name, String role, String num, String initials) {
    return GestureDetector(
      onTap: () => _makeCall(num),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey.shade100,
              child: Text(initials, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Note: User-added names shouldn't usually be translated,
                  // but role labels like 'Mom' can be.
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Row(
                    children: [
                      TrText(role, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                      Text(" · $num", style: const TextStyle(color: Colors.grey, fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(LucideIcons.phone, color: Color(0xFF00796B), size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildWarningBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.alertTriangle, size: 16, color: Colors.amber),
              const SizedBox(width: 8),
              TrText("Important", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          TrText(
            "If you're experiencing a medical emergency, call 108 immediately. This app is not a substitute for professional medical care.",
            style: TextStyle(fontSize: 11, color: Colors.grey.shade700, height: 1.5),
          ),
        ],
      ),
    );
  }
}