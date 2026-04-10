import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../widgets/tr_text.dart'; // ✅ Added for translations

class VideoDemoScreen extends StatelessWidget {
  const VideoDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Requirement 1: Responsive width detection
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(
        // ✅ Requirement 2: Translated AppBar
        title: const TrText(
          "Exercise Demo",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: screenWidth > 600 ? 40 : 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Video Player Placeholder (Responsive AspectRatio)
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Text("🧘‍♀️", style: TextStyle(fontSize: 60)),

                    // YouTube Style Badge
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          children: [
                            Icon(LucideIcons.play, color: Colors.white, size: 10),
                            SizedBox(width: 4),
                            Text(
                              "YouTube",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Controls Overlay
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.8),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(LucideIcons.skipBack, color: Colors.white70),
                            SizedBox(width: 30),
                            Icon(LucideIcons.play, color: Colors.white, size: 40),
                            SizedBox(width: 30),
                            Icon(LucideIcons.skipForward, color: Colors.white70),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 2. Video Info
            // ✅ Requirement 2: Translated Video Title & Description
            const TrText(
              "Gentle Neck Stretch",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const TrText(
              "Learn the proper technique for relieving neck tension safely.",
              style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.5),
            ),

            const SizedBox(height: 32),

            // 3. More Videos Section
            const TrText(
              "More Exercise Demos",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),

            _moreVideoItem("Cat-Cow Pose Demo", "8:15", "🐱"),
            _moreVideoItem("Shoulder Roll Technique", "3:45", "💪"),
            _moreVideoItem("Forward Bend Guide", "6:20", "🙆"),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Helper widget for the playlist items
  Widget _moreVideoItem(String title, String dur, String thumb) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(thumb, style: const TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ Requirement 2: Translated Playlist Title
                TrText(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  dur,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(LucideIcons.playCircle, size: 24, color: Color(0xFF00796B)),
        ],
      ),
    );
  }
}