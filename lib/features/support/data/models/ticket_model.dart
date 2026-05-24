enum TicketStatus { pending, resolved, newReply }

class TicketModel {
  const TicketModel({
    required this.ticketId,
    required this.issueType,
    required this.dateCreated,
    required this.timeAgo,
    required this.message,
    required this.status,
  });

  final String ticketId;    
  final String issueType;  
  final String dateCreated; 
  final String timeAgo;
  final String message;
  final TicketStatus status;

  // 'Meter Issue #00142' — composed for display
  String get displayTitle => '$issueType $ticketId';
}