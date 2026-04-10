import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../models/exercise_model.dart';
import '../screens/timer_screen.dart';
import '../widgets/tr_text.dart';
import '../services/translation_controller.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final ExerciseModel exercise;

  const ExerciseDetailScreen({super.key, required this.exercise});

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  bool isFavorite = false;
  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    // ✅ Initialize with safe checks
    _controller = YoutubePlayerController(
      initialVideoId: widget.exercise.youtubeId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        enableCaption: false,
        useHybridComposition: true, // Better for Android responsiveness
      ),
    )..addListener(() {
      if (mounted && _controller.value.isReady && !_isPlayerReady) {
        setState(() => _isPlayerReady = true);
      }
    });
  }

  @override
  void deactivate() {
    _controller.pause(); // Pause video if navigating away
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String lang = TranslationController.currentLang;
    String displayTitle = widget.exercise.titles[lang] ??
        widget.exercise.titles['en'] ?? "Exercise Detail";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: TrText(displayTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () => setState(() => isFavorite = !isFavorite),
            icon: Icon(LucideIcons.heart, color: isFavorite ? Colors.redAccent : Colors.grey.shade400),
          )
        ],
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // 1. YouTube Player with Fallback
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: widget.exercise.youtubeId.isNotEmpty
                    ? YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: const Color(0xFF00796B),
                  onReady: () => debugPrint("Player Ready"),
                  bottomActions: [
                    CurrentPosition(),
                    ProgressBar(isExpanded: true),
                    PlaybackSpeedButton(),
                  ],
                )
                    : _buildVideoPlaceholder(),
              ),

              const SizedBox(height: 24),

              // 2. Info Cards (Sets/Reps/Hold)
              Row(
                children: [
                  _infoCard(LucideIcons.clock, widget.exercise.holdTime, "Hold", Colors.blue),
                  const SizedBox(width: 10),
                  _infoCard(LucideIcons.activity, widget.exercise.sets, "Sets", Colors.orange),
                  const SizedBox(width: 10),
                  _infoCard(LucideIcons.repeat, widget.exercise.reps, "Reps", const Color(0xFF00796B)),
                ],
              ),
              const SizedBox(height: 32),

              // 3. Instructions & Benefit
              _buildSectionHeader("How to Perform"),
              const SizedBox(height: 12),
              TrText(
                widget.exercise.descriptions[lang] ?? widget.exercise.descriptions['en'] ?? "",
                style: TextStyle(color: Colors.grey.shade700, height: 1.5, fontSize: 14),
              ),

              const SizedBox(height: 24),
              _buildSectionHeader("Clinical Benefit"),
              const SizedBox(height: 12),
              TrText(
                widget.exercise.clinicalBenefit,
                style: TextStyle(color: Colors.blueGrey.shade700, height: 1.5, fontSize: 14),
              ),

              const SizedBox(height: 32),

              // 4. Caution Banner
              _buildCautionBanner(),

              const SizedBox(height: 100), // Extra space for floating button
            ],
          ),
        );
      }),

      // ✅ Start Timer Button (Floating at bottom)
      bottomSheet: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: () {
            // Check for valid context before pushing
            if (Navigator.canPop(context) || true) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TimerScreen(exercise: widget.exercise)),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00796B),
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(LucideIcons.play, color: Colors.white, size: 18),
              const SizedBox(width: 12),
              TrText("Start Exercise Timer", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return TrText(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16));
  }

  Widget _buildVideoPlaceholder() {
    return Container(
      height: 200,
      width: double.infinity,
      color: Colors.grey.shade100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.videoOff, size: 40, color: Colors.grey.shade300),
          const SizedBox(height: 8),
          TrText("Video unavailable", style: TextStyle(color: Colors.grey.shade500)),
        ],
      ),
    );
  }

  Widget _buildCautionBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(LucideIcons.alertTriangle, size: 18, color: Colors.amber.shade800),
          const SizedBox(width: 12),
          Expanded(
            child: TrText(
              widget.exercise.caution.isNotEmpty ? widget.exercise.caution : "Move within a pain-free range.",
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(IconData icon, String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 8),
            Text(value.isEmpty ? "-" : value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 2),
            TrText(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}