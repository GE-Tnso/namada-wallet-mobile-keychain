import 'package:flutter/material.dart';

class ConfirmationButton extends StatelessWidget {
  final bool isEnabled;
  final String label;
  final Widget destination;
  final Color color;

  const ConfirmationButton({
    Key? key,
    required this.isEnabled,
    required this.label,
    required this.destination,
    this.color = const Color(0xFFFFFF00),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: isEnabled
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => destination),
                );
              }
            : null,
        child: isEnabled
            ? Center(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'SpaceGrotesk',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
