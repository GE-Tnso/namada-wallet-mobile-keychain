// lib/widgets/copy_seed_button.dart

import 'package:flutter/material.dart';

class CopySeedButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final IconData icon;
  final EdgeInsetsGeometry padding;

  const CopySeedButton({
    Key? key,
    required this.onTap,
    this.label = 'Copy seed to clipboard',
    this.icon = Icons.copy,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: padding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                icon,
                color: const Color(0xFFFFFF00),
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFFFFFF00),
                  fontSize: 14,
                  fontFamily: 'SpaceGrotesk',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
