import 'package:flutter/material.dart';

class InstallerWizardPage extends StatelessWidget {
  final String controllerPath;

  const InstallerWizardPage({super.key, required this.controllerPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Installer"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text("Installer logic for:\n\n$controllerPath"),
      ),
    );
  }
}
