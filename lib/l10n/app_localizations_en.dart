// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'ARC Robot';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsMenu => 'Settings';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get language => 'Language';

  @override
  String errorPkg(Object pkg) {
    return 'Error: \'$pkg\' package not found.';
  }

  @override
  String get errorPkgList => 'The following packages were not found:';

  @override
  String get errorPkgListTitle => 'Missing ROS Packages';

  @override
  String get packagePath => 'Package\'s Path:';

  @override
  String get packagePathTitle => 'ROS Package Paths';

  @override
  String get packageInputManually => 'Click to input the path manually';

  @override
  String packageInputManuallyTitle(Object pkg) {
    return 'Set path for \'$pkg\'';
  }

  @override
  String get packageInputManuallyHint => '/path/to/package';

  @override
  String get packagePathNoOverwrite => 'Do not overwrite path values at startup';

  @override
  String get sourceSystem => 'Found via system';

  @override
  String get sourcePrefs => 'Loaded from saved settings';

  @override
  String get sourceMissing => 'Not found';

  @override
  String get packagePathNoOverwriteTooltip => 'Use previously saved paths instead of checking the system at startup (the missing path will still be checked).';

  @override
  String get parametersSavedTitle => 'Parameters saved';

  @override
  String get description => 'Description:';

  @override
  String get parameters => 'Parameters';

  @override
  String get saveParametersButton => 'Save the new parameters';

  @override
  String get noParameters => 'No parameters to display, please make a choice.';

  @override
  String get noPathButtonTooltip => 'Impossible to install without the path';

  @override
  String get installButtonTooltip => 'Open the install wizard';

  @override
  String get noSelection => 'No selection';

  @override
  String get advancedSettings => 'Advanced Settings';

  @override
  String get rosPath => 'Path of the ROS2 executable';

  @override
  String get rosPathTooltip => 'If ROS2 is already installed in your system PATH you can only write \'ros2\', otherwise you should indicate the full path.';

  @override
  String get robotTitle => 'Robot';

  @override
  String get robotMenu => 'Robot';

  @override
  String get selectRobotList => 'Select a robot';

  @override
  String get errorNoRobotListPath => 'The path to the robot controllers is not defined. Impossible to get the robot list.';

  @override
  String get errorNoRobotList => 'The path doesn\'t exist or no robot controllers have been found.';

  @override
  String get pleaseSelectRobot => 'Please select a robot';

  @override
  String get installRobotButton => 'Install a robot';

  @override
  String get communicationTitle => 'Communication Interface';

  @override
  String get communicationMenu => 'Communication';

  @override
  String get selectCommunicationList => 'Select a communication interface';

  @override
  String get errorNoCommunicationListPath => 'The path to the communication interfaces is not defined. Impossible to get the interface list.';

  @override
  String get errorNoCommunicationList => 'The path doesn\'t exist or no communication interfaces have been found.';

  @override
  String get pleaseCommunicationRobot => 'Please select an interface';

  @override
  String get installCommunicationButton => 'Install an interface';

  @override
  String get videoTitle => 'Video Streaming Protocol';

  @override
  String get videoMenu => 'Video';

  @override
  String get selectVideoList => 'Select a video streaming protocol';

  @override
  String get errorNoVideoListPath => 'The path to the video streaming protocols is not defined. Impossible to get the protocol list.';

  @override
  String get errorNoVideoList => 'The path doesn\'t exist or no video streaming protocols have been found.';

  @override
  String get pleaseVideoRobot => 'Please select a protocol';

  @override
  String get installVideoButton => 'Install a protocol';

  @override
  String get intentionTitle => 'Intention Estimation Algorithm';

  @override
  String get intentionMenu => 'Intention';

  @override
  String get selectIntentionList => 'Select an intention estimation algorithm';

  @override
  String get errorNoIntentionListPath => 'The path to the intention estimation algorithms is not defined. Impossible to get the algorithm list.';

  @override
  String get errorNoIntentionList => 'The path doesn\'t exist or no intention estimation algorithms have been found.';

  @override
  String get pleaseIntentionRobot => 'Please select an algorithm';

  @override
  String get installIntentionButton => 'Install an algorithm';

  @override
  String get launchTitle => 'Launch the Teleoperation';

  @override
  String get launchMenu => 'Launch';

  @override
  String get selectedParametersSubTitle => 'Selected parameters';

  @override
  String get logSubtitle => 'Log';

  @override
  String get logAllTab => 'All';

  @override
  String get launchButton => 'Launch';

  @override
  String get stopButton => 'Stop';

  @override
  String get exportLogButton => 'Export Log';

  @override
  String get saveLaunchParametersButton => 'Save the parameters in a file';

  @override
  String get loadLaunchParametersButton => 'Load the parameters from a file';

  @override
  String get genericTitle => 'Configuration';

  @override
  String get genericMenu => 'Configuration';

  @override
  String get selectGenericList => 'Select an item';

  @override
  String get errorNoGenericListPath => 'The path to the configuration files is not defined. Impossible to get the list.';

  @override
  String get errorNoGenericList => 'The path doesn\'t exist or no configurations have been found.';

  @override
  String get pleaseSelectGeneric => 'Please select an item';

  @override
  String get installGenericButton => 'Install an item';
}
