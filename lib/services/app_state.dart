import 'package:flutter/material.dart';
import '../models/locker_model.dart';

class AppState extends ChangeNotifier {
  // Onboarding
  bool _onboardingComplete = false;
  bool get onboardingComplete => _onboardingComplete;

  CompartmentType? _selectedType;
  CompartmentType? get selectedType => _selectedType;

  LockerSize _selectedSize = LockerSize.m;
  LockerSize get selectedSize => _selectedSize;

  // Navigation
  int _navIndex = 0;
  int get navIndex => _navIndex;

  // Locker state
  String? _selectedCompartmentId;
  String? get selectedCompartmentId => _selectedCompartmentId;

  bool _isUnlocked = false;
  bool get isUnlocked => _isUnlocked;

  // Temperature (simulated live)
  double _cooledTemp = 14.0;
  double get cooledTemp => _cooledTemp;

  // WebSocket connected
  bool _wsConnected = true;
  bool get wsConnected => _wsConnected;

  // AI assignment in progress
  bool _aiAssigning = false;
  bool get aiAssigning => _aiAssigning;

  String? _aiAssignedId;
  String? get aiAssignedId => _aiAssignedId;

  void selectType(CompartmentType type) {
    _selectedType = type;
    notifyListeners();
  }

  void selectSize(LockerSize size) {
    _selectedSize = size;
    notifyListeners();
  }

  void setNavIndex(int index) {
    _navIndex = index;
    notifyListeners();
  }

  void selectCompartment(String id) {
    _selectedCompartmentId = id;
    notifyListeners();
  }

  Future<void> triggerAiAssignment() async {
    _aiAssigning = true;
    _aiAssignedId = null;
    notifyListeners();

    // Simulate AI decision tree < 200ms
    await Future.delayed(const Duration(milliseconds: 180));
    _aiAssigning = false;
    _aiAssignedId = _selectedType == CompartmentType.cooled ? 'C-01' : 'B-09';
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _onboardingComplete = true;
    notifyListeners();
  }

  Future<void> toggleUnlock() async {
    _isUnlocked = !_isUnlocked;
    notifyListeners();
    // Simulate WebSocket command to hardware
    await Future.delayed(const Duration(milliseconds: 120));
    notifyListeners();
  }

  void updateTemperature(double temp) {
    _cooledTemp = temp;
    notifyListeners();
  }

  void resetOnboarding() {
    _onboardingComplete = false;
    _selectedType = null;
    _selectedSize = LockerSize.m;
    _aiAssignedId = null;
    notifyListeners();
  }
}
