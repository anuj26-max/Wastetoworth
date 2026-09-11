import 'package:flutter/material.dart';

enum NotificationType {
  order('Order & Pickup', Icons.local_shipping_outlined, Color(0xFF10B981), Color(0xFFECFDF5)),
  offer('Price Offer', Icons.local_offer_outlined, Color(0xFFF59E0B), Color(0xFFFEF3C7)),
  ai('AI Scan Insight', Icons.auto_awesome_outlined, Color(0xFF8B5CF6), Color(0xFFEDE9FE)),
  milestone('Eco Milestone', Icons.park_outlined, Color(0xFF0EA5E9), Color(0xFFE0F2FE));

  final String label;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;

  const NotificationType(this.label, this.icon, this.iconColor, this.bgColor);
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String timeAgo;
  final NotificationType type;
  bool isRead;
  final String? relatedItemId;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timeAgo,
    required this.type,
    this.isRead = false,
    this.relatedItemId,
  });

  NotificationItem copyWith({
    bool? isRead,
  }) {
    return NotificationItem(
      id: id,
      title: title,
      message: message,
      timeAgo: timeAgo,
      type: type,
      isRead: isRead ?? this.isRead,
      relatedItemId: relatedItemId,
    );
  }
}
