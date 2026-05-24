import 'package:flutter/material.dart';
import 'package:momaspayplus/utils/colors.dart';
import 'package:momaspayplus/utils/text/text_styles.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
    required this.timeAgo,
    required this.isSender,
  });

  final String message;
  final String timeAgo;
  final bool isSender;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: isSender ? 0 : 48, // receiver: full width; sender: indent right
        right: isSender ? 48 : 0, // sender: full width; receiver: indent left
        bottom: 12,
      ),
      child: Column(
        crossAxisAlignment:
            isSender ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: isSender ? MoColors.mainColor : Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              message,
              style: AppTextStyles.ticketText.copyWith(
                color: isSender ? Colors.white : Colors.black,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            timeAgo,
            style: AppTextStyles.ticketInfo.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
