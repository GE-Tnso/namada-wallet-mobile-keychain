import 'package:flutter/material.dart';
import 'package:namadawallet/services/namada_sdk/ffi_init_service.dart';
import 'package:namadawallet/ui/screens/seed/account_created_screen.dart';
import 'package:namadawallet/widgets/appbar/primary_appbar.dart';
import 'package:namadawallet/widgets/inputs/primary_input.dart';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ffi/ffi.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef DeriveAndSaveWalletC = Pointer<Utf8> Function(Pointer<Utf8>);
typedef DeriveAndSaveWalletDart = Pointer<Utf8> Function(Pointer<Utf8>);
typedef DeriveAndSaveWalletSpendingC = Pointer<Utf8> Function(Pointer<Utf8>);
typedef DeriveAndSaveWalletSpendingDart = Pointer<Utf8> Function(Pointer<Utf8>);

typedef FreeStringC = Void Function(Pointer<Utf8>);
typedef FreeStringDart = void Function(Pointer<Utf8>);

class SetKeysNameScreen extends StatefulWidget {
  final List<String> seedWords;
  final String title;

  const SetKeysNameScreen({
    Key? key,
    required this.seedWords,
    this.title = 'New Seed Phrase: Step 4 of 5',
  }) : super(key: key);

  @override
  _SetKeysNameScreenState createState() => _SetKeysNameScreenState();
}

class _SetKeysNameScreenState extends State<SetKeysNameScreen> {
  final TextEditingController _aliasController = TextEditingController();

  final dylib = FfiInitService().lib;

  @override
  void dispose() {
    _aliasController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _prepareConfigs();
  }

  Future<String> _getWalletDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    final walletDir = Directory('${directory.path}');
    if (!(await walletDir.exists())) {
      await walletDir.create(recursive: true);
    }
    return walletDir.path;
  }

  Future<String> deriveAndSaveWallet(String alias, String seedPhrase) async {
    final walletPath = await _getWalletDirectory();
    final String input = '$walletPath::$alias::$seedPhrase';

    final DeriveAndSaveWalletDart fnDeriveAndSave = dylib
        .lookup<NativeFunction<DeriveAndSaveWalletC>>("derive_and_save_wallet")
        .asFunction();
    final FreeStringDart freeString = dylib
        .lookup<NativeFunction<FreeStringC>>("free_string")
        .asFunction();

    final Pointer<Utf8> inputPtr = input.toNativeUtf8();
    final Pointer<Utf8> resultPtr = fnDeriveAndSave(inputPtr);
    malloc.free(inputPtr);
    final String result = resultPtr.toDartString();
    freeString(resultPtr);
    print("Parsed input: alias = {$alias}, mnemonic = {$seedPhrase} ");
    return result;
  }

  Future<String> deriveAndSaveWalletSpendingKey(
    String alias,
    String seedPhrase,
  ) async {
    final walletPath = await _getWalletDirectory();
    final String input = '$walletPath::$alias::$seedPhrase';

    final DeriveAndSaveWalletSpendingDart fnDeriveAndSave = dylib
        .lookup<NativeFunction<DeriveAndSaveWalletSpendingC>>(
          "derive_and_save_wallet_spending_key",
        )
        .asFunction();
    final FreeStringDart freeString = dylib
        .lookup<NativeFunction<FreeStringC>>("free_string")
        .asFunction();

    final Pointer<Utf8> inputPtr = input.toNativeUtf8();
    final Pointer<Utf8> resultPtr = fnDeriveAndSave(inputPtr);
    malloc.free(inputPtr);
    final String result = resultPtr.toDartString();
    freeString(resultPtr);
    print("Parsed input: alias = {$alias}, mnemonic = {$seedPhrase} ");
    return result;
  }

  Future<void> _saveAliasToLocalStorage(String alias) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('wallet_alias', alias);
  }

  Future<void> _validateNextStep() async {
    final alias = _aliasController.text.trim();
    if (alias.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an alias for your wallet.')),
      );
      return;
    }

    if (alias.length > 20) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Alias must be less than 20 characters.')),
      );
      return;
    }

    _saveAliasToLocalStorage(alias);

    // Convert the seed words list into a single seed phrase string.
    final String seedPhrase = widget.seedWords.join(' ');
    final result = await deriveAndSaveWallet(alias, seedPhrase);

    if (result.contains("Bad mnemonic")) {
      await showModalBottomSheet<void>(
        backgroundColor: Color(0xFF1D1B20),
        context: context,
        isDismissible: true,
        // Prevent tap-outside to dismiss
        enableDrag: true,
        // Disable swipe-to-dismiss
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (BuildContext bc) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Wrap content height
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Error",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Invalid seed phrase. Please try another one.",
                  style: TextStyle(fontSize: 16, color: Colors.redAccent),
                ),
                const SizedBox(height: 12),
              ],
            ),
          );
        },
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (c) => AccountCreatedScreen(alias: alias)),
    );
  }

  Future<void> _prepareConfigs() async {
    try {
      final base = await _getAppDir();
      await _prepareMaspParams(base);
      final ptr = base.path.toNativeUtf8();
      malloc.free(ptr);
    } catch (e) {
    } finally {}
  }

  Future<Directory> _getAppDir() async =>
      await getApplicationDocumentsDirectory();

  Future<void> _prepareMaspParams(Directory base) async {
    final d = Directory('${base.path}/masp');
    await d.create(recursive: true);
    for (final fname in [
      'masp-convert.params',
      'masp-output.params',
      'masp-spend.params',
    ]) {
      final data = await rootBundle.load('assets/masp/$fname');
      final f = File('${d.path}/$fname');
      if (!await f.exists() || await f.length() != data.lengthInBytes) {
        await f.writeAsBytes(data.buffer.asUint8List());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D1B20),
      appBar: PrimaryAppBar(
        title: widget.title,
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
                "Fill in your wallet alias (keys name) and press Next",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'SpaceGrotesk',
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            PrimaryInput(
              controller: _aliasController,
              label: "Wallet Alias",
              hint: "e.g. namada wallet mainnet",
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFFF00),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _validateNextStep,
                child: const Center(
                  child: Text(
                    "Next",
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
