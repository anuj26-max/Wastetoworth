import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../widgets/custom_bottom_nav.dart';
import 'home_screen.dart';
import '../marketplace/marketplace_screen.dart';
import '../facilities/facilities_screen.dart';
import '../profile/profile_screen.dart';
import '../scanner/scanner_screen.dart';
import '../marketplace/create_listing_screen.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  void _openScanner() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ScannerScreen()),
    );
  }

  void _showCenterActionBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'What would you like to do?',
                  style: AppTypography.titleLarge.copyWith(fontSize: 18),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Option 1: AI Waste Scanner
            ListTile(
              onTap: () {
                Navigator.pop(ctx);
                _openScanner();
              },
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.document_scanner_rounded,
                  color: AppColors.primaryDark,
                  size: 24,
                ),
              ),
              title: Text(
                'Scan Waste with AI Camera',
                style: AppTypography.titleSmall,
              ),
              subtitle: Text(
                'Detect recyclable material, estimated worth & CO2 savings',
                style: AppTypography.bodySmall,
              ),
              trailing: const Icon(Icons.chevron_right_rounded),
            ),

            const SizedBox(height: 10),

            // Option 2: Post Waste/Scrap Listing
            ListTile(
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreateListingScreen()),
                );
              },
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE9FE),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.add_business_rounded,
                  color: Color(0xFF7C3AED),
                  size: 24,
                ),
              ),
              title: Text(
                'Sell Scrap on Waste-to-Worth',
                style: AppTypography.titleSmall,
              ),
              subtitle: Text(
                'Create a listing for buyers, kabadiwalas, or upcyclers',
                style: AppTypography.bodySmall,
              ),
              trailing: const Icon(Icons.chevron_right_rounded),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final currentIndex = appState.currentBottomNavIndex;

    final List<Widget> pages = [
      // 0: Explore / Home Screen (matches reference photo)
      HomeScreen(
        onOpenScanner: _openScanner,
        onNavigateTab: (idx) => appState.setBottomNavIndex(idx),
      ),
      // 1: Saved / Favorites (matches star tab in reference photo)
      const MarketplaceScreen(showOnlyFavorites: true),
      // 2: Facilities / Hubs Directory
      const FacilitiesScreen(),
      // 3: Profile & Impact Analytics
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) => appState.setBottomNavIndex(index),
        onCenterActionTap: _showCenterActionBottomSheet,
      ),
    );
  }
}
