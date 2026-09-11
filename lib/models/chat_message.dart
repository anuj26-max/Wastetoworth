class ChatMessage {
  final String id;
  final String text;
  final DateTime timestamp;
  final bool isMe;
  final String? attachmentUrl;

  ChatMessage({
    required this.id,
    required this.text,
    required this.timestamp,
    required this.isMe,
    this.attachmentUrl,
  });

  String get timeFormatted {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

class ChatConversation {
  final String id;
  final String participantName;
  final String participantAvatar;
  final bool isOnline;
  final String listingTitle;
  final double listingPrice;
  final String listingImageUrl;
  final List<ChatMessage> messages;
  int unreadCount;

  ChatConversation({
    required this.id,
    required this.participantName,
    required this.participantAvatar,
    this.isOnline = true,
    required this.listingTitle,
    required this.listingPrice,
    required this.listingImageUrl,
    required this.messages,
    this.unreadCount = 0,
  });

  ChatMessage? get lastMessage => messages.isNotEmpty ? messages.last : null;
  String get formattedPrice => '₹${listingPrice.toStringAsFixed(0)}';
}
