import 'package:flutter/material.dart';
import 'package:namadawallet/ui/screens/wallet/wallet_setup_screen.dart';
import 'package:namadawallet/ui/screens/wallet/widgets/keys_modal.dart';

/// Model for a wallet entry.
class Wallet {
  final String id;
  final String name;
  final Widget icon;

  Wallet({required this.id, required this.name, required this.icon});
}

/// A standalone widget that displays the current wallet and,
/// on tap, shows a modal to select another one (and action buttons).
class WalletSelector extends StatelessWidget {
  /// The currently selected wallet.
  final Wallet currentWallet;

  /// All available wallets to choose from.
  final List<Wallet> allWallets;

  /// Called when the user picks a different wallet.
  final ValueChanged<Wallet> onWalletChanged;

  /// Data & callbacks for “View Keys”
  final String transparentAddress;
  final String publicKey;
  final String shieldedAddress;

  final VoidCallback onCopyTransparent;
  final VoidCallback onCopyPublic;
  final VoidCallback onCopyShielded;

  const WalletSelector({
    Key? key,
    required this.currentWallet,
    required this.allWallets,
    required this.onWalletChanged,
    required this.transparentAddress,
    required this.shieldedAddress,
    required this.publicKey,
    required this.onCopyTransparent,
    required this.onCopyPublic,
    required this.onCopyShielded,
  }) : super(key: key);

  void _showWalletModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1D1B20),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    const Text(
                      'Your Keys',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'SpaceGrotesk',
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.yellow),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
              ),

              // Wallet list
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: allWallets.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) {
                  final w = allWallets[i];
                  return Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF2B2930),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.3),
                        width: 0.5,
                      ),
                    ),
                    child: ListTile(
                      horizontalTitleGap: 8,
                      leading: w.icon,
                      title: Text(
                        w.name,
                        style: const TextStyle(color: Colors.white),
                      ),
                      trailing: w.id == currentWallet.id
                          ? const Icon(Icons.check, color: Colors.yellow)
                          : null,
                      onTap: () {
                        Navigator.of(ctx).pop();
                        if (w.id != currentWallet.id) {
                          onWalletChanged(w);
                        }
                      },
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),
              const Divider(color: Colors.white24),
              const SizedBox(height: 8),

              _buildActionItem(
                ctx,
                label: 'Add Keys',
                icon: Icons.add_circle_outline,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => WalletSetupScreen()),
                  );
                },
              ),

              _buildActionItem(
                ctx,
                label: 'View Keys',
                icon: Icons.vpn_key,
                onTap: () {
                  Navigator.of(ctx).pop();
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    backgroundColor: const Color(0xFF1D1B20),
                    isScrollControlled: true,
                    builder: (_) => KeysModal(
                      transparentAddress: transparentAddress,
                      shieldedAddress: shieldedAddress,
                      publicKey: publicKey,
                      onCopyTransparent: onCopyTransparent,
                      onCopyPublic: onCopyPublic,
                      onCopyShielded: onCopyShielded,
                    ),
                  );
                },
              ),

              _buildActionItem(
                ctx,
                label: 'View Seed Phrase',
                icon: Icons.visibility,
                onTap: () {
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "View seed will be available in the next app version.",
                      ),
                      duration: Duration(milliseconds: 1000),
                    ),
                  );
                },
              ),
              _buildActionItem(
                ctx,
                label: 'Rename',
                icon: Icons.edit,
                onTap: () {
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Rename coming soon :)"),
                      duration: Duration(milliseconds: 1000),
                    ),
                  );
                },
              ),
              _buildActionItem(
                ctx,
                label: 'Delete',
                icon: Icons.delete_outline,
                labelColor: Colors.redAccent,
                onTap: () {
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Delete coming soon :)"),
                      duration: Duration(milliseconds: 1000),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionItem(
    BuildContext ctx, {
    required String label,
    required VoidCallback onTap,
    IconData? icon,
    Color labelColor = Colors.white,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF2B2930),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.3), width: 0.5),
      ),
      child: ListTile(
        horizontalTitleGap: 8,
        leading: icon != null ? Icon(icon, color: labelColor, size: 24) : null,
        title: Text(label, style: TextStyle(color: labelColor, fontSize: 14)),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Ink(
        decoration: BoxDecoration(
          color: const Color(0xFF2B2930),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withOpacity(0.3), width: 0.5),
        ),
        child: InkWell(
          onTap: () => _showWalletModal(context),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                currentWallet.icon,
                const SizedBox(width: 8),
                Text(
                  currentWallet.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.keyboard_arrow_down, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
