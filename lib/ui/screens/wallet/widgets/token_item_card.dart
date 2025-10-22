import 'package:flutter/material.dart';

class TokenItemCard extends StatelessWidget {
  final String tokenBalance;
  final String tokenName;
  final String iconAssetPath;
  final VoidCallback? onShieldPressed;

  const TokenItemCard({
    super.key,
    required this.tokenBalance,
    required this.tokenName,
    required this.iconAssetPath,
    this.onShieldPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2B2930),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.3), width: 0.5),
      ),

      child: Row(
        children: [
          // Token icon
          SizedBox(
            width: 32,
            height: 32,
            child: Image.asset(iconAssetPath, fit: BoxFit.cover),
          ),

          const SizedBox(width: 12),

          // Token name
          Text(
            tokenName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'SpaceGrotesk',
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "$tokenBalance $tokenName",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'SpaceGrotesk',
                  fontWeight: FontWeight.w700,
                ),
              ),
              // do nothing in this version.
              if (onShieldPressed != null) ...[const SizedBox(width: 8)],
            ],
          ),
        ],
      ),
    );
  }
}
