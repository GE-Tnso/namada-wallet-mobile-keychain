import 'package:flutter/material.dart';
import 'package:namadawallet/widgets/buttons/confimation_button_v2.dart';

class ImportButton extends StatelessWidget {
  const ImportButton({
    super.key,
    required this.isEnabled,
    required this.onPressed,
  });

  final bool isEnabled;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ConfirmationButtonV2(
      isEnabled: isEnabled,
      label: 'Import',
      onPressed: onPressed,
    );
  }
}
