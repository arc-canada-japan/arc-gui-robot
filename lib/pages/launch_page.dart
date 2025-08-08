import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:arc_gui/l10n/app_localizations.dart';
import 'package:arc_gui/providers/ros_package_provider.dart';
import 'package:arc_gui/providers/settings_provider.dart';
import 'package:arc_gui/utils/config_file_tools.dart';
import 'package:arc_gui/utils/package_name_enum.dart';
import 'package:arc_gui/utils/translation_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/launch_parameter_provider.dart';
import 'package:file_selector/file_selector.dart';

class LaunchPage extends StatefulWidget {
  const LaunchPage({super.key});

  @override
  State<LaunchPage> createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  Process? _launchProcess;
  final Map<String, List<String>> _logOutputs = {
    "all": [],
    PackageName.robot: [],
    PackageName.communication: [],
    PackageName.video: [],
    PackageName.intention: [],
  };
  String _activeTab = 'all';
  final ScrollController _scrollController = ScrollController();
  StreamSubscription<String>? _stdoutSub;
  StreamSubscription<String>? _stderrSub;
  late Future<void> _stdoutDone;
  late Future<void> _stderrDone;
  bool _processDeathDetected = false;
  Completer<void>? _deathDetectedCompleter;
  bool _isStopping = false;

  @override
  void dispose() {
    _launchProcess?.kill();
    _scrollController.dispose();
    super.dispose();
  }

