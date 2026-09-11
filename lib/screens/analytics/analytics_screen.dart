import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/analytics_data.dart';
import '../../services/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/eco_stat_card.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final AnalyticsReport report = MockData.sampleAnalytics;
  int _touchedPieIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Impact & Recycling Analytics',
          style: AppTypography.titleLarge.copyWith(fontSize: 18),
        ),
        backgroundColor: AppColors.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Metric Highlights (2x2 Grid)
            Row(
              children: [
                Expanded(
                  child: EcoStatCard(
                    title: 'Total Recycled',
                    value: '${report.totalWasteKg} kg',
                    subtitle: '+18% from last month',
                    icon: Icons.recycling_rounded,
                    accentColor: AppColors.primary,
                    bgColor: AppColors.primaryLight,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: EcoStatCard(
                    title: 'Total Earnings',
                    value: '₹${report.totalEarningsInr.toStringAsFixed(0)}',
                    subtitle: 'Paid out to wallet',
                    icon: Icons.account_balance_wallet_rounded,
                    accentColor: AppColors.accentAmber,
                    bgColor: const Color(0xFFFEF3C7),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: EcoStatCard(
                    title: 'CO2 Offset',
                    value: '${report.totalCo2SavedKg} kg',
                    subtitle: 'Avoided greenhouse gas',
                    icon: Icons.cloud_done_rounded,
                    accentColor: AppColors.accentSky,
                    bgColor: const Color(0xFFE0F2FE),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: EcoStatCard(
                    title: 'Trees Equivalent',
                    value: '${report.treesEquivalent} Trees',
                    subtitle: 'Carbon sequestered',
                    icon: Icons.park_rounded,
                    accentColor: AppColors.accentTeal,
                    bgColor: const Color(0xFFCCFBF1),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Waste Breakdown Pie Chart
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
                boxShadow: AppColors.softShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Waste Diverted by Category',
                    style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Percentage breakdown of your recycled materials',
                    style: AppTypography.bodySmall,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 180,
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback: (FlTouchEvent event, pieTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  pieTouchResponse == null ||
                                  pieTouchResponse.touchedSection == null) {
                                _touchedPieIndex = -1;
                                return;
                              }
                              _touchedPieIndex =
                                  pieTouchResponse.touchedSection!.touchedSectionIndex;
                            });
                          },
                        ),
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 3,
                        centerSpaceRadius: 40,
                        sections: List.generate(report.categoryBreakdown.length, (i) {
                          final item = report.categoryBreakdown[i];
                          final isTouched = i == _touchedPieIndex;
                          final fontSize = isTouched ? 16.0 : 12.0;
                          final radius = isTouched ? 55.0 : 45.0;

                          return PieChartSectionData(
                            color: Color(item.colorValue),
                            value: item.percentage,
                            title: '${item.percentage.toInt()}%',
                            radius: radius,
                            titleStyle: TextStyle(
                              fontSize: fontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: report.categoryBreakdown.map((item) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Color(item.colorValue),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${item.categoryName} (${item.weightKg} kg)',
                            style: AppTypography.bodySmall.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Monthly Recycling & Earnings Bar Chart
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
                boxShadow: AppColors.softShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Monthly Earnings Trend (₹)',
                    style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Value realized from scrap sales over the last 5 months',
                    style: AppTypography.bodySmall,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 180,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 4000,
                        barTouchData: BarTouchData(
                          enabled: true,
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final index = value.toInt();
                                if (index >= 0 && index < report.monthlyTrends.length) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      report.monthlyTrends[index].month,
                                      style: AppTypography.bodySmall.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                          leftTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        gridData: const FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        barGroups: List.generate(report.monthlyTrends.length, (i) {
                          final trend = report.monthlyTrends[i];
                          return BarChartGroupData(
                            x: i,
                            barRods: [
                              BarChartRodData(
                                toY: trend.earnings,
                                color: AppColors.primary,
                                width: 22,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
