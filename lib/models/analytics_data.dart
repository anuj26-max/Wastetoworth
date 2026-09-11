class CategoryBreakdown {
  final String categoryName;
  final double percentage;
  final double weightKg;
  final int colorValue;

  CategoryBreakdown({
    required this.categoryName,
    required this.percentage,
    required this.weightKg,
    required this.colorValue,
  });
}

class MonthlyStat {
  final String month;
  final double earnings;
  final double wasteRecycledKg;

  MonthlyStat({
    required this.month,
    required this.earnings,
    required this.wasteRecycledKg,
  });
}

class AnalyticsReport {
  final double totalWasteKg;
  final double totalEarningsInr;
  final double totalCo2SavedKg;
  final int treesEquivalent;
  final List<CategoryBreakdown> categoryBreakdown;
  final List<MonthlyStat> monthlyTrends;

  AnalyticsReport({
    required this.totalWasteKg,
    required this.totalEarningsInr,
    required this.totalCo2SavedKg,
    required this.treesEquivalent,
    required this.categoryBreakdown,
    required this.monthlyTrends,
  });
}
