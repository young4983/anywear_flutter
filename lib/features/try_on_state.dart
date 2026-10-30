import 'package:decart_vton_flutter/decart_vton_flutter.dart';
import 'package:flutter/foundation.dart';

import '../l10n/app_localizations.dart';

enum OutfitPreset { navyHoodie, whiteShirt, leatherJacket, denimJacket }

List<({String name, String prompt})> localizedOutfitPresets(
  AppLocalizations l10n,
) => [
  (name: l10n.presetNavyName, prompt: l10n.presetNavyHoodie),
  (name: l10n.presetWhiteName, prompt: l10n.presetWhiteShirt),
  (name: l10n.presetLeatherName, prompt: l10n.presetLeatherJacket),
  (name: l10n.presetDenimName, prompt: l10n.presetDenimJacket),
];

const _unchanged = Object();

@immutable
class TryOnState {
  const TryOnState({
    this.connection = VtonConnectionState.idle,
    this.quality = VtonConnectionQuality.unknown,
    this.elapsed = Duration.zero,
    required this.prompt,
    this.garmentPath,
    this.garmentName,
    this.message,
    this.presetIndex = 0,
    this.busy = false,
    this.sessionRequested = false,
  });

  final VtonConnectionState connection;
  final VtonConnectionQuality quality;
  final Duration elapsed;
  final String prompt;
  final String? garmentPath;
  final String? garmentName;
  final String? message;
  final int? presetIndex;
  final bool busy;
  final bool sessionRequested;

  bool get isLive => connection.isLive;
  bool get isInSession => connection.isInSession || sessionRequested;
  VtonOutfit get outfit => VtonOutfit(
    prompt: prompt.trim().isEmpty ? null : prompt.trim(),
    referenceImagePath: garmentPath,
    enhance: true,
  );

  TryOnState copyWith({
    VtonConnectionState? connection,
    VtonConnectionQuality? quality,
    Duration? elapsed,
    String? prompt,
    Object? garmentPath = _unchanged,
    Object? garmentName = _unchanged,
    Object? message = _unchanged,
    Object? presetIndex = _unchanged,
    bool? busy,
    bool? sessionRequested,
  }) => TryOnState(
    connection: connection ?? this.connection,
    quality: quality ?? this.quality,
    elapsed: elapsed ?? this.elapsed,
    prompt: prompt ?? this.prompt,
    garmentPath: identical(garmentPath, _unchanged)
        ? this.garmentPath
        : garmentPath as String?,
    garmentName: identical(garmentName, _unchanged)
        ? this.garmentName
        : garmentName as String?,
    message: identical(message, _unchanged) ? this.message : message as String?,
    presetIndex: identical(presetIndex, _unchanged)
        ? this.presetIndex
        : presetIndex as int?,
    busy: busy ?? this.busy,
    sessionRequested: sessionRequested ?? this.sessionRequested,
  );
}
