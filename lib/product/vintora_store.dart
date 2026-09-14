import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class VintoraStore extends ChangeNotifier {
  SharedPreferences? _prefs;
  List<dynamic> _logs = [];

  List<dynamic> get logs => _logs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final data = _prefs?.getString('vintora_data');
    if (data != null) {
      _logs = jsonDecode(data);
    }
    notifyListeners();
  }

  void addLog(String item) {
    _logs.add(item);
    _prefs?.setString('vintora_data', jsonEncode(_logs));
    notifyListeners();
  }
}
