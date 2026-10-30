# Anywear Fitting Room · Flutter Android / iOS

[简体中文 README](README.md) · [GitHub publishing guide](docs/github-publishing.md) · [Security policy](SECURITY.md)

An independent Flutter MVP for realtime virtual try-on with Decart Lucy VTON. It supports Android and iOS native video rendering, garment image upload, localized outfit presets, editable prompts, camera switching, fullscreen playback, and lifecycle-safe disconnects. It is not a source conversion of the official Anywear Chrome extension and does not include model weights.

![Android home screen](anywear-modern-android.png)

![Android AI Key settings](docs/screenshots/key-settings-android.png)

The screenshot is from a real Android debug build. Video quality, latency, and cost depend on your Decart account, network, and device.

## Features

- Simplified Chinese, Traditional Chinese (Taiwan), and English UI.
- Realtime camera try-on with native Android/iOS rendering.
- Garment image upload, four localized presets, and custom outfit descriptions.
- Front/back camera switching and immersive fullscreen video.
- Camera permission and cloud-processing disclosure before starting.
- Automatic disconnect when the app goes to the background.
- Debug-only local test-key entry; production builds use short-lived server tokens.

## Requirements

| Component | Requirement |
| --- | --- |
| Flutter / Dart | Flutter 3.44+ / Dart 3.12+ |
| Android | API 24+, Java 17, AGP 9, Android SDK 36+ |
| iOS | iOS 17+, Swift 6.2.1+ (for example Xcode 26.1+), Swift Package Manager |
| Device | A physical device is required for realtime camera try-on |

## Local setup

```bash
flutter pub get
dart run build_runner build
cp config/development.example.json config/local.json
```

Create a temporary development key in the [Decart console](https://decart.ai), then put it in your local `config/local.json`:

```json
{
  "DECART_DEV_API_KEY": "dct_replace_with_your_temporary_test_key"
}
```

Run on a connected device:

```bash
flutter devices
flutter run -d <device-id> --dart-define-from-file=config/local.json
```

`config/local.json` and `config/production.json` are ignored by Git. Never commit a real key. Revoke and rotate a key immediately if it is exposed. In a release build, keep the permanent `dct_` credential on your backend and return a short-lived client token to the app; see [SECURITY.md](SECURITY.md).

## Decart token service

The sample `backend/token_server.py` is for private integration testing only. It expects `DECART_API_KEY` and `APP_SESSION_TOKENS`, listens on `127.0.0.1:8080` by default, validates a bearer session, rate-limits requests, and returns a short-lived token. Put it behind your own HTTPS service and replace the test allowlist with real authentication, quotas, and revocation before production.

```bash
export DECART_API_KEY='dct_your_server_only_key'
export APP_SESSION_TOKENS='local-test-session'
python3 backend/token_server.py
```

## Checks

```bash
dart run build_runner build
flutter analyze
flutter test
python3 -m unittest discover -s backend -v
flutter build apk --debug
```

See [`VALIDATION.md`](VALIDATION.md) for the current device and toolchain results. The iOS build requires a Swift toolchain compatible with Decart's native SDK.

## Repository layout

- `lib/`: Flutter application, localization, Riverpod state, and token wiring.
- `packages/decart_vton_flutter/`: pinned Flutter wrapper for Decart's native SDKs.
- `backend/`: dependency-free private token-service example.
- `config/*.example.json`: safe configuration templates.
- `anywear-modern-android.png`: public README screenshot.

## License and third-party code

This project uses the [MIT License](LICENSE), which permits copying, modification, commercial use, and redistribution when the copyright and license notice are retained. The embedded Flutter wrapper keeps its upstream MIT license in [`packages/decart_vton_flutter/LICENSE`](packages/decart_vton_flutter/LICENSE). See [`THIRD_PARTY_LICENSES.txt`](THIRD_PARTY_LICENSES.txt) for attribution details. Decart trademarks, APIs, pricing, and account terms remain subject to Decart's current documentation and terms.
