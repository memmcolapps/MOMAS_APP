import 'package:flutter/material.dart';
import 'package:momaspayplus/features/support/data/mock/mock_tickets.dart';
import 'package:momaspayplus/features/support/screens/all_tickets_screen.dart';
import 'package:momaspayplus/features/support/screens/new_ticket_screen.dart';
import 'package:momaspayplus/reuseable/mo_button.dart';

import 'package:momaspayplus/screens/stack_screens/stack_screen_skeleton.dart';
import 'package:momaspayplus/features/support/widgets/ticket_card.dart';
import 'package:momaspayplus/utils/colors.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final preview = mockTickets.take(3).toList();

    return StackScreenSkeleton(
      heading: 'Support',
      body: Column(
        children: [
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AllTicketsScreen()),
                  );
                },
                style:
                    TextButton.styleFrom(foregroundColor: MoColors.mainColor),
                child: const Text('See All >')),
          ),
          ListView.separated(
            shrinkWrap: true,
            itemCount: preview.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final ticket = preview[index];
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
          const SizedBox(height: 40),
          MoButton(
            title: "Raise New Ticket",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NewTicketScreen()),
              );
            },
          )
        ],
      ),
    );
  }
}
