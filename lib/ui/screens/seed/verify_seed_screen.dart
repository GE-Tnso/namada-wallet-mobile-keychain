import 'dart:math';
import 'package:flutter/material.dart';
import 'package:namadawallet/ui/screens/seed/set_keys_name_screen.dart';
import 'package:namadawallet/widgets/appbar/primary_appbar.dart';
import 'package:namadawallet/widgets/inputs/primary_input.dart';

class VerifySeedScreen extends StatefulWidget {
  final List<String> seedWords;
  const VerifySeedScreen({Key? key, required this.seedWords}) : super(key: key);

  @override
  _VerifySeedScreenState createState() => _VerifySeedScreenState();
}

class _VerifySeedScreenState extends State<VerifySeedScreen> {
  final TextEditingController _wordController1 = TextEditingController();
  final TextEditingController _wordController2 = TextEditingController();

  bool _isConfirmationButtonEnabled = false;
  late int _randomIndex1;
  late int _randomIndex2;

  @override
  void initState() {
    super.initState();
    _generateRandomVerificationIndexes();
  }

  void _generateRandomVerificationIndexes() {
    final random = Random();
    final int totalWords = widget.seedWords.length;
    _randomIndex1 = random.nextInt(totalWords);
    do {
      _randomIndex2 = random.nextInt(totalWords);
    } while (_randomIndex2 == _randomIndex1);

    _wordController1.addListener(_updateButtonState);
    _wordController2.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    final isFilled =
        _wordController1.text.isNotEmpty && _wordController2.text.isNotEmpty;
    if (isFilled != _isConfirmationButtonEnabled) {
      setState(() {
        _isConfirmationButtonEnabled = isFilled;
      });
    }
  }

  void _verifySeedWords() {
    final String userWord1 = _wordController1.text.trim();
    final String userWord2 = _wordController2.text.trim();

    final String correctWord1 = widget.seedWords[_randomIndex1];
    final String correctWord2 = widget.seedWords[_randomIndex2];

    // check case-insensitively if the entries match.
    if (userWord1.toLowerCase() == correctWord1.toLowerCase() &&
        userWord2.toLowerCase() == correctWord2.toLowerCase()) {
      // if correct, pass the seed words to the next screen.
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SetKeysNameScreen(seedWords: widget.seedWords),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Incorrect seed words. Please try again.")),
      );
    }
  }

  @override
  void dispose() {
    _wordController1.dispose();
    _wordController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D1B20),
      appBar: PrimaryAppBar(
        title: 'New Seed Phrase: Step 3 of 5',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              alignment: Alignment.center,
              child: const Text(
                "Please confirm your seed phrase by entering the correct words for the positions indicated below:",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'SpaceGrotesk',
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // Display first randomly chosen word's position.
            PrimaryInput(
              controller: _wordController1,
              label: "Word #${_randomIndex1 + 1}",
              hint: "Type the seed word for position ${_randomIndex1 + 1}",
            ),
            // Display second randomly chosen word's position.
            PrimaryInput(
              controller: _wordController2,
              label: "Word #${_randomIndex2 + 1}",
              hint: "Type the seed word for position ${_randomIndex2 + 1}",
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFFF00),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _verifySeedWords,
                child: const Center(
                  child: Text(
                    "Verify Seed Phrase",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'SpaceGrotesk',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
