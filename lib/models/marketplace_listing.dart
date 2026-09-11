import 'waste_item.dart';

class MarketplaceListing {
  final String id;
  final String title;
  final double price; // in INR ₹
  final WasteCategory category;
  final String location; // e.g. "HSR Layout, 24th Main Road, Bangalore"
  final String postedTimeAgo; // e.g. "10 mins ago"
  final List<String> imageUrls;
  final String sellerName;
  final String sellerAvatar;
  final double sellerRating;
  final String brandOrType; // e.g. "Apple iPhone" or "High-Purity Copper Wire"
  final String conditionOrDefect; // e.g. "Working with minor scratch" or "Clean stripped grade A"
  final String warrantyOrCertification; // e.g. "2 months Warranty" or "Certified Scrap Batch"
  final String accessoriesOrQuantity; // e.g. "Original Box & Charger" or "Approx 15 kg bundle"
  final String description;
  final bool isFavorite;
  final String status; // "Active", "Sold", "Reserved"
  final double weightKg;

  MarketplaceListing({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.location,
    required this.postedTimeAgo,
    required this.imageUrls,
    required this.sellerName,
    required this.sellerAvatar,
    this.sellerRating = 4.8,
    required this.brandOrType,
    required this.conditionOrDefect,
    required this.warrantyOrCertification,
    required this.accessoriesOrQuantity,
    required this.description,
    this.isFavorite = false,
    this.status = 'Active',
    this.weightKg = 1.0,
  });

  String get formattedPrice => '₹${price.toStringAsFixed(0)}';

  MarketplaceListing copyWith({
    bool? isFavorite,
    String? status,
  }) {
    return MarketplaceListing(
      id: id,
      title: title,
      price: price,
      category: category,
      location: location,
      postedTimeAgo: postedTimeAgo,
      imageUrls: imageUrls,
      sellerName: sellerName,
      sellerAvatar: sellerAvatar,
      sellerRating: sellerRating,
      brandOrType: brandOrType,
      conditionOrDefect: conditionOrDefect,
      warrantyOrCertification: warrantyOrCertification,
      accessoriesOrQuantity: accessoriesOrQuantity,
      description: description,
      isFavorite: isFavorite ?? this.isFavorite,
      status: status ?? this.status,
      weightKg: weightKg,
    );
  }
}
