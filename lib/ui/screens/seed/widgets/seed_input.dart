import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SeedInputField extends StatefulWidget {
  const SeedInputField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onPaste,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onPaste;

  @override
  State<SeedInputField> createState() => _SeedInputFieldState();
}

class _SeedInputFieldState extends State<SeedInputField> {
  Future<void> _handlePaste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null) widget.onPaste(data!.text!.trim());
  }

  void _dismissKeyboard() => widget.focusNode.unfocus();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2B2F),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: widget.focusNode,
                  maxLines: null,
                  keyboardAppearance: Brightness.dark,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _dismissKeyboard(),
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Enter / Paste wallet seed phrase here',
                    hintStyle: TextStyle(color: Colors.white54),
                    hintMaxLines: 2,
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: _handlePaste,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00FFFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 0,
              ),
              child: const Text(
                'Paste',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
