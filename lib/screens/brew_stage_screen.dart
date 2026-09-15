import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/vintora_theme.dart';
import '../painters/pour_over_drip_painter.dart';

class BrewStageScreen extends StatefulWidget {
  final String methodName;
  final int defaultCoffeeGrams;
  final int ratio;

  const BrewStageScreen({
    super.key,
    required this.methodName,
    required this.defaultCoffeeGrams,
    required this.ratio,
  });

  @override
  State<BrewStageScreen> createState() => _BrewStageScreenState();
}

class _BrewStageScreenState extends State<BrewStageScreen> {
  late int _coffeeGrams;
  late int _waterTotal;
  int _secondsLeft = 180;
  final int _totalSeconds = 180;
  bool _isRunning = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _coffeeGrams = widget.defaultCoffeeGrams;
    _waterTotal = _coffeeGrams * widget.ratio;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggleTimer() {
    setState(() {
      _isRunning = !_isRunning;
      if (_isRunning) {
        _timer = Timer.periodic(const Duration(seconds: 1), (t) {
          if (_secondsLeft > 0) {
            setState(() => _secondsLeft--);
          } else {
            t.cancel();
            setState(() => _isRunning = false);
          }
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _secondsLeft = _totalSeconds;
    });
  }

  String get _currentStageName {
    final elapsed = _totalSeconds - _secondsLeft;
    if (elapsed < 45) return 'Bloom Phase (60ml)';
    if (elapsed < 90) return 'First Pour (up to 160ml)';
    if (elapsed < 140) return 'Second Pour (Target ${_waterTotal}ml)';
    return 'Drawdown & Extraction Complete';
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_totalSeconds - _secondsLeft) / _totalSeconds;
    final mins = _secondsLeft ~/ 60;
    final secs = _secondsLeft % 60;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.methodName, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Visual Pour-over Dripper
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: VintoraTheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: VintoraTheme.edge),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      width: 220,
                      height: 180,
                      child: CustomPaint(
                        painter: PourOverDripPainter(
                          extractionProgress: progress,
                          isExtracting: _isRunning,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _currentStageName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: VintoraTheme.accent,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Big Countdown Display
              Text(
                '$mins:${secs.toString().padLeft(2, '0')}',
                style: const TextStyle(
                  fontSize: 54,
                  fontWeight: FontWeight.bold,
                  color: VintoraTheme.ink,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Ratio 1:${widget.ratio} • ${_coffeeGrams}g Dose -> ${_waterTotal}ml Yield',
                style: const TextStyle(color: VintoraTheme.muted, fontSize: 13),
              ),
              const SizedBox(height: 24),
              // Start / Pause / Reset Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isRunning ? Colors.amber.shade800 : VintoraTheme.accent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _toggleTimer,
                      icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                      label: Text(
                        _isRunning ? 'PAUSE EXTRACTION' : 'START STAGE BREW',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton.filledTonal(
                    onPressed: _resetTimer,
                    icon: const Icon(Icons.refresh),
                    style: IconButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      backgroundColor: VintoraTheme.surface,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
