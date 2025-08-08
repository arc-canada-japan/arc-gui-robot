import 'package:flutter/material.dart';
import 'package:arc_gui/l10n/app_localizations.dart';

class PackageInfoBox extends StatelessWidget {
  final String packageName;
  final String? path;

  const PackageInfoBox({
    super.key,
    required this.packageName,
    required this.path,
  });

  @override
  Widget build(BuildContext context) {
    final hasPath = path != null && path!.isNotEmpty;
    final color = hasPath ? Colors.green : Colors.red;
    final textColor = hasPath ? Colors.green.shade800 : Colors.red.shade800;
    final icon = hasPath ? Icons.info : Icons.report;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: color.shade50,
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: textColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              hasPath
                  ? '${AppLocalizations.of(context)!.packagePath} $path'
                  : AppLocalizations.of(context)!.errorPkg(packageName),
              style: TextStyle(color: textColor),
            ),
          ),
        ],
      ),
    );
  }
}
