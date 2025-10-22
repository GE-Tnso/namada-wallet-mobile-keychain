import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShieldedDummyContainer extends StatelessWidget {
  const ShieldedDummyContainer({
    required this.onSyncPressed,
    required this.shieldedBalance,
    required this.status,
    required this.isSyncing,
  });

  final VoidCallback onSyncPressed;
  final String shieldedBalance;
  final String status;
  final bool isSyncing;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2B2930), // same as other widgets
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.3), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.security, color: Colors.yellow),
              const SizedBox(width: 8),
              const Text(
                'Shielded Pool',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "This feature isn’t in the open source version. \n\nGet the full app on App Store and Google Play via namadawallet.com\n",
            style: TextStyle(color: Colors.white.withOpacity(0.78)),
          ),
          if (status.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              status,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}
