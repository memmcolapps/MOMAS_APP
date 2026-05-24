import 'package:flutter/material.dart';
import 'package:momaspayplus/features/support/data/models/ticket_model.dart';
import 'package:momaspayplus/utils/colors.dart';
import 'package:momaspayplus/utils/images.dart';

extension TicketStatusX on TicketStatus {
  Color get borderColor {
    return switch (this) {
      TicketStatus.resolved => MoColors.ticketSuccess,
      TicketStatus.pending => MoColors.ticketWarning,
      TicketStatus.newReply => MoColors.ticketWarning,
    };
  }

  String get label {
    return switch (this) {
      TicketStatus.resolved => 'Resolved',
      TicketStatus.pending => 'Pending',
      TicketStatus.newReply => 'New Reply',
    };
  }

  String get icon {
    return switch (this) {
      TicketStatus.resolved => MoImage.resolvedTicket,
      TicketStatus.pending => MoImage.pendingTicket,
      TicketStatus.newReply => MoImage.newReplyTicket,
    };
  }
}