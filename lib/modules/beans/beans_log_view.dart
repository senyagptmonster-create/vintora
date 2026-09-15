import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/brew_theme.dart';
import '../stage_timer/brew_controller.dart';

class BeansLogView extends StatefulWidget {
  const BeansLogView({super.key});

  @override
  State<BeansLogView> createState() => _BeansLogViewState();
}

class _BeansLogViewState extends State<BeansLogView> {
  String _selectedRoastFilter = 'All';
  final List<String> _roastFilters = ['All', 'Light', 'Medium-Light', 'Medium', 'Dark'];

  void _showAddBeanDialog(BuildContext context) {
    final controller = context.read<BrewController>();
    final nameController = TextEditingController();
    final originController = TextEditingController();
    final notesController = TextEditingController(text: 'Floral, Citrus, Caramel');
    String selectedRoast = 'Light';
    String selectedProcess = 'Washed';
    double rating = 4.5;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: BrewColors.cardSurface,
          title: const Text('Log Specialty Beans', style: TextStyle(color: BrewColors.espresso)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Coffee Name / Roastery',
                    hintText: 'e.g. Kenya Nyeri Hill',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: originController,
                  decoration: const InputDecoration(
                    labelText: 'Origin & Altitude',
                    hintText: 'e.g. Kenya (1900m)',
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: selectedRoast,
                  decoration: const InputDecoration(labelText: 'Roast Level'),
                  items: const [
                    DropdownMenuItem(value: 'Light', child: Text('Light Roast (Cinnamon/Nordic)')),
                    DropdownMenuItem(value: 'Medium-Light', child: Text('Medium-Light (City+)')),
                    DropdownMenuItem(value: 'Medium', child: Text('Medium Roast (Full City)')),
                    DropdownMenuItem(value: 'Dark', child: Text('Dark Roast (French/Vienna)')),
                  ],
                  onChanged: (val) {
                    if (val != null) setDialogState(() => selectedRoast = val);
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: selectedProcess,
                  decoration: const InputDecoration(labelText: 'Processing Method'),
                  items: const [
                    DropdownMenuItem(value: 'Washed', child: Text('Washed / Wet Processed')),
                    DropdownMenuItem(value: 'Natural', child: Text('Natural / Dry Processed')),
                    DropdownMenuItem(value: 'Honey', child: Text('Honey / Pulped Natural')),
                    DropdownMenuItem(value: 'Anaerobic', child: Text('Anaerobic Fermentation')),
                  ],
                  onChanged: (val) {
                    if (val != null) setDialogState(() => selectedProcess = val);
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(
                    labelText: 'Tasting Notes (comma separated)',
                    hintText: 'e.g. Bergamot, Jasmine, Apricot',
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Rating: ${rating.toStringAsFixed(1)} ★', style: const TextStyle(fontWeight: FontWeight.bold)),
                    Expanded(
                      child: Slider(
                        value: rating,
                        min: 3.0,
                        max: 5.0,
                        divisions: 20,
                        activeColor: BrewColors.roastAmber,
                        onChanged: (v) => setDialogState(() => rating = v),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: BrewColors.roastAmber,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (nameController.text.trim().isEmpty) return;
                final rawNotes = notesController.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();

                final bean = BeanEntry(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text.trim(),
                  origin: originController.text.trim().isEmpty ? 'Single Origin' : originController.text.trim(),
                  roastLevel: selectedRoast,
                  process: selectedProcess,
                  notes: rawNotes.isEmpty ? ['Clean Cup'] : rawNotes,
                  rating: rating,
                );

                controller.addBean(bean);
                Navigator.pop(ctx);
              },
              child: const Text('Save to Cellar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BrewController>();
    final allBeans = controller.beans;
    final filteredBeans = _selectedRoastFilter == 'All'
        ? allBeans
        : allBeans.where((b) => b.roastLevel == _selectedRoastFilter).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.inventory_2_outlined, color: BrewColors.roastAmber),
            SizedBox(width: 8),
            Text('Bean Cellar & Tasting'),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => _showAddBeanDialog(context),
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Add Bean',
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: _roastFilters.map((filter) {
                final isSelected = _selectedRoastFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: isSelected,
                    selectedColor: BrewColors.roastAmber,
                    backgroundColor: BrewColors.warmParchment,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : BrewColors.textDark,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    side: BorderSide(
                      color: isSelected ? BrewColors.roastAmber : BrewColors.borderMuted,
                    ),
                    onSelected: (_) => setState(() => _selectedRoastFilter = filter),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 6),

          // Bean List
          Expanded(
            child: filteredBeans.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.coffee_maker_outlined, size: 60, color: BrewColors.textMuted),
                        const SizedBox(height: 12),
                        const Text(
                          'No beans logged in this category',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: BrewColors.textMuted),
                        ),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: () => _showAddBeanDialog(context),
                          icon: const Icon(Icons.add, color: BrewColors.roastAmber),
                          label: const Text('Add your first bean record', style: TextStyle(color: BrewColors.roastAmber)),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: filteredBeans.length,
                    itemBuilder: (context, index) {
                      final bean = filteredBeans[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: BrewColors.cardSurface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: BrewColors.borderMuted),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        bean.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: BrewColors.espresso,
                                        ),
                                      ),
                                      Text(
                                        bean.origin,
                                        style: const TextStyle(fontSize: 12, color: BrewColors.textMuted),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: BrewColors.warmParchment,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.star_rounded, size: 16, color: BrewColors.roastAmber),
                                      const SizedBox(width: 4),
                                      Text(
                                        bean.rating.toStringAsFixed(1),
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline_rounded, size: 20, color: Colors.grey),
                                  onPressed: () => controller.deleteBean(bean.id),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            // Badges: Roast + Process
                            Row(
                              children: [
                                _buildBadge(bean.roastLevel, BrewColors.roastAmber),
                                const SizedBox(width: 6),
                                _buildBadge(bean.process, BrewColors.sageAccent),
                              ],
                            ),
                            const SizedBox(height: 10),

                            // Tasting Notes
                            Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: bean.notes.map((note) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: BrewColors.warmParchment,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: BrewColors.borderMuted),
                                  ),
                                  child: Text(
                                    '# $note',
                                    style: const TextStyle(fontSize: 11, color: BrewColors.textDark),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}
