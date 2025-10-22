import 'dart:math';

import 'package:flutter/material.dart';
import 'package:namadawallet/models/balance.dart';
import 'package:namadawallet/models/token_meta.dart';
import 'package:namadawallet/ui/screens/wallet/widgets/token_item_with_shielded.dart';

class TokenListView extends StatelessWidget {
  final List<Balance> balances;
  final String namTokenAddress;

  const TokenListView({required this.balances, required this.namTokenAddress});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: balances.length,
      itemBuilder: (context, index) {
        final balance = balances[index];
        final atomic = BigInt.tryParse(balance.minDenomAmount) ?? BigInt.zero;

        final dec = TokenMeta.decimalsOf(balance.tokenAddress);
        final symbol = TokenMeta.symbolOf(balance.tokenAddress);
        final iconPath = TokenMeta.iconOf(balance.tokenAddress);

        // format atomic
        final formattedAmount = (atomic.toDouble() / pow(10, dec))
            .toStringAsFixed(4);

        return TokenItemWithShieldButton(
          tokenName: symbol,
          tokenBalance: formattedAmount,
          iconAssetPath: iconPath,
          onShieldPressed: () => {},
        );
      },
    );
  }
}
