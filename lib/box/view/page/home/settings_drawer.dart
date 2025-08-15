import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:miko/box/data/store/setting.dart';

class AiSettingsDrawerHive extends StatefulWidget {
  const AiSettingsDrawerHive({super.key});

  @override
  State<AiSettingsDrawerHive> createState() => _AiSettingsDrawerHiveState();
}

class _AiSettingsDrawerHiveState extends State<AiSettingsDrawerHive> {
  SettingStore get ss => SettingStore.instance;

  @override
  Widget build(BuildContext context) {
    final openAIVoiceOptions = const [
      'alloy',
      'ash',
      'echo',
      'ballad',
      'sage',
      'coral',
      'shimmer',
    ];

    return Drawer(
      width: 320,
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(left: Radius.circular(0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Run settings',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.white),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.push_pin_outlined,
                        size: 20,
                        color: Colors.white54,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Pin feature not yet implemented'),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 20,
                        color: Colors.white54,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                _SliderRow(
                  label: 'Temperature',
                  valueListenable: ss.temperature.listenable(),
                  min: 0.0,
                  max: 1.0,
                  divisions: 100,
                  onChanged: (v) =>
                      ss.temperature.set(double.parse(v.toStringAsFixed(2))),
                ),
                _DropdownRow(
                  label: 'Media resolution',
                  options: const ['Default', 'High'],
                  valueListenable: ss.mediaResolution.listenable(),
                  onChanged: (v) => ss.mediaResolution.set(v ?? 'Default'),
                ),
                const Divider(color: Colors.white10),
                _SwitchRow(
                  label: 'Enable Tools',
                  valueListenable: ss.toolsEnabled.listenable(),
                  onChanged: ss.toolsEnabled.set,
                ),
                _SwitchRow(
                  label: 'Enable Voice Response',
                  valueListenable: ss.voiceResponse.listenable(),
                  onChanged: ss.voiceResponse.set,
                ),
                ValueListenableBuilder(
                  valueListenable: ss.voiceResponse.listenable(),
                  builder: (context, vr, _) => vr
                      ? _DropdownRow(
                          label: 'Select Voice',
                          options: openAIVoiceOptions,
                          valueListenable: ss.selectedVoice.listenable(),
                          onChanged: (v) {
                            if (v != null && openAIVoiceOptions.contains(v)) {
                              ss.selectedVoice.set(v);
                            }
                          },
                        )
                      : const SizedBox.shrink(),
                ),
                _SwitchRow(
                  label: 'Enable Streaming',
                  valueListenable: ss.streaming.listenable(),
                  onChanged: ss.streaming.set,
                ),
                _SwitchRow(
                  label: 'Enable History',
                  valueListenable: ss.historyEnabled.listenable(),
                  onChanged: ss.historyEnabled.set,
                ),
                _SwitchRow(
                  label: 'Enable Thinking Mode',
                  valueListenable: ss.thinkingModeEnabled.listenable(),
                  onChanged: ss.thinkingModeEnabled.set,
                ),
                _SwitchRow(
                  label: 'Enable System Message',
                  valueListenable: ss.persistSystemMessage.listenable(),
                  onChanged: ss.persistSystemMessage.set,
                ),
                const Divider(color: Colors.white10),
                _SwitchRow(
                  label: 'Set Thinking Budget',
                  valueListenable: ss.thinkingBudgetEnabled.listenable(),
                  onChanged: ss.thinkingBudgetEnabled.set,
                ),
                const Divider(color: Colors.white10),
                _Expansion(
                  title: 'Tools',
                  children: [
                    _SwitchRow(
                      label: 'Structured Output',
                      valueListenable: ss.structuredOutputEnabled.listenable(),
                      onChanged: ss.structuredOutputEnabled.set,
                    ),
                    _SwitchRow(
                      label: 'Code Execution',
                      valueListenable: ss.codeExecutionEnabled.listenable(),
                      onChanged: ss.codeExecutionEnabled.set,
                    ),
                    _SwitchRow(
                      label: 'Function Calling',
                      valueListenable: ss.functionCallingEnabled.listenable(),
                      onChanged: ss.functionCallingEnabled.set,
                    ),
                    _SwitchRow(
                      label: 'Grounding with Google Search',
                      valueListenable: ss.groundingWithSearchEnabled
                          .listenable(),
                      onChanged: ss.groundingWithSearchEnabled.set,
                    ),
                    _SwitchRow(
                      label: 'URL context',
                      valueListenable: ss.urlContextEnabled.listenable(),
                      onChanged: ss.urlContextEnabled.set,
                    ),
                  ],
                ),
                _Expansion(
                  title: 'Advanced settings',
                  children: [
                    _SwitchRow(
                      label: 'Safety settings',
                      valueListenable: ss.safetySettingsEnabled.listenable(),
                      onChanged: ss.safetySettingsEnabled.set,
                    ),
                    _SwitchRow(
                      label: 'Add stop sequence',
                      valueListenable: ss.addStopSequenceEnabled.listenable(),
                      onChanged: ss.addStopSequenceEnabled.set,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Live token count (read-only)
                ValueListenableBuilder(
                  valueListenable: ss.currentTokenCount.listenable(),
                  builder: (context, val, _) => _SliderRow.readOnly(
                    label: 'Token count',
                    value: (val).toDouble(),
                    min: 0,
                    max: ss.maxTokens.get().toDouble(),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _resetAll,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red.shade700,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Clear All Settings'),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _resetAll() {
    final ss = SettingStore.instance;
    // reset only things exposed in this drawer
    ss.temperature.set(1.0);
    ss.mediaResolution.set('Default');
    ss.toolsEnabled.set(false);
    ss.voiceResponse.set(false);
    ss.selectedVoice.set('alloy');
    ss.streaming.set(true);
    ss.historyEnabled.set(false);
    ss.thinkingModeEnabled.set(false);
    ss.persistSystemMessage.set(true);
    ss.thinkingBudgetEnabled.set(false);
    ss.structuredOutputEnabled.set(false);
    ss.codeExecutionEnabled.set(false);
    ss.functionCallingEnabled.set(false);
    ss.groundingWithSearchEnabled.set(false);
    ss.urlContextEnabled.set(false);
    ss.safetySettingsEnabled.set(false);
    ss.addStopSequenceEnabled.set(false);
    // token count is runtime; keep it
    setState(() {});
  }
}

class _DropdownRow extends StatelessWidget {
  final String label;
  final List<String> options;
  final ValueListenable<dynamic> valueListenable;
  final ValueChanged<String?> onChanged;

  const _DropdownRow({
    required this.label,
    required this.options,
    required this.valueListenable,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: valueListenable,
      builder: (_, value, __) {
        final cur = value?.toString() ?? options.first;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 4),
              DropdownButtonFormField<String>(
                value: cur,
                dropdownColor: Colors.grey[800],
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.white10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.white10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                items: options
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(
                          e,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: onChanged,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SliderRow extends StatelessWidget {
  final String label;
  final ValueListenable<dynamic>? valueListenable;
  final double? value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double>? onChanged;

  const _SliderRow({
    required this.label,
    required this.valueListenable,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
    this.value,
  });

  const _SliderRow.readOnly({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
  }) : divisions = 1,
       onChanged = null,
       valueListenable = null;

  @override
  Widget build(BuildContext context) {
    final child = (double v) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              Text(
                v == v.roundToDouble()
                    ? v.toInt().toString()
                    : v.toStringAsFixed(2),
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
          Slider(
            value: v.clamp(min, max),
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
            activeColor: Theme.of(context).colorScheme.primary,
            inactiveColor: Colors.white10,
          ),
        ],
      ),
    );

    if (valueListenable != null) {
      return ValueListenableBuilder(
        valueListenable: valueListenable!,
        builder: (_, val, __) => child((val as num).toDouble()),
      );
    } else {
      return child(value ?? min);
    }
  }
}

class _SwitchRow extends StatelessWidget {
  final String label;
  final ValueListenable<dynamic> valueListenable;
  final ValueChanged<bool> onChanged;

  const _SwitchRow({
    required this.label,
    required this.valueListenable,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: valueListenable,
      builder: (_, val, __) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.white)),
            Switch(
              value: (val as bool? ?? false),
              onChanged: onChanged,
              activeColor: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}

class _Expansion extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _Expansion({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        children: children,
        collapsedIconColor: Colors.white54,
        iconColor: Colors.white,
      ),
    );
  }
}
