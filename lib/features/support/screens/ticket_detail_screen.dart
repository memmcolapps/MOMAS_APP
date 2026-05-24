import 'package:flutter/material.dart';
import 'package:momaspayplus/features/support/data/mock/mock_messages.dart';
import 'package:momaspayplus/features/support/data/models/chat_message.dart';
import 'package:momaspayplus/features/support/data/models/ticket_model.dart';
import 'package:momaspayplus/features/support/widgets/chat_bubble.dart';
import 'package:momaspayplus/features/support/widgets/chat_input_bar.dart';
import 'package:momaspayplus/screens/stack_screens/stack_screen_skeleton.dart';
import 'package:momaspayplus/utils/colors.dart';
import 'package:momaspayplus/utils/text/text_styles.dart';

class TicketDetailScreen extends StatefulWidget {
  const TicketDetailScreen({
    super.key,
    required this.ticketId,
    required this.issueType,
    required this.dateCreated,
    required this.status,
  });

  final String ticketId;
  final String issueType;
  final String dateCreated;
  final TicketStatus status;

  @override
  State<TicketDetailScreen> createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();

  bool get _isChatDisabled => widget.status == TicketStatus.resolved;
  late List<ChatMessage> _messages;

  @override
  void initState() {
    super.initState();
    _messages = mockMessages[widget.ticketId] ?? [];
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    // TODO: hook into your BLoC/provider/cubit
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return StackScreenSkeleton(
      heading: '${widget.issueType} ${widget.ticketId}',
      body: Column(
        children: [
          // Ticket header card — expands to fill available space
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 36),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: MoColors.cardBg,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE4E7EC), width: 1),
              ),
              child: Column(
                children: [
                  // Issue type + date row
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFE4E7EC),
                            width: 1.5,
                          ),
                        ),
                        child: const Icon(
                          Icons.error_outline_rounded,
                          size: 18,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.issueType,
                            style: AppTextStyles.ticketHeading.copyWith(
                              color: MoColors.mainColor,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Date: ${widget.dateCreated}',
                            style: AppTextStyles.ticketInfo.copyWith(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Chat list fills remaining card space
                  Expanded(
                    child: _messages.isEmpty
                        ? const SizedBox.shrink()
                        : ListView.builder(
                            controller: _scrollController,
                            padding: EdgeInsets.zero,
                            itemCount: _messages.length,
                            itemBuilder: (context, index) {
                              final msg = _messages[index];
                              return ChatBubble(
                                message: msg.text,
                                timeAgo: msg.timeAgo,
                                isSender: msg.isSender,
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),

          // Input bar or disabled label
          if (_isChatDisabled)
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 16,
                top: 16,
              ),
              child: Text(
                'chat disabled',
                style: AppTextStyles.ticketInfo.copyWith(
                  fontStyle: FontStyle.italic,
                  fontSize: 14,
                ),
              ),
            )
          else
            ChatInputBar(
              controller: _messageController,
              onSend: _sendMessage,
            ),
        ],
      ),
    );
  }
}
