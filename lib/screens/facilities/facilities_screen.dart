import 'package:flutter/material.dart';
import '../../models/facility.dart';
import '../../models/waste_item.dart';
import '../../services/facility_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/facility_card.dart';

class FacilitiesScreen extends StatefulWidget {
  const FacilitiesScreen({super.key});

  @override
  State<FacilitiesScreen> createState() => _FacilitiesScreenState();
}

class _FacilitiesScreenState extends State<FacilitiesScreen> {
  final FacilityService _facilityService = FacilityService();
  List<Facility> _facilities = [];
  WasteCategory? _selectedCategory;
  String _searchQuery = '';
  bool _isLoading = true;
  bool _showMap = false;

  @override
  void initState() {
    super.initState();
    _loadFacilities();
  }

  Future<void> _loadFacilities() async {
    setState(() => _isLoading = true);
    final results = await _facilityService.getNearbyFacilities(
      category: _selectedCategory,
      searchQuery: _searchQuery,
    );
    if (mounted) {
      setState(() {
        _facilities = results;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Nearby Recycling & Scrap Hubs',
          style: AppTypography.titleLarge.copyWith(fontSize: 18),
        ),
        backgroundColor: AppColors.surface,
        actions: [
          IconButton(
            icon: Icon(
              _showMap ? Icons.view_list_rounded : Icons.map_outlined,
              color: AppColors.primary,
            ),
            tooltip: _showMap ? 'List View' : 'Map View',
            onPressed: () {
              setState(() => _showMap = !_showMap);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filters Header
          Container(
            color: AppColors.surface,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                // Search Input
                TextField(
                  onChanged: (val) {
                    _searchQuery = val;
                    _loadFacilities();
                  },
                  decoration: InputDecoration(
                    hintText: 'Search kabadiwalas, e-waste hubs...',
                    prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                    filled: true,
                    fillColor: const Color(0xFFF1F5F9),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),

                const SizedBox(height: 10),

                // Category Filter Pills
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: const Text('All Hubs'),
                          selected: _selectedCategory == null,
                          onSelected: (_) {
                            setState(() => _selectedCategory = null);
                            _loadFacilities();
                          },
                          selectedColor: AppColors.primaryLight,
                          checkmarkColor: AppColors.primaryDark,
                        ),
                      ),
                      ...WasteCategory.values.map((cat) {
                        final isSelected = _selectedCategory == cat;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(cat.label),
                            selected: isSelected,
                            onSelected: (_) {
                              setState(() {
                                _selectedCategory = isSelected ? null : cat;
                              });
                              _loadFacilities();
                            },
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

          // Content Area (List vs Simulated Map)
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : _showMap
                    ? _buildSimulatedMap()
                    : _buildFacilityList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFacilityList() {
    if (_facilities.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.location_off_outlined, size: 48, color: AppColors.textMuted),
              const SizedBox(height: 12),
              Text('No facilities found for your filters.', style: AppTypography.bodyMedium),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _facilities.length,
      itemBuilder: (context, index) {
        final fac = _facilities[index];
        return FacilityCard(
          facility: fac,
          onCallTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Calling ${fac.name} at ${fac.phone}...'),
                backgroundColor: AppColors.primary,
              ),
            );
          },
          onDirectionsTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Opening GPS navigation to ${fac.name} (${fac.distanceDisplay})'),
                backgroundColor: AppColors.primary,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSimulatedMap() {
    return Stack(
      children: [
        // Map Canvas Mock
        Container(
          color: const Color(0xFFE2E8F0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.map_rounded, size: 80, color: Color(0xFF94A3B8)),
                const SizedBox(height: 12),
                Text(
                  'Bangalore Recycling Geo-Network',
                  style: AppTypography.titleMedium.copyWith(color: AppColors.textSecondary),
                ),
                Text(
                  '${_facilities.length} verified facilities plotted in your area',
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
          ),
        ),

        // Simulated Map Pins
        ...List.generate(_facilities.length, (i) {
          final fac = _facilities[i];
          final double topOffset = 120.0 + (i * 70);
          final double leftOffset = 40.0 + ((i % 2) * 140);
          return Positioned(
            top: topOffset,
            left: leftOffset,
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${fac.name} • ${fac.distanceDisplay}'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: AppColors.cardShadow,
                    ),
                    child: Text(
                      fac.name.split(' ').first,
                      style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const Icon(Icons.location_pin, color: AppColors.primaryDark, size: 36),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
