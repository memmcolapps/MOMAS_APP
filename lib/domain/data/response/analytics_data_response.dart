import 'dart:ui';

import 'package:momaspayplus/domain/data/model/analytics_data/ring_data.dart';
import 'package:momaspayplus/utils/colors.dart';

class AnalysisResponse {
  final bool status;
  final String? message;
  final AnalysisData data;

  AnalysisResponse({
    required this.status,
    this.message,
    required this.data,
  });

  factory AnalysisResponse.fromJson(Map<String, dynamic> json) {
    return AnalysisResponse(
      status: json['status'] ?? false,
      message: json['message'],
      data: AnalysisData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'data': data.toJson(),
    'message': message,
  };
}

class AnalysisData {
  final String selectedYear;
  final double totalMonthAmount;
  final double monthChangePercent;
  final List<MonthlyTransaction> byYear;
  final List<ServiceTypeMetric> byServiceType;
  final List<TokenStatusBreakdown> tokenStatusBreakdown;
  final List<String> availableYears;

  AnalysisData({
    required this.selectedYear,
    required this.totalMonthAmount,
    required this.monthChangePercent,
    required this.byYear,
    required this.byServiceType,
    required this.tokenStatusBreakdown,
    required this.availableYears,
  });

  factory AnalysisData.fromJson(Map<String, dynamic> json) {
    final currentYear = DateTime.now().year.toString();

    final rawYears = List<String>.from(json['available_years'] ?? []);
    final mappedYears = rawYears.map((y) => y == currentYear ? 'This year' : y).toList();
    if (!mappedYears.contains('This year')) {
      mappedYears.insert(0, 'This year');
    }

    return AnalysisData(
      selectedYear: json['year'] == currentYear ? 'This year' : json['year'],
      totalMonthAmount: (json['total_month_amount'] ?? 0).toDouble(),
      monthChangePercent: (json['month_change_percent'] ?? 0).toDouble(),
      byYear: (json['months'] as List<dynamic>? ?? [])
          .map((e) => MonthlyTransaction.fromJson(e))
          .where((t) => t.month <= DateTime.now().month)
          .toList(),
      byServiceType: (json['services'] as List<dynamic>? ?? [])
          .map((e) => ServiceTypeMetric.fromJson(e))
          .toList(),
      tokenStatusBreakdown:
      (json['token_breakdown'] as List<dynamic>? ?? [])
          .map((e) => TokenStatusBreakdown.fromJson(e))
          .toList(),
      availableYears: mappedYears,
    );
  }

  Map<String, dynamic> toJson() => {
    'selectedYear': selectedYear,
    'total_month_amount': totalMonthAmount,
    'month_change_percent': monthChangePercent,
    'months': byYear.map((e) => e.toJson()).toList(),
    'services': byServiceType.map((e) => e.toJson()).toList(),
    'token_breakdown':
    tokenStatusBreakdown.map((e) => e.toJson()).toList(),
    'available_years': availableYears,
  };
}

class TransactionAnalysisResponse {
  final bool status;
  final String? message;
  final TransactionAnalysisData data;

  TransactionAnalysisResponse({
    required this.status,
    this.message,
    required this.data,
  });

  factory TransactionAnalysisResponse.fromJson(Map<String, dynamic> json) {
    return TransactionAnalysisResponse(
      status: json['status'] ?? false,
      message: json['message'],
      data: TransactionAnalysisData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'data': data.toJson(),
    'message': message,
  };
}

class TransactionAnalysisData {
  final String selectedYear;
  final List<MonthlyTransaction> byYear;
  final List<String> availableYears;

  TransactionAnalysisData({
    required this.selectedYear,
    required this.byYear,
    required this.availableYears,
  });

  factory TransactionAnalysisData.fromJson(Map<String, dynamic> json) {
    final currentYear = DateTime.now().year.toString();

    final rawYears = List<String>.from(json['available_years'] ?? []);
    final mappedYears = rawYears.map((y) => y == currentYear ? 'This year' : y).toList();
    if (!mappedYears.contains('This year')) {
      mappedYears.insert(0, 'This year');
    }

    return TransactionAnalysisData(
      selectedYear: json['year'] == currentYear ? 'This year' : json['year'],
      byYear: (json['months'] as List<dynamic>? ?? [])
          .map((e) => MonthlyTransaction.fromJson(e))
          .toList(),
      availableYears: mappedYears,
    );
  }

  Map<String, dynamic> toJson() => {
    'selectedYear': selectedYear,
    'months': byYear.map((e) => e.toJson()).toList(),
    'available_years': availableYears,
  };
}

class UtilityMetricsResponse {
  final bool status;
  final String? message;
  final UtilityMetricsData data;

