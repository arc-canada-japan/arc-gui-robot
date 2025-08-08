// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'ARC Robot';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsMenu => 'Paramètres';

  @override
  String get darkMode => 'Mode sombre';

  @override
  String get language => 'Langue';

  @override
  String errorPkg(Object pkg) {
    return 'Erreur : le paquet « $pkg » est introuvable.';
  }

  @override
  String get errorPkgList => 'Les paquet suivants n\'ont pas été trouvés :';

  @override
  String get errorPkgListTitle => 'Paquets ROS manquants';

  @override
  String get packagePath => 'Chemin du paquet :';

  @override
  String get packagePathTitle => 'Chemins des paquets ROS';

  @override
  String get packageInputManually => 'Cliquez pour saisir le chemin manuellement';

  @override
  String packageInputManuallyTitle(Object pkg) {
    return 'Définir le chemin pour « $pkg »';
  }

  @override
  String get packageInputManuallyHint => '/chemin/vers/le/paquet';

  @override
  String get packagePathNoOverwrite => 'Ne pas écraser les chemins au démarrage';

  @override
  String get sourceSystem => 'Trouvé via le système';

  @override
  String get sourcePrefs => 'Chargé depuis les paramètres';

  @override
  String get sourceMissing => 'Non trouvé';

  @override
  String get packagePathNoOverwriteTooltip => 'Utiliser les chemins enregistrés au lieu de vérifier le système au démarrage (les chemins manquants seront tout de même vérifiés).';

  @override
  String get parametersSavedTitle => 'Paramètres enregistrés';

  @override
  String get description => 'Description:';

  @override
  String get parameters => 'Paramètres';

  @override
  String get saveParametersButton => 'Enregistrer les nouveaux paramètres';

  @override
  String get noParameters => 'Aucun paramètres à afficher, veuillez faire un choix.';

  @override
  String get noPathButtonTooltip => 'Impossible d\'installer sans le chemin du paquet';

  @override
  String get installButtonTooltip => 'Ouvrir l\'assistant d\'installation';

  @override
  String get noSelection => 'Pas de sélection';

  @override
  String get advancedSettings => 'Paramètres avancés';

  @override
  String get rosPath => 'Chemin de l\'exécutable ROS2';

  @override
  String get rosPathTooltip => 'Si ROS2 est déjà dans votre variable d\'environnement PATH, vous pouvez simplement écrire \'ros2\'. Sinon, indiquez le chemin complet.';

  @override
  String get robotTitle => 'Robot';

  @override
  String get robotMenu => 'Robot';

  @override
  String get selectRobotList => 'Sélectionnez un robot';

  @override
  String get errorNoRobotListPath => 'Le chemin vers les contrôleurs de robots n\'est pas défini. Impossible d\'obtenir la liste des robots.';

  @override
  String get errorNoRobotList => 'Le chemin n\'existe pas ou aucun contrôleur de robot n\'a été trouvé.';

  @override
  String get pleaseSelectRobot => 'Veuillez sélectionner un robot';

  @override
  String get installRobotButton => 'Installer un robot';

  @override
  String get communicationTitle => 'Interface de Communication';

  @override
  String get communicationMenu => 'Communication';

  @override
  String get selectCommunicationList => 'Sélectionnez une interface de communication';

  @override
  String get errorNoCommunicationListPath => 'Le chemin vers les interfaces de communication n\'est pas défini. Impossible d\'obtenir la liste.';

  @override
  String get errorNoCommunicationList => 'Le chemin n\'existe pas ou aucune interface de communication n\'a été trouvée.';

  @override
  String get pleaseCommunicationRobot => 'Veuillez sélectionner une interface';

  @override
  String get installCommunicationButton => 'Installer une interface';

  @override
  String get videoTitle => 'Protocole de Streaming Vidéo';

  @override
  String get videoMenu => 'Vidéo';

  @override
  String get selectVideoList => 'Sélectionnez un protocole de streaming vidéo';

  @override
  String get errorNoVideoListPath => 'Le chemin vers les protocoles vidéo n\'est pas défini. Impossible d\'obtenir la liste.';

  @override
  String get errorNoVideoList => 'Le chemin n\'existe pas ou aucun protocole de streaming vidéo n\'a été trouvé.';

  @override
  String get pleaseVideoRobot => 'Veuillez sélectionner un protocole';

  @override
  String get installVideoButton => 'Installer un protocole';

  @override
  String get intentionTitle => 'Algorithme d\'Estimation d\'Intention';

  @override
  String get intentionMenu => 'Intention';

  @override
  String get selectIntentionList => 'Sélectionnez un algorithme d\'estimation d\'intention';

  @override
  String get errorNoIntentionListPath => 'Le chemin vers les algorithmes d\'intention n\'est pas défini. Impossible d\'obtenir la liste.';

  @override
  String get errorNoIntentionList => 'Le chemin n\'existe pas ou aucun algorithme d\'intention n\'a été trouvé.';

  @override
  String get pleaseIntentionRobot => 'Veuillez sélectionner un algorithme';

  @override
  String get installIntentionButton => 'Installer un algorithme';

  @override
  String get launchTitle => 'Démarrer la téléopération';

  @override
  String get launchMenu => 'Démarrer';

  @override
  String get selectedParametersSubTitle => 'Paramètres sélectionnés';

  @override
  String get logSubtitle => 'Log';

  @override
  String get logAllTab => 'Tous';

  @override
  String get launchButton => 'Démarrer';

  @override
  String get stopButton => 'Arrêter';

  @override
  String get exportLogButton => 'Exporter les logs';

  @override
  String get saveLaunchParametersButton => 'Enregistrer les paramètres dans un fichier';

  @override
  String get loadLaunchParametersButton => 'Charger les paramètres depuis un fichier';

  @override
  String get genericTitle => 'Configuration';

  @override
  String get genericMenu => 'Configuration';

  @override
  String get selectGenericList => 'Sélectionnez un élément';

  @override
  String get errorNoGenericListPath => 'Le chemin vers les fichiers de configuration n\'est pas défini. Impossible d\'obtenir la liste.';

  @override
  String get errorNoGenericList => 'Le chemin n\'existe pas ou aucune configuration n\'a été trouvée.';

  @override
  String get pleaseSelectGeneric => 'Veuillez sélectionner un élément';

  @override
  String get installGenericButton => 'Installer un élément';
}
