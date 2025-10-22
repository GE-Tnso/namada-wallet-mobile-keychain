import 'package:flutter/material.dart';
import 'package:namadawallet/ui/screens/seed/initial_keys_creation_screen.dart';
import 'package:namadawallet/ui/screens/seed/import_keys_screen.dart';
import 'package:namadawallet/widgets/buttons/confirmation_button.dart';

class WalletActionButtons extends StatelessWidget {
  const WalletActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ConfirmationButton(
          isEnabled: true,
          label: "Create New Keys",
          destination: InitialKeysCreationScreen(),
        ),
        ConfirmationButton(
          isEnabled: true,
          label: "Import Existing Keys",
          destination: ImportKeysScreen(),
          color: const Color(0xFF00FFFF),
        ),
      ],
    );
  }
}
