import 'package:flutter/material.dart';
import '../models/notification_item.dart';
import '../models/chat_message.dart';

class CommunicationProvider extends ChangeNotifier {
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: 'notif_1',
      title: 'Counter-Offer: ₹43,500 Received!',
      message: 'Zaire Siphron offered ₹43,500 on your listed Apple iPhone 12. Tap to review.',
      timeAgo: '5 mins ago',
      type: NotificationType.offer,
      isRead: false,
      relatedItemId: 'item_1',
    ),
    NotificationItem(
      id: 'notif_2',
      title: 'Kabadiwala Scrap Pickup Confirmed',
      message: 'GreenEarth Scrap & Recyclers will arrive at HSR Sector 3 tomorrow between 10:00 AM - 12:00 PM.',
      timeAgo: '42 mins ago',
      type: NotificationType.order,
      isRead: false,
      relatedItemId: 'fac_1',
    ),
    NotificationItem(
      id: 'notif_3',
      title: 'AI Vision Analysis Complete',
      message: 'Himanshu\'s YOLO-v11 pipeline identified 12kg Clean Copper Wire (Valued at ₹9,600).',
      timeAgo: '2 hours ago',
      type: NotificationType.ai,
      isRead: true,
      relatedItemId: 'item_3',
    ),
    NotificationItem(
      id: 'notif_4',
      title: 'Milestone: 100 kg Diverted!',
      message: 'You have prevented 84.2 kg of CO2 emissions. "Eco Pioneer" badge credited to your profile.',
      timeAgo: '1 day ago',
      type: NotificationType.milestone,
      isRead: true,
    ),
  ];

  final List<ChatConversation> _conversations = [
    ChatConversation(
      id: 'chat_1',
      participantName: 'Zaire Siphron',
      participantAvatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
      isOnline: true,
      listingTitle: 'Apple iPhone 12 128 GB, Blue',
      listingPrice: 45000,
      listingImageUrl: 'https://images.unsplash.com/photo-1605236453806-6ff36851218e?w=800',
      unreadCount: 1,
      messages: [
        ChatMessage(
          id: 'm1',
          text: 'Hi Anuj, is this iPhone 12 still available for pickup in HSR Layout?',
          timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
          isMe: false,
        ),
        ChatMessage(
          id: 'm2',
          text: 'Yes Zaire! It is in great condition, battery health 88%. Are you looking to pick it up today?',
          timestamp: DateTime.now().subtract(const Duration(minutes: 18)),
          isMe: true,
        ),
        ChatMessage(
          id: 'm3',
          text: 'Would you be willing to do ₹43,500 if I come by this evening?',
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
          isMe: false,
        ),
      ],
    ),
    ChatConversation(
      id: 'chat_2',
      participantName: 'Rajesh Metallics',
      participantAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
      isOnline: false,
      listingTitle: 'High-Grade Clean Copper Wire Scrap (12 kg)',
      listingPrice: 9600,
      listingImageUrl: 'https://images.unsplash.com/photo-1558346490-a72e53ae2d4f?w=800',
      unreadCount: 0,
      messages: [
        ChatMessage(
          id: 'm201',
          text: 'Namaste! We can purchase your 12kg copper lot at Peenya depot.',
          timestamp: DateTime.now().subtract(const Duration(hours: 3)),
          isMe: false,
        ),
        ChatMessage(
          id: 'm202',
          text: 'Great, do you have calibrated digital scales on site?',
          timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 30)),
          isMe: true,
        ),
        ChatMessage(
          id: 'm203',
          text: 'Yes certified by BBMP. Weighing slip and instant UPI payment on spot.',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          isMe: false,
        ),
      ],
    ),
    ChatConversation(
      id: 'chat_3',
      participantName: 'EcoCycle Hub',
      participantAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
      isOnline: true,
      listingTitle: 'Baled PET Plastic Flakes (50 kg)',
      listingPrice: 1500,
      listingImageUrl: 'https://images.unsplash.com/photo-1618477461853-cf6ed80faba5?w=800',
      unreadCount: 0,
      messages: [
        ChatMessage(
          id: 'm301',
          text: 'Hello, our truck can collect the 50kg PET bales tomorrow.',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          isMe: false,
        ),
      ],
    ),
  ];

  List<NotificationItem> get notifications => _notifications;
  List<ChatConversation> get conversations => _conversations;

  int get unreadNotificationCount =>
      _notifications.where((n) => !n.isRead).length;

  int get unreadMessageCount =>
      _conversations.fold(0, (sum, chat) => sum + chat.unreadCount);

  void markNotificationAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1 && !_notifications[index].isRead) {
      _notifications[index].isRead = true;
      notifyListeners();
    }
  }

  void markAllNotificationsAsRead() {
    for (var n in _notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }

  void markConversationAsRead(String conversationId) {
    final index = _conversations.indexWhere((c) => c.id == conversationId);
    if (index != -1 && _conversations[index].unreadCount > 0) {
      _conversations[index].unreadCount = 0;
      notifyListeners();
    }
  }

  void sendMessage(String conversationId, String text) {
    final index = _conversations.indexWhere((c) => c.id == conversationId);
    if (index != -1) {
      final newMsg = ChatMessage(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        text: text,
        timestamp: DateTime.now(),
        isMe: true,
      );
      _conversations[index].messages.add(newMsg);
      notifyListeners();
    }
  }

  ChatConversation getOrCreateConversationForListing({
    required String sellerName,
    required String sellerAvatar,
    required String listingTitle,
    required double listingPrice,
    required String listingImageUrl,
  }) {
    final existingIndex = _conversations.indexWhere(
      (c) => c.participantName == sellerName && c.listingTitle == listingTitle,
    );

    if (existingIndex != -1) {
      return _conversations[existingIndex];
    }

    final newConv = ChatConversation(
      id: 'chat_${DateTime.now().millisecondsSinceEpoch}',
      participantName: sellerName,
      participantAvatar: sellerAvatar,
      isOnline: true,
      listingTitle: listingTitle,
      listingPrice: listingPrice,
      listingImageUrl: listingImageUrl,
      unreadCount: 0,
      messages: [
        ChatMessage(
          id: 'init_msg',
          text: 'Hi $sellerName, I saw your listing for "$listingTitle". Is it still available?',
          timestamp: DateTime.now(),
          isMe: true,
        ),
      ],
    );

    _conversations.insert(0, newConv);
    notifyListeners();
    return newConv;
  }
}
