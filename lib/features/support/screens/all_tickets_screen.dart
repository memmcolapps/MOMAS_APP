import 'package:flutter/material.dart';
import 'package:momaspayplus/features/support/data/mock/mock_tickets.dart';
import 'package:momaspayplus/features/support/widgets/ticket_card.dart';
import 'package:momaspayplus/screens/stack_screens/stack_screen_skeleton.dart';

class AllTicketsScreen extends StatelessWidget {
  const AllTicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StackScreenSkeleton(
      heading: 'All Tickets',
      body: Column(
        children: [
          const SizedBox(height: 24),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: mockTickets.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final ticket = mockTickets[index];
                return TicketCard(
                  ticketId: ticket.ticketId,
                  timeAgo: ticket.timeAgo,
                  message: ticket.message,
                  status: ticket.status,
                  issueType: ticket.issueType,
                  dateCreated: ticket.dateCreated,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
