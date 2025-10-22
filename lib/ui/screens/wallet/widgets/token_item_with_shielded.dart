import 'package:flutter/material.dart';
import 'token_item_card.dart';

class TokenItemWithShieldButton extends StatelessWidget {
  final String tokenBalance;
  final String tokenName;
  final String iconAssetPath;
  final VoidCallback onShieldPressed;

  const TokenItemWithShieldButton({
    super.key,
    required this.tokenBalance,
    required this.tokenName,
    required this.iconAssetPath,
    required this.onShieldPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TokenItemCard(
      tokenName: tokenName,
      tokenBalance: tokenBalance,
      iconAssetPath: iconAssetPath,
      onShieldPressed: onShieldPressed,
    );
  }
}
