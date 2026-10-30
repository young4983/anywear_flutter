import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
    Locale('zh', 'TW'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Anywear'**
  String get appTitle;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Fitting Room'**
  String get appName;

  /// No description provided for @brandLabel.
  ///
  /// In en, this message translates to:
  /// **'ANYWEAR'**
  String get brandLabel;

  /// No description provided for @introTitle.
  ///
  /// In en, this message translates to:
  /// **'Wear the future.'**
  String get introTitle;

  /// No description provided for @introSubtitle.
  ///
  /// In en, this message translates to:
  /// **'AI maps your outfit ideas in real time.'**
  String get introSubtitle;

  /// No description provided for @statusReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get statusReady;

  /// No description provided for @statusConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting'**
  String get statusConnecting;

  /// No description provided for @statusPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing view'**
  String get statusPreparing;

  /// No description provided for @statusLive.
  ///
  /// In en, this message translates to:
  /// **'Live try-on'**
  String get statusLive;

  /// No description provided for @statusReconnecting.
  ///
  /// In en, this message translates to:
  /// **'Reconnecting'**
  String get statusReconnecting;

  /// No description provided for @emptyVideoTitle.
  ///
  /// In en, this message translates to:
  /// **'Your next outfit'**
  String get emptyVideoTitle;

  /// No description provided for @emptyVideoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your look will appear here after you start'**
  String get emptyVideoSubtitle;

  /// No description provided for @styleHeading.
  ///
  /// In en, this message translates to:
  /// **'Choose your style'**
  String get styleHeading;

  /// No description provided for @uploadGarment.
  ///
  /// In en, this message translates to:
  /// **'Upload garment'**
  String get uploadGarment;

  /// No description provided for @openingGallery.
  ///
  /// In en, this message translates to:
  /// **'Opening'**
  String get openingGallery;

  /// No description provided for @promptLabel.
  ///
  /// In en, this message translates to:
  /// **'Outfit description'**
  String get promptLabel;

  /// No description provided for @promptHint.
  ///
  /// In en, this message translates to:
  /// **'Describe color, material, and fit'**
  String get promptHint;

  /// No description provided for @promptExample.
  ///
  /// In en, this message translates to:
  /// **'For example: a light gray oversized hoodie with white drawstrings.'**
  String get promptExample;

  /// No description provided for @editPromptTitle.
  ///
  /// In en, this message translates to:
  /// **'Adjust outfit description'**
  String get editPromptTitle;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @myGarment.
  ///
  /// In en, this message translates to:
  /// **'My garment'**
  String get myGarment;

  /// No description provided for @startTryOn.
  ///
  /// In en, this message translates to:
  /// **'Start try-on'**
  String get startTryOn;

  /// No description provided for @stopTryOn.
  ///
  /// In en, this message translates to:
  /// **'Stop try-on'**
  String get stopTryOn;

  /// No description provided for @cloudFooter.
  ///
  /// In en, this message translates to:
  /// **'Cloud generation · Pauses automatically in background'**
  String get cloudFooter;

  /// No description provided for @consentTitle.
  ///
  /// In en, this message translates to:
  /// **'Start live try-on'**
  String get consentTitle;

  /// No description provided for @consentBody.
  ///
  /// In en, this message translates to:
  /// **'Your camera video and selected garment image will be sent to Decart cloud services to generate the try-on. Keep a network connection; stopping or backgrounding the app ends the session.'**
  String get consentBody;

  /// No description provided for @decline.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get decline;

  /// No description provided for @agreeAndStart.
  ///
  /// In en, this message translates to:
  /// **'Agree and start'**
  String get agreeAndStart;

  /// No description provided for @cannotReadImage.
  ///
  /// In en, this message translates to:
  /// **'Could not read the image. Try again or check photo permissions.'**
  String get cannotReadImage;

  /// No description provided for @backToFittingRoom.
  ///
  /// In en, this message translates to:
  /// **'Back to fitting room'**
  String get backToFittingRoom;

  /// No description provided for @keySettings.
  ///
  /// In en, this message translates to:
  /// **'AI Key settings'**
  String get keySettings;

  /// No description provided for @usageInfo.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get usageInfo;

  /// No description provided for @usageTitle.
  ///
  /// In en, this message translates to:
  /// **'Meet your next outfit'**
  String get usageTitle;

  /// No description provided for @usageBody.
  ///
  /// In en, this message translates to:
  /// **'Choose a preset or upload a garment, then start try-on and allow camera access. Keep your upper body in frame; even lighting gives more stable results.'**
  String get usageBody;

  /// No description provided for @gotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get gotIt;

  /// No description provided for @fullscreen.
  ///
  /// In en, this message translates to:
  /// **'View full screen'**
  String get fullscreen;

  /// No description provided for @exitFullscreen.
  ///
  /// In en, this message translates to:
  /// **'Exit full screen'**
  String get exitFullscreen;

  /// No description provided for @viewTryOn.
  ///
  /// In en, this message translates to:
  /// **'View try-on'**
  String get viewTryOn;

  /// No description provided for @viewCamera.
  ///
  /// In en, this message translates to:
  /// **'View camera'**
  String get viewCamera;

  /// No description provided for @switchCamera.
  ///
  /// In en, this message translates to:
  /// **'Switch camera'**
  String get switchCamera;

  /// No description provided for @networkUnstable.
  ///
  /// In en, this message translates to:
  /// **'Network is unstable; video may be delayed'**
  String get networkUnstable;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get openSettings;

  /// No description provided for @keyConfigured.
  ///
  /// In en, this message translates to:
  /// **'A Key is configured'**
  String get keyConfigured;

  /// No description provided for @keyNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'No Key configured'**
  String get keyNotConfigured;

  /// No description provided for @keyStorageBody.
  ///
  /// In en, this message translates to:
  /// **'The new Key is encrypted on this device. Saving stops the current try-on; it takes effect the next time you start.'**
  String get keyStorageBody;

  /// No description provided for @readingConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Reading configuration…'**
  String get readingConfiguration;

  /// No description provided for @keyStorageReadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not read the saved Key. Please save it again.'**
  String get keyStorageReadFailed;

  /// No description provided for @apiKeyLabel.
  ///
  /// In en, this message translates to:
  /// **'Decart API Key'**
  String get apiKeyLabel;

  /// No description provided for @showKey.
  ///
  /// In en, this message translates to:
  /// **'Show entered Key'**
  String get showKey;

  /// No description provided for @hideKey.
  ///
  /// In en, this message translates to:
  /// **'Hide entered Key'**
  String get hideKey;

  /// No description provided for @clearKey.
  ///
  /// In en, this message translates to:
  /// **'Clear current Key'**
  String get clearKey;

  /// No description provided for @saveKey.
  ///
  /// In en, this message translates to:
  /// **'Save Key'**
  String get saveKey;

  /// No description provided for @savingKey.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get savingKey;

  /// No description provided for @enterNewKey.
  ///
  /// In en, this message translates to:
  /// **'Enter a new Decart API Key.'**
  String get enterNewKey;

  /// No description provided for @invalidKey.
  ///
  /// In en, this message translates to:
  /// **'Enter a complete Decart API Key beginning with dct_.'**
  String get invalidKey;

  /// No description provided for @releaseBackendOnly.
  ///
  /// In en, this message translates to:
  /// **'Release builds use server-issued try-on credentials.'**
  String get releaseBackendOnly;

  /// No description provided for @keySaved.
  ///
  /// In en, this message translates to:
  /// **'AI Key saved. Tap Start try-on to use it.'**
  String get keySaved;

  /// No description provided for @keyCleared.
  ///
  /// In en, this message translates to:
  /// **'AI Key cleared. Add one in settings before starting try-on.'**
  String get keyCleared;

  /// No description provided for @disconnectBeforeKey.
  ///
  /// In en, this message translates to:
  /// **'The try-on session has not disconnected. Stop it before changing the Key.'**
  String get disconnectBeforeKey;

  /// No description provided for @permissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Camera permission is required for try-on. Allow camera access in system settings.'**
  String get permissionRequired;

  /// No description provided for @pausedMessage.
  ///
  /// In en, this message translates to:
  /// **'Try-on paused. Tap Start try-on to continue.'**
  String get pausedMessage;

  /// No description provided for @connectionTimeout.
  ///
  /// In en, this message translates to:
  /// **'Connection timed out. Check your network and try again.'**
  String get connectionTimeout;

  /// No description provided for @networkFailure.
  ///
  /// In en, this message translates to:
  /// **'Network connection failed. Check your network and try again.'**
  String get networkFailure;

  /// No description provided for @cameraUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Camera is temporarily unavailable. Use a physical device and close other camera apps.'**
  String get cameraUnavailable;

  /// No description provided for @invalidApiKey.
  ///
  /// In en, this message translates to:
  /// **'Try-on authorization failed. Check your account and quota.'**
  String get invalidApiKey;

  /// No description provided for @tryOnConnectionError.
  ///
  /// In en, this message translates to:
  /// **'Try-on connection encountered a problem. Stop and try again.'**
  String get tryOnConnectionError;

  /// No description provided for @operationFailed.
  ///
  /// In en, this message translates to:
  /// **'The operation could not be completed. Try again later.'**
  String get operationFailed;

  /// No description provided for @backendConfigConflict.
  ///
  /// In en, this message translates to:
  /// **'Development configuration conflicts. Choose only one connection method.'**
  String get backendConfigConflict;

  /// No description provided for @releaseConfigError.
  ///
  /// In en, this message translates to:
  /// **'Release builds must use the server login and temporary credential endpoint.'**
  String get releaseConfigError;

  /// No description provided for @invalidDevelopmentCredential.
  ///
  /// In en, this message translates to:
  /// **'The development credential format is invalid.'**
  String get invalidDevelopmentCredential;

  /// No description provided for @serviceNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Try-on service is not configured. Contact the app developer.'**
  String get serviceNotConfigured;

  /// No description provided for @noDevelopmentKey.
  ///
  /// In en, this message translates to:
  /// **'Add a Key from AI Key settings at the top before starting try-on.'**
  String get noDevelopmentKey;

  /// No description provided for @saveKeyFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save the Key. Try again later.'**
  String get saveKeyFailed;

  /// No description provided for @presetNavyHoodie.
  ///
  /// In en, this message translates to:
  /// **'Navy blue cotton hoodie with white drawstrings and a relaxed fit.'**
  String get presetNavyHoodie;

  /// No description provided for @presetWhiteShirt.
  ///
  /// In en, this message translates to:
  /// **'Crisp white cotton Oxford shirt with a button-down collar.'**
  String get presetWhiteShirt;

  /// No description provided for @presetLeatherJacket.
  ///
  /// In en, this message translates to:
  /// **'Black motorcycle leather jacket with silver metal zippers.'**
  String get presetLeatherJacket;

  /// No description provided for @presetDenimJacket.
  ///
  /// In en, this message translates to:
  /// **'Light blue relaxed-fit denim jacket.'**
  String get presetDenimJacket;

  /// No description provided for @presetNavyName.
  ///
  /// In en, this message translates to:
  /// **'Navy hoodie'**
  String get presetNavyName;

  /// No description provided for @presetWhiteName.
  ///
  /// In en, this message translates to:
  /// **'White shirt'**
  String get presetWhiteName;

  /// No description provided for @presetLeatherName.
  ///
  /// In en, this message translates to:
  /// **'Leather jacket'**
  String get presetLeatherName;

  /// No description provided for @presetDenimName.
  ///
  /// In en, this message translates to:
  /// **'Denim jacket'**
  String get presetDenimName;

  /// No description provided for @referencePrompt.
  ///
  /// In en, this message translates to:
  /// **'Replace the current garment with the clothing in the reference image, preserving its color, material, and style details.'**
  String get referencePrompt;

  /// No description provided for @qualityWarning.
  ///
  /// In en, this message translates to:
  /// **'Network is unstable; video may be delayed'**
  String get qualityWarning;

  /// No description provided for @keyFormatError.
  ///
  /// In en, this message translates to:
  /// **'Enter a complete Decart API Key beginning with dct_.'**
  String get keyFormatError;

  /// No description provided for @imageTooLarge.
  ///
  /// In en, this message translates to:
  /// **'Choose a garment image smaller than 5 MB.'**
  String get imageTooLarge;

  /// No description provided for @tokenEndpointInvalid.
  ///
  /// In en, this message translates to:
  /// **'The try-on service address is not configured correctly.'**
  String get tokenEndpointInvalid;

  /// No description provided for @loginExpired.
  ///
  /// In en, this message translates to:
  /// **'Your login has expired. Sign in again and retry.'**
  String get loginExpired;

  /// No description provided for @serviceBusy.
  ///
  /// In en, this message translates to:
  /// **'Many people are trying on outfits right now. Try again later.'**
  String get serviceBusy;

  /// No description provided for @serviceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The try-on service is temporarily unavailable. Try again later.'**
  String get serviceUnavailable;

  /// No description provided for @invalidResponse.
  ///
  /// In en, this message translates to:
  /// **'The try-on service returned invalid data.'**
  String get invalidResponse;

  /// No description provided for @credentialExpired.
  ///
  /// In en, this message translates to:
  /// **'The try-on credential is invalid or expired. Try again.'**
  String get credentialExpired;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'TW':
            return AppLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
