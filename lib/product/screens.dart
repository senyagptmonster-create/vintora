import 'package:flutter/material.dart';
import '../app/brand.dart';
import '../app/theme.dart';

class VintoraDashboardScreen extends StatelessWidget {
  const VintoraDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Vintora Hub', style: AppTheme.display(cInk))),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        children: [
          _buildCard(context, 'Ratio Estimator', const RatioEstimatorScreen()),
          _buildCard(context, 'Pour Timer', const PourTimerScreen()),
          _buildCard(context, 'Beans Log', const BeansLogScreen()),
          _buildCard(context, 'Grind Guide', const GrindGuideScreen()),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, Widget screen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
      },
      child: Card(
        color: cSurface,
        child: Center(child: Text(title, style: AppTheme.text(cInk))),
      ),
    );
  }
}

class RatioEstimatorScreen extends StatelessWidget {
  const RatioEstimatorScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ratio', style: AppTheme.display(cInk))),
      body: Center(child: Text('Ratio Estimator', style: AppTheme.text(cInk))),
    );
  }
}

class PourTimerScreen extends StatelessWidget {
  const PourTimerScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Timer', style: AppTheme.display(cInk))),
      body: Center(child: Text('Pour-over Timer', style: AppTheme.text(cInk))),
    );
  }
}

class BeansLogScreen extends StatelessWidget {
  const BeansLogScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Beans', style: AppTheme.display(cInk))),
      body: Center(child: Text('Beans Log', style: AppTheme.text(cInk))),
    );
  }
}

class GrindGuideScreen extends StatelessWidget {
  const GrindGuideScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Grind', style: AppTheme.display(cInk))),
      body: Center(child: Text('Grind Size Guide', style: AppTheme.text(cInk))),
    );
  }
}
