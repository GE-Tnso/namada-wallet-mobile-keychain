import 'package:flutter/material.dart';

class WarningCard extends StatelessWidget {
  const WarningCard({super.key});

  static const _warningTextStyle = TextStyle(
    color: Color(0xFFFFFF00),
    fontSize: 14,
    fontFamily: 'SpaceGrotesk',
    fontWeight: FontWeight.w600,
  );

  static const _bodyTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontFamily: 'SpaceGrotesk',
    fontWeight: FontWeight.w600,
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.all(12),
      color: const Color(0xFF2B2930),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Align(
              alignment: Alignment.center,
              child: Icon(Icons.warning_rounded,
                  size: 40, color: Color(0xFFFFFF00)),
            ),
            SizedBox(height: 8),
            Text(
              "DO NOT share your seed phrase with ANYONE",
              style: _warningTextStyle,
            ),
            SizedBox(height: 8),
            Text(
              "Enter your seed phrase in the right order without capitalisation, punctuation symbols or spaces. Or copy and paste your entire phrase.",
              style: _bodyTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
