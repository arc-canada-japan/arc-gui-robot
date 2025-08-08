import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/settings_provider.dart';
import 'providers/ros_package_provider.dart';
import 'providers/page_provider.dart';
import 'widgets/sidebar.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return MaterialApp(
      title: 'ARC Robot',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: settings.themeMode,
      locale: settings.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const AppInitializer(),
    );
  }
}

class HomeLayout extends StatelessWidget {
  const HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final currentPage = context.watch<PageProvider>().currentWidget;

    return Scaffold(
      body: Row(
        children: [
          const Sidebar(),
          Expanded(child: currentPage),
        ],
      ),
    );
  }
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      _initializeRosPackages();
    }
  }

  Future<void> _initializeRosPackages() async {
    final ros = Provider.of<RosPackageProvider>(context, listen: false);
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final localizations = AppLocalizations.of(context)!;

    await ros.initialize(settings);

    // Skip dialog if all packages were loaded from system
    final allFromSystem = ros.packageSources.values.every((s) => s == 'system');
    if (allFromSystem) return;

    iconColor(String source) {
      switch (source) {
        case 'system':
          return Colors.green;
        case 'prefs':
          return Colors.orange;
        case 'missing':
        default:
          return Colors.red;
      }
    }

    iconType(String source) {
      switch (source) {
        case 'system':
          return Icons.check_circle;
        case 'prefs':
          return Icons.warning;
        case 'missing':
        default:
          return Icons.report;
      }
    }

    sourceText(String source) {
      switch (source) {
        case 'system':
          return localizations.sourceSystem;
        case 'prefs':
          return localizations.sourcePrefs;
        case 'missing':
        default:
          return localizations.sourceMissing;
      }
    }

    final rows = ros.packageSources.entries.map((entry) {
      final source = entry.value;
      final label = entry.key;

      return Row(
        children: [
          Icon(iconType(source), color: iconColor(source), size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Text(
            '— ${sourceText(source)}',
            style: TextStyle(color: iconColor(source)),
          ),
        ],
      );
    }).toList();

    if (context.mounted) {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(localizations.errorPkgListTitle),
          content: SizedBox(
            width: 400, // wider dialog
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(localizations.errorPkgList),
                const SizedBox(height: 16),
                ...rows,
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(MaterialLocalizations.of(context).okButtonLabel),
            ),
          ],
        ),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return const HomeLayout();
  }
}