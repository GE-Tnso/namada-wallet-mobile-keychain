import 'package:flutter/material.dart';

/// A bottom sheet that shows wallet keys.
class KeysModal extends StatelessWidget {
  /// The transparent address to display.
  final String transparentAddress;

  /// The shielded address to display.
  final String shieldedAddress;

  /// The public key to display.
  final String publicKey;

  /// Called when the user taps the copy icon next to the transparent address.
  final VoidCallback onCopyTransparent;

  /// Called when the user taps the copy icon next to the public key.
  final VoidCallback onCopyPublic;

  /// Called when the user taps the copy icon next to the transparent address.
  final VoidCallback onCopyShielded;

  const KeysModal({
    Key? key,
    required this.transparentAddress,
    required this.shieldedAddress,
    required this.publicKey,
    required this.onCopyTransparent,
    required this.onCopyPublic,
    required this.onCopyShielded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ───────────────────────────────────────────────
          Row(
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
                tooltip: 'Close',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ── Transparent Address ───────────────────────────────────
          const Text('Transparent Address',
              style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          _KeyRow(
            value: transparentAddress,
            onCopy: onCopyTransparent,
            copyTooltip: 'Copy Transparent Address',
          ),
          const SizedBox(height: 16),

          // ── Public Key ────────────────────────────────────────────
          const Text('Public Key', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          _KeyRow(
            value: publicKey,
            onCopy: onCopyPublic,
            copyTooltip: 'Copy Public Key',
          ),
          const SizedBox(height: 16),
          // ── Transparent Address ───────────────────────────────────
          const Text('Shielded Address', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          _KeyRow(
            value: shieldedAddress,
            onCopy: onCopyShielded,
            copyTooltip: 'Copy Shielded Address',
          ),
          const SizedBox(height: 16),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

/// A reusable row for displaying a key + copy icon.
class _KeyRow extends StatelessWidget {
  final String value;
  final VoidCallback onCopy;
  final String copyTooltip;

  const _KeyRow({
    Key? key,
    required this.value,
    required this.onCopy,
    required this.copyTooltip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: const Color(0xFF2B2930),
      child: Row(
        children: [
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.white)),
          ),
          IconButton(
            icon: const Icon(Icons.copy, color: Colors.yellow, size: 20),
            tooltip: copyTooltip,
            onPressed: onCopy,
          ),
        ],
      ),
    );
  }
}
