import 'package:flutter/material.dart';

class SecurityNotificationContainer extends StatelessWidget {
  final bool shouldDisplayIcon;

  const SecurityNotificationContainer({
    super.key,
    required this.shouldDisplayIcon,
  });

  // Define common text styles as static constants.
  static const TextStyle warningTextStyle = TextStyle(
    color: Color(0xFFFFFF00),
    fontSize: 14,
    fontFamily: 'SpaceGrotesk',
    fontWeight: FontWeight.w600,
  );

  static const TextStyle bodyTextStyle = TextStyle(
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
          children: [
            if (shouldDisplayIcon)
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(bottom: 8, right: 4),
                child: const Icon(
                  Icons.warning_rounded,
                  size: 40,
                  color: Color(0xFFFFFF00),
                ),
              ),
            const Text(
              "DO NOT share your seed phrase with ANYONE",
              style: warningTextStyle,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 8),
            const Text(
              "Anyone with your seed phrase can have full control over your assets.",
              style: bodyTextStyle,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 8),
            const Text(
              "Back up the phrase safely",
              style: warningTextStyle,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 8),
            const Text(
              "You will never be able to restore your account without your seed phrase.",
              style: bodyTextStyle,
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }
}
