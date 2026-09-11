import 'package:flutter/material.dart';
import '../models/analysis_result.dart';
import '../services/waste_analysis_service.dart';

class ScannerProvider extends ChangeNotifier {
  final WasteAnalysisService _service = WasteAnalysisService();

  bool _isAnalyzing = false;
  AnalysisResult? _currentResult;
  List<AnalysisResult> _scanHistory = [];

  bool get isAnalyzing => _isAnalyzing;
  AnalysisResult? get currentResult => _currentResult;
  List<AnalysisResult> get scanHistory => _scanHistory;

  ScannerProvider() {
    _scanHistory = _service.getRecentScans();
  }

  Future<AnalysisResult> analyzeWaste({
    String? localImagePath,
    String? sampleType,
  }) async {
    _isAnalyzing = true;
    notifyListeners();

    final result = await _service.analyzeImage(
      localImagePath: localImagePath,
      sampleType: sampleType,
    );

    _currentResult = result;
    _scanHistory.insert(0, result);
    _isAnalyzing = false;
    notifyListeners();

    return result;
  }

  void clearCurrentResult() {
    _currentResult = null;
    notifyListeners();
  }
}
