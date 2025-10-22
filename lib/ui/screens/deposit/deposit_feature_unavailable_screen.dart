import 'package:flutter/material.dart';
import 'package:namadawallet/widgets/appbar/primary_appbar.dart';

class DepositFeatureUnavailableScreen extends StatelessWidget {
  const DepositFeatureUnavailableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D1B20), // same as AccountScreen
      appBar: const PrimaryAppBar(title: 'Deposit'),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 560),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF2B2930), // same tile bg
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.withOpacity(0.3),
              width: 0.5, // same subtle stroke
            ),
          ),
          child: const Text(
            "This feature isn’t in the open source version.\n\n"
                "Get the full app on App Store and Google Play via namadawallet.com\n",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              height: 1.4,
              fontWeight: FontWeight.w700,
              fontFamily: 'SpaceGrotesk',
            ),
          ),
        ),
      ),
    );
  }
}
