import 'dart:async';
import '../models/facility.dart';
import '../models/waste_item.dart';
import 'mock_data.dart';

class FacilityService {
  final List<Facility> _facilities = List.from(MockData.sampleFacilities);

  Future<List<Facility>> getNearbyFacilities({
    WasteCategory? category,
    String? searchQuery,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    var results = List<Facility>.from(_facilities);

    if (category != null) {
      results = results.where((fac) => fac.acceptedCategories.contains(category)).toList();
    }

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final query = searchQuery.toLowerCase().trim();
      results = results.where((fac) {
        return fac.name.toLowerCase().contains(query) ||
            fac.address.toLowerCase().contains(query) ||
            fac.type.toLowerCase().contains(query);
      }).toList();
    }

    // Sort by nearest distance
    results.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    return results;
  }
}
