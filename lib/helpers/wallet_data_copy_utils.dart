import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:namadawallet/ui/screens/wallet/wallet_screen.dart';

mixin WalletDataCopyUtils on State<WalletScreen> {
  void copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied'),
        duration: const Duration(seconds: 1),
      ),
    );
    Navigator.of(context).pop();
  }
}