  UtilityMetricsResponse({
    required this.status,
    this.message,
    required this.data,
  });

  factory UtilityMetricsResponse.fromJson(Map<String, dynamic> json) {
    return UtilityMetricsResponse(
      status: json['status'] ?? false,
      message: json['message'],
      data: UtilityMetricsData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'data': data.toJson(),
    'message': message,
  };
}

class UtilityMetricsData {
  final String selectedYear;
  final List<ServiceTypeMetric> byServiceType;
  final List<String> availableYears;

  UtilityMetricsData({
    required this.selectedYear,
    required this.byServiceType,
    required this.availableYears,
  });

  factory UtilityMetricsData.fromJson(Map<String, dynamic> json) {
    final currentYear = DateTime.now().year.toString();

    final rawYears = List<String>.from(json['available_years'] ?? []);
    final mappedYears = rawYears.map((y) => y == currentYear ? 'This year' : y).toList();
    if (!mappedYears.contains('This year')) {
      mappedYears.insert(0, 'This year');
    }

    return UtilityMetricsData(
      selectedYear: json['year'] == currentYear ? 'This year' : json['year'],
      byServiceType: (json['services'] as List<dynamic>? ?? [])
          .map((e) => ServiceTypeMetric.fromJson(e))
          .toList(),
      availableYears: mappedYears,
    );
  }

  Map<String, dynamic> toJson() => {
    'selectedYear': selectedYear,
    'services': byServiceType.map((e) => e.toJson()).toList(),
    'available_years': availableYears,
  };

// ---- Convenience Getters ----

// /// Total transactions across all months
// int get totalTransactionCount =>
//     byYear.fold(0, (sum, m) => sum + m.transactionCount);
//
// /// Only months that have transactions (for chart filtering)
// List<MonthlyTransaction> get activeMonths =>
//     byYear.where((m) => m.transactionCount > 0).toList();

// /// Whether the monthly trend is going up
// bool get isTrendingUp => monthTrend == 'up';

// /// Total tokens across all statuses
// int get totalTokenCount =>
//     tokenStatusBreakdown.fold(0, (sum, t) => sum + t.count);

// /// [byYear] guaranteed to be in calendar order (Jan → Dec),
// /// with empty placeholder entries for any missing months.
// List<MonthlyTransaction> get byYearOrdered {
//   final indexed = {for (final m in byYear) m.month: m};
//   return List.generate(
//     12,
//         (i) =>
//     indexed[i + 1] ??
//         MonthlyTransaction(month: i + 1, totalAmount: 0, transactionCount: 0),
//   );
// }
}

class AccessTokenReportResponse {
  final bool status;
  final String? message;
  final AccessTokenReportData data;

  AccessTokenReportResponse({
    required this.status,
    this.message,
    required this.data,
  });

  factory AccessTokenReportResponse.fromJson(Map<String, dynamic> json) {
    return AccessTokenReportResponse(
      status: json['status'] ?? false,
      message: json['message'],
      data: AccessTokenReportData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'data': data.toJson(),
    'message': message,
  };
}

class AccessTokenReportData {
  final String selectedYear;
  final List<TokenStatusBreakdown> tokenStatusBreakdown;
  final List<String> availableYears;

  AccessTokenReportData({
    required this.selectedYear,
    required this.tokenStatusBreakdown,
    required this.availableYears,
  });

  factory AccessTokenReportData.fromJson(Map<String, dynamic> json) {
    final currentYear = DateTime.now().year.toString();

    final rawYears = List<String>.from(json['available_years'] ?? []);
    final mappedYears = rawYears.map((y) => y == currentYear ? 'This year' : y).toList();
    if (!mappedYears.contains('This year')) {
      mappedYears.insert(0, 'This year');
    }

    return AccessTokenReportData(
      selectedYear: json['year'] == currentYear ? 'This year' : json['year'],
      tokenStatusBreakdown:
      (json['token_breakdown'] as List<dynamic>? ?? [])
          .map((e) => TokenStatusBreakdown.fromJson(e))
          .toList(),
      availableYears: mappedYears,
    );
  }

  Map<String, dynamic> toJson() => {
    'selectedYear': selectedYear,
    'token_breakdown':
    tokenStatusBreakdown.map((e) => e.toJson()).toList(),
    'available_years': availableYears,
  };
}

class MonthlyTransaction {
  final int month;
  final double totalAmount;
  final int transactionCount;

