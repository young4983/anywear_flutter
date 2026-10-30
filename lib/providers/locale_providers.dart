import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../l10n/app_localizations.dart';
import '../l10n/locale_utils.dart';

part 'locale_providers.g.dart';

@Riverpod(keepAlive: true)
Locale appLocale(Ref ref) => appLocaleFor(PlatformDispatcher.instance.locale);

@Riverpod(keepAlive: true)
AppLocalizations appLocalizations(Ref ref) =>
    lookupAppLocalizations(ref.watch(appLocaleProvider));
