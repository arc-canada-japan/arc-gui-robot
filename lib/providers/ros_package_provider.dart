import 'dart:io';
import 'package:arc_gui/utils/package_name_enum.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:arc_gui/providers/settings_provider.dart';

class RosPackageProvider with ChangeNotifier {
  String? robotControlPath;
  String? communicationInterfacePath;
  String? videoPublisherPath;
  String? intentionEstimationPath;

  static const _prefsKeys = {
    PackageName.robot: 'ros_pkg_robot_control',
    PackageName.communication: 'ros_pkg_communication_interface',
    PackageName.video: 'ros_pkg_video_publisher',
    PackageName.intention: 'ros_pkg_intention_estimation',
  };

  final Map<String, String> packageSources = {};
  late SettingsProvider _settingsProvider;

  Future<void> initialize(SettingsProvider settings) async {
    _settingsProvider = settings;
    final prefs = await SharedPreferences.getInstance();
    packageSources.clear();

    // If preserve is false, clear in-memory and check all via command
    if (!settings.preservePackagePaths) {
      robotControlPath = await _checkAndUpdateFromCommand(
        PackageName.robot,
        prefs,
        source: packageSources,
      );
      communicationInterfacePath = await _checkAndUpdateFromCommand(
        PackageName.communication,
        prefs,
        source: packageSources,
      );
      videoPublisherPath = await _checkAndUpdateFromCommand(
        PackageName.video,
        prefs,
        source: packageSources,
      );
      intentionEstimationPath = await _checkAndUpdateFromCommand(
        PackageName.intention,
        prefs,
        source: packageSources,
      );
    } else {
      await _checkAndStoreWithFallback(
        PackageName.robot,
        (v) => robotControlPath = v,
        prefs,
        packageSources,
      );
      await _checkAndStoreWithFallback(
        PackageName.communication,
        (v) => communicationInterfacePath = v,
        prefs,
        packageSources,
      );
      await _checkAndStoreWithFallback(
        PackageName.video,
        (v) => videoPublisherPath = v,
        prefs,
        packageSources,
      );
      await _checkAndStoreWithFallback(
        PackageName.intention,
        (v) => intentionEstimationPath = v,
        prefs,
        packageSources,
      );
    }

    notifyListeners();
  }

  Future<String?> _checkAndUpdateFromCommand(
    String pkg,
    SharedPreferences prefs, {
    required Map<String, String> source,
  }) async {
    final result = await _getPathFromCommand(pkg);
    if (result != null) {
      await prefs.setString(_prefsKeys[pkg]!, result);
      source[pkg] = 'system';
      return result;
    } else {
      await prefs.remove(_prefsKeys[pkg]!); // remove outdated
      source[pkg] = 'missing';
      return null;
    }
  }

  Future<void> _checkAndStoreWithFallback(
    String pkg,
    Function(String) setter,
    SharedPreferences prefs,
    Map<String, String> source,
  ) async {
    final result = await _getPathFromCommand(pkg);
    if (result != null) {
      setter(result);
      await prefs.setString(_prefsKeys[pkg]!, result);
      source[pkg] = 'system';
    } else {
      final stored = prefs.getString(_prefsKeys[pkg]!);
      if (stored != null && stored.isNotEmpty) {
        setter(stored);
        source[pkg] = 'prefs';
      } else {
        source[pkg] = 'missing';
      }
    }
  }

  Future<String?> _getPathFromCommand(String pkg) async {
    try {
      final result = await Process.run(_settingsProvider.rosPath, [
        'pkg',
        'prefix',
        pkg,
      ]);
      final output = (result.stdout as String).trim();
      if (output.contains('Package') || output.isEmpty) return null;
      return output;
    } catch (e) {
      print('Caught a general exception: $e');
      return null;
    }
  }

  Future<void> updatePath(String packageName, String path) async {
    final prefs = await SharedPreferences.getInstance();

    switch (packageName) {
      case PackageName.robot:
        robotControlPath = path;
        break;
      case PackageName.communication:
        communicationInterfacePath = path;
        break;
      case PackageName.video:
        videoPublisherPath = path;
        break;
      case PackageName.intention:
        intentionEstimationPath = path;
        break;
    }

    await prefs.setString(_prefsKeys[packageName]!, path);
    notifyListeners();
  }

  /// Allows access via provider['package_name']
  String? operator [](String packageName) {
    switch (packageName) {
      case PackageName.robot:
        return robotControlPath;
      case PackageName.communication:
        return communicationInterfacePath;
      case PackageName.video:
        return videoPublisherPath;
      case PackageName.intention:
        return intentionEstimationPath;
      default:
        return null;
    }
  }
}
