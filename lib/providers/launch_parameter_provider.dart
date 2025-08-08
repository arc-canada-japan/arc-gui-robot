import 'package:flutter/material.dart';

class LaunchParameterProvider with ChangeNotifier {
  final Map<String, String?> _selectedControllers = {};
  bool _isLaunched = false;

  String? getSelected(String packageName) => _selectedControllers[packageName];

  void setSelected(String packageName, String? value) {
    _selectedControllers[packageName] = value;
    notifyListeners();
  }

  bool get isLaunched => _isLaunched;

  set isLaunched(bool value) {
    if (_isLaunched != value) {
      _isLaunched = value;
      notifyListeners();
    }
  }
}
