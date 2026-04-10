import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/exercise_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/tr_text.dart'; // ✅ Added
import '../services/translation_controller.dart'; // ✅ Added

class TimerScreen extends StatefulWidget {
  final ExerciseModel exercise;

  const TimerScreen({super.key, required this.exercise});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int _totalSets = 1;
  int _currentSet = 1;
  int _exerciseSeconds = 30;
  int _restSeconds = 30;

  int _totalSeconds = 30;
  int _remainingSeconds = 30;
  bool _isRunning = false;
  bool _isResting = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _parseExerciseData();
  }

  void _parseExerciseData() {
    _totalSets = int.tryParse(widget.exercise.sets.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1;
    if (_totalSets == 0) _totalSets = 1;

    int parsedHold = 0;
    final holdMatch = RegExp(r'\d+').firstMatch(widget.exercise.holdTime);
    if (holdMatch != null) {
      parsedHold = int.parse(holdMatch.group(0)!);
    }

    int parsedReps = 10;
    final repMatch = RegExp(r'\d+').firstMatch(widget.exercise.reps);
    if (repMatch != null) {
      parsedReps = int.parse(repMatch.group(0)!);
    }

    if (parsedHold >= 15) {
      _exerciseSeconds = parsedHold;
    } else if (parsedHold > 0) {
      _exerciseSeconds = parsedReps * (parsedHold + 2);
    } else {
      _exerciseSeconds = parsedReps * 3;
    }

    if (_exerciseSeconds < 15) _exerciseSeconds = 15;

    _totalSeconds = _exerciseSeconds;
    _remainingSeconds = _exerciseSeconds;
  }

  void _startTimer() {
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        _handleTimerComplete();
      }
    });
  }

  void _handleTimerComplete() {
    _stopTimer();
    if (!_isResting) {
      if (_currentSet < _totalSets) {
        setState(() {
          _isResting = true;
          _totalSeconds = _restSeconds;
          _remainingSeconds = _restSeconds;
        });
        _startTimer();
      } else {
        _showCompletionDialog();
      }
    } else {
      setState(() {
        _isResting = false;
        _currentSet++;
        _totalSeconds = _exerciseSeconds;
        _remainingSeconds = _exerciseSeconds;
      });
    }
  }

  void _skipToNext() => _handleTimerComplete();
  void _stopTimer() { _timer?.cancel(); setState(() => _isRunning = false); }
  void _resetTimer() { _stopTimer(); setState(() => _remainingSeconds = _totalSeconds); }

  String _formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: [
            const Icon(LucideIcons.checkCircle, color: Color(0xFF00796B), size: 50),
            const SizedBox(height: 16),
            // ✅ Requirement 2: Translated Dialog Title
            TrText("Workout Complete!", textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: const TrText("Great job! You've completed all sets for this exercise.", textAlign: TextAlign.center),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00796B),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                try {
                  int sessionMinutes = ((_exerciseSeconds * _totalSets) / 60).ceil();
                  await FirebaseFirestore.instance.collection('activity_logs').add({
                    'userId': user.uid,
                    'exerciseName': widget.exercise.titles['en'] ?? "Exercise",
                    'timestamp': FieldValue.serverTimestamp(),
                    'durationMinutes': sessionMinutes,
                    'setsCompleted': _totalSets,
                  });
                } catch (e) {
                  debugPrint("Error logging activity: $e");
                }
              }
              if (context.mounted) {
                Navigator.pop(context);
                Navigator.pop(context);
              }
            },
            child: const TrText("Done", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  @override
  void dispose() { _timer?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    double progress = (_totalSeconds - _remainingSeconds) / _totalSeconds;
    // ✅ Requirement 1: Responsive Scaling
    double screenWidth = MediaQuery.of(context).size.width;
    double timerSize = screenWidth * 0.6; // Circular timer is 60% of screen width

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: TrText(widget.exercise.titles[TranslationController.currentLang] ?? "Timer",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _isResting ? Colors.blue.shade50 : const Color(0xFFE0F2F1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_isResting) const TrText("Resting...", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold))
                  else ...[
                    const TrText("Set", style: TextStyle(color: Color(0xFF00796B), fontWeight: FontWeight.bold)),
                    Text(" $_currentSet ", style: const TextStyle(color: Color(0xFF00796B), fontWeight: FontWeight.bold)),
                    const TrText("of", style: TextStyle(color: Color(0xFF00796B), fontWeight: FontWeight.bold)),
                    Text(" $_totalSets", style: const TextStyle(color: Color(0xFF00796B), fontWeight: FontWeight.bold)),
                  ]
                ],
              ),
            ),
            const SizedBox(height: 40),

            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: timerSize,
                    height: timerSize,
                    child: CircularProgressIndicator(
                      value: 1.0,
                      strokeWidth: 12,
                      color: Colors.grey.shade100,
                    ),
                  ),
                  SizedBox(
                    width: timerSize,
                    height: timerSize,
                    child: CircularProgressIndicator(
                      value: 1 - progress,
                      strokeWidth: 12,
                      strokeCap: StrokeCap.round,
                      color: _isResting ? Colors.blue : const Color(0xFF00796B),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(_remainingSeconds),
                        style: TextStyle(fontSize: screenWidth * 0.15, fontWeight: FontWeight.bold, letterSpacing: -2),
                      ),
                      // ✅ Requirement 2: Translated Status
                      TrText(
                        _isRunning ? "In Progress" : (_remainingSeconds == _totalSeconds ? "Ready" : "Paused"),
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 50),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _controlButton(LucideIcons.rotateCcw, _resetTimer),
                const SizedBox(width: 30),
                GestureDetector(
                  onTap: () => _isRunning ? _stopTimer() : _startTimer(),
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                          colors: _isResting
                              ? [Colors.blue, Colors.lightBlueAccent]
                              : [const Color(0xFF00796B), const Color(0xFF4DB6AC)]
                      ),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, 10))],
                    ),
                    child: Icon(
                      _isRunning ? LucideIcons.pause : LucideIcons.play,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                _controlButton(LucideIcons.skipForward, _skipToNext),
              ],
            ),

            const Spacer(),

            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(bottom: 40),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _targetInfo(LucideIcons.repeat, "Target Reps", widget.exercise.reps),
                  Container(width: 1, height: 40, color: Colors.grey.shade300),
                  _targetInfo(LucideIcons.activity, "Target Sets", widget.exercise.sets),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _controlButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(20)),
        child: Icon(icon, color: Colors.black87, size: 20),
      ),
    );
  }

  Widget _targetInfo(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey.shade400, size: 20),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        TrText(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
      ],
    );
  }
}