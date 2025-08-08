import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:yaml_edit/yaml_edit.dart';
import 'package:path/path.dart' as p;

/// Returns the path to the config directory: `<inputPath>/share/<packageName>/config`
String getConfigDirPath(String inputPath) {
  //final packageName = inputPath.split('/').last;
  //return '$inputPath/share/$packageName/config';
  return "${getPackageDirPath(inputPath)}/config";
}

String getImageDirPath(String inputPath) {
  return "${getPackageDirPath(inputPath)}/image";
}

String getPackageDirPath(String inputPath) {
  final packageName = inputPath.split('/').last;
  return '$inputPath/share/$packageName';
}

/// Returns a map of filename (without extension) to the 'name' value inside each YAML file.
/// If 'name' is missing, the filename itself is used as the value.
Future<Map<String, String>> getListOf(String inputPath) async {
  final Map<String, String> result = {};
  final configDir = Directory(getConfigDirPath(inputPath));

  if (!await configDir.exists()) return result;

  final files = configDir.listSync().whereType<File>().where((f) {
    final name = f.path;
    final isYaml = name.endsWith('.yaml') || name.endsWith('.yml');
    final isLangFile =
        name.endsWith('.lang.yaml') || name.endsWith('.lang.yml');
    return isYaml && !isLangFile;
  });

  for (final file in files) {
    final fileName = file.uri.pathSegments.last.replaceAll(
      RegExp(r'\.ya?ml$'),
      '',
    );
    try {
      final content = await file.readAsString();
      final yamlMap = loadYaml(content);
      final meta = yamlMap['/**']?['meta'];
      final name = meta?['name']?.toString() ?? fileName;
      result[fileName] = name;
    } catch (e) {
      result[fileName] = fileName; // fallback if invalid YAML
    }
  }
  return result;
}

Future<String?> getNameOf(String inputPath, String key) async {
  final list = await getListOf(inputPath);
  return list[key];
}

Future<File?> findImage(String basePath, String fileName) async {
    const exts = ['.png', '.jpg', '.jpeg'];
    for (final ext in exts) {
      final path = p.join(getImageDirPath(basePath), '$fileName$ext');
      final file = File(path);
      if (await file.exists()) return file;
    }
    return null;
  }

/// Shared logic to load parameters and optionally their comments
Future<Map<String, Map<String, String>>> _loadParametersWithComments(
  String inputPath,
  String fileName, {
  bool excludeMeta = false,
  bool includeComments = false,
}) async {
  final Map<String, Map<String, String>> result = {};
  final configDir = getConfigDirPath(inputPath);

  // Try both .yaml and .yml extensions
  final yamlFile = File('$configDir/$fileName.yaml');
  final ymlFile = File('$configDir/$fileName.yml');
  final file = await yamlFile.exists()
      ? yamlFile
      : await ymlFile.exists()
      ? ymlFile
      : null;

  if (file == null) return result;

  try {
    final lines = await file.readAsLines();
    final rawContent = await file.readAsString();
    final yamlMap = loadYaml(rawContent);
    final params = yamlMap['/**']?['ros__parameters'];
    final meta = yamlMap['/**']?['meta'];

    if (params != null && params is YamlMap) {
      for (final key in params.keys) {
        final keyStr = key.toString();
        final valueStr = params[key].toString();
        String comment = '';

        if (includeComments) {
          final regex = RegExp(
            r'\b' + RegExp.escape(keyStr) + r'\s*:\s*.*?#(.*)',
          );
          final commentLine = lines.firstWhere(
            (line) => regex.hasMatch(line),
            orElse: () => '',
          );
          final match = regex.firstMatch(commentLine);
          comment = match?.group(1)?.trim() ?? '';
        }

        result[keyStr] = {'value': valueStr, 'comment': comment};
      }
    }

    if (meta != null && meta is YamlMap && !excludeMeta) {
      for (final key in meta.keys) {
        final keyStr = key.toString();
        final valueStr = meta[key].toString();
        result['#$keyStr'] = {'value': valueStr, 'comment': ''};
      }
    }
  } catch (_) {
    // Return empty if error
  }

  return result;
}

/// Returns a map of all parameters as strings.
Future<Map<String, String>> getParametersFromFile(
  String inputPath,
  String fileName, {
  bool excludeMeta = false,
}) async {
  final raw = await _loadParametersWithComments(
    inputPath,
    fileName,
    excludeMeta: excludeMeta,
    includeComments: false,
  );
  return {
    for (final entry in raw.entries) entry.key: entry.value['value'] ?? '',
  };
}

