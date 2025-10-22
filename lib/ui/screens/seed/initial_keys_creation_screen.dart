import 'package:flutter/material.dart';
import 'package:namadawallet/ui/screens/seed/seed_screen.dart';
import 'package:namadawallet/ui/screens/seed/widgets/policy_checkbox_list.dart';
import 'package:namadawallet/ui/screens/seed/widgets/security_notification_container.dart';
import 'package:namadawallet/widgets/appbar/primary_appbar.dart';
import 'package:namadawallet/widgets/buttons/confirmation_button.dart';

class InitialKeysCreationScreen extends StatefulWidget {
  @override
  _InitialKeysCreationScreenState createState() =>
      _InitialKeysCreationScreenState();
}

class _InitialKeysCreationScreenState extends State<InitialKeysCreationScreen> {
  bool _checkbox1 = false;
  bool _checkbox2 = false;
  bool _checkbox3 = false;

  bool get _isButtonEnabled => _checkbox1 && _checkbox2 && _checkbox3;

  void _onCheckboxChanged(int index, bool value) {
    setState(() {
      switch (index) {
        case 1:
          _checkbox1 = value;
          break;
        case 2:
          _checkbox2 = value;
          break;
        case 3:
          _checkbox3 = value;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D1B20),
      appBar: PrimaryAppBar(
        title: 'New Seed Phrase: step 1 of 5',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SecurityNotificationContainer(shouldDisplayIcon: true),
            ConfirmationCheckboxList(
              checkbox1: _checkbox1,
              checkbox2: _checkbox2,
              checkbox3: _checkbox3,
              onChanged: _onCheckboxChanged,
            ),
            const SizedBox(height: 12),
            ConfirmationButton(
              isEnabled: _isButtonEnabled,
              label: "I understood, show my phrase",
              destination: const SeedWordsScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
