import 'waste_item.dart';

class AnalysisResult {
  final String id;
  final String itemName;
  final WasteCategory category;
  final double confidence; // e.g. 0.96 for 96%
  final String material; // e.g. "PET Type 1 Thermoplastic" or "Printed Circuit Board / Gold & Copper"
  final RecyclabilityStatus recyclability;
  final double estimatedWorthPerKg; // in INR ₹
  final double estimatedWeightKg;
  final double totalEstimatedWorth; // in INR ₹
  final double co2SavingsKg; // e.g. 1.8 kg CO2 saved
  final String imageUrl;
  final List<String> recommendations;
  final List<String> disposalGuidelines;
  final DateTime timestamp;

  AnalysisResult({
    required this.id,
    required this.itemName,
    required this.category,
    required this.confidence,
    required this.material,
    required this.recyclability,
    required this.estimatedWorthPerKg,
    required this.estimatedWeightKg,
    required this.totalEstimatedWorth,
    required this.co2SavingsKg,
    required this.imageUrl,
    required this.recommendations,
    required this.disposalGuidelines,
    required this.timestamp,
  });

  String get confidencePercentage => '${(confidence * 100).toStringAsFixed(1)}%';
  String get worthDisplay => '₹${totalEstimatedWorth.toStringAsFixed(0)}';
  String get rateDisplay => '₹${estimatedWorthPerKg.toStringAsFixed(0)}/kg';
}
