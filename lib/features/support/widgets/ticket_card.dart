import 'package:flutter/material.dart';
import 'package:momaspayplus/features/support/data/models/ticket_model.dart';
import 'package:momaspayplus/features/support/screens/ticket_detail_screen.dart';
import 'package:momaspayplus/utils/colors.dart';
import 'package:momaspayplus/utils/text/text_styles.dart';
import 'package:momaspayplus/features/support/utils/ticket_status_extension.dart';

class TicketCard extends StatelessWidget {
  const TicketCard({
    super.key,
    required this.ticketId,
    required this.timeAgo,
    required this.message,
    required this.status,
    required this.issueType,
    required this.dateCreated,
  });

  final String ticketId;
  final String timeAgo;
  final String message;
  final TicketStatus status;
  final String issueType;
  final String dateCreated;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TicketDetailScreen(
            ticketId: ticketId,
            issueType: issueType,
            dateCreated: dateCreated,
            status: status,
          ),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: MoColors.cardBg,
          borderRadius: BorderRadius.circular(5),
          border: Border(
            left: BorderSide(color: status.borderColor, width: 5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$issueType $ticketId', style: AppTextStyles.ticketHeading),
                Text(timeAgo, style: AppTextStyles.ticketInfo),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              message,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: AppTextStyles.ticketText,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Image.asset(status.icon, width: 16, height: 16),
                const SizedBox(width: 4),
                Text(status.label, style: AppTextStyles.ticketInfo),
              ],
            ),
          ],
        ),
      ),
    );
  }
}