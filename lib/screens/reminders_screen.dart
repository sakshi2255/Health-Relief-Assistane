import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/notification_service.dart';
import '../widgets/tr_text.dart'; // ✅ Added for translations

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  final user = FirebaseAuth.instance.currentUser;

  Future<void> _addReminder() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      // The time picker itself handles system localization automatically
    );

    if (picked != null && user != null) {
      String formattedTime = picked.format(context);

      // 1. Save to Firebase
      final doc = await FirebaseFirestore.instance.collection('reminders').add({
        'userId': user!.uid,
        'time': formattedTime,
        'enabled': true,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // 2. Schedule Global Notification
      await NotificationService.scheduleNotification(doc.id.hashCode, formattedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Requirement 1: Responsive width detection
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(
        // ✅ Requirement 2: Translated AppBar
        title: const TrText("Daily Reminders", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(onPressed: _addReminder, icon: const Icon(LucideIcons.plus)),
          const SizedBox(width: 10),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('reminders')
            .where('userId', isEqualTo: user?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: Color(0xFF00796B)));

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.bellOff, size: 48, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  const TrText("No reminders set", style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: screenWidth > 600 ? 40 : 20, vertical: 20),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              bool isEnabled = data['enabled'] ?? true;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
                ),
                child: Row(
                  children: [
                    const Icon(LucideIcons.bell, color: Colors.orange, size: 20),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ✅ Requirement 2: Translated Label
                          const TrText("Workout Session", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          Text(data['time'], style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                    // Use a smaller Switch and padding for responsiveness
                    Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: isEnabled,
                        activeColor: const Color(0xFF00796B),
                        onChanged: (val) {
                          docs[index].reference.update({'enabled': val});
                          if (val) {
                            NotificationService.scheduleNotification(docs[index].id.hashCode, data['time']);
                          } else {
                            NotificationService.cancel(docs[index].id.hashCode);
                          }
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(LucideIcons.trash2, color: Colors.redAccent, size: 18),
                      onPressed: () {
                        NotificationService.cancel(docs[index].id.hashCode);
                        docs[index].reference.delete();
                      },
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}