  // ros2 launch robot_control controller.launch.py robot_name:=xarm streaming_method:=ffmpeg communication_interface:=ros
  void _startLaunch() async {
    final launchProvider = Provider.of<LaunchParameterProvider>(
      context,
      listen: false,
    );
    if (_launchProcess != null) return;
    final settingsProvider = Provider.of<SettingsProvider>(
      context,
      listen: false,
    );

    // Clear previous logs
    setState(() {
      for (var key in _logOutputs.keys) {
        _logOutputs[key] = [];
      }
    });

    launchProvider.isLaunched = true;
    _processDeathDetected = false;

    final robotId =
        launchProvider.getSelected(PackageName.robot) ?? "NO_METHOD";
    final videoId =
        launchProvider.getSelected(PackageName.video) ?? "NO_METHOD";
    final commId =
        launchProvider.getSelected(PackageName.communication) ?? "NO_METHOD";
    final intentId =
        launchProvider.getSelected(PackageName.intention) ?? "NO_METHOD";

    final process = await Process.start(settingsProvider.rosPath, [
      'launch',
      PackageName.robot,
      'controller.launch.py',
      'robot_name:=$robotId',
      'streaming_method:=$videoId',
      'communication_interface:=$commId',
    ], runInShell: true);

    setState(() => _launchProcess = process);

    void handleLine(String line) {
      setState(() {
        _logOutputs['all']?.add(line);
        if (line.startsWith("[${robotId}_controller-")) {
          _logOutputs[PackageName.robot]?.add(line);
        } else if (line.startsWith("[${videoId}_streamer-")) {
          _logOutputs[PackageName.video]?.add(line);
        } else if (line.startsWith("[default_server_endpoint-")) {
          _logOutputs[PackageName.communication]?.add(line);
        } else if (line.startsWith("[${intentId}_algorithm-")) {
          _logOutputs[PackageName.intention]?.add(line);
        } else if (line.startsWith("[ERROR] [${robotId}_controller-")) {
          if (line.contains("process has died")) {
            // [ERROR] [xarm_controller-3]: process has died
            _processDeathDetected = true;
            _deathDetectedCompleter?.complete();
            if (!_isStopping) {
              _stopLaunch(); // stop immediately if not already stopping
            }
          }
        }
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
    }

    _stdoutSub = process.stdout
        .transform(SystemEncoding().decoder)
        .transform(const LineSplitter())
        .listen(handleLine);
    _stderrSub = process.stderr
        .transform(SystemEncoding().decoder)
        .transform(const LineSplitter())
        .listen(handleLine);

    _stdoutDone = _stdoutSub!.asFuture();
    _stderrDone = _stderrSub!.asFuture();

    process.exitCode.then((_) async {
      //await Future.wait([_stdoutDone, _stderrDone]);
      if (mounted) {
        launchProvider.isLaunched = false;
        setState(() => _launchProcess = null);
      }
    });
  }

  void _stopLaunch() async {
    final process = _launchProcess;
    if (process == null) return;

    setState(() => _isStopping = true);

    process.kill();
    _logOutputs['all']?.add("Stopping process...");

    // Wait for death flag with timeout (max 20 sec)
    const maxWait = Duration(seconds: 20);
    final stopwatch = Stopwatch()..start();

    while (!_processDeathDetected && stopwatch.elapsed < maxWait) {
      await Future.delayed(Duration(milliseconds: 100));
    }

    await process.exitCode;

    if (!mounted) return;

    setState(() {
      _launchProcess = null;
      _stdoutSub = null;
      _stderrSub = null;
      _isStopping = false;
      _deathDetectedCompleter = null;
    });

    Provider.of<LaunchParameterProvider>(context, listen: false).isLaunched =
        false;
    _logOutputs['all']?.add("Process stopped.");
  }

  Future<void> exportLogToFile(String logContent) async {
    const String fileName = 'arc_log_output.txt';

    // Show file save dialog
    final FileSaveLocation? result = await getSaveLocation(
      suggestedName: fileName,
    );
    if (result == null) {
      // User canceled
      return;
    }

    // Prepare log data
    final Uint8List fileData = Uint8List.fromList(logContent.codeUnits);
    const String mimeType = 'text/plain';

    // Save file
    final XFile textFile = XFile.fromData(
      fileData,
      mimeType: mimeType,
      name: fileName,
    );
    await textFile.saveTo(result.path);
  }

  @override
  Widget build(BuildContext context) {
    final launchProvider = Provider.of<LaunchParameterProvider>(context);
    final localizations = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.launchTitle,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),

          ExpansionTile(
            initiallyExpanded: true, // Optional: make it open by default
            title: Text(
              localizations.selectedParametersSubTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            children: [
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: PackageName.packageNames.map((pkgName) {
                    final controllerPath = context
                        .read<RosPackageProvider>()[pkgName];
                    final launchArg = context.read<LaunchParameterProvider>();

                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        width: 150,
                        child: Column(
                          children: [
                            Text(
                              getLocalizedStringForPackage(
                                context,
                                pkgName,
                                "Menu",
                              ),
                            ),
                            const SizedBox(height: 4),
                            FutureBuilder<File?>(
                              future: controllerPath != null
                                  ? findImage(
                                      controllerPath,
                                      launchArg.getSelected(pkgName) ?? "",
                                    )
                                  : Future.value(null),
                              builder: (context, snapshot) {
                                final file = snapshot.data;
                                return SizedBox(
                                  height: 150,
                                  width: 150,
                                  child: file != null
                                      ? Image.file(file, fit: BoxFit.contain)
                                      : Container(
                                          color: Colors.grey[300],
                                          child: const Center(
                                            child: Icon(
                                              Icons.image_not_supported,
                                            ),
                                          ),
                                        ),
                                );
                              },
                            ),
                            const SizedBox(height: 4),
                            FutureBuilder<String?>(
                              future: controllerPath != null
                                  ? getNameOf(
                                      controllerPath,
                                      launchArg.getSelected(pkgName) ?? "",
                                    )
                                  : Future.value(null),
                              builder: (context, snapshot) {
                                return Text(
                                  snapshot.data ?? localizations.noSelection,
                                  style: Theme.of(context).textTheme.bodySmall,
                                  textAlign: TextAlign.center,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => {},
                    label: Text(localizations.saveLaunchParametersButton),
                    icon: const Icon(Icons.save),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () => {},
                    label: Text(localizations.loadLaunchParametersButton),
                    icon: const Icon(Icons.file_open),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),

          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: (launchProvider.isLaunched && !_isStopping)
                ? _stopLaunch
                : (!launchProvider.isLaunched && !_isStopping)
                ? _startLaunch
                : null,
            icon: Icon(
              launchProvider.isLaunched ? Icons.stop : Icons.play_arrow,
              size: 32,
              color: launchProvider.isLaunched
                  ? Theme.of(context).colorScheme.onError
                  : Theme.of(context).colorScheme.onPrimary,
            ),
            label: Text(
              _isStopping
                  ? 'Stopping...'
                  : launchProvider.isLaunched
                  ? localizations.stopButton
                  : localizations.launchButton,
              style: TextStyle(
                fontSize: 20,
                color: launchProvider.isLaunched
                    ? Theme.of(context).colorScheme.onError
                    : Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: launchProvider.isLaunched
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              minimumSize: const Size(200, 60),
            ),
          ),

          const SizedBox(height: 20),
          _buildLogTabs(),
        ],
      ),
    );
  }

  Widget _buildLogTabs() {
    final localizations = AppLocalizations.of(context)!;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                localizations.logSubtitle,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save_alt),
                  label: Text(localizations.exportLogButton),
                  onPressed: () {
                    final fullLog = _logOutputs["all"]?.join('\n') ?? '';
                    exportLogToFile(fullLog);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SegmentedButton<String>(
            style: ButtonStyle(
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              ),
            ),
            segments: [
              ButtonSegment(
                value: "all",
                label: Text('All'),
                icon: Icon(Icons.terminal),
              ),
              ButtonSegment(
                value: PackageName.robot,
                label: Text(localizations.robotMenu),
                icon: Icon(Icons.smart_toy_outlined),
              ),
              ButtonSegment(
                value: PackageName.communication,
                label: Text(localizations.communicationMenu),
                icon: Icon(Icons.message_outlined),
              ),
              ButtonSegment(
                value: PackageName.video,
                label: Text(localizations.videoMenu),
                icon: Icon(Icons.videocam_outlined),
              ),
              ButtonSegment(
                value: PackageName.intention,
                label: Text(localizations.intentionMenu),
                icon: Icon(Icons.auto_awesome_outlined),
              ),
            ],
            selected: <String>{_activeTab},
            onSelectionChanged: (newSelection) {
              setState(() {
                _activeTab = newSelection.first;
              });
            },
          ),
          //const SizedBox(height: 10),
          Expanded(
            child: Row(
              children: [
                const SizedBox(height: 10),
                Expanded(
                  child: Column(
                    children: [
                      // Optional: your SegmentedButton or header here
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          color: Colors.black87,
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            scrollDirection: Axis.vertical,
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: SelectableText(
                                _logOutputs[_activeTab]?.join('\n') ??
                                    'NOTHING TO DISPLAY',
                                style: const TextStyle(
                                  fontFamily: 'Courier',
                                  fontFamilyFallback: ['monospace'],
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
