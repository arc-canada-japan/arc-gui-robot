import 'package:arc_gui/providers/ros_package_provider.dart';
import 'package:arc_gui/utils/package_name_enum.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import 'package:arc_gui/l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final ros = Provider.of<RosPackageProvider>(context);
    final isDark = settings.themeMode == ThemeMode.dark;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: ListView(
        children: [
          Text(AppLocalizations.of(context)!.settingsTitle, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 20),

          // Theme mode toggle
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: Text(AppLocalizations.of(context)!.darkMode),
            trailing: Switch(
              value: isDark,
              onChanged: (value) => settings.toggleTheme(value),
            ),
          ),
          const Divider(),

          // Language selector
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(AppLocalizations.of(context)!.language),
            trailing: DropdownButton<String>(
              value: settings.locale?.languageCode ?? 'en',
              onChanged: (value) {
                if (value != null) settings.changeLanguage(value);
              },
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'ja', child: Text('日本語')),
                DropdownMenuItem(value: 'fr', child: Text('Français')),
              ],
            ),
          ),
          const Divider(),

          ExpansionTile(            
            title: Text(
              AppLocalizations.of(context)!.advancedSettings,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: [

          _buildPathTile(
            context,
            label: AppLocalizations.of(context)!.rosPath,
            value: settings.rosPath,
            onChanged: (path) => settings.changeRosPath(path.trim()),
            tooltip: AppLocalizations.of(context)!.rosPathTooltip
          ),

          // Section title
          Text(
            AppLocalizations.of(context)!.packagePathTitle,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // Preserve package paths toggle
          ListTile(
            leading: const Icon(Icons.save_alt),
            title: Row(
              children: [
                Text(AppLocalizations.of(context)!.packagePathNoOverwrite),
                const SizedBox(width: 4),
                Tooltip(
                  message: AppLocalizations.of(context)!.packagePathNoOverwriteTooltip,
                  child: const Icon(Icons.help, size: 18),
                ),
              ],
            ),
            trailing: Switch(
              value: settings.preservePackagePaths,
              onChanged: (value) => settings.togglePreservePaths(value),
            ),
          ),
          const SizedBox(height: 10),

          

          // Package path tiles
          _buildPathTile(
            context,
            label: PackageName.robot,
            value: ros.robotControlPath,
            onChanged: (path) => ros.updatePath(PackageName.robot, path.trim()),
          ),
          //const Divider(),
          _buildPathTile(
            context,
            label: PackageName.communication,
            value: ros.communicationInterfacePath,
            onChanged: (path) => ros.updatePath(PackageName.communication, path.trim()),
          ),
          //const Divider(),
          _buildPathTile(
            context,
            label: PackageName.video,
            value: ros.videoPublisherPath,
            onChanged: (path) => ros.updatePath(PackageName.video, path.trim()),
          ),
          //const Divider(),
          _buildPathTile(
            context,
            label: PackageName.intention,
            value: ros.intentionEstimationPath,
            onChanged: (path) => ros.updatePath(PackageName.intention, path.trim()),
          ),
          //const Divider(),
          ]),
        ],
      ),
    );
  }


  Widget _buildPathTile(
    BuildContext context, {
    required String label,
    required String? value,
    required Function(String) onChanged,
    String? tooltip
  }) {
    return ListTile(
      leading: const Icon(Icons.folder),
      title: tooltip == null ? Text(label) : Row(
              children: [
                Text(label),
                const SizedBox(width: 4),
                Tooltip(
                  message: tooltip,
                  child: const Icon(Icons.help, size: 18),
                ),
              ],
            ),
      subtitle: Text(
        value?.isNotEmpty == true ? value! : AppLocalizations.of(context)!.packageInputManually,
        style: TextStyle(
          color: value?.isNotEmpty == true
              ? Theme.of(context).textTheme.bodySmall?.color
              : Theme.of(context).colorScheme.error,
        ),
      ),
      onTap: () async {
        final controller = TextEditingController(text: value);
        final result = await showDialog<String>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.packageInputManuallyTitle(label)),
              content: TextField(
                controller: controller,
                decoration: InputDecoration(hintText: AppLocalizations.of(context)!.packageInputManuallyHint),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, controller.text.trim()),
                  child: Text(MaterialLocalizations.of(context).saveButtonLabel),
                ),
              ],
            );
          },
        );

        if (result != null && result.isNotEmpty) {
          onChanged(result);
        }
      },
    );
  }
}
