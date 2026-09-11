import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../providers/app_state.dart';
import '../providers/communication_provider.dart';
import '../screens/notifications/notifications_screen.dart';
import '../screens/messages/messages_screen.dart';

class AppHeader extends StatelessWidget {
  final VoidCallback? onChatTap;
  final VoidCallback? onNotificationTap;

  const AppHeader({
    super.key,
    this.onChatTap,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final comm = Provider.of<CommunicationProvider>(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppColors.surface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Location Selector (matches reference screenshot "Bangalore ▾")
          PopupMenuButton<String>(
            initialValue: appState.selectedCity,
            onSelected: (city) => appState.setSelectedCity(city),
            offset: const Offset(0, 38),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.location_on,
                  size: 18,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  appState.selectedCity,
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 2),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 20,
                  color: AppColors.textPrimary,
                ),
              ],
            ),
            itemBuilder: (context) {
              return appState.availableCities.map((city) {
                return PopupMenuItem<String>(
                  value: city,
                  child: Row(
                    children: [
                      Icon(
                        city == appState.selectedCity
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        size: 16,
                        color: city == appState.selectedCity
                            ? AppColors.primary
                            : AppColors.textMuted,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        city,
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: city == appState.selectedCity
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: city == appState.selectedCity
                              ? AppColors.primary
                              : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList();
            },
          ),

          // Right action icons (Chat & Notifications with live badges)
          Row(
            children: [
              // Notification Icon
              Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_none_rounded,
                      color: AppColors.textPrimary,
                      size: 24,
                    ),
                    onPressed: onNotificationTap ??
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const NotificationsScreen(),
                            ),
                          );
                        },
                  ),
                  if (comm.unreadNotificationCount > 0)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Center(
                          child: Text(
                            '${comm.unreadNotificationCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              // Chat Icon (matches reference screenshot speech bubble)
              Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.chat_bubble_outline_rounded,
                      color: AppColors.textPrimary,
                      size: 22,
                    ),
                    onPressed: onChatTap ??
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MessagesScreen(),
                            ),
                          );
                        },
                  ),
                  if (comm.unreadMessageCount > 0)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Center(
                          child: Text(
                            '${comm.unreadMessageCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
