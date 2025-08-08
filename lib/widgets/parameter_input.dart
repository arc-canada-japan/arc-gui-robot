import 'package:flutter/material.dart';
import 'package:arc_gui/l10n/app_localizations.dart';

class ParameterInput extends StatefulWidget {
  final Map<String, String> parameters;
  final Map<String, String> comments;
  final void Function(String key, String value)? onChanged;
  final void Function(Map<String, String> allParams)? onSave;

  const ParameterInput({
    super.key,
    required this.parameters,
    this.comments = const {},
    this.onChanged,
    this.onSave,
  });

  @override
  State<ParameterInput> createState() => _ParameterInputState();
}

class _ParameterInputState extends State<ParameterInput> {
  final Map<String, TextEditingController> _controllers = {};
  bool _hasChanged = false;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    widget.parameters.forEach((key, value) {
      _controllers[key] = TextEditingController(text: value);
    });
  }

  @override
  void didUpdateWidget(covariant ParameterInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update controllers if keys changed
    for (final key in widget.parameters.keys) {
      if (!_controllers.containsKey(key)) {
        _controllers[key] = TextEditingController(
          text: widget.parameters[key]!,
        );
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _handleSave() {
    final updatedParams = {
      for (var entry in _controllers.entries) entry.key: entry.value.text,
    };
    widget.onSave?.call(updatedParams);
    setState(() => _hasChanged = false);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    if (widget.parameters.isEmpty) {
      return Text(
        localizations.noParameters,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );
    }

    return Card(
      elevation: 2,
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).colorScheme.outline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.parameters,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...widget.parameters.keys.map((key) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: TextField(
                  controller: _controllers[key],
                  decoration: InputDecoration(
                    labelText: key,
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Courier',
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 22,
                    ),
                    fillColor: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    filled: true,
                    helperText: widget.comments[key],
                  ),
                  onChanged: (val) {
                    widget.onChanged?.call(key, val);
                    setState(() => _hasChanged = true);
                  },
                ),
              );
            }),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: _hasChanged ? _handleSave : null,
                icon: const Icon(Icons.save),
                label: Text(localizations.saveParametersButton),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
