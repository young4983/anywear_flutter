import 'dart:ui';

import 'app_localizations.dart';

/// Maps all device locales to the three locales supported by the product.
Locale appLocaleFor(Locale deviceLocale) {
  if (deviceLocale.languageCode != 'zh') return const Locale('en');
  final country = deviceLocale.countryCode?.toUpperCase();
  final script = deviceLocale.scriptCode?.toLowerCase();
  if (country == 'TW' || script == 'hant') return const Locale('zh', 'TW');
  return const Locale('zh');
}

AppLocalizations currentAppLocalizations() =>
    lookupAppLocalizations(appLocaleFor(PlatformDispatcher.instance.locale));
