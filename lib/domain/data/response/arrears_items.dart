import 'dart:convert';

class ArrearItem {
  final int id;
  final int estateId;
  final int userId;
  final double amount;
  final double totalAmount;
  final String duration;
  final DateTime nextDueDate;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int status;
  List<ArrearHistory>? history;

  ArrearItem({
    required this.id,
    required this.estateId,
    required this.userId,
    required this.amount,
    required this.totalAmount,
    required this.duration,
    required this.nextDueDate,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    this.history,
  });

  factory ArrearItem.fromJson(Map<String, dynamic> json) {
    return ArrearItem(
      id: json['id'],
      estateId: json['estate_id'],
      userId: json['user_id'],
      amount: double.tryParse(json['amount'] as String) ?? 0,
      totalAmount: (json['total_amount'] as num).toDouble(),
      duration: json['duration'],
      nextDueDate: DateTime.parse(json['next_due_date']),
      type: json['type'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      status: json['status'],
      history: json['history'] != null
          ? List<ArrearHistory>.from(
              json['history'].map((x) => ArrearHistory.fromJson(x)),
            )
          : null,
    );
  }
}

class ArrearHistory {
  final String amount;
  final int status;
  final DateTime createdAt;
  DateTime? nextDueDate;

  ArrearHistory(
      {required this.amount,
      required this.status,
      required this.createdAt,
      this.nextDueDate});

  factory ArrearHistory.fromJson(Map<String, dynamic> json) {
    return ArrearHistory(
        amount: json['amount'],
        status: json['status'],
        createdAt: DateTime.parse(json['created_at']),
        nextDueDate: DateTime.parse(json['next_due_date']));
  }
}
