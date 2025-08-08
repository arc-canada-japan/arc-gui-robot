import 'package:arc_gui/pages/generic_config_page.dart';
import 'package:arc_gui/pages/launch_page.dart';
import 'package:arc_gui/utils/package_name_enum.dart';
import 'package:flutter/material.dart';
import '../pages/settings_page.dart';

enum AppPage {
  robot,
  communication,
  video,
  intention,
  launch,
  settings,
}

class PageProvider extends ChangeNotifier {
  AppPage _currentPage = AppPage.robot;

  AppPage get currentPage => _currentPage;

  Widget get currentWidget {
    String packageName;
    switch (_currentPage) {
      case AppPage.robot:
        packageName = PackageName.robot;
      case AppPage.communication:
        packageName = PackageName.communication;
      case AppPage.video:
        packageName = PackageName.video;
      case AppPage.intention:
        packageName = PackageName.intention;
      case AppPage.launch:
        return const LaunchPage();
      case AppPage.settings:
        return const SettingsPage();
      default:
        return Center(child: Text('Page: $_currentPage not implemented'));      
    }

    return GenericConfigPage(
      key: ValueKey('generic_${_currentPage.name}'),
      packageName: packageName,
      getSelectedController: (provider) => provider.getSelected(packageName),
      setSelectedController: (provider, value) => provider.setSelected(packageName, value),
    );
  }

  void changePage(AppPage page) {
    _currentPage = page;
    notifyListeners();
  }
}
