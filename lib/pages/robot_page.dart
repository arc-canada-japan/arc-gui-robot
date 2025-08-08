import 'package:arc_gui/l10n/app_localizations.dart';
import 'package:arc_gui/providers/launch_parameter_provider.dart';
import 'package:arc_gui/widgets/package_info_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/parameter_input.dart';
import '../providers/ros_package_provider.dart';
import 'package:arc_gui/utils/config_file_tools.dart';
import 'dart:io';
import 'package:path/path.dart' as p;

// DEPRECIATED -- TO DELETE

class RobotPage extends StatefulWidget {
  const RobotPage({super.key});

  @override
  State<RobotPage> createState() => _RobotPageState();
}

class _RobotPageState extends State<RobotPage> {
  String? selectedRobot;
  Map<String, String> parameters = {};
  Map<String, String> comments = {};
  bool hasLangFile = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final launchParams = Provider.of<LaunchParameterProvider>(context, listen: false);
      final robot = launchParams.getSelected('robot_control');
      final controllerPath = Provider.of<RosPackageProvider>(context, listen: false).robotControlPath;

      if (robot != null && controllerPath != null) {
        _helperLoadParametersAndComments(controllerPath, robot);
      }
    });
  }

  Future<void> _helperLoadParametersAndComments(String controllerPath, String robot) async
  {
    final commentMap = await loadCommentsFromLang(
      controllerPath,
      robot,
      Localizations.localeOf(context).languageCode,
    );

    hasLangFile = commentMap.isNotEmpty;

    if (!mounted) return;

    if (hasLangFile) {
      final paramMap = await getParametersFromFile(controllerPath, robot);
      setState(() {
        selectedRobot = robot;
        parameters = paramMap;
        comments = commentMap;
      });
    } else {
      final paramMap = await getParametersWithCommentFromFile(controllerPath, robot);
      setState(() {
        selectedRobot = robot;
        _helperSplitParamMap(paramMap); // split into `parameters` and `comments`
      });
    }
  }

  void _helperSplitParamMap(Map<String, Map<String, String>> paramMap)
  {
    parameters = {
      for (final entry in paramMap.entries) entry.key: entry.value['value'] ?? '',
    };
    comments = {
      for (final entry in paramMap.entries) entry.key: entry.value['comment'] ?? '',
    };
  }

  Widget buildRobotDropdown({
    required BuildContext context,
    required String? controllerPath,
    required String? selected,
    required void Function(String?) onChanged,
  }) {
    final localizations = AppLocalizations.of(context)!;

    if (controllerPath == null) {
      return Text(
        localizations.errorNoRobotListPath,
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

        if (snapshot.hasError) {
          return Text(
            localizations.errorNoRobotList,
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontWeight: FontWeight.bold,
            ),
          );
        }

        final data = snapshot.data ?? {};
        if (data.isEmpty) {
          return Text(
            localizations.errorNoRobotList,
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontWeight: FontWeight.bold,
            ),
          );
        }

        return DropdownButtonFormField<String>(
          value: selected,
          decoration: InputDecoration(
            labelText: localizations.selectRobotList,
            border: const OutlineInputBorder(),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
          ),
          items: data.entries
              .map(
                (entry) => DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(entry.value),
                ),
              )
              .toList(),
          onChanged: (val) async {
            selectedRobot = val;
            setState(() {
              parameters = {};
            });
            if (val != null) {
              _helperLoadParametersAndComments(controllerPath, val);
              Provider.of<LaunchParameterProvider>(context, listen: false).setSelected('robot_control', val);
            }
          },
          validator: (value) =>
              value == null ? localizations.pleaseSelectRobot : null,
        );
      },
    );
  }

  // Helper: Find the first image that exists with supported extensions
  Future<File?> findRobotImage(String basePath, String fileName) async {
    const extensions = ['.png', '.jpg', '.jpeg'];

    for (final ext in extensions) {
      final imagePath = p.join(basePath, '$fileName$ext');
      final file = File(imagePath);
      if (await file.exists()) return file;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final ros = Provider.of<RosPackageProvider>(context);
    final controllerPath = ros.robotControlPath;
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
                    localizations.robotTitle,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),

                  PackageInfoBox(
                    packageName: 'robot_control',
                    path: ros.robotControlPath,
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: buildRobotDropdown(
                          context: context,
                          controllerPath: controllerPath,
                          selected: selectedRobot,
                          onChanged: (val) {},
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: () {}, // You can update this later
                        icon: const Icon(Icons.install_desktop),
                        label: Text(
                          AppLocalizations.of(context)!.installRobotButton,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  if (parameters["#description"] != null)
                    Text("${localizations.description} ${parameters["#description"]}"),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder<File?>(
                        future: selectedRobot != null
                            ? findRobotImage(
                                getImageDirPath(controllerPath!),
                                selectedRobot!,
                              )
                            : Future.value(null),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox(
                              width: 200,
                              height: 200,
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          final file = snapshot.data;

                          if (file == null) {
                            return Container(
                              width: 200,
                              height: 200,
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(Icons.image_not_supported),
                              ),
                            );
                          }

                          return SizedBox(
                            width: 200,
                            height: 200,
                            child: Image.file(file, fit: BoxFit.contain),
                          );
                        },
                      ),
                      const SizedBox(width: 40),
                      Expanded(
                        child: ParameterInput(
                          parameters: {
                            for (var entry in parameters.entries)
                              if (!entry.key.startsWith('#'))
                                entry.key: entry.value,
                          },
                          comments: comments,
                          onChanged: (key, val) {
                            setState(() {
                              parameters[key] = val;
                            });
                          },
                          onSave: (allParams) {
                            hasLangFile 
                              ? saveParametersToFile(controllerPath!, selectedRobot!, parameters)
                              : saveParametersWithCommentToFile(controllerPath!, selectedRobot!, parameters, comments: comments);
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                    localizations.parametersSavedTitle,
                                  ),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: allParams.entries.map((e) {
                                        return Text('${e.key}: ${e.value}');
                                      }).toList(),
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
                                );
                              },
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
