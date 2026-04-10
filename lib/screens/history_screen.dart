import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/tr_text.dart'; // ✅ Added
import '../services/translation_controller.dart'; // ✅ Added

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    // ✅ Requirement 1: Responsive width detection
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(
        // ✅ Requirement 2: Translated AppBar
        title: TrText("Exercise History",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('activity_logs')
            .where('userId', isEqualTo: user?.uid)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF00796B)));
          }

          final logs = snapshot.data?.docs ?? [];

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: screenWidth > 600 ? 40 : 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Insights Section ---
                TrText("Insights", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),

                _buildChartCard(
                  title: "Active Minutes",
                  subtitle: "Last 7 Days",
                  child: _buildActivityLineChart(),
                ),

                const SizedBox(height: 20),

                _buildChartCard(
                  title: "Hydration Tracker",
                  subtitle: "Daily Intake (Glasses)",
                  child: _buildHydrationBarChart(),
                ),

                const SizedBox(height: 32),

                // --- Completed Exercises Section ---
                TrText("Completed Exercises", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),

                if (logs.isEmpty)
                  _buildEmptyState()
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: logs.length,
                    itemBuilder: (context, index) {
                      final data = logs[index].data() as Map<String, dynamic>;
                      final Timestamp? ts = data['timestamp'] as Timestamp?;

                      // Formatting date with localized separator
                      final String dateLabel = ts != null
                          ? "${ts.toDate().day}/${ts.toDate().month} • ${ts.toDate().hour}:${ts.toDate().minute.toString().padLeft(2, '0')}"
                          : "Just now";

                      return _buildHistoryItem(
                        data['exerciseName'] ?? "Unknown Exercise",
                        dateLabel,
                        "${data['durationMinutes'] ?? 0}",
                      );
                    },
                  ),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Icon(LucideIcons.history, color: Colors.grey.shade300, size: 60),
          const SizedBox(height: 16),
          TrText(
            "No workouts recorded yet.\nFinish your first exercise to see it here!",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(String name, String date, String durationValue) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2F1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(LucideIcons.checkCircle, color: Color(0xFF00796B), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Exercise names are usually from database, but TrText handles them if translations exist
                TrText(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(date, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
              ],
            ),
          ),
          // ✅ Requirement 1 & 2: Responsive Translated Duration
          Row(
            children: [
              Text(durationValue, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Color(0xFF00796B))),
              const SizedBox(width: 2),
              TrText("min", style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Color(0xFF00796B))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard({required String title, required String subtitle, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ✅ Requirement 2: Translated Chart Titles
              Expanded(child: TrText(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
              TrText(subtitle, style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 24),
          // Set responsive height for charts
          SizedBox(height: 150, child: child),
        ],
      ),
    );
  }

  // --- Chart Logic ---

  Widget _buildActivityLineChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const style = TextStyle(color: Colors.grey, fontSize: 10);
                // Note: Days are usually static, but can be translated if needed
                switch (value.toInt()) {
                  case 0: return const Padding(padding: EdgeInsets.only(top: 8), child: Text('M', style: style));
                  case 2: return const Padding(padding: EdgeInsets.only(top: 8), child: Text('W', style: style));
                  case 4: return const Padding(padding: EdgeInsets.only(top: 8), child: Text('F', style: style));
                  case 6: return const Padding(padding: EdgeInsets.only(top: 8), child: Text('S', style: style));
                }
                return const Text('');
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: const [FlSpot(0, 15), FlSpot(1, 20), FlSpot(2, 10), FlSpot(3, 30), FlSpot(4, 25), FlSpot(5, 35), FlSpot(6, 20)],
            isCurved: true,
            color: const Color(0xFF00796B),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: true, color: const Color(0xFF00796B).withOpacity(0.1)),
          ),
        ],
      ),
    );
  }

  Widget _buildHydrationBarChart() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('water_logs')
          .where('userId', isEqualTo: user?.uid)
          .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 7))))
          .snapshots(),
      builder: (context, snapshot) {
        Map<int, double> waterByDay = {0: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0};

        if (snapshot.hasData) {
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          for (var doc in snapshot.data!.docs) {
            final Timestamp? ts = doc['timestamp'] as Timestamp?;
            if (ts != null) {
              final difference = today.difference(DateTime(ts.toDate().year, ts.toDate().month, ts.toDate().day)).inDays;
              int dayIndex = 6 - difference;
              if (dayIndex >= 0 && dayIndex <= 6) waterByDay[dayIndex] = (waterByDay[dayIndex] ?? 0) + 1;
            }
          }
        }

        return BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 12,
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final days = ['6d', '5d', '4d', '3d', '2d', '1d', 'T'];
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        days[value.toInt()],
                        style: const TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                    );
                  },
                ),
              ),
            ),
            barGroups: waterByDay.entries.map((e) {
              return BarChartGroupData(
                x: e.key,
                barRods: [
                  BarChartRodData(
                    toY: e.value,
                    color: Colors.blue.shade400,
                    width: 14,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: 8,
                      color: Colors.blue.shade50,
                    ),
                  )
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }
}