import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'arb/app_localizations.dart';
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
    Locale('es'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'QR iBar Kitchen'**
  String get appName;

  /// Skip the current step
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Go to the next step
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Start
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// Welcome to your Civil Protection App!
  ///
  /// In en, this message translates to:
  /// **'Welcome to your Civil Protection App!'**
  String get welcomeToCivilProtection;

  /// Learn about the different risks and protect yourself and your loved ones - let's get started!
  ///
  /// In en, this message translates to:
  /// **'Learn about the different risks and protect yourself and your loved ones - let\'s get started!'**
  String get learnAboutDifferentRisks;

  /// Alerts tailored to your world
  ///
  /// In en, this message translates to:
  /// **'Alerts tailored to your world'**
  String get alertsTailoredToYourWorld;

  /// With Civil Protection, you can receive Alerts about the different risks in the areas you are interested in.
  ///
  /// In en, this message translates to:
  /// **'With Civil Protection, you can receive Alerts about the different risks in the areas you are interested in.'**
  String get withCivilProtectionYouCan;

  /// A shield against the elements!
  ///
  /// In en, this message translates to:
  /// **'A shield against the elements!'**
  String get aShieldAgainstTheElements;

  /// From vital links to expert advice, we're here to strengthen your preparedness for any phenomenon.
  ///
  /// In en, this message translates to:
  /// **'From vital links to expert advice, we\'re here to strengthen your preparedness for any phenomenon.'**
  String get fromVitalLinksToExpertAdvice;

  /// Your alerts
  ///
  /// In en, this message translates to:
  /// **'Your alerts'**
  String get yourAlerts;

  /// You can activate notifications for the places where you would like to receive alerts
  ///
  /// In en, this message translates to:
  /// **'You can activate notifications for the places where you would like to receive alerts'**
  String get canActivateAlerts;

  /// You don't have alerts from anywhere activated
  ///
  /// In en, this message translates to:
  /// **'You don\'t have alerts from anywhere activated'**
  String get noActiveAlerts;

  /// You can add the places you would like to be informed about.
  ///
  /// In en, this message translates to:
  /// **'You can add the places you would like to be informed about.'**
  String get noActiveAlertsInfo;

  /// You are up to date with everything!
  ///
  /// In en, this message translates to:
  /// **'You are up to date with everything!'**
  String get activeAlerts;

  /// Alert detail
  ///
  /// In en, this message translates to:
  /// **'Alert detail'**
  String get alertDetail;

  /// Are you sure?
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get alertModalAreYouSure;

  /// If you unsubscribe from {address} you will no longer receive alerts in this area. To reactivate this place, click on the "+" button to add a new subscription.
  ///
  /// In en, this message translates to:
  /// **'If you unsubscribe from {address} you will no longer receive alerts in this area. To reactivate this place, click on the \"+\" button to add a new subscription.'**
  String alertModalAreYouSureSubtitle(String address);

  /// Delete subscription
  ///
  /// In en, this message translates to:
  /// **'Delete subscription'**
  String get alertModalDeleteButton;

  /// Delete alert
  ///
  /// In en, this message translates to:
  /// **'Delete alert'**
  String get alertSuscriptionTrashButton;

  /// Make sure you have activated alerts in the places where you would like to be notified.
  ///
  /// In en, this message translates to:
  /// **'Make sure you have activated alerts in the places where you would like to be notified.'**
  String get activeAlertsInfo;

  /// Subscribed places
  ///
  /// In en, this message translates to:
  /// **'Subscribed places'**
  String get subscribedPlaces;

  /// Active
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeAlert;

  /// Finished
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get inactiveAlert;

  /// Ended alerts
  ///
  /// In en, this message translates to:
  /// **'Ended alerts'**
  String get endedAlerts;

  /// Now
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get alertNow;

  /// No description provided for @alertMinutes.
  ///
  /// In en, this message translates to:
  /// **'{value, plural, one {{value} minute ago}other{{value} minutes ago}}}}'**
  String alertMinutes(int value);

  /// No description provided for @alertHours.
  ///
  /// In en, this message translates to:
  /// **'{value, plural, one {{value} hour ago}other{{value} hours ago}}}}'**
  String alertHours(int value);

  /// No description provided for @alertDays.
  ///
  /// In en, this message translates to:
  /// **'{value, plural, one {{value} day ago}other{{value} days ago}}}}'**
  String alertDays(int value);

  /// No description provided for @alertMonths.
  ///
  /// In en, this message translates to:
  /// **'{value, plural, one {{value} month ago}other{{value} months ago}}}}'**
  String alertMonths(int value);

  /// No description provided for @alertYears.
  ///
  /// In en, this message translates to:
  /// **'{value, plural, one {{value} year ago}other{{value} years ago}}}}'**
  String alertYears(int value);

  /// No description provided for @endedDateAlert.
  ///
  /// In en, this message translates to:
  /// **'Alert end date: {value}'**
  String endedDateAlert(String value);

  /// You have
  ///
  /// In en, this message translates to:
  /// **'You have '**
  String get youHave;

  /// No description provided for @activeNumAlerts.
  ///
  /// In en, this message translates to:
  /// **'{value, plural, one {{value} active}other{{value} active}} }}'**
  String activeNumAlerts(int value);

  /// No description provided for @alertsNum.
  ///
  /// In en, this message translates to:
  /// **'{value, plural, one {alert}other{alerts}}}}'**
  String alertsNum(int value);

  /// Accept
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// Cancel
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// I have read and agree to the Privacy Policy
  ///
  /// In en, this message translates to:
  /// **'I have read and agree to the Privacy Policy'**
  String get iHaveReadPrivacy;

  /// I have read and agree to the Legal Notice and the Terms and Conditions of Use
  ///
  /// In en, this message translates to:
  /// **'I have read and agree to the Legal Notice and the Terms and Conditions of Use'**
  String get iHaveReadTerms;

  /// Acceptance of conditions
  ///
  /// In en, this message translates to:
  /// **'Acceptance of conditions'**
  String get acceptanceOfConditions;

  /// Civil Protection Logo
  ///
  /// In en, this message translates to:
  /// **'Civil Protection Logo'**
  String get civilProtectionLogo;

  /// My profile
  ///
  /// In en, this message translates to:
  /// **'My profile'**
  String get myProfile;

  /// Settings
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Configuration
  ///
  /// In en, this message translates to:
  /// **'Configuration'**
  String get configuration;

  /// Language
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Help
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// Frequently Asked Questions
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get frequentAskedQuestions;

  /// Support
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// General Information
  ///
  /// In en, this message translates to:
  /// **'General Information'**
  String get generalInformation;

  /// Accessibility Statement
  ///
  /// In en, this message translates to:
  /// **'Accessibility Statement'**
  String get accesibilityStatement;

  /// Legal Notice
  ///
  /// In en, this message translates to:
  /// **'Legal Notice'**
  String get legalNotice;

  /// Privacy Policy
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Version v.
  ///
  /// In en, this message translates to:
  /// **'Version v.{version}'**
  String version(String version);

  /// Español
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// English
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Català
  ///
  /// In en, this message translates to:
  /// **'Català'**
  String get catalan;

  /// Galego
  ///
  /// In en, this message translates to:
  /// **'Galego'**
  String get galician;

  /// Euskera
  ///
  /// In en, this message translates to:
  /// **'Euskera'**
  String get basque;

  /// Map Viewer
  ///
  /// In en, this message translates to:
  /// **'Map Viewer'**
  String get mapViewer;

  /// Alerts
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get alerts;

  /// Files
  ///
  /// In en, this message translates to:
  /// **'Files'**
  String get files;

  /// Interest
  ///
  /// In en, this message translates to:
  /// **'Interest'**
  String get interest;

  /// Your national alert network
  ///
  /// In en, this message translates to:
  /// **'Your national alert network'**
  String get yourNationalAlertNetwork;

  /// Today is {date}
  ///
  /// In en, this message translates to:
  /// **'Today is {date}'**
  String todayIs(String date);

  /// New subscription
  ///
  /// In en, this message translates to:
  /// **'New subscription'**
  String get newSubscription;

  /// Add new subscription
  ///
  /// In en, this message translates to:
  /// **'Add new subscription'**
  String get addNewSubscription;

  /// Autonomous Community
  ///
  /// In en, this message translates to:
  /// **'Autonomous Community'**
  String get autonomousCommunity;

  /// Province
  ///
  /// In en, this message translates to:
  /// **'Province'**
  String get province;

  /// Municipality
  ///
  /// In en, this message translates to:
  /// **'Municipality'**
  String get municipality;

  /// Use current location
  ///
  /// In en, this message translates to:
  /// **'Use current location'**
  String get useCurrentLocation;

  /// Create new subscription
  ///
  /// In en, this message translates to:
  /// **'Create new subscription'**
  String get createNewSubscription;

  /// Ready!
  ///
  /// In en, this message translates to:
  /// **'Ready!'**
  String get readyExclamations;

  /// Understood
  ///
  /// In en, this message translates to:
  /// **'Understood'**
  String get understood;

  /// You have just added "“{address}”" to your subscribed Places. Now you will receive all the alerts that affect this place.
  ///
  /// In en, this message translates to:
  /// **'You have just added \"“{address}”\" to your subscribed Places. Now you will receive all the alerts that affect this place.'**
  String youHaveJustAddedAddress(String address);

  /// Information
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get information;

  /// The alerts will be available to you in the application for one year. At the end of this time, the alerts will be deleted.
  ///
  /// In en, this message translates to:
  /// **'The alerts will be available to you in the application for one year. At the end of this time, the alerts will be deleted.'**
  String get theAlertsWillBeAvailableForOneYear;

  /// Magnitude: 3 or more
  ///
  /// In en, this message translates to:
  /// **'Magnitude: 3 or more'**
  String get magnitude3OrMore;

  /// Magnitude: less than 3 and felt
  ///
  /// In en, this message translates to:
  /// **'Magnitude: less than 3 and felt'**
  String get magnitudeLessThan3;

  /// {x} Recommendations
  ///
  /// In en, this message translates to:
  /// **'{x} Recommendations'**
  String recommendationsX(String x);

  /// Meteo
  ///
  /// In en, this message translates to:
  /// **'Meteo'**
  String get meteo;

  /// Earthquakes
  ///
  /// In en, this message translates to:
  /// **'Earthquakes'**
  String get earthquakes;

  /// Extreme risk
  ///
  /// In en, this message translates to:
  /// **'Extreme risk'**
  String get extremeRisk;

  /// Very high risk
  ///
  /// In en, this message translates to:
  /// **'Very high risk'**
  String get veryHighRisk;

  /// High risk
  ///
  /// In en, this message translates to:
  /// **'High risk'**
  String get highRisk;

  /// Moderate risk
  ///
  /// In en, this message translates to:
  /// **'Moderate risk'**
  String get moderateRisk;

  /// Low risk
  ///
  /// In en, this message translates to:
  /// **'Low risk'**
  String get lowRisk;

  /// Wildfire
  ///
  /// In en, this message translates to:
  /// **'Wildfire'**
  String get wildfire;

  /// Extreme
  ///
  /// In en, this message translates to:
  /// **'Extreme'**
  String get extreme;

  /// Important
  ///
  /// In en, this message translates to:
  /// **'Important'**
  String get important;

  /// Depends on activity
  ///
  /// In en, this message translates to:
  /// **'Depends on activity'**
  String get dependsOnActivity;

  /// Summary
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summary;

  /// Coastal hazards
  ///
  /// In en, this message translates to:
  /// **'Coastal hazards'**
  String get coastalHazards;

  /// Rainwater Accumulation 1h
  ///
  /// In en, this message translates to:
  /// **'Rainwater Acc. 1h'**
  String get rainwaterAccumulation;

  /// Snow Accumulation 24h
  ///
  /// In en, this message translates to:
  /// **'Snow Acc. 24h'**
  String get snowAccumulation;

  /// Minimum temperatures
  ///
  /// In en, this message translates to:
  /// **'Minimum temperatures'**
  String get minimumTemperatures;

  /// Error starting application
  ///
  /// In en, this message translates to:
  /// **'Error starting application'**
  String get errorStartingApp;

  /// A connection error has been detected.
  /// Our services may not be available at the moment, please check that you have an internet connection, and try again later.
  ///
  /// In en, this message translates to:
  /// **'A connection error has been detected.\nOur services may not be available at the moment, please check that you have an internet connection, and try again later.'**
  String get errorStartingAppText;

  /// Retry
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryText;

  /// Civil Protection Logo, Ministry of Interior
  ///
  /// In en, this message translates to:
  /// **'Civil Protection Logo, Ministry of Interior'**
  String get appLogo;

  /// Peninsula map showing {x} alerts
  ///
  /// In en, this message translates to:
  /// **'Peninsula map showing {x} alerts'**
  String peninsulaMapShowing(String x);

  /// No description provided for @canariesMapShowing.
  ///
  /// In en, this message translates to:
  /// **'Canary Islands map showing {x} alerts'**
  String canariesMapShowing(Object x);

  /// Close
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Page {x} of {y}
  ///
  /// In en, this message translates to:
  /// **'Page {x} of {y}'**
  String pageXofY(int x, int y);

  /// GPS required
  ///
  /// In en, this message translates to:
  /// **'GPS required'**
  String get gpsRequired;

  /// Message to know the size and type of elements of a list for accesibility purposes
  ///
  /// In en, this message translates to:
  /// **'Unordered list of {size} {type}'**
  String unorderedListSemantic(num size, String type);

  /// Recommendations
  ///
  /// In en, this message translates to:
  /// **'Recommendations'**
  String get recommendations;

  /// High winds
  ///
  /// In en, this message translates to:
  /// **'High winds'**
  String get highWinds;

  /// Heavy rains
  ///
  /// In en, this message translates to:
  /// **'Heavy rains'**
  String get heavyRains;

  /// High temperatures
  ///
  /// In en, this message translates to:
  /// **'High temperatures'**
  String get highTemperatures;

  /// Coastal
  ///
  /// In en, this message translates to:
  /// **'Coastal'**
  String get coastal;

  /// Storms and lightning strikes
  ///
  /// In en, this message translates to:
  /// **'Storms and lightning strikes'**
  String get stormsAndLightningStrikes;

  /// Forest fires
  ///
  /// In en, this message translates to:
  /// **'Forest fires'**
  String get forestFires;

  /// Back
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Element {x} of {y}
  ///
  /// In en, this message translates to:
  /// **'Element {x} of {y}'**
  String elementXInListSemantic(num x, num y);

  /// Logo de NextGenerationEU, Financiado por la Unión Europea
  ///
  /// In en, this message translates to:
  /// **'Logo de NextGenerationEU, Financiado por la Unión Europea'**
  String get nextGenLogo;

  /// Logo del Plan de Recuperación, Transformación y Resiliencia
  ///
  /// In en, this message translates to:
  /// **'Logo del Plan de Recuperación, Transformación y Resiliencia'**
  String get recoveryPlanLogo;

  /// Logo de España Digital 2026
  ///
  /// In en, this message translates to:
  /// **'Logo de España Digital 2026'**
  String get digitalSpainLogo;

  /// Entries
  ///
  /// In en, this message translates to:
  /// **'Entries'**
  String get entries;

  /// Opens external link
  ///
  /// In en, this message translates to:
  /// **'Opens external link'**
  String get opensExternalLink;

  /// New version available
  ///
  /// In en, this message translates to:
  /// **'New version available'**
  String get newVersionAvailable;

  /// A new update of Proteccion Civil is available.
  ///
  /// In en, this message translates to:
  /// **'A new update of Proteccion Civil is available.'**
  String get newVersionAvailableText;

  /// Omit
  ///
  /// In en, this message translates to:
  /// **'Omit'**
  String get omit;

  /// Mandatory update Proteccion Civil v.{version}
  ///
  /// In en, this message translates to:
  /// **'Mandatory update Proteccion Civil v.{version}'**
  String forcedUpdate(String version);

  /// In order to continue updating the application, you must upgrade it.
  ///
  /// In en, this message translates to:
  /// **'In order to continue updating the application, you must upgrade it.'**
  String get forcedUpdateText;

  /// Update
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// Civil Protection Alert
  ///
  /// In en, this message translates to:
  /// **'Civil Protection Alert'**
  String get civilProtectionAlert;

  /// Error!
  ///
  /// In en, this message translates to:
  /// **'Error!'**
  String get errorPopUp;

  /// An error occurred during the query. Please try again.
  ///
  /// In en, this message translates to:
  /// **'An error occurred during the query. Please try again.'**
  String get anErrorOccurredDuringTheQuery;

  /// Try again
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// Back to home
  ///
  /// In en, this message translates to:
  /// **'Back to home'**
  String get backToHome;

  /// No description provided for @authenticationExpired.
  ///
  /// In en, this message translates to:
  /// **'Authentication expired'**
  String get authenticationExpired;

  /// No description provided for @badRequest.
  ///
  /// In en, this message translates to:
  /// **'Bad request'**
  String get badRequest;

  /// No description provided for @unauthorized.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized'**
  String get unauthorized;

  /// No description provided for @forbidden.
  ///
  /// In en, this message translates to:
  /// **'Forbidden'**
  String get forbidden;

  /// No description provided for @notFound.
  ///
  /// In en, this message translates to:
  /// **'Not found'**
  String get notFound;

  /// No description provided for @conflict.
  ///
  /// In en, this message translates to:
  /// **'Conflict'**
  String get conflict;

  /// No description provided for @internalServerError.
  ///
  /// In en, this message translates to:
  /// **'Internal server error'**
  String get internalServerError;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get unknownError;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternetConnection;

  /// No description provided for @infoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'The information does not match'**
  String get infoNotMatch;

  /// No description provided for @noAccess.
  ///
  /// In en, this message translates to:
  /// **'No access'**
  String get noAccess;

  /// No description provided for @securityError.
  ///
  /// In en, this message translates to:
  /// **'Security error'**
  String get securityError;

  /// Search by Autonomous Community
  ///
  /// In en, this message translates to:
  /// **'Search by Autonomous Community'**
  String get searchByAutonomousCommunity;

  /// Search by Province
  ///
  /// In en, this message translates to:
  /// **'Search by Province'**
  String get searchByProvince;

  /// Search by Municipality
  ///
  /// In en, this message translates to:
  /// **'Search by Municipality'**
  String get searchByMunicipality;

  /// Select
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @semanticMinMap.
  ///
  /// In en, this message translates to:
  /// **'Map of the Canary Islands showing weather alerts'**
  String get semanticMinMap;

  /// No description provided for @semanticMap.
  ///
  /// In en, this message translates to:
  /// **'Map of the Peninsula showing weather alerts'**
  String get semanticMap;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'User not found'**
  String get userNotFound;

  /// No description provided for @wrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Wrong password'**
  String get wrongPassword;

  /// No description provided for @generalView.
  ///
  /// In en, this message translates to:
  /// **'Kitchen General View'**
  String get generalView;

  /// No description provided for @tablesView.
  ///
  /// In en, this message translates to:
  /// **'Kitchen Tables View'**
  String get tablesView;

  /// No description provided for @cocinaPedidosPorMesa.
  ///
  /// In en, this message translates to:
  /// **'Kitchen Orders by Table'**
  String get cocinaPedidosPorMesa;

  /// No description provided for @cocinaEstadoPedidos.
  ///
  /// In en, this message translates to:
  /// **'Kitchen Orders Status'**
  String get cocinaEstadoPedidos;

  /// No description provided for @cancelOrder.
  ///
  /// In en, this message translates to:
  /// **'Can\'t cancel here'**
  String get cancelOrder;

  /// No description provided for @served.
  ///
  /// In en, this message translates to:
  /// **'SERVED'**
  String get served;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailError.
  ///
  /// In en, this message translates to:
  /// **'The email is not correct'**
  String get emailError;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordError.
  ///
  /// In en, this message translates to:
  /// **'The password must be 6 characters'**
  String get passwordError;

  /// No description provided for @wait.
  ///
  /// In en, this message translates to:
  /// **'Wait...'**
  String get wait;

  /// No description provided for @enter.
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get enter;

  /// No description provided for @exitMenu.
  ///
  /// In en, this message translates to:
  /// **'Exit menu'**
  String get exitMenu;

  /// No description provided for @closeApp.
  ///
  /// In en, this message translates to:
  /// **'Do you want to close the application?'**
  String get closeApp;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @exitApp.
  ///
  /// In en, this message translates to:
  /// **'Exit the application'**
  String get exitApp;
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
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
