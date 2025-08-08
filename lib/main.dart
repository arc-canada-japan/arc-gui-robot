import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/page_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/ros_package_provider.dart';
import 'providers/launch_parameter_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settings = SettingsProvider();
  await settings.loadSettings();

  final ros = RosPackageProvider();
  await ros.initialize(settings); // Pass settings here

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => settings),
        ChangeNotifierProvider(create: (_) => PageProvider()),
        ChangeNotifierProvider(create: (_) => ros),
        ChangeNotifierProvider(create: (_) => LaunchParameterProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
