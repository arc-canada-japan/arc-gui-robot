// A generic configuration page with parameter editing, comments, image, and install button
import 'package:arc_gui/pages/installer_wizard_page.dart';
import 'package:arc_gui/utils/translation_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:arc_gui/l10n/app_localizations.dart';
import 'package:arc_gui/providers/launch_parameter_provider.dart';
import 'package:arc_gui/providers/ros_package_provider.dart';
import 'package:arc_gui/utils/config_file_tools.dart';
import 'package:arc_gui/widgets/package_info_box.dart';
import 'package:arc_gui/widgets/parameter_input.dart';
import 'dart:io';
import 'package:path/path.dart' as p;

class GenericConfigPage extends StatefulWidget {
  final String packageName;
  final String? Function(LaunchParameterProvider provider)
  getSelectedController;
  final void Function(LaunchParameterProvider provider, String value)
  setSelectedController;
  final String? controllerPath;

  const GenericConfigPage({
    super.key,
    required this.packageName,
    required this.getSelectedController,
    required this.setSelectedController,
    this.controllerPath,
  });

  @override
  State<GenericConfigPage> createState() => _GenericConfigPageState();
}

class _GenericConfigPageState extends State<GenericConfigPage> {
  String? selected;
  Map<String, String> parameters = {};
  Map<String, String> comments = {};
  bool hasLangFile = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final launchParams = Provider.of<LaunchParameterProvider>(
        context,
        listen: false,
      );
      final ctrl = widget.getSelectedController(launchParams);
      final controllerPath =
          widget.controllerPath ??
          Provider.of<RosPackageProvider>(
            context,
            listen: false,
          )[widget.packageName];

      if (ctrl != null && controllerPath != null) {
        await _loadParametersAndComments(controllerPath, ctrl);
      }
    });
  }

  Future<void> _loadParametersAndComments(String path, String ctrl) async {
    final commentMap = await loadCommentsFromLang(
      path,
      ctrl,
      Localizations.localeOf(context).languageCode,
    );
    hasLangFile = commentMap.isNotEmpty;

    if (!mounted) return;

    if (hasLangFile) {
      final paramMap = await getParametersFromFile(path, ctrl);
      setState(() {
        selected = ctrl;
        parameters = paramMap;
        comments = commentMap;
      });
    } else {
      final paramMap = await getParametersWithCommentFromFile(path, ctrl);
      setState(() {
        selected = ctrl;
        parameters = {
          for (final e in paramMap.entries) e.key: e.value['value'] ?? '',
        };
        comments = {
          for (final e in paramMap.entries) e.key: e.value['comment'] ?? '',
        };
      });
    }
  }

  Widget _buildDropdown(BuildContext context, String? controllerPath) {
    if (controllerPath == null) {
      return Text(
        getLocalizedStringForPackage(
          context,
          widget.packageName,
          'ErrorListPath',
        ),
        style: TextStyle(
          color: Theme.of(context).colorScheme.error,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    return FutureBuilder<Map<String, String>>(
      future: getListOf(controllerPath),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        final data = snapshot.data ?? {};
        return DropdownButtonFormField<String>(
          value: selected,
          decoration: InputDecoration(
            labelText: getLocalizedStringForPackage(
              context,
              widget.packageName,
              'SelectList',
            ),
            border: const OutlineInputBorder(),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
          ),
          items: data.entries
              .map(
                (e) => DropdownMenuItem<String>(
                  value: e.key,
                  child: Text(e.value),
                ),
              )
              .toList(),
          onChanged: (val) async {
            if (val == null) return;
            setState(() => selected = val);
            final launchParams = Provider.of<LaunchParameterProvider>(
              context,
              listen: false,
            );
            widget.setSelectedController(launchParams, val);
            await _loadParametersAndComments(controllerPath, val);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controllerPath =
        widget.controllerPath ??
        Provider.of<RosPackageProvider>(
          context,
          listen: false,
        )[widget.packageName];
    final localizations = AppLocalizations.of(context)!;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getLocalizedStringForPackage(
                      context,
                      widget.packageName,
                      'Title',
                    ),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  PackageInfoBox(
                    packageName: widget.packageName,
                    path: controllerPath,
                  ),
                  Row(
                    children: [
                      Expanded(child: _buildDropdown(context, controllerPath)),
                      const SizedBox(width: 12),
                      Tooltip(
                        message: controllerPath == null
                            ? localizations.noPathButtonTooltip
                            : localizations.installButtonTooltip,
                        child: ElevatedButton.icon(
                          onPressed: controllerPath == null
                              ? null
                              : () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => InstallerWizardPage(
                                        controllerPath: controllerPath,
                                      ),
                                    ),
                                  );
                                },
                          icon: const Icon(Icons.install_desktop),
                          label: Text(
                            getLocalizedStringForPackage(
                              context,
                              widget.packageName,
                              'InstallButton',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (parameters['#description'] != null)
                    Text(
                      '${localizations.description} ${parameters['#description']}',
                    ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder<File?>(
                        future: selected != null
                            ? findImage(controllerPath!, selected!)
                            : Future.value(null),
                        builder: (context, snapshot) {
                          final file = snapshot.data;
                          return SizedBox(
                            width: 200,
                            height: 200,
                            child: file != null
                                ? Image.file(file, fit: BoxFit.contain)
                                : Container(
                                    color: Colors.grey[300],
                                    child: const Center(
                                      child: Icon(Icons.image_not_supported),
                                    ),
                                  ),
                          );
                        },
                      ),
                      const SizedBox(width: 40),
                      Expanded(
                        child: ParameterInput(
                          parameters: {
                            for (var e in parameters.entries)
                              if (!e.key.startsWith('#')) e.key: e.value,
                          },
                          comments: comments,
                          onChanged: (key, val) =>
                              setState(() => parameters[key] = val),
                          onSave: (allParams) {
                            controllerPath == null || selected == null
                                ? null
                                : hasLangFile
                                ? saveParametersToFile(
                                    controllerPath,
                                    selected!,
                                    parameters,
                                  )
                                : saveParametersWithCommentToFile(
                                    controllerPath,
                                    selected!,
                                    parameters,
                                    comments: comments,
                                  );
                            if (!mounted) return;
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (context) => AlertDialog(
                                title: Text(localizations.parametersSavedTitle),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: allParams.entries
                                        .map(
                                          (e) => Text('${e.key}: ${e.value}'),
                                        )
                                        .toList(),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text(
                                      MaterialLocalizations.of(
                                        context,
                                      ).okButtonLabel,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
