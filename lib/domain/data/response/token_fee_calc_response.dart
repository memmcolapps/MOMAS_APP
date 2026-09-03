class TokenFeeCalculationResponse {
  final bool status;
  final String message;
  final TokenFeeData data;

  TokenFeeCalculationResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory TokenFeeCalculationResponse.fromJson(
      Map<String, dynamic> json) {
    return TokenFeeCalculationResponse(
      status: json['status'],
      message: json['message'],
      data: TokenFeeData.fromJson(json['data']),
    );
  }
}

class TokenFeeData {
  final num tariffAmount;
  final num vat;
  final num vatAmount;
  final num fixedCharge;
  final num afterFixedCharge;
  final num serviceFee;
  final num estateFee;
  final num afterEstateFee;
  final num vendingAmount;
  final num unit;
  final num utilityAmount;
  final num utilityOwed;
  final num afterUtility;

  TokenFeeData({
    required this.tariffAmount,
    required this.vat,
    required this.fixedCharge,
    required this.serviceFee,
    required this.estateFee,
    required this.vendingAmount,
    required this.unit,
    required this.afterEstateFee,
    required this.vatAmount,
    required this.afterFixedCharge,
    required this.utilityAmount,
    required this.utilityOwed,
    required this.afterUtility,
  });

  factory TokenFeeData.fromJson(Map<String, dynamic> json) {
    return TokenFeeData(
      tariffAmount: json['tariffAmount'] ?? 0,
      vat: json['vat'] ?? 0,
      vatAmount: json['vatAmount'] ?? 0,
      fixedCharge: json['fixedCharge'] ?? 0,
      afterFixedCharge: json['afterFixedCharge'] ?? 0,
      serviceFee: json['serviceFee'] ?? 0,
      estateFee: json['estateFee'] ?? 0,
      afterEstateFee: json['afterEstateFee'] ?? 0,
      vendingAmount: json['vendingAmount'] ?? 0,
      unit: json['unit'] ?? 0,
      utilityAmount: json['utilityAmount'] ?? 0,
      utilityOwed: json['utilityOwed'] ?? 0,
      afterUtility: json['afterUtility'] ?? 0,
    );
  }
}