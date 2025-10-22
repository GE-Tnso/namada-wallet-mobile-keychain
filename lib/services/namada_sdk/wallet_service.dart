import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:path_provider/path_provider.dart';

typedef DeriveAndSaveWalletC = Pointer<Utf8> Function(Pointer<Utf8>);
typedef DeriveAndSaveWalletDart = Pointer<Utf8> Function(Pointer<Utf8>);

typedef FreeStringC = Void Function(Pointer<Utf8>);
typedef FreeStringDart = void Function(Pointer<Utf8>);

typedef GenerateSeedPhraseC = Pointer<Utf8> Function();
typedef GenerateSeedPhraseDart = Pointer<Utf8> Function();

typedef GenerateSeedPhrase24C = Pointer<Utf8> Function();
typedef GenerateSeedPhrase24Dart = Pointer<Utf8> Function();

class WalletService {
  static DynamicLibrary _openLibrary() {
    if (Platform.isAndroid) {
      return DynamicLibrary.open('libnamada_wrapper.so');
    } else if (Platform.isIOS) {
      return DynamicLibrary.process();
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  /// Generates and save wallet to device storage.
  static Future<String> deriveAndSaveWallet(
      String alias, String seedPhrase) async {
    final walletPath = await getWalletDirectory();
    final String input = '$walletPath::$alias::$seedPhrase';
    final dylib = _openLibrary();

    final DeriveAndSaveWalletDart fnDeriveAndSave = dylib
        .lookup<NativeFunction<DeriveAndSaveWalletC>>("derive_and_save_wallet")
        .asFunction();
    final FreeStringDart freeString =
        dylib.lookup<NativeFunction<FreeStringC>>("free_string").asFunction();

    final Pointer<Utf8> inputPtr = input.toNativeUtf8();
    final Pointer<Utf8> resultPtr = fnDeriveAndSave(inputPtr);
    malloc.free(inputPtr);
    final String result = resultPtr.toDartString();
    freeString(resultPtr);
    return result;
  }

  /// Returns the path to a writable wallet directory.
  static Future<String> getWalletDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    final walletDir = Directory('${directory.path}/sdk-wallet');
    if (!(await walletDir.exists())) {
      await walletDir.create(recursive: true);
    }
    return walletDir.path;
  }
}
