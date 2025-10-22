import 'dart:ffi';
import 'dart:io';

/// A singleton that opens Namada FFI library exactly once.
class FfiInitService {
  static final FfiInitService _instance = FfiInitService._initialize();

  /// The loaded DynamicLibrary
  final DynamicLibrary lib;

  FfiInitService._initialize() : lib = _openLibrary();

  factory FfiInitService() => _instance;

  /// OS handling
  static DynamicLibrary _openLibrary() {
    if (Platform.isAndroid) {
      return DynamicLibrary.open('libnamada_wrapper.so');
    } else if (Platform.isIOS) {
      return DynamicLibrary.process();
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
