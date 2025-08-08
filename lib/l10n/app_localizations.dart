import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ja.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
    Locale('ja')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'ARC Robot'**
  String get appTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsMenu.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsMenu;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @errorPkg.
  ///
  /// In en, this message translates to:
  /// **'Error: \'{pkg}\' package not found.'**
  String errorPkg(Object pkg);

  /// No description provided for @errorPkgList.
  ///
  /// In en, this message translates to:
  /// **'The following packages were not found:'**
  String get errorPkgList;

  /// No description provided for @errorPkgListTitle.
  ///
  /// In en, this message translates to:
  /// **'Missing ROS Packages'**
  String get errorPkgListTitle;

  /// No description provided for @packagePath.
  ///
  /// In en, this message translates to:
  /// **'Package\'s Path:'**
  String get packagePath;

  /// No description provided for @packagePathTitle.
  ///
  /// In en, this message translates to:
  /// **'ROS Package Paths'**
  String get packagePathTitle;

  /// No description provided for @packageInputManually.
  ///
  /// In en, this message translates to:
  /// **'Click to input the path manually'**
  String get packageInputManually;

  /// No description provided for @packageInputManuallyTitle.
  ///
  /// In en, this message translates to:
  /// **'Set path for \'{pkg}\''**
  String packageInputManuallyTitle(Object pkg);

  /// No description provided for @packageInputManuallyHint.
  ///
  /// In en, this message translates to:
  /// **'/path/to/package'**
  String get packageInputManuallyHint;

  /// No description provided for @packagePathNoOverwrite.
  ///
  /// In en, this message translates to:
  /// **'Do not overwrite path values at startup'**
  String get packagePathNoOverwrite;

  /// No description provided for @sourceSystem.
  ///
  /// In en, this message translates to:
  /// **'Found via system'**
  String get sourceSystem;

  /// No description provided for @sourcePrefs.
  ///
  /// In en, this message translates to:
  /// **'Loaded from saved settings'**
  String get sourcePrefs;

  /// No description provided for @sourceMissing.
  ///
  /// In en, this message translates to:
  /// **'Not found'**
  String get sourceMissing;

  /// No description provided for @packagePathNoOverwriteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Use previously saved paths instead of checking the system at startup (the missing path will still be checked).'**
  String get packagePathNoOverwriteTooltip;

  /// No description provided for @parametersSavedTitle.
  ///
  /// In en, this message translates to:
  /// **'Parameters saved'**
  String get parametersSavedTitle;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description:'**
  String get description;

  /// No description provided for @parameters.
  ///
  /// In en, this message translates to:
  /// **'Parameters'**
  String get parameters;

  /// No description provided for @saveParametersButton.
  ///
  /// In en, this message translates to:
  /// **'Save the new parameters'**
  String get saveParametersButton;

  /// No description provided for @noParameters.
  ///
  /// In en, this message translates to:
  /// **'No parameters to display, please make a choice.'**
  String get noParameters;

  /// No description provided for @noPathButtonTooltip.
  ///
  /// In en, this message translates to:
  /// **'Impossible to install without the path'**
  String get noPathButtonTooltip;

  /// No description provided for @installButtonTooltip.
  ///
  /// In en, this message translates to:
  /// **'Open the install wizard'**
  String get installButtonTooltip;

  /// No description provided for @noSelection.
  ///
  /// In en, this message translates to:
  /// **'No selection'**
  String get noSelection;

  /// No description provided for @advancedSettings.
  ///
  /// In en, this message translates to:
  /// **'Advanced Settings'**
  String get advancedSettings;

  /// No description provided for @rosPath.
  ///
  /// In en, this message translates to:
  /// **'Path of the ROS2 executable'**
  String get rosPath;

  /// No description provided for @rosPathTooltip.
  ///
  /// In en, this message translates to:
  /// **'If ROS2 is already installed in your system PATH you can only write \'ros2\', otherwise you should indicate the full path.'**
  String get rosPathTooltip;

  /// No description provided for @robotTitle.
  ///
  /// In en, this message translates to:
  /// **'Robot'**
  String get robotTitle;

  /// No description provided for @robotMenu.
  ///
  /// In en, this message translates to:
  /// **'Robot'**
  String get robotMenu;

  /// No description provided for @selectRobotList.
  ///
  /// In en, this message translates to:
  /// **'Select a robot'**
  String get selectRobotList;

  /// No description provided for @errorNoRobotListPath.
  ///
  /// In en, this message translates to:
  /// **'The path to the robot controllers is not defined. Impossible to get the robot list.'**
  String get errorNoRobotListPath;

  /// No description provided for @errorNoRobotList.
  ///
  /// In en, this message translates to:
  /// **'The path doesn\'t exist or no robot controllers have been found.'**
  String get errorNoRobotList;

  /// No description provided for @pleaseSelectRobot.
  ///
  /// In en, this message translates to:
  /// **'Please select a robot'**
  String get pleaseSelectRobot;

  /// No description provided for @installRobotButton.
  ///
  /// In en, this message translates to:
  /// **'Install a robot'**
  String get installRobotButton;

  /// No description provided for @communicationTitle.
  ///
  /// In en, this message translates to:
  /// **'Communication Interface'**
  String get communicationTitle;

  /// No description provided for @communicationMenu.
  ///
  /// In en, this message translates to:
  /// **'Communication'**
  String get communicationMenu;

  /// No description provided for @selectCommunicationList.
  ///
  /// In en, this message translates to:
  /// **'Select a communication interface'**
  String get selectCommunicationList;

  /// No description provided for @errorNoCommunicationListPath.
  ///
  /// In en, this message translates to:
  /// **'The path to the communication interfaces is not defined. Impossible to get the interface list.'**
  String get errorNoCommunicationListPath;

  /// No description provided for @errorNoCommunicationList.
  ///
  /// In en, this message translates to:
  /// **'The path doesn\'t exist or no communication interfaces have been found.'**
  String get errorNoCommunicationList;

  /// No description provided for @pleaseCommunicationRobot.
  ///
  /// In en, this message translates to:
  /// **'Please select an interface'**
  String get pleaseCommunicationRobot;

  /// No description provided for @installCommunicationButton.
  ///
  /// In en, this message translates to:
  /// **'Install an interface'**
  String get installCommunicationButton;

  /// No description provided for @videoTitle.
  ///
  /// In en, this message translates to:
  /// **'Video Streaming Protocol'**
  String get videoTitle;

  /// No description provided for @videoMenu.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get videoMenu;

  /// No description provided for @selectVideoList.
  ///
  /// In en, this message translates to:
  /// **'Select a video streaming protocol'**
  String get selectVideoList;

  /// No description provided for @errorNoVideoListPath.
  ///
  /// In en, this message translates to:
  /// **'The path to the video streaming protocols is not defined. Impossible to get the protocol list.'**
  String get errorNoVideoListPath;

  /// No description provided for @errorNoVideoList.
  ///
  /// In en, this message translates to:
  /// **'The path doesn\'t exist or no video streaming protocols have been found.'**
  String get errorNoVideoList;

  /// No description provided for @pleaseVideoRobot.
  ///
  /// In en, this message translates to:
  /// **'Please select a protocol'**
  String get pleaseVideoRobot;

  /// No description provided for @installVideoButton.
  ///
  /// In en, this message translates to:
  /// **'Install a protocol'**
  String get installVideoButton;

  /// No description provided for @intentionTitle.
  ///
  /// In en, this message translates to:
  /// **'Intention Estimation Algorithm'**
  String get intentionTitle;

  /// No description provided for @intentionMenu.
  ///
  /// In en, this message translates to:
  /// **'Intention'**
  String get intentionMenu;

  /// No description provided for @selectIntentionList.
  ///
  /// In en, this message translates to:
  /// **'Select an intention estimation algorithm'**
  String get selectIntentionList;

  /// No description provided for @errorNoIntentionListPath.
  ///
  /// In en, this message translates to:
  /// **'The path to the intention estimation algorithms is not defined. Impossible to get the algorithm list.'**
  String get errorNoIntentionListPath;

  /// No description provided for @errorNoIntentionList.
  ///
  /// In en, this message translates to:
  /// **'The path doesn\'t exist or no intention estimation algorithms have been found.'**
  String get errorNoIntentionList;

  /// No description provided for @pleaseIntentionRobot.
  ///
  /// In en, this message translates to:
  /// **'Please select an algorithm'**
  String get pleaseIntentionRobot;

  /// No description provided for @installIntentionButton.
  ///
  /// In en, this message translates to:
  /// **'Install an algorithm'**
  String get installIntentionButton;

  /// No description provided for @launchTitle.
  ///
  /// In en, this message translates to:
  /// **'Launch the Teleoperation'**
  String get launchTitle;

  /// No description provided for @launchMenu.
  ///
  /// In en, this message translates to:
  /// **'Launch'**
  String get launchMenu;

  /// No description provided for @selectedParametersSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Selected parameters'**
  String get selectedParametersSubTitle;

  /// No description provided for @logSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log'**
  String get logSubtitle;

  /// No description provided for @logAllTab.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get logAllTab;

  /// No description provided for @launchButton.
  ///
  /// In en, this message translates to:
  /// **'Launch'**
  String get launchButton;

  /// No description provided for @stopButton.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stopButton;

  /// No description provided for @exportLogButton.
  ///
  /// In en, this message translates to:
  /// **'Export Log'**
  String get exportLogButton;

  /// No description provided for @saveLaunchParametersButton.
  ///
  /// In en, this message translates to:
  /// **'Save the parameters in a file'**
  String get saveLaunchParametersButton;

  /// No description provided for @loadLaunchParametersButton.
  ///
  /// In en, this message translates to:
  /// **'Load the parameters from a file'**
  String get loadLaunchParametersButton;

  /// No description provided for @genericTitle.
  ///
  /// In en, this message translates to:
  /// **'Configuration'**
  String get genericTitle;

  /// No description provided for @genericMenu.
  ///
  /// In en, this message translates to:
  /// **'Configuration'**
  String get genericMenu;

  /// No description provided for @selectGenericList.
  ///
  /// In en, this message translates to:
  /// **'Select an item'**
  String get selectGenericList;

  /// No description provided for @errorNoGenericListPath.
  ///
  /// In en, this message translates to:
  /// **'The path to the configuration files is not defined. Impossible to get the list.'**
  String get errorNoGenericListPath;

  /// No description provided for @errorNoGenericList.
  ///
  /// In en, this message translates to:
  /// **'The path doesn\'t exist or no configurations have been found.'**
  String get errorNoGenericList;

  /// No description provided for @pleaseSelectGeneric.
  ///
  /// In en, this message translates to:
  /// **'Please select an item'**
  String get pleaseSelectGeneric;

  /// No description provided for @installGenericButton.
  ///
  /// In en, this message translates to:
  /// **'Install an item'**
  String get installGenericButton;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'fr', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
    case 'ja': return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
