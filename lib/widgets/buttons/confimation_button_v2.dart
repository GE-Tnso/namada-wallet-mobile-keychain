import 'package:flutter/material.dart';

class ConfirmationButtonV2 extends StatelessWidget {
  final bool isEnabled;
  final String label;
  final VoidCallback? onPressed;

  const ConfirmationButtonV2({
    Key? key,
    required this.isEnabled,
    required this.label,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFFF00),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: isEnabled ? onPressed : null,
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'SpaceGrotesk',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
