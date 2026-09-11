import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  int _currentBottomNavIndex = 0;
  String _selectedCity = 'Bangalore';
  final List<String> _availableCities = [
    'Bangalore',
    'Mumbai',
    'Delhi NCR',
    'Hyderabad',
    'Pune',
    'Chennai',
  ];
  int _unreadNotifications = 2;

  int get currentBottomNavIndex => _currentBottomNavIndex;
  String get selectedCity => _selectedCity;
  List<String> get availableCities => _availableCities;
  int get unreadNotifications => _unreadNotifications;

  void setBottomNavIndex(int index) {
    _currentBottomNavIndex = index;
    notifyListeners();
  }

  void setSelectedCity(String city) {
    _selectedCity = city;
    notifyListeners();
  }

  void clearNotifications() {
    _unreadNotifications = 0;
    notifyListeners();
  }
}
