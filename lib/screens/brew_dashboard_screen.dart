import 'package:flutter/material.dart';
import '../theme/vintora_theme.dart';
import 'brew_stage_screen.dart';

class BrewDashboardScreen extends StatefulWidget {
  const BrewDashboardScreen({super.key});

  @override
  State<BrewDashboardScreen> createState() => _BrewDashboardScreenState();
}

class _BrewDashboardScreenState extends State<BrewDashboardScreen> {
  int _doseGrams = 18;
  int _ratio = 16;

  final List<Map<String, dynamic>> _methods = const [
    {
      'name': 'Hario V60 Dripper',
      'icon': Icons.coffee_outlined,
      'desc': 'Clean, bright cup with floral notes',
      'grind': 'Medium-Fine',
      'temp': '93°C',
    },
    {
      'name': 'Chemex Classic',
      'icon': Icons.local_cafe_outlined,
      'desc': 'Triple-filtered velvety clarity',
      'grind': 'Medium-Coarse',
      'temp': '94°C',
    },
    {
      'name': 'Aeropress Inverted',
      'icon': Icons.hourglass_empty_rounded,
      'desc': 'Rich body with espresso-like sweetness',
      'grind': 'Fine',
      'temp': '88°C',
    },
    {
      'name': 'French Press Immersion',
      'icon': Icons.emoji_food_beverage_outlined,
      'desc': 'Heavy mouthfeel with bold cocoa oils',
      'grind': 'Coarse',
      'temp': '95°C',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final waterTotal = _doseGrams * _ratio;

    return Scaffold(
      appBar: AppBar(
        title: const Text('VINTORA SPECIALTY BREW',
            style: TextStyle(letterSpacing: 1.2, fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Brew Ratio Calculator Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: VintoraTheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: VintoraTheme.edge),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Ratio Calculator',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: VintoraTheme.ink),
                      ),
                      Text(
                        '1:$_ratio Ratio',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: VintoraTheme.accent),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Coffee Dose: ${_doseGrams}g'),
                      Text('Water Yield: ${waterTotal}ml',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: VintoraTheme.accent)),
                    ],
                  ),
                  Slider(
                    value: _doseGrams.toDouble(),
                    min: 12,
                    max: 40,
                    activeColor: VintoraTheme.accent,
                    inactiveColor: VintoraTheme.edge,
                    onChanged: (v) => setState(() => _doseGrams = v.round()),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [15, 16, 17].map((r) {
                      final isSel = _ratio == r;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: ChoiceChip(
                          label: Text('1:$r'),
                          selected: isSel,
                          selectedColor: VintoraTheme.accentLight.withValues(alpha: 0.3),
                          onSelected: (_) => setState(() => _ratio = r),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Select Extraction Method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: VintoraTheme.ink),
            ),
            const SizedBox(height: 12),
            // Methods List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _methods.length,
              separatorBuilder: (_, index) => const SizedBox(height: 12),
              itemBuilder: (context, idx) {
                final method = _methods[idx];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BrewStageScreen(
                          methodName: method['name'] as String,
                          defaultCoffeeGrams: _doseGrams,
                          ratio: _ratio,
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: VintoraTheme.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: VintoraTheme.edge),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: VintoraTheme.accent.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(method['icon'] as IconData, color: VintoraTheme.accent, size: 28),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                method['name'] as String,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                method['desc'] as String,
                                style: const TextStyle(color: VintoraTheme.muted, fontSize: 13),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Grind: ${method['grind']} • Temp: ${method['temp']}',
                                style: const TextStyle(
                                  color: VintoraTheme.accentLight,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 16, color: VintoraTheme.accent),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
