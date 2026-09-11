enum UserRole {
  individual('Individual Recycler'),
  dealer('Scrap Dealer / Collector'),
  admin('System Administrator');

  final String label;
  const UserRole(this.label);
}

class UserBadge {
  final String title;
  final String description;
  final String icon;
  final String dateEarned;

  UserBadge({
    required this.title,
    required this.description,
    required this.icon,
    required this.dateEarned,
  });
}

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatarUrl;
  final String city;
  final UserRole role;
  final double walletBalance; // in INR ₹
  final double totalWasteRecycledKg;
  final double totalCo2SavedKg;
  final int totalScansCompleted;
  final List<UserBadge> badges;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatarUrl,
    required this.city,
    required this.role,
    required this.walletBalance,
    required this.totalWasteRecycledKg,
    required this.totalCo2SavedKg,
    required this.totalScansCompleted,
    required this.badges,
  });

  String get formattedBalance => '₹${walletBalance.toStringAsFixed(0)}';
}
