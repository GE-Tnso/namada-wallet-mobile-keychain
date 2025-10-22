import 'package:flutter/material.dart';

/// Primary input
class PrimaryInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;

  const PrimaryInput({
    Key? key,
    required this.controller,
    required this.label,
    required this.hint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2B2930),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: TextField(
          controller: controller,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'SpaceGrotesk',
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.start,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Color(0xFFFFFF00)),
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
