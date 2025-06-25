// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'QR iBar Kitchen';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get start => 'Start';

  @override
  String get welcomeToCivilProtection =>
      'Welcome to your Civil Protection App!';

  @override
  String get learnAboutDifferentRisks =>
      'Learn about the different risks and protect yourself and your loved ones - let\'s get started!';

  @override
  String get alertsTailoredToYourWorld => 'Alerts tailored to your world';

  @override
  String get withCivilProtectionYouCan =>
      'With Civil Protection, you can receive Alerts about the different risks in the areas you are interested in.';

  @override
  String get aShieldAgainstTheElements => 'A shield against the elements!';

  @override
  String get fromVitalLinksToExpertAdvice =>
      'From vital links to expert advice, we\'re here to strengthen your preparedness for any phenomenon.';

  @override
  String get yourAlerts => 'Your alerts';

  @override
  String get canActivateAlerts =>
      'You can activate notifications for the places where you would like to receive alerts';

  @override
  String get noActiveAlerts => 'You don\'t have alerts from anywhere activated';

  @override
  String get noActiveAlertsInfo =>
      'You can add the places you would like to be informed about.';

  @override
  String get activeAlerts => 'You are up to date with everything!';

  @override
  String get alertDetail => 'Alert detail';

  @override
  String get alertModalAreYouSure => 'Are you sure?';

  @override
  String alertModalAreYouSureSubtitle(String address) {
    return 'If you unsubscribe from $address you will no longer receive alerts in this area. To reactivate this place, click on the \"+\" button to add a new subscription.';
  }

  @override
  String get alertModalDeleteButton => 'Delete subscription';

  @override
  String get alertSuscriptionTrashButton => 'Delete alert';

  @override
  String get activeAlertsInfo =>
      'Make sure you have activated alerts in the places where you would like to be notified.';

  @override
  String get subscribedPlaces => 'Subscribed places';

  @override
  String get activeAlert => 'Active';

  @override
  String get inactiveAlert => 'Finished';

  @override
  String get endedAlerts => 'Ended alerts';

  @override
  String get alertNow => 'Now';

  @override
  String alertMinutes(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '$value minutes ago',
      one: '$value minute ago',
    );
    return '$_temp0';
  }

  @override
  String alertHours(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '$value hours ago',
      one: '$value hour ago',
    );
    return '$_temp0';
  }

  @override
  String alertDays(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '$value days ago',
      one: '$value day ago',
    );
    return '$_temp0';
  }

  @override
  String alertMonths(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '$value months ago',
      one: '$value month ago',
    );
    return '$_temp0';
  }

  @override
  String alertYears(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '$value years ago',
      one: '$value year ago',
    );
    return '$_temp0';
  }

  @override
  String endedDateAlert(String value) {
    return 'Alert end date: $value';
  }

  @override
  String get youHave => 'You have ';

  @override
  String activeNumAlerts(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '$value active',
      one: '$value active',
    );
    return '$_temp0 ';
  }

  @override
  String alertsNum(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: 'alerts',
      one: 'alert',
    );
    return '$_temp0';
  }

  @override
  String get accept => 'Accept';

  @override
  String get cancel => 'Cancel';

  @override
  String get iHaveReadPrivacy => 'I have read and agree to the Privacy Policy';

  @override
  String get iHaveReadTerms =>
      'I have read and agree to the Legal Notice and the Terms and Conditions of Use';

  @override
  String get acceptanceOfConditions => 'Acceptance of conditions';

  @override
  String get civilProtectionLogo => 'Civil Protection Logo';

  @override
  String get myProfile => 'My profile';

  @override
  String get settings => 'Settings';

  @override
  String get configuration => 'Configuration';

  @override
  String get language => 'Language';

  @override
  String get help => 'Help';

  @override
  String get frequentAskedQuestions => 'Frequently Asked Questions';

  @override
  String get support => 'Support';

  @override
  String get generalInformation => 'General Information';

  @override
  String get accesibilityStatement => 'Accessibility Statement';

  @override
  String get legalNotice => 'Legal Notice';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String version(String version) {
    return 'Version v.$version';
  }

  @override
  String get spanish => 'Spanish';

  @override
  String get english => 'English';

  @override
  String get catalan => 'Català';

  @override
  String get galician => 'Galego';

  @override
  String get basque => 'Euskera';

  @override
  String get mapViewer => 'Map Viewer';

  @override
  String get alerts => 'Alerts';

  @override
  String get files => 'Files';

  @override
  String get interest => 'Interest';

  @override
  String get yourNationalAlertNetwork => 'Your national alert network';

  @override
  String todayIs(String date) {
    return 'Today is $date';
  }

  @override
  String get newSubscription => 'New subscription';

  @override
  String get addNewSubscription => 'Add new subscription';

  @override
  String get autonomousCommunity => 'Autonomous Community';

  @override
  String get province => 'Province';

  @override
  String get municipality => 'Municipality';

  @override
  String get useCurrentLocation => 'Use current location';

  @override
  String get createNewSubscription => 'Create new subscription';

  @override
  String get readyExclamations => 'Ready!';

  @override
  String get understood => 'Understood';

  @override
  String youHaveJustAddedAddress(String address) {
    return 'You have just added \"“$address”\" to your subscribed Places. Now you will receive all the alerts that affect this place.';
  }

  @override
  String get information => 'Information';

  @override
  String get theAlertsWillBeAvailableForOneYear =>
      'The alerts will be available to you in the application for one year. At the end of this time, the alerts will be deleted.';

  @override
  String get magnitude3OrMore => 'Magnitude: 3 or more';

  @override
  String get magnitudeLessThan3 => 'Magnitude: less than 3 and felt';

  @override
  String recommendationsX(String x) {
    return '$x Recommendations';
  }

  @override
  String get meteo => 'Meteo';

  @override
  String get earthquakes => 'Earthquakes';

  @override
  String get extremeRisk => 'Extreme risk';

  @override
  String get veryHighRisk => 'Very high risk';

  @override
  String get highRisk => 'High risk';

  @override
  String get moderateRisk => 'Moderate risk';

  @override
  String get lowRisk => 'Low risk';

  @override
  String get wildfire => 'Wildfire';

  @override
  String get extreme => 'Extreme';

  @override
  String get important => 'Important';

  @override
  String get dependsOnActivity => 'Depends on activity';

  @override
  String get summary => 'Summary';

  @override
  String get coastalHazards => 'Coastal hazards';

  @override
  String get rainwaterAccumulation => 'Rainwater Acc. 1h';

  @override
  String get snowAccumulation => 'Snow Acc. 24h';

  @override
  String get minimumTemperatures => 'Minimum temperatures';

  @override
  String get errorStartingApp => 'Error starting application';

  @override
  String get errorStartingAppText =>
      'A connection error has been detected.\nOur services may not be available at the moment, please check that you have an internet connection, and try again later.';

  @override
  String get retryText => 'Retry';

  @override
  String get appLogo => 'Civil Protection Logo, Ministry of Interior';

  @override
  String peninsulaMapShowing(String x) {
    return 'Peninsula map showing $x alerts';
  }

  @override
  String canariesMapShowing(Object x) {
    return 'Canary Islands map showing $x alerts';
  }

  @override
  String get close => 'Close';

  @override
  String pageXofY(int x, int y) {
    return 'Page $x of $y';
  }

  @override
  String get gpsRequired => 'GPS required';

  @override
  String unorderedListSemantic(num size, String type) {
    return 'Unordered list of $size $type';
  }

  @override
  String get recommendations => 'Recommendations';

  @override
  String get highWinds => 'High winds';

  @override
  String get heavyRains => 'Heavy rains';

  @override
  String get highTemperatures => 'High temperatures';

  @override
  String get coastal => 'Coastal';

  @override
  String get stormsAndLightningStrikes => 'Storms and lightning strikes';

  @override
  String get forestFires => 'Forest fires';

  @override
  String get back => 'Back';

  @override
  String elementXInListSemantic(num x, num y) {
    return 'Element $x of $y';
  }

  @override
  String get nextGenLogo =>
      'Logo de NextGenerationEU, Financiado por la Unión Europea';

  @override
  String get recoveryPlanLogo =>
      'Logo del Plan de Recuperación, Transformación y Resiliencia';

  @override
  String get digitalSpainLogo => 'Logo de España Digital 2026';

  @override
  String get entries => 'Entries';

  @override
  String get opensExternalLink => 'Opens external link';

  @override
  String get newVersionAvailable => 'New version available';

  @override
  String get newVersionAvailableText =>
      'A new update of Proteccion Civil is available.';

  @override
  String get omit => 'Omit';

  @override
  String forcedUpdate(String version) {
    return 'Mandatory update Proteccion Civil v.$version';
  }

  @override
  String get forcedUpdateText =>
      'In order to continue updating the application, you must upgrade it.';

  @override
  String get update => 'Update';

  @override
  String get civilProtectionAlert => 'Civil Protection Alert';

  @override
  String get errorPopUp => 'Error!';

  @override
  String get anErrorOccurredDuringTheQuery =>
      'An error occurred during the query. Please try again.';

  @override
  String get tryAgain => 'Try again';

  @override
  String get backToHome => 'Back to home';

  @override
  String get authenticationExpired => 'Authentication expired';

  @override
  String get badRequest => 'Bad request';

  @override
  String get unauthorized => 'Unauthorized';

  @override
  String get forbidden => 'Forbidden';

  @override
  String get notFound => 'Not found';

  @override
  String get conflict => 'Conflict';

  @override
  String get internalServerError => 'Internal server error';

  @override
  String get unknownError => 'Unknown error';

  @override
  String get noInternetConnection => 'No internet connection';

  @override
  String get infoNotMatch => 'The information does not match';

  @override
  String get noAccess => 'No access';

  @override
  String get securityError => 'Security error';

  @override
  String get searchByAutonomousCommunity => 'Search by Autonomous Community';

  @override
  String get searchByProvince => 'Search by Province';

  @override
  String get searchByMunicipality => 'Search by Municipality';

  @override
  String get select => 'Select';

  @override
  String get semanticMinMap =>
      'Map of the Canary Islands showing weather alerts';

  @override
  String get semanticMap => 'Map of the Peninsula showing weather alerts';

  @override
  String get clear => 'Clear';

  @override
  String get userNotFound => 'User not found';

  @override
  String get wrongPassword => 'Wrong password';

  @override
  String get generalView => 'Kitchen General View';

  @override
  String get tablesView => 'Kitchen Tables View';

  @override
  String get cocinaPedidosPorMesa => 'Kitchen Orders by Table';

  @override
  String get cocinaEstadoPedidos => 'Kitchen Orders Status';

  @override
  String get cancelOrder => 'Can\'t cancel here';

  @override
  String get served => 'SERVED';

  @override
  String get email => 'Email';

  @override
  String get emailError => 'The email is not correct';

  @override
  String get password => 'Password';

  @override
  String get passwordError => 'The password must be 6 characters';

  @override
  String get wait => 'Wait...';

  @override
  String get enter => 'Enter';

  @override
  String get exitMenu => 'Exit menu';

  @override
  String get closeApp => 'Do you want to close the application?';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get exitApp => 'Exit the application';
}
