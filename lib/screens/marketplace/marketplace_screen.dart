import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/waste_item.dart';
import '../../providers/marketplace_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/listing_card.dart';
import 'listing_detail_screen.dart';
import 'create_listing_screen.dart';

class MarketplaceScreen extends StatefulWidget {
  final bool showOnlyFavorites;

  const MarketplaceScreen({
    super.key,
    this.showOnlyFavorites = false,
  });

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  @override
  Widget build(BuildContext context) {
    final marketplace = Provider.of<MarketplaceProvider>(context);
    final items = widget.showOnlyFavorites
        ? marketplace.favoriteListings
        : marketplace.listings;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          widget.showOnlyFavorites ? 'Saved Listings' : 'Waste-to-Worth Marketplace',
          style: AppTypography.titleLarge.copyWith(fontSize: 18),
        ),
        backgroundColor: AppColors.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_business_rounded, color: AppColors.primary),
            tooltip: 'Sell Scrap / Item',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateListingScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (!widget.showOnlyFavorites) ...[
            // Search Input
            Container(
              color: AppColors.surface,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  TextField(
                    onChanged: (val) => marketplace.setSearchQuery(val),
                    decoration: InputDecoration(
                      hintText: 'Search recyclable scrap, metal, PET...',
                      prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                      filled: true,
                      fillColor: const Color(0xFFF1F5F9),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Horizontal Category Filter Bar
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: const Text('All Scrap'),
                            selected: marketplace.selectedCategory == null,
                            onSelected: (_) => marketplace.selectCategory(null),
                            selectedColor: AppColors.primaryLight,
                            checkmarkColor: AppColors.primaryDark,
                          ),
                        ),
                        ...WasteCategory.values.map((cat) {
                          final isSelected = marketplace.selectedCategory == cat;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(cat.label),
                              selected: isSelected,
                              onSelected: (_) => marketplace.selectCategory(cat),
                              selectedColor: AppColors.primaryLight,
                              checkmarkColor: AppColors.primaryDark,
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Grid of items
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            widget.showOnlyFavorites
                                ? Icons.star_border_rounded
                                : Icons.search_off_rounded,
                            size: 56,
                            color: AppColors.textMuted,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            widget.showOnlyFavorites
                                ? 'No saved listings yet.\nTap the star icon on any card to save!'
                                : 'No listings found matching your filters.',
                            textAlign: TextAlign.center,
                            style: AppTypography.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.66,
                    ),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return ListingCard(
                        listing: item,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ListingDetailScreen(listing: item),
                            ),
                          );
                        },
                        onFavoriteTap: () {
                          marketplace.toggleFavorite(item.id);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
