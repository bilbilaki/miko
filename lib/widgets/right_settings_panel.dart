import 'package:flutter/material.dart';
import 'package:miko/core/ai/ai_task_orchestrator.dart';
import 'package:miko/services/ai_service_provider.dart';

class RightSettingsPanel extends StatefulWidget {
  const RightSettingsPanel({super.key});

  @override
  State<RightSettingsPanel> createState() => _RightSettingsPanelState();
}

class _RightSettingsPanelState extends State<RightSettingsPanel> {
  late final AITaskOrchestrator _orchestrator;
  late List<String> _availableModels;
  late String _selectedModel;
  double _temperature = 1.0;
  bool _thinkingMode = false;

  @override
  void initState() {
    super.initState();
    _orchestrator = AiServiceProvider().aiTaskOrchestrator;
    _availableModels = _orchestrator.getAvailableModels();
    _selectedModel = _availableModels.first;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: <Widget>[
        const Text(
          'Run settings',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Divider(),
        DropdownButton<String>(
          value: _selectedModel,
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedModel = newValue;
                _orchestrator.setModel(newValue);
              });
            }
          },
          items: _availableModels.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        ListTile(
          title: const Text('Token count'),
          trailing: const Text('34,155 / 1,048,576'),
        ),
        Row(
          children: [
            const Text('Temperature'),
            Expanded(
              child: Slider(
                value: _temperature,
                min: 0.0,
                max: 1.0,
                divisions: 10,
                label: _temperature.toStringAsFixed(1),
                onChanged: (value) {
                  setState(() {
                    _temperature = value;
                    _orchestrator.setTemperature(value);
                  });
                },
              ),
            ),
            Text(_temperature.toStringAsFixed(1)),
          ],
        ),
        ListTile(
          title: const Text('Media Resolution'),
          trailing: const Text('Default'),
          onTap: () {
            // Handle media resolution selection
          },
        ),
        const SizedBox(height: 16),
        const Text(
          'Thinking',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Divider(),
        SwitchListTile(
          title: const Text('Thinking mode'),
          value: _thinkingMode,
          onChanged: (value) {
            setState(() {
              _thinkingMode = value;
              _orchestrator.setThinkingMode(value);
            });
          },
        ),
        ListTile(
          title: const Text('Set thinking budget'),
          trailing: const Icon(Icons.edit),
          onTap: () {
            // Handle set thinking budget
          },
        ),
        const SizedBox(height: 16),
        const Text(
          'Tools',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Divider(),
        ListTile(
          title: const Text('Structured output'),
          trailing: const Icon(Icons.edit),
          onTap: () {
            // Handle structured output
          },
        ),
        ListTile(
          title: const Text('Code execution'),
          trailing: const Icon(Icons.edit),
          onTap: () {
            // Handle code execution
          },
        ),
        ListTile(
          title: const Text('Function calling'),
          trailing: const Icon(Icons.edit),
          onTap: () {
            // Handle function calling
          },
        ),
        ListTile(
          title: const Text('Grounding with Google Search'),
          trailing: const Icon(Icons.edit),
          onTap: () {
            // Handle grounding with Google Search
          },
        ),
        ListTile(
          title: const Text('URL context'),
          trailing: const Icon(Icons.edit),
          onTap: () {
            // Handle URL context
          },
        ),
        const SizedBox(height: 16),
        const Text(
          'Advanced settings',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Divider(),
        ListTile(
          title: const Text('Safety settings'),
          trailing: const Icon(Icons.edit),
          onTap: () {
            // Handle safety settings
          },
        ),
      ],
    );
  }
}