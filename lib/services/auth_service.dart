import 'dart:async';
import '../models/user_profile.dart';
import 'mock_data.dart';

class AuthService {
  UserProfile _currentUser = MockData.defaultUser;
  bool _isAuthenticated = true;

  UserProfile get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _isAuthenticated = true;
    return true;
  }

  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required UserRole role,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    _currentUser = UserProfile(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      phone: phone,
      avatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
      city: 'Bangalore',
      role: role,
      walletBalance: 0.0,
      totalWasteRecycledKg: 0.0,
      totalCo2SavedKg: 0.0,
      totalScansCompleted: 0,
      badges: [],
    );
    _isAuthenticated = true;
    return true;
  }

  void switchRole(UserRole newRole) {
    _currentUser = UserProfile(
      id: _currentUser.id,
      name: _currentUser.name,
      email: _currentUser.email,
      phone: _currentUser.phone,
      avatarUrl: _currentUser.avatarUrl,
      city: _currentUser.city,
      role: newRole,
      walletBalance: _currentUser.walletBalance,
      totalWasteRecycledKg: _currentUser.totalWasteRecycledKg,
      totalCo2SavedKg: _currentUser.totalCo2SavedKg,
      totalScansCompleted: _currentUser.totalScansCompleted,
      badges: _currentUser.badges,
    );
  }

  void logout() {
    _isAuthenticated = false;
  }
}
