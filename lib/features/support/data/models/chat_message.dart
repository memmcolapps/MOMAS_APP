class ChatMessage {
  const ChatMessage({
    required this.text,
    required this.timeAgo,
    required this.isSender,
  });

  final String text;
  final String timeAgo;
  final bool isSender;
}