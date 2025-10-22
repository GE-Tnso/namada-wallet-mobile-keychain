import 'package:flutter/material.dart';
import 'package:namadawallet/widgets/animations/icon_zoom_animation.dart';

class WalletHeaderSection extends StatelessWidget {
  const WalletHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(padding: EdgeInsets.all(12), child: IconZoomAnimation()),
        const SizedBox(height: 12),
        Container(
          margin: const EdgeInsets.all(12),
          alignment: Alignment.center,
          child: const Text(
            "Your Keys to Multichain Privacy",
            style: TextStyle(
              color: Color(0xFFFFFF00),
              fontSize: 16,
              fontFamily: 'SpaceGrotesk',
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }
}
