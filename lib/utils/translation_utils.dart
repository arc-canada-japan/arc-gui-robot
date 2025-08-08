import 'package:flutter/material.dart';
import 'package:arc_gui/l10n/app_localizations.dart';

/// Get the localized string based on the package and suffix.
/// 
/// Examples:
/// - packageName: 'robot_control', suffix: 'Title' → will look for `robotTitle`
/// - packageName: 'video_publisher', suffix: 'InstallButton' → `videoInstallButton`
String getLocalizedStringForPackage(
  BuildContext context,
  String packageName,
  String suffix, {
  String fallback = '',
}) {
  final l10n = AppLocalizations.of(context)!;

  // Extract only the first word from packageName (e.g., 'robot' from 'robot_control')
  final shortKey = packageName.split('_').first;

  final key = '${shortKey}${suffix[0].toUpperCase()}${suffix.substring(1)}';

  // Manually mapped keys (since AppLocalizations is not a Map)
  final Map<String, String> l10nMap = {
    'robotTitle': l10n.robotTitle,
    'robotMenu': l10n.robotMenu,
    'robotSelectList': l10n.selectRobotList,
    'robotInstallButton': l10n.installRobotButton,
    'robotErrorListPath': l10n.errorNoRobotListPath,
    'robotErrorList': l10n.errorNoRobotList,
    'robotPleaseSelect': l10n.pleaseSelectRobot,

    'communicationTitle': l10n.communicationTitle,
    'communicationMenu': l10n.communicationMenu,
    'communicationSelectList': l10n.selectCommunicationList,
    'communicationInstallButton': l10n.installCommunicationButton,
    'communicationErrorListPath': l10n.errorNoCommunicationListPath,
    'communicationErrorList': l10n.errorNoCommunicationList,
    'communicationPleaseSelect': l10n.pleaseCommunicationRobot,

    'videoTitle': l10n.videoTitle,
    'videoMenu': l10n.videoMenu,
    'videoSelectList': l10n.selectVideoList,
    'videoInstallButton': l10n.installVideoButton,
    'videoErrorListPath': l10n.errorNoVideoListPath,
    'videoErrorList': l10n.errorNoVideoList,
    'videoPleaseSelect': l10n.pleaseVideoRobot,

    'intentionTitle': l10n.intentionTitle,
    'intentionMenu': l10n.intentionMenu,
    'intentionSelectList': l10n.selectIntentionList,
    'intentionInstallButton': l10n.installIntentionButton,
    'intentionErrorListPath': l10n.errorNoIntentionListPath,
    'intentionErrorList': l10n.errorNoIntentionList,
    'intentionPleaseSelect': l10n.pleaseIntentionRobot,

    'genericTitle': l10n.genericTitle,
    'genericInstallButton': l10n.installGenericButton,
    'genericSelectList': l10n.selectGenericList,
    'genericErrorList': l10n.errorNoGenericList,
    'genericErrorListPath': l10n.errorNoGenericListPath,
    'genericPleaseSelect': l10n.pleaseSelectGeneric,
  };

  return l10nMap[key] ?? fallback;
}
