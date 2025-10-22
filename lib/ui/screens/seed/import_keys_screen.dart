import 'package:flutter/material.dart';
import 'package:namadawallet/ui/screens/seed/set_keys_name_screen.dart';
import 'package:namadawallet/ui/screens/seed/widgets/policy_checkbox_list.dart';
import 'package:namadawallet/ui/screens/seed/widgets/seed_input.dart';
import 'package:namadawallet/widgets/appbar/primary_appbar.dart';

import 'widgets/warning_card.dart';
import 'widgets/import_button.dart';

class ImportKeysScreen extends StatefulWidget {
  const ImportKeysScreen({super.key});

  @override
  State<ImportKeysScreen> createState() => _ImportKeysScreenState();
}

class _ImportKeysScreenState extends State<ImportKeysScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool _checkbox1 = false;
  bool _checkbox2 = false;
  bool _checkbox3 = false;

  bool get _hasText => _controller.text.trim().isNotEmpty;

  bool get _isImportEnabled =>
      _hasText && _checkbox1 && _checkbox2 && _checkbox3;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() => setState(() {});

  void _onPaste(String text) {
    _controller.text = text;
  }

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

  void _onImport() {
    final seedWords = _controller.text.trim().split(RegExp(r'\s+'));

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SetKeysNameScreen(
          seedWords: seedWords,
          title: 'Enter Wallet Alias',
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D1B20),
      resizeToAvoidBottomInset: true,
      appBar: PrimaryAppBar(
        title: 'Import Keys',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            children: [
              const WarningCard(),
              SeedInputField(
                controller: _controller,
                focusNode: _focusNode,
                onPaste: _onPaste,
              ),
              ConfirmationCheckboxList(
                checkbox1: _checkbox1,
                checkbox2: _checkbox2,
                checkbox3: _checkbox3,
                onChanged: _onCheckboxChanged,
              ),
              if (_isImportEnabled)
                ImportButton(
                  key: const ValueKey('import_btn'),
                  isEnabled: true,
                  onPressed: _onImport,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