  MonthlyTransaction({
    required this.month,
    required this.totalAmount,
    required this.transactionCount,
  });

  factory MonthlyTransaction.fromJson(Map<String, dynamic> json) {
    return MonthlyTransaction(
      month: json['month'] ?? 0,
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      transactionCount: json['transaction_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'month': month,
    'total_amount': totalAmount,
    'transaction_count': transactionCount,
  };

  bool get hasData => transactionCount > 0;
}

enum ServiceType {
  airtimeTopUp,
  dataTopUp,
  creditToken,
  creditTokenOthers,
  cableSubscription,
  unknown;

  static ServiceType fromString(String value) {
    switch (value) {
      case 'airtime_top_up':
        return ServiceType.airtimeTopUp;
      case 'data_top_up':
        return ServiceType.dataTopUp;
      case 'credit_token':
        return ServiceType.creditToken;
      case 'credit_token_others':
        return ServiceType.creditTokenOthers;
      case 'cable_subscription':
        return ServiceType.cableSubscription;
      default:
        return ServiceType.unknown;
    }
  }

  String toJsonValue() {
    switch (this) {
      case ServiceType.airtimeTopUp:
        return 'airtime_top_up';
      case ServiceType.dataTopUp:
        return 'data_top_up';
      case ServiceType.creditToken:
        return 'credit_token';
      case ServiceType.creditTokenOthers:
        return 'credit_token_others';
      case ServiceType.cableSubscription:
        return 'cable_subscription';
      case ServiceType.unknown:
        return 'unknown';
    }
  }

  String get displayName {
    switch (this) {
      case ServiceType.airtimeTopUp:
        return 'Airtime';
      case ServiceType.dataTopUp:
        return 'Data';
      case ServiceType.creditToken:
        return 'Credit Token';
      case ServiceType.creditTokenOthers:
        return 'Credit(Others)';
      case ServiceType.cableSubscription:
        return 'Cable';
      case ServiceType.unknown:
        return 'Unknown';
    }
  }
}

class ServiceTypeMetric {
  final ServiceType serviceType;
  final double totalAmount;
  final int transactionCount;
  final double changePercent;
  final String trend;

  ServiceTypeMetric({
    required this.serviceType,
    required this.totalAmount,
    required this.transactionCount,
    required this.changePercent,
    required this.trend,
  });

  factory ServiceTypeMetric.fromJson(Map<String, dynamic> json) {
    return ServiceTypeMetric(
      serviceType: ServiceType.fromString(json['service_type'] ?? ''),
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      transactionCount: json['transaction_count'] ?? 0,
      changePercent: (json['change_percent'] ?? 0).toDouble(),
      trend: json['trend'] ?? 'up',
    );
  }

  Map<String, dynamic> toJson() => {
    'service_type': serviceType.toJsonValue(),
    'total_amount': totalAmount,
    'transaction_count': transactionCount,
    'change_percent': changePercent,
    'trend': trend,
  };

  bool get isTrendingUp => trend == 'up';
  bool get hasActivity => transactionCount > 0;
}

enum TokenStatus {
  pending,
  used,
  failed,
  unknown;

  static TokenStatus fromString(String value) {
    switch (value) {
      case 'pending':
        return TokenStatus.pending;
      case 'used':
        return TokenStatus.used;
      case 'failed':
        return TokenStatus.failed;
      default:
        return TokenStatus.unknown;
    }
  }

  String toJsonValue() => name == 'unknown' ? 'unknown' : name;

  String get displayName {
    switch (this) {
      case TokenStatus.pending:
        return 'Pending';
      case TokenStatus.used:
        return 'Used';
      case TokenStatus.failed:
        return 'Failed';
      case TokenStatus.unknown:
        return 'Unknown';
    }
  }

  Color get color {
    switch (this) {
      case TokenStatus.pending:
        return MoColors.tigerOrange;
      case TokenStatus.used:
        return MoColors.glacierBlue;
      case TokenStatus.failed:
        return MoColors.flareRed;
      case TokenStatus.unknown:
        return MoColors.carbon;
    }
  }
}

class TokenStatusBreakdown {
  final TokenStatus status;
  final int count;

  TokenStatusBreakdown({
    required this.status,
    required this.count,
  });

  factory TokenStatusBreakdown.fromJson(Map<String, dynamic> json) {
    return TokenStatusBreakdown(
      status: TokenStatus.fromString(json['status'] ?? ''),
      count: json['count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status.toJsonValue(),
    'count': count,
  };

  RingData toRingData() => RingData(
    label: status.displayName,
    count: count,
    color: status.color,
  );
}