import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final List<Map<String, dynamic>> _pendingListings = [
    {
      'id': 'pl_1',
      'title': 'Industrial Brass Radiator Scrap (45 kg)',
      'seller': 'Peenya Foundries',
      'price': '₹14,500',
      'category': 'Metal',
      'status': 'Pending Verification',
    },
    {
      'id': 'pl_2',
      'title': 'Bulk Lithium-ion Battery Cells (Grade B)',
      'seller': 'ElectroCycle Labs',
      'price': '₹8,200',
      'category': 'E-Waste',
      'status': 'Hazardous Flagged',
    },
    {
      'id': 'pl_3',
      'title': 'Shredded HDPE Agricultural Pipes (100 kg)',
      'seller': 'Krishi Upcycle',
      'price': '₹3,200',
      'category': 'Plastic',
      'status': 'Pending Verification',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Waste2Worth Admin Portal',
          style: AppTypography.titleLarge.copyWith(fontSize: 18),
        ),
        backgroundColor: AppColors.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Admin KPI cards
            Row(
              children: [
                _buildAdminMetric(
                  'Active Listings',
                  '1,428',
                  Icons.storefront_rounded,
                  AppColors.primary,
                ),
                const SizedBox(width: 12),
                _buildAdminMetric(
                  'Verified Hubs',
                  '86',
                  Icons.verified_rounded,
                  AppColors.accentIndigo,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildAdminMetric(
                  'Gross Recycled',
                  '42.8 Tons',
                  Icons.eco_rounded,
                  AppColors.accentTeal,
                ),
                const SizedBox(width: 12),
                _buildAdminMetric(
                  'Platform Escrow',
                  '₹4.2 Lakh',
                  Icons.account_balance_rounded,
                  AppColors.accentAmber,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // System Integration Status (FastAPI Nikunj + YOLO Himanshu)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'System Architecture & Pipeline Status',
                    style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  _buildStatusRow(
                    'FastAPI Backend (Nikunj)',
                    'Online • 42ms response',
                    Colors.green,
                  ),
                  const Divider(height: 16),
                  _buildStatusRow(
                    'MongoDB Atlas Cluster',
                    'Connected • 12 collections',
                    Colors.green,
                  ),
                  const Divider(height: 16),
                  _buildStatusRow(
                    'AI Vision Model (Himanshu)',
                    'YOLO-v11 active • 96.2% mAP',
                    Colors.green,
                  ),
                  const Divider(height: 16),
                  _buildStatusRow(
                    'Frontend Flutter Client (Anuj)',
                    'Phase 1-4 Complete',
                    Colors.green,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Pending Approvals Queue
            Text(
              'Moderation & Verification Queue',
              style: AppTypography.titleLarge.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 12),

            ...List.generate(_pendingListings.length, (i) {
              final item = _pendingListings[i];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                  boxShadow: AppColors.softShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item['title'],
                            style: AppTypography.titleSmall,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            item['status'],
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFD97706),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Seller: ${item['seller']} • Category: ${item['category']} • Expected: ${item['price']}',
                      style: AppTypography.bodySmall,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _pendingListings.removeAt(i);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Listing rejected and flagged')),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.error,
                            side: const BorderSide(color: AppColors.error),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          ),
                          child: const Text('Reject'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _pendingListings.removeAt(i);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Listing approved and published to marketplace!'),
                                backgroundColor: AppColors.primary,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          ),
                          child: const Text('Approve'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminMetric(String title, String val, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: AppColors.softShadow,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodySmall,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    val,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, String detail, Color indicatorColor) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: indicatorColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        Text(
          detail,
          style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
