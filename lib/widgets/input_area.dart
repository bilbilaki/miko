import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:miko/core/ai/ai_task_orchestrator.dart';
import 'package:miko/services/ai_service_provider.dart';

class InputArea extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isEnabled;

  const InputArea({
    super.key,
    required this.controller,
    required this.onSend,
    this.isEnabled = true,
  });

  @override
  State<InputArea> createState() => _InputAreaState();
}

class _InputAreaState extends State<InputArea> {
  String? _pickedFilePath;
  String? _pickedFileName;

  void _clearAttachments() {
    setState(() {
      _pickedFilePath = null;
      _pickedFileName = null;
    });
  }

  Future<void> _pickFile() async {
    final AITaskOrchestrator orchestrator = AiServiceProvider().aiTaskOrchestrator;
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null && result.files.single.path != null) {
      final path = result.files.single.path!;
      await orchestrator.attachFile(path);
      setState(() {
        _clearAttachments();
        _pickedFilePath = path;
        _pickedFileName = result.files.single.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Column(
          children: [
            if (_pickedFileName != null)
              _AttachmentPreview(
                fileName: _pickedFileName!,
                onClear: _clearAttachments,
              ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file_outlined),
                  onPressed: widget.isEnabled ? _pickFile : null,
                ),
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    enabled: widget.isEnabled,
                    minLines: 1,
                    maxLines: 5,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => widget.onSend(),
                    decoration: const InputDecoration.collapsed(
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                IconButton.filled(
                  icon: const Icon(Icons.send),
                  onPressed: widget.isEnabled ? widget.onSend : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AttachmentPreview extends StatelessWidget {
  final String fileName;
  final VoidCallback onClear;

  const _AttachmentPreview({required this.fileName, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.surfaceContainer,
            ),
            child: Row(
              children: [
                Icon(Icons.attach_file, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(child: Text(fileName, overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
          Material(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(30),
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: onClear,
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Icon(Icons.close, size: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}