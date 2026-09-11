import 'waste_item.dart';

class Facility {
  final String id;
  final String name;
  final String address;
  final double distanceKm;
  final String type; // "Verified Scrap Dealer", "E-Waste Drop-off Hub", "Municipal Recycling Center"
  final double rating;
  final int reviewsCount;
  final String phone;
  final List<WasteCategory> acceptedCategories;
  final String openHours;
  final bool isVerified;
  final double lat;
  final double lng;

  Facility({
    required this.id,
    required this.name,
    required this.address,
    required this.distanceKm,
    required this.type,
    required this.rating,
    required this.reviewsCount,
    required this.phone,
    required this.acceptedCategories,
    required this.openHours,
    this.isVerified = true,
    required this.lat,
    required this.lng,
  });

  String get distanceDisplay => '${distanceKm.toStringAsFixed(1)} km away';
}
