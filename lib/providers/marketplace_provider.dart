import 'package:flutter/material.dart';
import '../models/marketplace_listing.dart';
import '../models/waste_item.dart';
import '../services/marketplace_service.dart';

class MarketplaceProvider extends ChangeNotifier {
  final MarketplaceService _service = MarketplaceService();

  List<MarketplaceListing> _listings = [];
  WasteCategory? _selectedCategory;
  String _searchQuery = '';
  bool _isLoading = false;

  List<MarketplaceListing> get listings => _listings;
  WasteCategory? get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;

  List<MarketplaceListing> get favoriteListings =>
      _listings.where((item) => item.isFavorite).toList();

  MarketplaceProvider() {
    loadListings();
  }

  Future<void> loadListings() async {
    _isLoading = true;
    notifyListeners();

    _listings = await _service.getListings(
      category: _selectedCategory,
      searchQuery: _searchQuery,
    );

    _isLoading = false;
    notifyListeners();
  }

  void selectCategory(WasteCategory? category) {
    if (_selectedCategory == category) {
      _selectedCategory = null; // deselect to show all
    } else {
      _selectedCategory = category;
    }
    loadListings();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    loadListings();
  }

  Future<void> toggleFavorite(String id) async {
    await _service.toggleFavorite(id);
    final index = _listings.indexWhere((item) => item.id == id);
    if (index != -1) {
      _listings[index] = _listings[index].copyWith(
        isFavorite: !_listings[index].isFavorite,
      );
      notifyListeners();
    }
  }

  Future<void> addListing(MarketplaceListing listing) async {
    final added = await _service.addListing(listing);
    _listings.insert(0, added);
    notifyListeners();
  }
}
