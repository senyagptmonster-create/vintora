import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BeanEntry {
  final String id;
  final String name;
  final String origin;
  final String roastLevel; // Light, Medium-Light, Medium, Dark
  final String process; // Washed, Natural, Honey, Anaerobic
  final List<String> notes;
  final double rating;

  BeanEntry({
    required this.id,
    required this.name,
    required this.origin,
    required this.roastLevel,
    required this.process,
    required this.notes,
    required this.rating,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'origin': origin,
        'roastLevel': roastLevel,
        'process': process,
        'notes': notes,
        'rating': rating,
      };

  factory BeanEntry.fromJson(Map<String, dynamic> json) => BeanEntry(
        id: json['id'] as String,
        name: json['name'] as String,
        origin: json['origin'] as String,
        roastLevel: json['roastLevel'] as String,
        process: json['process'] as String,
        notes: List<String>.from(json['notes'] as List),
        rating: (json['rating'] as num).toDouble(),
      );
}

class BrewStageInfo {
  final String name;
  final int durationSeconds;
  final double targetWater;
  final String instruction;

  BrewStageInfo({
    required this.name,
    required this.durationSeconds,
    required this.targetWater,
    required this.instruction,
  });
}

class BrewController extends ChangeNotifier {
  static const String _keyBeans = 'vintora_coffee_beans';
  static const String _keyDose = 'vintora_brew_dose';
  static const String _keyRatio = 'vintora_brew_ratio';

  double _coffeeDose = 18.0; // grams
  double _waterRatio = 16.0; // 1:16
  List<BeanEntry> _beans = [];

  // Stage timer state
  bool _isBrewing = false;
  int _currentStageIndex = 0;
  int _stageSecondsElapsed = 0;
  int _totalBrewSeconds = 0;
  Timer? _ticker;

  BrewController() {
    _loadData();
  }

  double get coffeeDose => _coffeeDose;
  double get waterRatio => _waterRatio;
  double get totalWater => (_coffeeDose * _waterRatio).roundToDouble();
  double get bloomWater => (_coffeeDose * 3.0).roundToDouble();
  List<BeanEntry> get beans => List.unmodifiable(_beans);

  bool get isBrewing => _isBrewing;
  int get currentStageIndex => _currentStageIndex;
  int get stageSecondsElapsed => _stageSecondsElapsed;
  int get totalBrewSeconds => _totalBrewSeconds;

  List<BrewStageInfo> get stages {
    final bloom = bloomWater;
    final pour1 = (totalWater * 0.6).roundToDouble();
    final pour2 = totalWater;

    return [
      BrewStageInfo(
        name: 'Bloom',
        durationSeconds: 45,
        targetWater: bloom,
        instruction: 'Pour ${bloom.toInt()}g water gently in spiral to release CO2 gas.',
      ),
      BrewStageInfo(
        name: 'First Pour',
        durationSeconds: 45,
        targetWater: pour1,
        instruction: 'Pour up to ${pour1.toInt()}g in steady circles from center outward.',
      ),
      BrewStageInfo(
        name: 'Second Pour',
        durationSeconds: 45,
        targetWater: pour2,
        instruction: 'Top up to ${pour2.toInt()}g keeping gentle kettle flow.',
      ),
      BrewStageInfo(
        name: 'Drawdown',
        durationSeconds: 45,
        targetWater: pour2,
        instruction: 'Swirl once lightly and let coffee bed filter through flat.',
      ),
    ];
  }

  BrewStageInfo get currentStage => stages[_currentStageIndex.clamp(0, stages.length - 1)];

  Future<void> _loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _coffeeDose = prefs.getDouble(_keyDose) ?? 18.0;
      _waterRatio = prefs.getDouble(_keyRatio) ?? 16.0;

      final rawBeans = prefs.getStringList(_keyBeans);
      if (rawBeans != null && rawBeans.isNotEmpty) {
        _beans = rawBeans
            .map((str) => BeanEntry.fromJson(jsonDecode(str) as Map<String, dynamic>))
            .toList();
      } else {
        _beans = [
          BeanEntry(
            id: 'init-ethiopia',
            name: 'Yirgacheffe Chelbessa',
            origin: 'Ethiopia (Gedeb, 2050m)',
            roastLevel: 'Light',
            process: 'Washed',
            notes: ['Jasmine', 'Bergamot', 'Peach Iced Tea'],
            rating: 4.8,
          ),
          BeanEntry(
            id: 'init-colombia',
            name: 'Huila Pink Bourbon',
            origin: 'Colombia (San Agustin, 1750m)',
            roastLevel: 'Medium-Light',
            process: 'Anaerobic Washed',
            notes: ['Papaya', 'Pink Guava', 'Raw Honey'],
            rating: 4.9,
          ),
          BeanEntry(
            id: 'init-guatemala',
            name: 'Antigua Los Volcanes',
            origin: 'Guatemala (1600m)',
            roastLevel: 'Medium',
            process: 'Washed',
            notes: ['Dark Chocolate', 'Almond', 'Orange Zest'],
            rating: 4.6,
          ),
        ];
      }
    } catch (e) {
      debugPrint('Error loading vintora storage: $e');
    } finally {
      notifyListeners();
    }
  }

  void setDose(double dose) {
    _coffeeDose = dose.clamp(8.0, 60.0);
    notifyListeners();
    _persistSettings();
  }

  void setRatio(double ratio) {
    _waterRatio = ratio.clamp(10.0, 20.0);
    notifyListeners();
    _persistSettings();
  }

  void startBrew() {
    if (_isBrewing) return;
    _isBrewing = true;
    notifyListeners();

    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      _totalBrewSeconds++;
      _stageSecondsElapsed++;

      final stageDuration = currentStage.durationSeconds;
      if (_stageSecondsElapsed >= stageDuration) {
        if (_currentStageIndex < stages.length - 1) {
          _currentStageIndex++;
          _stageSecondsElapsed = 0;
        } else {
          // Completed all stages
          pauseBrew();
        }
      }
      notifyListeners();
    });
  }

  void pauseBrew() {
    _isBrewing = false;
    _ticker?.cancel();
    notifyListeners();
  }

  void resetBrew() {
    _isBrewing = false;
    _ticker?.cancel();
    _currentStageIndex = 0;
    _stageSecondsElapsed = 0;
    _totalBrewSeconds = 0;
    notifyListeners();
  }

  void nextStage() {
    if (_currentStageIndex < stages.length - 1) {
      _currentStageIndex++;
      _stageSecondsElapsed = 0;
      notifyListeners();
    }
  }

  Future<void> addBean(BeanEntry bean) async {
    _beans.insert(0, bean);
    notifyListeners();
    await _persistBeans();
  }

  Future<void> deleteBean(String id) async {
    _beans.removeWhere((b) => b.id == id);
    notifyListeners();
    await _persistBeans();
  }

  Future<void> _persistSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyDose, _coffeeDose);
    await prefs.setDouble(_keyRatio, _waterRatio);
  }

  Future<void> _persistBeans() async {
    final prefs = await SharedPreferences.getInstance();
    final list = _beans.map((b) => jsonEncode(b.toJson())).toList();
    await prefs.setStringList(_keyBeans, list);
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
