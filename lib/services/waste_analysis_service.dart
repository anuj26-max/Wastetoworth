import 'dart:async';
import '../models/analysis_result.dart';
import '../models/waste_item.dart';
import 'mock_data.dart';

class WasteAnalysisService {
  // Simulates call to Nikunj's FastAPI endpoint `/api/v1/analyze`
  // which interfaces with Himanshu's trained YOLO computer-vision model
  Future<AnalysisResult> analyzeImage({
    String? localImagePath,
    String? sampleType,
  }) async {
    // Simulate network and YOLO inference latency (1.2 seconds)
    await Future.delayed(const Duration(milliseconds: 1200));

    if (sampleType == 'plastic') {
      return MockData.sampleScans[0];
    } else if (sampleType == 'ewaste') {
      return MockData.sampleScans[1];
    } else if (sampleType == 'metal') {
      return MockData.sampleScans[2];
    }

    // Default dynamic result for user camera capture / gallery uploads
    return AnalysisResult(
      id: 'scan_${DateTime.now().millisecondsSinceEpoch}',
      itemName: 'Identified Recyclable Material',
      category: WasteCategory.eWaste,
      confidence: 0.954,
      material: 'Consumer Electronic Component / Recyclable Metal Matrix',
      recyclability: RecyclabilityStatus.highlyRecyclable,
      estimatedWorthPerKg: 65.0,
      estimatedWeightKg: 1.2,
      totalEstimatedWorth: 78.0,
      co2SavingsKg: 2.10,
      imageUrl: localImagePath ??
          'https://images.unsplash.com/photo-1550009158-9ebf69173e03?w=600',
      recommendations: [
        'Eligible for immediate sale on the Waste2Worth marketplace.',
        'High recyclability index: can be processed at local E-Waste Hub.',
        'Saves ~2.10 kg of CO2 compared to virgin raw material extraction.',
      ],
      disposalGuidelines: [
        'Store in dry ambient conditions.',
        'Keep away from household domestic wet waste.',
      ],
      timestamp: DateTime.now(),
    );
  }

  List<AnalysisResult> getRecentScans() {
    return MockData.sampleScans;
  }
}
