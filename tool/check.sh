#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
flutter pub get
dart run build_runner build
flutter analyze
flutter test
python3 -m unittest discover -s backend -v
