
# namada-mobile-wallet-keychain
Namada wallet for iOS and Android.

## How does it look like?
<img src="assets/demo.gif" alt="Demo" width="360">

## Features
- Key management: create, import.
- Transparent assets balance with a refresh logic.
- Custom UI components and original UX/UI flow.

## Architecture
Flutter UI → FFI bridge → Mobile SDK wrapper → Namada SDK.

- **Flutter**: app screens, state, and UX
- **FFI**: low level bridge between Dart and Rust code.
- **Mobile SDK wrapper**: rust wrapper built on top of the official Namada SDK crates.




## How to build
0. Install the actual version of:
- Rust
- Dart
- Flutter
- Android Studio or an equivalent toolchain for Android/iOS builds
- XCode for iOS builds


1. Clone repo from GitHub.
2. Build the mobile SDK wrapper for your hardware [namada-sdk-wrapper-keychain](https://github.com/GE-Tnso/namada-sdk-wrapper-keychain)
3. Add compiled library to the path:

Android
- `android../jniLibs/arm64-v8a/libnamada_wrapper.so`
- `android../jniLibs/x86_64/libnamada_wrapper.so`

iOS
- `ios../RustLib/libnamada_wrapper.a`
<br>

4. Build & Run

### Android
**Run (release):**
```bash
flutter run --release
```
**Build APK (release):**
```bash
flutter build apk --release
```
**Build AAB (release):**
```bash
flutter build appbundle --release
```

### iOS
**Run (release):**
```bash
flutter run --release --flavor Prod -t lib/main.dart
```
**Build IPA (release):**
```bash
flutter build ipa \
  --flavor Prod \
  -t lib/main.dart \
  --release
```


## License
Apache License 2.0 — see [LICENSE](./LICENSE) and [NOTICE](./NOTICE).
