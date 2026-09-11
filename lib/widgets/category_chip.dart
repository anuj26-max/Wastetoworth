import 'package:flutter/material.dart';
import '../models/waste_item.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class CategoryItemData {
  final WasteCategory category;
  final String label;
  final IconData icon;
  final Color bgColor;
  final Color iconColor;

  const CategoryItemData({
    required this.category,
    required this.label,
    required this.icon,
    required this.bgColor,
    required this.iconColor,
  });
}

class CategoryChipGrid extends StatelessWidget {
  final WasteCategory? selectedCategory;
  final Function(WasteCategory) onCategorySelected;
  final VoidCallback? onSeeAll;

  const CategoryChipGrid({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
    this.onSeeAll,
  });

  static const List<CategoryItemData> categories = [
    CategoryItemData(
      category: WasteCategory.metal,
      label: 'Vehicle & Metal',
      icon: Icons.directions_car_rounded,
      bgColor: Color(0xFFFEF3C7),
      iconColor: Color(0xFFD97706),
    ),
    CategoryItemData(
      category: WasteCategory.eWaste,
      label: 'Electronics',
      icon: Icons.tv_rounded,
      bgColor: Color(0xFFEDE9FE),
      iconColor: Color(0xFF7C3AED),
    ),
    CategoryItemData(
      category: WasteCategory.textile,
      label: 'Fashion',
      icon: Icons.checkroom_rounded,
      bgColor: Color(0xFFFCE7F3),
      iconColor: Color(0xFFDB2777),
    ),
    CategoryItemData(
      category: WasteCategory.organic,
      label: 'Compost & Bio',
      icon: Icons.eco_rounded,
      bgColor: Color(0xFFECFCCB),
      iconColor: Color(0xFF65A30D),
    ),
    CategoryItemData(
      category: WasteCategory.paper,
      label: 'Books & Paper',
      icon: Icons.menu_book_rounded,
      bgColor: Color(0xFFE0F2FE),
      iconColor: Color(0xFF0284C7),
    ),
    CategoryItemData(
      category: WasteCategory.upcycled,
      label: 'Furniture & Art',
      icon: Icons.weekend_rounded,
      bgColor: Color(0xFFF3E8FF),
      iconColor: Color(0xFF9333EA),
    ),
    CategoryItemData(
      category: WasteCategory.glass,
      label: 'Kitchen & Glass',
      icon: Icons.kitchen_rounded,
      bgColor: Color(0xFFCCFBF1),
      iconColor: Color(0xFF0D9488),
    ),
    CategoryItemData(
      category: WasteCategory.plastic,
      label: 'Plastic & Scrap',
      icon: Icons.recycling_rounded,
      bgColor: Color(0xFFFFEDD5),
      iconColor: Color(0xFFEA580C),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header matching screenshot: "What are you looking for?   See all >"
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'What are you looking for?',
                style: AppTypography.titleLarge.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              InkWell(
                onTap: onSeeAll,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'See all',
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(
                        Icons.chevron_right_rounded,
                        size: 18,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 6),

        // Grid of 8 category circular icons matching the screenshot layout
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double itemWidth = (constraints.maxWidth - (12 * 3)) / 4;
              return Wrap(
                spacing: 12,
                runSpacing: 14,
                children: categories.map((cat) {
                  final isSelected = selectedCategory == cat.category;
                  return SizedBox(
                    width: itemWidth,
                    child: InkWell(
                      onTap: () => onCategorySelected(cat.category),
                      borderRadius: BorderRadius.circular(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : cat.bgColor,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primaryDark
                                    : Colors.transparent,
                                width: 2,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: AppColors.primary.withValues(alpha: 0.3),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Icon(
                              cat.icon,
                              color: isSelected ? Colors.white : cat.iconColor,
                              size: 28,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            cat.label,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.bodySmall.copyWith(
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                              color: isSelected
                                  ? AppColors.primaryDark
                                  : AppColors.textPrimary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }
}
