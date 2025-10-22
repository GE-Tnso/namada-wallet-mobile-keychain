import 'package:flutter/material.dart';

class ConfirmationCheckboxList extends StatelessWidget {
  const ConfirmationCheckboxList({
    super.key,
    required this.checkbox1,
    required this.checkbox2,
    required this.checkbox3,
    required this.onChanged,
  });

  final bool checkbox1;
  final bool checkbox2;
  final bool checkbox3;
  final void Function(int index, bool value) onChanged;

  static const String securityResponsibilityText =
      "I understand that I'm solely responsible for the security and backup of my wallet.";
  static const String illegalUseWarningText =
      "I understand that Namada Wallet is not a bank or exchange, and using it for illegal purposes is strictly prohibited.";
  static const String lossLiabilityDisclaimerText =
      "I understand that if I ever lose access to my wallet, Namada Wallet is not liable and cannot help in any way.";

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(unselectedWidgetColor: Colors.grey),
      child: Column(
        children: [
          _tile(1, checkbox1, securityResponsibilityText),
          _tile(2, checkbox2, illegalUseWarningText),
          _tile(3, checkbox3, lossLiabilityDisclaimerText),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  CheckboxListTile _tile(int id, bool value, String text) {
    return CheckboxListTile(
      activeColor: Colors.yellow,
      checkColor: Colors.black,
      title:
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
      value: value,
      onChanged: (val) => onChanged(id, val ?? false),
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
