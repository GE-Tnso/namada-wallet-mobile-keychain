class Balance {
  final String tokenAddress;
  final String minDenomAmount;

  Balance({
    required this.tokenAddress,
    required this.minDenomAmount,
  });

  factory Balance.fromJson(Map<String, dynamic> json) {
    return Balance(
      tokenAddress:    json['tokenAddress']   as String,
      minDenomAmount:  json['minDenomAmount'] as String,
    );
  }
}
