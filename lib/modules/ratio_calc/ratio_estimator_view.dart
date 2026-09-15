import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/brew_theme.dart';
import '../stage_timer/brew_controller.dart';

class RatioEstimatorView extends StatefulWidget {
  const RatioEstimatorView({super.key});

  @override
  State<RatioEstimatorView> createState() => _RatioEstimatorViewState();
}

class _RatioEstimatorViewState extends State<RatioEstimatorView> {
  bool _isIcedDrip = false;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BrewController>();
    final dose = controller.coffeeDose;
    final ratio = controller.waterRatio;
    final totalWater = controller.totalWater;
    final bloomWater = controller.bloomWater;

    // Coffee retains ~2g of water per 1g of ground coffee
    final estimatedLiquidYield = (totalWater - (dose * 2.0)).clamp(0.0, totalWater);

    // If iced: 60% hot pour, 40% ice in server
    final hotPourWater = _isIcedDrip ? (totalWater * 0.6).roundToDouble() : totalWater;
    final iceCubeGrams = _isIcedDrip ? (totalWater * 0.4).roundToDouble() : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.scale_rounded, color: BrewColors.roastAmber),
            SizedBox(width: 8),
            Text('Coffee Ratio Estimator'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dose card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: BrewColors.cardSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: BrewColors.borderMuted),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Coffee Ground Dose',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: BrewColors.espresso,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: BrewColors.warmParchment,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${dose.toStringAsFixed(1)} g',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: BrewColors.espresso,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Slider(
                    value: dose,
                    min: 10.0,
                    max: 40.0,
                    divisions: 60,
                    activeColor: BrewColors.roastAmber,
                    onChanged: (val) => controller.setDose(val),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('10g (Single cup)', style: TextStyle(fontSize: 11, color: BrewColors.textMuted)),
                      Text('18g (Standard)', style: TextStyle(fontSize: 11, color: BrewColors.roastAmber)),
                      Text('40g (Carafe)', style: TextStyle(fontSize: 11, color: BrewColors.textMuted)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Ratio preset pills
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: BrewColors.cardSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: BrewColors.borderMuted),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Brew Strength Ratio',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: BrewColors.espresso,
                        ),
                      ),
                      Text(
                        '1:${ratio.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: BrewColors.roastAmber,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildRatioChip(controller, 14.0, '1:14 Bold'),
                      _buildRatioChip(controller, 15.0, '1:15 Rich'),
                      _buildRatioChip(controller, 16.0, '1:16 Golden Cup'),
                      _buildRatioChip(controller, 17.0, '1:17 Delicate'),
                      _buildRatioChip(controller, 18.0, '1:18 Tea-Like'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Japanese Iced Flash Brew Split',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    subtitle: const Text(
                      '60% hot water extraction over 40% clean ice cubes',
                      style: TextStyle(fontSize: 12, color: BrewColors.textMuted),
                    ),
                    value: _isIcedDrip,
                    activeThumbColor: BrewColors.sageAccent,
                    onChanged: (val) => setState(() => _isIcedDrip = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Computed Recipe Breakdown
            const Text(
              'BREW RECIPE SPECIFICATION',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: BrewColors.textMuted,
              ),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    title: _isIcedDrip ? 'HOT POUR' : 'TOTAL WATER',
                    value: '${hotPourWater.toInt()} g',
                    subtitle: _isIcedDrip ? '+ ${iceCubeGrams.toInt()}g ice' : 'at 93°C / 200°F',
                    color: BrewColors.roastAmber,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    title: 'BLOOM WATER',
                    value: '${bloomWater.toInt()} g',
                    subtitle: '3x coffee bed dose',
                    color: BrewColors.sageAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: BrewColors.warmParchment,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: BrewColors.borderMuted),
              ),
              child: Row(
                children: [
                  const Icon(Icons.coffee_rounded, color: BrewColors.espresso, size: 28),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Estimated Cup Yield',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: BrewColors.espresso),
                        ),
                        Text(
                          'Yields ~${estimatedLiquidYield.toInt()} ml (~${(estimatedLiquidYield / 240).toStringAsFixed(1)} cups) of clean aromatic pourover.',
                          style: const TextStyle(fontSize: 12, color: BrewColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildRatioChip(BrewController controller, double r, String label) {
    final isSelected = controller.waterRatio == r;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: BrewColors.roastAmber,
      backgroundColor: BrewColors.warmParchment,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : BrewColors.textDark,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 12,
      ),
      side: BorderSide(
        color: isSelected ? BrewColors.roastAmber : BrewColors.borderMuted,
      ),
      onSelected: (_) => controller.setRatio(r),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BrewColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BrewColors.borderMuted),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: BrewColors.espresso,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 11, color: BrewColors.textMuted),
          ),
        ],
      ),
    );
  }
}
