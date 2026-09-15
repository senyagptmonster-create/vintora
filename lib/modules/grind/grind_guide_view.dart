import 'package:flutter/material.dart';
import '../../common/brew_theme.dart';

class GrindGuideView extends StatefulWidget {
  const GrindGuideView({super.key});

  @override
  State<GrindGuideView> createState() => _GrindGuideViewState();
}

class _GrindGuideViewState extends State<GrindGuideView> {
  int _selectedMethodIndex = 2; // Default V60

  final List<Map<String, dynamic>> _methods = [
    {
      'name': 'Espresso',
      'icon': Icons.coffee_rounded,
      'microns': '200 – 400 µm',
      'texture': 'Fine table flour / powdered sugar',
      'flowRate': '25 – 30 seconds for 1:2 yield',
      'c40': '8 – 14 clicks',
      'c2': '9 – 12 clicks',
      'ode': '1 – 2 (with SSP burrs)',
      'notes': 'High pressure extraction creates crema emulsion.',
    },
    {
      'name': 'Aeropress',
      'icon': Icons.compress_rounded,
      'microns': '400 – 700 µm',
      'texture': 'Fine table salt',
      'flowRate': '1:30 – 2:00 min brew time',
      'c40': '14 – 18 clicks',
      'c2': '13 – 16 clicks',
      'ode': '2 – 4',
      'notes': 'Versatile for inverted and standard short extractions.',
    },
    {
      'name': 'V60 & Kalita',
      'icon': Icons.filter_alt_rounded,
      'microns': '500 – 800 µm',
      'texture': 'Medium-fine sea sand',
      'flowRate': '2:45 – 3:30 min total drawdown',
      'c40': '20 – 26 clicks',
      'c2': '18 – 23 clicks',
      'ode': '4 – 6',
      'notes': 'Delivers high clarity, vibrant acidity, and floral notes.',
    },
    {
      'name': 'Chemex',
      'icon': Icons.science_outlined,
      'microns': '700 – 1000 µm',
      'texture': 'Kosher salt / coarse sand',
      'flowRate': '3:45 – 4:30 min total drawdown',
      'c40': '26 – 32 clicks',
      'c2': '22 – 27 clicks',
      'ode': '6 – 8',
      'notes': 'Thick bonded paper filters require coarser grinds to prevent stalling.',
    },
    {
      'name': 'French Press',
      'icon': Icons.coffee_maker_outlined,
      'microns': '1000 – 1400 µm',
      'texture': 'Coarse sea salt crystals',
      'flowRate': '4:00 – 5:00 min full immersion',
      'c40': '32 – 38 clicks',
      'c2': '27 – 32 clicks',
      'ode': '8 – 10',
      'notes': 'Full immersion with metal mesh filter leaves rich body and oils.',
    },
    {
      'name': 'Cold Brew',
      'icon': Icons.ac_unit_rounded,
      'microns': '1200 – 1600 µm',
      'texture': 'Cracked peppercorns / breadcrumbs',
      'flowRate': '12 – 18 hours steep time',
      'c40': '38 – 45 clicks',
      'c2': '32+ clicks',
      'ode': '10 – 11',
      'notes': 'Slow ambient extraction prevents over-extracting bitterness.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final current = _methods[_selectedMethodIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.grain_rounded, color: BrewColors.roastAmber),
            SizedBox(width: 8),
            Text('Micron Grind Guide'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Method Selector Pills
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_methods.length, (idx) {
                  final isSelected = _selectedMethodIndex == idx;
                  final item = _methods[idx];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      avatar: Icon(item['icon'] as IconData, size: 16, color: isSelected ? Colors.white : BrewColors.espresso),
                      label: Text(item['name'] as String),
                      selected: isSelected,
                      selectedColor: BrewColors.roastAmber,
                      backgroundColor: BrewColors.warmParchment,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : BrewColors.textDark,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      ),
                      side: BorderSide(
                        color: isSelected ? BrewColors.roastAmber : BrewColors.borderMuted,
                      ),
                      onSelected: (_) => setState(() => _selectedMethodIndex = idx),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),

            // Active Method Detail Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: BrewColors.cardSurface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: BrewColors.roastAmber.withValues(alpha: 0.5)),
                boxShadow: [
                  BoxShadow(
                    color: BrewColors.roastAmber.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: BrewColors.warmParchment,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(current['icon'] as IconData, color: BrewColors.roastAmber, size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              current['name'] as String,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: BrewColors.espresso,
                              ),
                            ),
                            Text(
                              current['microns'] as String,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                color: BrewColors.roastAmber,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: BrewColors.borderMuted),
                  const SizedBox(height: 12),

                  _buildDetailRow('Tactile Texture', current['texture'] as String),
                  const SizedBox(height: 8),
                  _buildDetailRow('Target Flow Rate', current['flowRate'] as String),
                  const SizedBox(height: 8),
                  _buildDetailRow('Barista Advice', current['notes'] as String),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Grinder Click Settings
            const Text(
              'GRINDER CLICK CALIBRATION',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: BrewColors.textMuted),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: _buildGrinderCard('Comandante C40', current['c40'] as String, Icons.dialpad_rounded),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildGrinderCard('Timemore C2/C3', current['c2'] as String, Icons.tune_rounded),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildGrinderCard('Fellow Ode Gen2', current['ode'] as String, Icons.speed_rounded),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Sensory Extraction Diagnostic Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: BrewColors.warmParchment,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: BrewColors.borderMuted),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Row(
                    children: [
                      Icon(Icons.balance_rounded, color: BrewColors.roastAmber),
                      SizedBox(width: 8),
                      Text(
                        'Sensory Dialing Diagnostics',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: BrewColors.espresso),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    '• Sour, hollow, thin taste or quick flow? Your coffee is under-extracted. Grind 2 clicks finer.\n'
                    '• Bitter, astringent, dry mouthfeel or water pool stalling? Your coffee is over-extracted. Grind 2 clicks coarser.\n'
                    '• Sweet, juicy, aromatic and pleasant lingering finish? Your grind size is locked in!',
                    style: TextStyle(fontSize: 12, height: 1.5, color: BrewColors.textDark),
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

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: BrewColors.textMuted, letterSpacing: 1),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 13, color: BrewColors.textDark, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildGrinderCard(String name, String clicks, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: BrewColors.cardSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: BrewColors.borderMuted),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: BrewColors.roastAmber),
          const SizedBox(height: 6),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: BrewColors.espresso),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            clicks,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, color: BrewColors.roastAmber, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
