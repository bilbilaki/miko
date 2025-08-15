import 'package:flutter/material.dart';
import 'package:miko/box/data/res/openai.dart';
import 'package:openai_dart/openai_dart.dart';

class PromptGeneratorDialog extends StatefulWidget {
  final ValueChanged<String> onPromptGenerated;

  const PromptGeneratorDialog({super.key, required this.onPromptGenerated});

  @override
  State<PromptGeneratorDialog> createState() => _PromptGeneratorDialogState();
}

class _PromptGeneratorDialogState extends State<PromptGeneratorDialog> {
  final _topicController = TextEditingController();
  String _generatedPrompt = '';
  bool _isLoading = false;

  Future<void> _generate() async {
    final topic = _topicController.text.trim();
    if (topic.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      final prompt = await generatePromptFromTopic(topic);
      setState(() => _generatedPrompt = prompt);
    } catch (e) {
      setState(() => _generatedPrompt = "Error generating prompt: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Generate Prompt'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _topicController,
              decoration: const InputDecoration(
                labelText: 'Enter a topic or idea',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _generate(),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _generate,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(),
                    )
                  : const Icon(Icons.auto_awesome),
              label: const Text('Generate'),
            ),
            if (_generatedPrompt.isNotEmpty) ...[
              const Divider(height: 32),
              Text(
                'Generated Prompt:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SelectableText(_generatedPrompt),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
        if (_generatedPrompt.isNotEmpty &&
            !_generatedPrompt.startsWith('Error'))
          TextButton(
            onPressed: () {
              widget.onPromptGenerated(_generatedPrompt);
              Navigator.of(context).pop();
            },
            child: const Text('Use This Prompt'),
          ),
      ],
    );
  }
}

// Simple helper using your configured client/model.
// System prompt designed to produce a concise, structured, high-signal prompt.
Future<String> generatePromptFromTopic(String topic) async {
  final cfg = Cfg.current;
  final req = CreateChatCompletionRequest(
    model: ChatCompletionModel.modelId(cfg.model),
    messages: [
      ChatCompletionMessage.system(
        content:
            'You turn a topic into a precise, actionable prompt for an AI assistant. '
            'Keep it concise but complete; include role, objectives, constraints, input format, and desired output.',
      ),
      ChatCompletionUserMessage(
        content: ChatCompletionUserMessageContent.string('Topic: $topic'),
      ),
    ],
  );
  final resp = await Cfg.client.createChatCompletion(request: req);
  return (resp.choices.firstOrNull?.message.content ?? '').trim();
}
