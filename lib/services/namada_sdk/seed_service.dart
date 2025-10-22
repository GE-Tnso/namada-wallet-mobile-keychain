import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:namadawallet/services/namada_sdk/ffi_init_service.dart';

typedef GenerateSeedPhraseC = Pointer<Utf8> Function();
typedef GenerateSeedPhraseDart = Pointer<Utf8> Function();

typedef GenerateSeedPhrase24C = Pointer<Utf8> Function();
typedef GenerateSeedPhrase24Dart = Pointer<Utf8> Function();

typedef FreeStringC = Void Function(Pointer<Utf8>);
typedef FreeStringDart = void Function(Pointer<Utf8>);

class SeedService {
  /// Generates a 12-word seed phrase by calling the Rust FFI function.
  static Future<String> generateSeedPhrase12() async {
    final dylib = FfiInitService().lib;

    final GenerateSeedPhraseDart generateSeedPhrase = dylib
        .lookup<NativeFunction<GenerateSeedPhraseC>>("generate_seed_phrase")
        .asFunction();
    final FreeStringDart freeString =
        dylib.lookup<NativeFunction<FreeStringC>>("free_string").asFunction();

    final Pointer<Utf8> resultPtr = generateSeedPhrase();
    final String result = resultPtr.toDartString();
    freeString(resultPtr);
    return result;
  }

  /// Generates a 24-word seed phrase by calling the Rust FFI function.
  static Future<String> generateSeedPhrase24() async {
    final dylib = FfiInitService().lib;

    final GenerateSeedPhrase24Dart generateSeedPhrase24 = dylib
        .lookup<NativeFunction<GenerateSeedPhrase24C>>(
            "generate_seed_phrase_24")
        .asFunction();
    final FreeStringDart freeString =
        dylib.lookup<NativeFunction<FreeStringC>>("free_string").asFunction();

    final Pointer<Utf8> resultPtr = generateSeedPhrase24();
    final String result = resultPtr.toDartString();
    freeString(resultPtr);
    return result;
  }
}
