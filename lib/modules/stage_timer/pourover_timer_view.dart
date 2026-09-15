import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/brew_theme.dart';
import 'brew_controller.dart';

class PouroverTimerView extends StatelessWidget {
  const PouroverTimerView({super.key});

  String _formatSeconds(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BrewController>();
    final stages = controller.stages;
    final currentStage = controller.currentStage;
    final remainingStageSec =
        (currentStage.durationSeconds - controller.stageSecondsElapsed).clamp(0, currentStage.durationSeconds);
    final stageProgress = controller.stageSecondsElapsed / currentStage.durationSeconds;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.timer_outlined, color: BrewColors.roastAmber),
            SizedBox(width: 8),
            Text('Pourover Stage Timer'),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => controller.resetBrew(),
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Reset Timer',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          children: [
            // Overall Timer bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: BrewColors.warmParchment,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: BrewColors.borderMuted),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.hourglass_top_rounded, size: 18, color: BrewColors.roastAmber),
                  const SizedBox(width: 8),
                  Text(
                    'TOTAL TIME: ${_formatSeconds(controller.totalBrewSeconds)}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                      color: BrewColors.espresso,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Big Circular Dial with Progress
            Center(
              child: SizedBox(
                width: 230,
                height: 230,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 220,
                      height: 220,
                      child: CircularProgressIndicator(
                        value: stageProgress.clamp(0.0, 1.0),
                        strokeWidth: 10,
                        backgroundColor: BrewColors.warmParchment,
                        color: BrewColors.roastAmber,
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          currentStage.name.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            color: BrewColors.roastAmber,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${remainingStageSec}s',
                          style: const TextStyle(
                            fontSize: 54,
                            fontWeight: FontWeight.w900,
                            color: BrewColors.espresso,
                            letterSpacing: -2,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: BrewColors.warmParchment,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Target: ${currentStage.targetWater.toInt()}g',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: BrewColors.espresso,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Stage instruction card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: BrewColors.cardSurface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: BrewColors.borderMuted),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: BrewColors.roastAmber, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      currentStage.instruction,
                      style: const TextStyle(fontSize: 13, color: BrewColors.textDark, height: 1.3),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Controls
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 54,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: controller.isBrewing ? Colors.orange[800] : BrewColors.roastAmber,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 2,
                      ),
                      onPressed: () {
                        if (controller.isBrewing) {
                          controller.pauseBrew();
                        } else {
                          controller.startBrew();
                        }
                      },
                      icon: Icon(controller.isBrewing ? Icons.pause_rounded : Icons.play_arrow_rounded, size: 28),
                      label: Text(
                        controller.isBrewing ? 'PAUSE BREW' : 'START BREW',
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, letterSpacing: 1),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton.filledTonal(
                  style: IconButton.styleFrom(
                    backgroundColor: BrewColors.warmParchment,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    fixedSize: const Size(54, 54),
                  ),
                  onPressed: () => controller.nextStage(),
                  icon: const Icon(Icons.skip_next_rounded, color: BrewColors.espresso),
                  tooltip: 'Next Stage',
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Stages timeline progression
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'BREW STAGES SEQUENCE',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: BrewColors.textMuted),
              ),
            ),
            const SizedBox(height: 10),

            ...List.generate(stages.length, (idx) {
              final s = stages[idx];
              final isCurrent = controller.currentStageIndex == idx;
              final isDone = controller.currentStageIndex > idx;

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isCurrent
                      ? BrewColors.roastAmber.withValues(alpha: 0.1)
                      : BrewColors.cardSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isCurrent ? BrewColors.roastAmber : BrewColors.borderMuted,
                    width: isCurrent ? 1.5 : 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isDone
                          ? Icons.check_circle_rounded
                          : isCurrent
                              ? Icons.radio_button_checked_rounded
                              : Icons.radio_button_off_rounded,
                      color: isDone
                          ? BrewColors.sageAccent
                          : isCurrent
                              ? BrewColors.roastAmber
                              : BrewColors.borderMuted,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        s.name,
                        style: TextStyle(
                          fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                          color: isCurrent ? BrewColors.espresso : BrewColors.textDark,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Text(
                      '${s.targetWater.toInt()}g • ${s.durationSeconds}s',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: BrewColors.textMuted,
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
