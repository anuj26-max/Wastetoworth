import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/marketplace_provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/app_header.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/listing_card.dart';
import '../marketplace/listing_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onOpenScanner;
  final Function(int) onNavigateTab;

  const HomeScreen({
    super.key,
    required this.onOpenScanner,
    required this.onNavigateTab,
  });

  @override
  Widget build(BuildContext context) {
    final marketplace = Provider.of<MarketplaceProvider>(context);
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar matching reference (Bangalore ▾, Notifications, Chat)
            const AppHeader(),

            // Scrollable Content
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () async {
                  await marketplace.loadListings();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Branding & Tagline matching reference: "Holo / Buy and Sell Stuff"
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Waste2Worth',
                                  style: AppTypography.displayMedium.copyWith(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w900,
                                    color: const Color(0xFF4C1D95), // Deep regal purple like screenshot
                                    letterSpacing: -0.6,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryLight,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'AI POWERED',
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.primaryDark,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 9,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Buy and Sell Stuff • Turn Waste into Wealth',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Search Input matching reference screenshot
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: TextField(
                            onChanged: (val) => marketplace.setSearchQuery(val),
                            decoration: InputDecoration(
                              hintText: 'Find scrap, electronics, cardboard and more...',
                              hintStyle: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textMuted,
                              ),
                              prefixIcon: const Icon(
                                Icons.search_rounded,
                                color: AppColors.textSecondary,
                                size: 22,
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Eco Impact Card Banner
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF10B981), Color(0xFF059669)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.25),
                                blurRadius: 14,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.eco_rounded,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Your Eco Earnings',
                                          style: AppTypography.bodySmall.copyWith(
                                            color: Colors.white.withValues(alpha: 0.9),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      user.formattedBalance,
                                      style: AppTypography.displayMedium.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 24,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${user.totalWasteRecycledKg} kg recycled • ${user.totalCo2SavedKg} kg CO2 saved',
                                      style: AppTypography.bodySmall.copyWith(
                                        color: Colors.white.withValues(alpha: 0.85),
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: onOpenScanner,
                                icon: const Icon(
                                  Icons.document_scanner_outlined,
                                  size: 16,
                                  color: AppColors.primaryDark,
                                ),
                                label: const Text('AI Scan'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: AppColors.primaryDark,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // What are you looking for? (Category icons matching reference screenshot)
                      CategoryChipGrid(
                        selectedCategory: marketplace.selectedCategory,
                        onCategorySelected: (category) {
                          marketplace.selectCategory(category);
                        },
                        onSeeAll: () {
                          // Navigate to Marketplace tab
                          onNavigateTab(0);
                        },
                      ),

                      const SizedBox(height: 20),

                      // New Recommendations Header matching screenshot: "New Recommendations"
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'New Recommendations',
                              style: AppTypography.titleLarge.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            if (marketplace.selectedCategory != null)
                              TextButton(
                                onPressed: () => marketplace.selectCategory(null),
                                child: Text(
                                  'Clear filter',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // 2-Column Grid of Listing Cards matching reference screenshot
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: marketplace.isLoading
                            ? const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(32),
                                  child: CircularProgressIndicator(
                                    color: AppColors.primary,
                                  ),
                                ),
                              )
                            : marketplace.listings.isEmpty
                                ? Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(32),
                                      child: Column(
                                        children: [
                                          const Icon(
                                            Icons.search_off_rounded,
                                            size: 48,
                                            color: AppColors.textMuted,
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            'No listings match your search.',
                                            style: AppTypography.bodyMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : GridView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: marketplace.listings.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 14,
                                      childAspectRatio: 0.66,
                                    ),
                                    itemBuilder: (context, index) {
                                      final item = marketplace.listings[index];
                                      return ListingCard(
                                        listing: item,
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => ListingDetailScreen(
                                                listing: item,
                                              ),
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

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
