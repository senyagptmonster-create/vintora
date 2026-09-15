import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'common/brew_theme.dart';
import 'modules/beans/beans_log_view.dart';
import 'modules/grind/grind_guide_view.dart';
import 'modules/ratio_calc/ratio_estimator_view.dart';
import 'modules/stage_timer/brew_controller.dart';
import 'modules/stage_timer/pourover_timer_view.dart';

class VintoraBrewApp extends StatelessWidget {
  const VintoraBrewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BrewController>(
      create: (_) => BrewController(),
      child: MaterialApp(
        title: 'Vintora Artisan Brew Lab',
        debugShowCheckedModeBanner: false,
        theme: BrewTheme.themeData(),
        home: const _VintoraHomeShell(),
      ),
    );
  }
}

class _VintoraHomeShell extends StatefulWidget {
  const _VintoraHomeShell();

  @override
  State<_VintoraHomeShell> createState() => _VintoraHomeShellState();
}

class _VintoraHomeShellState extends State<_VintoraHomeShell> {
  int _currentIndex = 0;

  final List<Widget> _views = const [
    RatioEstimatorView(),
    PouroverTimerView(),
    BeansLogView(),
    GrindGuideView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _views,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.scale_outlined),
            selectedIcon: Icon(Icons.scale_rounded),
            label: 'Ratio',
          ),
          NavigationDestination(
            icon: Icon(Icons.timer_outlined),
            selectedIcon: Icon(Icons.timer_rounded),
            label: 'Timer',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2_rounded),
            label: 'Beans',
          ),
          NavigationDestination(
            icon: Icon(Icons.grain_outlined),
            selectedIcon: Icon(Icons.grain_rounded),
            label: 'Grind Guide',
          ),
        ],
      ),
    );
  }
}