/// Returns a map of all parameters and their comments.
Future<Map<String, Map<String, String>>> getParametersWithCommentFromFile(
  String inputPath,
  String fileName, {
  bool excludeMeta = false,
}) async {
  return _loadParametersWithComments(
    inputPath,
    fileName,
    excludeMeta: excludeMeta,
    includeComments: true,
  );
}

/// Saves parameters back to file
Future<void> saveParametersToFile(
  String inputPath,
  String fileName,
  dynamic parameters,
) async {
  final configDir = getConfigDirPath(inputPath);
  final file = File('$configDir/$fileName.yaml');

  if (!await file.exists()) return;

  try {
    final content = await file.readAsString();
    final editor = YamlEditor(content);
    final yamlMap = loadYaml(content);

    final rawParams = parameters is Map<String, Map<String, String>>
        ? parameters
        : (parameters as Map<String, String>).map(
            (k, v) => MapEntry(k, {'value': v}),
          );

    final newParams = Map<String, String>.fromEntries(
      rawParams.entries
          .where((e) => !e.key.startsWith('#'))
          .map((e) => MapEntry(e.key, e.value['value'] ?? '')),
    );

    final root = yamlMap['/**'];
    if (root != null &&
        root is YamlMap &&
        root.containsKey('ros__parameters')) {
      final existingParams = root['ros__parameters'];
      final mergedParams = {...?existingParams, ...newParams};
      editor.update(['/**', 'ros__parameters'], mergedParams);
    }

    await file.writeAsString(editor.toString());
  } catch (_) {
    // Ignore save error
  }
}

/// Saves parameters back to file without modifying existing comments.
Future<void> saveParametersWithCommentToFile(
  String inputPath,
  String fileName,
  dynamic parameters, {
  Map<String, String>? comments,
}) async {
  final configDir = getConfigDirPath(inputPath);
  final file = File('$configDir/$fileName.yaml');

  if (!await file.exists()) return;

  try {
    final lines = await file.readAsLines();
    final newParams = parameters is Map<String, Map<String, String>>
        ? parameters.map((k, v) => MapEntry(k, v['value'] ?? ''))
        : (parameters as Map<String, String>).map((k, v) => MapEntry(k, v));

    final updatedLines = <String>[];
    bool insideRosParams = false;
    final writtenKeys = <String>{};

    for (final line in lines) {
      if (line.trim().startsWith('ros__parameters:')) {
        insideRosParams = true;
        updatedLines.add(line);
        continue;
      }

      if (insideRosParams) {
        final match = RegExp(r'^(\s*)(\w+):').firstMatch(line);
        if (match != null) {
          final indent = match.group(1)!;
          final key = match.group(2)!;
          if (newParams.containsKey(key) && !key.startsWith('#')) {
            final comment = comments?[key];
            final value = newParams[key]!;
            final commentStr = comment != null ? ' # $comment' : '';
            updatedLines.add('$indent$key: $value$commentStr');
            writtenKeys.add(key);
            continue;
          }
        } else if (line.trim().isEmpty || line.startsWith(' ')) {
          updatedLines.add(line);
          continue;
        }

        if (line.trim().isNotEmpty && !line.startsWith(' ')) {
          insideRosParams = false;
        }
      }

      if (!insideRosParams) {
        updatedLines.add(line);
      }
    }

    // Add new parameters
    if (insideRosParams) {
      for (final entry in newParams.entries) {
        final key = entry.key;
        if (!writtenKeys.contains(key) && !key.startsWith('#')) {
          final commentStr = comments?[key] != null
              ? ' # ${comments![key]}'
              : '';
          updatedLines.add('  $key: ${entry.value}$commentStr');
        }
      }
    }

    await file.writeAsString(updatedLines.join('\n'));
  } catch (_) {
    // Ignore save error
  }
}

/// Loads localized comments for parameters based on language
Future<Map<String, String>> loadCommentsFromLang(
  String inputPath,
  String fileName,
  String lang,
) async {
  final Map<String, String> result = {};
  final configDir = getConfigDirPath(inputPath);
  final file = File('$configDir/$fileName.lang.yaml');

  if (!await file.exists()) return result;

  try {
    final content = await file.readAsString();
    final yamlMap = loadYaml(content);

    yamlMap.forEach((key, value) {
      if (value is YamlMap) {
        if (value.containsKey(lang)) {
          result[key.toString()] = value[lang].toString();
        } else if (value.containsKey('en')) {
          result[key.toString()] = value['en'].toString();
        } else {
          final fallbackLang = value.keys.first;
          result[key.toString()] = '$fallbackLang: ${value[fallbackLang]}';
        }
      }
    });
  } catch (_) {
    // Return empty on error
  }

  return result;
}
