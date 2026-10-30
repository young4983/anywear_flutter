// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Anywear';

  @override
  String get appName => 'Fitting Room';

  @override
  String get brandLabel => 'ANYWEAR';

  @override
  String get introTitle => 'Wear the future.';

  @override
  String get introSubtitle => 'AI maps your outfit ideas in real time.';

  @override
  String get statusReady => 'Ready';

  @override
  String get statusConnecting => 'Connecting';

  @override
  String get statusPreparing => 'Preparing view';

  @override
  String get statusLive => 'Live try-on';

  @override
  String get statusReconnecting => 'Reconnecting';

  @override
  String get emptyVideoTitle => 'Your next outfit';

  @override
  String get emptyVideoSubtitle => 'Your look will appear here after you start';

  @override
  String get styleHeading => 'Choose your style';

  @override
  String get uploadGarment => 'Upload garment';

  @override
  String get openingGallery => 'Opening';

  @override
  String get promptLabel => 'Outfit description';

  @override
  String get promptHint => 'Describe color, material, and fit';

  @override
  String get promptExample =>
      'For example: a light gray oversized hoodie with white drawstrings.';

  @override
  String get editPromptTitle => 'Adjust outfit description';

  @override
  String get apply => 'Apply';

  @override
  String get cancel => 'Cancel';

  @override
  String get myGarment => 'My garment';

  @override
  String get startTryOn => 'Start try-on';

  @override
  String get stopTryOn => 'Stop try-on';

  @override
  String get cloudFooter =>
      'Cloud generation · Pauses automatically in background';

  @override
  String get consentTitle => 'Start live try-on';

  @override
  String get consentBody =>
      'Your camera video and selected garment image will be sent to Decart cloud services to generate the try-on. Keep a network connection; stopping or backgrounding the app ends the session.';

  @override
  String get decline => 'Not now';

  @override
  String get agreeAndStart => 'Agree and start';

  @override
  String get cannotReadImage =>
      'Could not read the image. Try again or check photo permissions.';

  @override
  String get backToFittingRoom => 'Back to fitting room';

  @override
  String get keySettings => 'AI Key settings';

  @override
  String get usageInfo => 'How it works';

  @override
  String get usageTitle => 'Meet your next outfit';

  @override
  String get usageBody =>
      'Choose a preset or upload a garment, then start try-on and allow camera access. Keep your upper body in frame; even lighting gives more stable results.';

  @override
  String get gotIt => 'Got it';

  @override
  String get fullscreen => 'View full screen';

  @override
  String get exitFullscreen => 'Exit full screen';

  @override
  String get viewTryOn => 'View try-on';

  @override
  String get viewCamera => 'View camera';

  @override
  String get switchCamera => 'Switch camera';

  @override
  String get networkUnstable => 'Network is unstable; video may be delayed';

  @override
  String get openSettings => 'Open settings';

  @override
  String get keyConfigured => 'A Key is configured';

  @override
  String get keyNotConfigured => 'No Key configured';

  @override
  String get keyStorageBody =>
      'The new Key is encrypted on this device. Saving stops the current try-on; it takes effect the next time you start.';

  @override
  String get readingConfiguration => 'Reading configuration…';

  @override
  String get keyStorageReadFailed =>
      'Could not read the saved Key. Please save it again.';

  @override
  String get apiKeyLabel => 'Decart API Key';

  @override
  String get showKey => 'Show entered Key';

  @override
  String get hideKey => 'Hide entered Key';

  @override
  String get clearKey => 'Clear current Key';

  @override
  String get saveKey => 'Save Key';

  @override
  String get savingKey => 'Saving…';

  @override
  String get enterNewKey => 'Enter a new Decart API Key.';

  @override
  String get invalidKey =>
      'Enter a complete Decart API Key beginning with dct_.';

  @override
  String get releaseBackendOnly =>
      'Release builds use server-issued try-on credentials.';

  @override
  String get keySaved => 'AI Key saved. Tap Start try-on to use it.';

  @override
  String get keyCleared =>
      'AI Key cleared. Add one in settings before starting try-on.';

  @override
  String get disconnectBeforeKey =>
      'The try-on session has not disconnected. Stop it before changing the Key.';

  @override
  String get permissionRequired =>
      'Camera permission is required for try-on. Allow camera access in system settings.';

  @override
  String get pausedMessage => 'Try-on paused. Tap Start try-on to continue.';

  @override
  String get connectionTimeout =>
      'Connection timed out. Check your network and try again.';

  @override
  String get networkFailure =>
      'Network connection failed. Check your network and try again.';

  @override
  String get cameraUnavailable =>
      'Camera is temporarily unavailable. Use a physical device and close other camera apps.';

  @override
  String get invalidApiKey =>
      'Try-on authorization failed. Check your account and quota.';

  @override
  String get tryOnConnectionError =>
      'Try-on connection encountered a problem. Stop and try again.';

  @override
  String get operationFailed =>
      'The operation could not be completed. Try again later.';

  @override
  String get backendConfigConflict =>
      'Development configuration conflicts. Choose only one connection method.';

  @override
  String get releaseConfigError =>
      'Release builds must use the server login and temporary credential endpoint.';

  @override
  String get invalidDevelopmentCredential =>
      'The development credential format is invalid.';

  @override
  String get serviceNotConfigured =>
      'Try-on service is not configured. Contact the app developer.';

  @override
  String get noDevelopmentKey =>
      'Add a Key from AI Key settings at the top before starting try-on.';

  @override
  String get saveKeyFailed => 'Could not save the Key. Try again later.';

  @override
  String get presetNavyHoodie =>
      'Navy blue cotton hoodie with white drawstrings and a relaxed fit.';

  @override
  String get presetWhiteShirt =>
      'Crisp white cotton Oxford shirt with a button-down collar.';

  @override
  String get presetLeatherJacket =>
      'Black motorcycle leather jacket with silver metal zippers.';

  @override
  String get presetDenimJacket => 'Light blue relaxed-fit denim jacket.';

  @override
  String get presetNavyName => 'Navy hoodie';

  @override
  String get presetWhiteName => 'White shirt';

  @override
  String get presetLeatherName => 'Leather jacket';

  @override
  String get presetDenimName => 'Denim jacket';

  @override
  String get referencePrompt =>
      'Replace the current garment with the clothing in the reference image, preserving its color, material, and style details.';

  @override
  String get qualityWarning => 'Network is unstable; video may be delayed';

  @override
  String get keyFormatError =>
      'Enter a complete Decart API Key beginning with dct_.';

  @override
  String get imageTooLarge => 'Choose a garment image smaller than 5 MB.';

  @override
  String get tokenEndpointInvalid =>
      'The try-on service address is not configured correctly.';

  @override
  String get loginExpired => 'Your login has expired. Sign in again and retry.';

  @override
  String get serviceBusy =>
      'Many people are trying on outfits right now. Try again later.';

  @override
  String get serviceUnavailable =>
      'The try-on service is temporarily unavailable. Try again later.';

  @override
  String get invalidResponse => 'The try-on service returned invalid data.';

  @override
  String get credentialExpired =>
      'The try-on credential is invalid or expired. Try again.';
}
