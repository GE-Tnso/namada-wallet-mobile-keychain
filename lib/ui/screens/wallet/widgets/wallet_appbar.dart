import 'package:flutter/material.dart';
import 'package:namadawallet/ui/screens/wallet/widgets/wallet_selector.dart';

class WalletAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Wallet selected;
  final List<Wallet> wallets;
  final String transparentAddress;
  final String shieldedAddress;
  final String publicKey;
  final VoidCallback onCopyTransparent;
  final VoidCallback onCopyPublic;
  final VoidCallback onCopyShielded;
  final ValueChanged<Wallet> onWalletChanged;

  const WalletAppBar({
    required this.selected,
    required this.wallets,
    required this.transparentAddress,
    required this.shieldedAddress,
    required this.publicKey,
    required this.onCopyTransparent,
    required this.onCopyPublic,
    required this.onCopyShielded,
    required this.onWalletChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: const Color(0xFF1D1B20),
      title: WalletSelector(
        currentWallet: selected,
        allWallets: wallets,
        onWalletChanged: onWalletChanged,
        transparentAddress: transparentAddress,
        shieldedAddress: shieldedAddress,
        publicKey: publicKey,
        onCopyTransparent: onCopyTransparent,
        onCopyPublic: onCopyPublic,
        onCopyShielded: onCopyShielded,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
