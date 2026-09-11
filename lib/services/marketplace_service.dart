import 'dart:async';
import '../models/marketplace_listing.dart';
import '../models/waste_item.dart';
import 'mock_data.dart';

class MarketplaceService {
  final List<MarketplaceListing> _listings = List.from(MockData.initialListings);

  Future<List<MarketplaceListing>> getListings({
    WasteCategory? category,
    String? searchQuery,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    var results = List<MarketplaceListing>.from(_listings);

    if (category != null) {
      results = results.where((item) => item.category == category).toList();
    }

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final query = searchQuery.toLowerCase().trim();
      results = results.where((item) {
        return item.title.toLowerCase().contains(query) ||
            item.description.toLowerCase().contains(query) ||
            item.location.toLowerCase().contains(query) ||
            item.brandOrType.toLowerCase().contains(query);
      }).toList();
    }

    return results;
  }

  Future<MarketplaceListing?> getListingById(String id) async {
    await Future.delayed(const Duration(milliseconds: 150));
    try {
      return _listings.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> toggleFavorite(String id) async {
    final index = _listings.indexWhere((item) => item.id == id);
    if (index != -1) {
      _listings[index] = _listings[index].copyWith(
        isFavorite: !_listings[index].isFavorite,
      );
    }
  }

  Future<MarketplaceListing> addListing(MarketplaceListing listing) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _listings.insert(0, listing);
    return listing;
  }
}
