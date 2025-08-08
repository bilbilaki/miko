// lib/ui/chat_page.dart
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'ai_core_models.dart';
import 'session_manager.dart';
import 'chat_controller.dart';
import 'attachment_preview.dart';
import 'message_bubble.dart';

class ChatPage extends StatefulWidget {
 const ChatPage({super.key});

 @override
 State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
 final _scrollController = ScrollController();
 final _imagePicker = ImagePicker();

 @override
 void dispose() {
 _scrollController.dispose();
 super.dispose();
 }

 @override
 Widget build(BuildContext context) {
 return MultiProvider(
 providers: [
 ChangeNotifierProvider(create: (_) => SessionManager()..createSession()),
 ChangeNotifierProvider(create: (_) => AiSettings()),
 ChangeNotifierProxyProvider2<SessionManager, AiSettings, ChatController>(
 create: (ctx) => ChatController(
 sessionManager: ctx.read<SessionManager>(),
 settings: ctx.read<AiSettings>(),
 ),
 update: (ctx, sm, st, prev) => prev!..notifyListeners(),
 ),
 ],
 child: Builder(builder: (context) {
 final sessionManager = context.watch<SessionManager>();
 final settings = context.watch<AiSettings>();
 final chat = context.watch<ChatController>();
 final session = sessionManager.currentSession;

 return Scaffold(
 appBar: AppBar(
 title: Text(session?.title ?? 'Chat'),
 leading: Builder(
 builder: (context) => IconButton(
 icon: const Icon(Icons.menu),
 onPressed: () => Scaffold.of(context).openDrawer(),
 ),
 ),
 actions: [
 Builder(
 builder: (context) => IconButton(
 icon: const Icon(Icons.tune),
 onPressed: () => Scaffold.of(context).openEndDrawer(),
 ),
 ),
 ],
 ),
 drawer: _LeftDrawer(sessionManager: sessionManager),
 endDrawer: _RightDrawer(settings: settings, chat: chat),
 body: Column(
 children: [
 Expanded(child: _messagesList(sessionManager, chat)),
 _inputArea(context, chat, settings),
 ],
 ),
 );
 }),
 );
 }

 Widget _messagesList(SessionManager sm, ChatController chat) {
 final session = sm.currentSession;
 final messages = session?.messages ?? const <UnifiedMessage>[];
 return NotificationListener<SizeChangedLayoutNotification>(
 onNotification: (_) {
 _scrollToBottom();
 return true;
 },
 child: SizeChangedLayoutNotifier(
 child: ListView.separated(
 controller: _scrollController,
 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
 itemBuilder: (context, index) {
 final m = messages[index];
 final isUser = m.role == MessageRole.user;
 return MessageBubble(
 message: m,
 isUser: isUser,
 isStreaming: chat.isStreaming && index == messages.length - 1 && !isUser,
 onResendFromHere: () async {
 final confirm = await showDialog<bool>(
 context: context,
 builder: (_) => AlertDialog(
 title: const Text('Resend from here?'),
 content: const Text('This will remove messages after this point and resend. Continue?'),
 actions: [
 TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
 FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Resend')),
 ],
 ),
 );
 if (confirm == true) {
 await chat.resendFromMessage(m.id);
 }
 },
 onEdit: isUser
 ? () async {
 final controller = TextEditingController(text: m.text ?? '');
 final ok = await showDialog<bool>(
 context: context,
 builder: (_) => AlertDialog(
 title: const Text('Edit message'),
 content: TextField(
 controller: controller,
 minLines: 1,
 maxLines: 12,
 decoration: const InputDecoration(border: OutlineInputBorder()),
 ),
 actions: [
 TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
 FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Save')),
 ],
 ),
 );
 if (ok == true) {
 chat.updateMessage(m.id, controller.text.trim());
 }
 }
 : null,
 );
 },
 separatorBuilder: (_, __) => const SizedBox(height: 10),
 itemCount: messages.length,
 ),
 ),
 );
 }

 void _scrollToBottom() {
 WidgetsBinding.instance.addPostFrameCallback((_) {
 if (!_scrollController.hasClients) return;
 _scrollController.animateTo(
 _scrollController.position.maxScrollExtent,
 duration: const Duration(milliseconds: 300),
 curve: Curves.easeOut,
 );
 });
 }

 Widget _inputArea(BuildContext context, ChatController chat, AiSettings settings) {
 final canSend = chat.textController.text.trim().isNotEmpty || chat.hasPendingAttachments;
 final showRecord = !canSend;

 return SafeArea(
 top: false,
 child: Container(
 padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
 decoration: BoxDecoration(
 color: Theme.of(context).colorScheme.surface,
 boxShadow: [
 BoxShadow(
 blurRadius: 10,
 color: Colors.black.withOpacity(0.06),
 ),
 ],
 ),
 child: Column(
 crossAxisAlignment: CrossAxisAlignment.stretch,
 children: [
 // Attachments preview
 AttachmentPreview(
 attachments: chat.pendingAttachments,
 onRemove: (i) => chat.removePendingAttachmentAt(i),
 ),
 const SizedBox(height: 8),
 Row(
 crossAxisAlignment: CrossAxisAlignment.end,
 children: [
 // Attachment button
 IconButton(
 tooltip: 'Attach',
 icon: const Icon(Icons.attach_file_outlined),
 onPressed: () => _showAttachBottomSheet(context, chat),
 ),
 // Text field
 Expanded(
 child: RawKeyboardListener(
 focusNode: FocusNode(),
 onKey: (event) {
 if (event is RawKeyDownEvent) {
 final isEnter = event.logicalKey == LogicalKeyboardKey.enter;
 final isShift = event.isShiftPressed;
 final isCtrl = event.isControlPressed || event.isMetaPressed;
 if (isEnter && (isShift || isCtrl)) {
 // Send on Shift+Enter or Ctrl+Enter
 _send(context, chat);
 }
 }
 },
 child: TextField(
 controller: chat.textController,
 focusNode: chat.inputFocus,
 minLines: 1,
 maxLines: 8,
 textCapitalization: TextCapitalization.sentences,
 decoration: InputDecoration(
 hintText: 'Write a message...',
 filled: true,
 fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.6),
 contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
 border: OutlineInputBorder(
 borderRadius: BorderRadius.circular(12),
 borderSide: BorderSide.none,
 ),
 ),
 onChanged: (_) => setState(() {}),
 keyboardType: TextInputType.multiline,
 textInputAction: TextInputAction.newline, // Enter = newline
 ),
 ),
 ),
 const SizedBox(width: 8),
 // Record or Send button
 if (showRecord) _recButton(context, chat) else _sendButton(context, chat),
 ],
 ),
 if (chat.isRecording) ...[
 const SizedBox(height: 8),
 Row(
 children: [
 const Icon(Icons.mic, color: Colors.red),
 const SizedBox(width: 6),
 Text(_formatDuration(chat.recordingDuration)),
 const SizedBox(width: 10),
 TextButton.icon(
 onPressed: () => chat.stopRecording(cancelled: true),
 icon: const Icon(Icons.close),
 label: const Text('Cancel'),
 ),
 ],
 ),
 ],
 ],
 ),
 ),
 );
 }

 Widget _sendButton(BuildContext context, ChatController chat) {
 return IconButton.filled(
 onPressed: chat.isSending ? null : () => _send(context, chat),
 icon: chat.isSending
 ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
 : const Icon(Icons.send_rounded),
 );
 }

 Widget _recButton(BuildContext context, ChatController chat) {
 if (chat.isRecording) {
 return IconButton.filled(
 style: IconButton.styleFrom(backgroundColor: Colors.red),
 onPressed: () => chat.stopRecording(),
 icon: const Icon(Icons.stop),
 );
 } else {
 return IconButton.filled(
 onPressed: () => chat.startRecording(),
 icon: const Icon(Icons.mic),
 );
 }
 }

 void _send(BuildContext context, ChatController chat) {
 FocusScope.of(context).unfocus();
 chat.sendCurrentInput();
 }

 Future<void> _showAttachBottomSheet(BuildContext context, ChatController chat) async {
 showModalBottomSheet(
 context: context,
 showDragHandle: true,
 builder: (ctx) => SafeArea(
 child: Column(
 mainAxisSize: MainAxisSize.min,
 children: [
 ListTile(
 leading: const Icon(Icons.image_outlined),
 title: const Text('Pick image'),
 onTap: () async {
 final x = await ImagePicker().pickImage(source: ImageSource.gallery);
 if (x != null) {
 final bytes = await x.readAsBytes();
 chat.addImageBase64(base64Encode(bytes));
 }
 if (mounted) Navigator.pop(ctx);
 },
 ),
 ListTile(
 leading: const Icon(Icons.audiotrack_outlined),
 title: const Text('Pick audio'),
 onTap: () async {
 final res = await FilePicker.platform.pickFiles(type: FileType.audio);
 if (res != null && res.files.single.path != null) {
 final f = File(res.files.single.path!);
 final bytes = await f.readAsBytes();
 chat.addAudioBytes(bytes, format: AudioFormat.mp3, source: AudioSourceType.picked);
 }
 if (mounted) Navigator.pop(ctx);
 },
 ),
 ListTile(
 leading: const Icon(Icons.description_outlined),
 title: const Text('Pick file'),
 onTap: () async {
 final res = await FilePicker.platform.pickFiles(withData: true);
 if (res != null) {
 final file = res.files.single;
 final bytes = file.bytes ?? await File(file.path!).readAsBytes();
 chat.addFileBytes(
 fileName: file.name,
 bytes: bytes,
 mimeType: file.extension ?? 'application/octet-stream',
 size: file.size,
 );
 }
 if (mounted) Navigator.pop(ctx);
 },
 ),
 ],
 ),
 ),
 );
 }

 String _formatDuration(Duration d) {
 String two(int n) => n.toString().padLeft(2, '0');
 return '${two(d.inMinutes.remainder(60))}:${two(d.inSeconds.remainder(60))}';
 }
}

class _LeftDrawer extends StatelessWidget {
 final SessionManager sessionManager;
 const _LeftDrawer({required this.sessionManager});

 @override
 Widget build(BuildContext context) {
 final sessions = sessionManager.sessions;
 final currentId = sessionManager.currentSessionId;

 return Drawer(
 child: SafeArea(
 child: Column(
 children: [
 ListTile(
 leading: const Icon(Icons.add),
 title: const Text('New session'),
 onTap: () {
 final id = sessionManager.createSession();
 sessionManager.setCurrentSession(id);
 Navigator.pop(context);
 },
 ),
 const Divider(),
 Expanded(
 child: ListView.builder(
 itemCount: sessions.length,
 itemBuilder: (context, index) {
 final s = sessions[index];
 final selected = s.id == currentId;
 return ListTile(
 selected: selected,
 leading: const Icon(Icons.chat_bubble_outline),
 title: Text(s.title),
 subtitle: Text(
 s.lastMessage?.text ?? '',
 maxLines: 1,
 overflow: TextOverflow.ellipsis,
 ),
 onTap: () {
 sessionManager.setCurrentSession(s.id);
 Navigator.pop(context);
 },
 trailing: PopupMenuButton<String>(
 onSelected: (v) async {
 if (v == 'rename') {
 final controller = TextEditingController(text: s.title);
 final ok = await showDialog<bool>(
 context: context,
 builder: (_) => AlertDialog(
 title: const Text('Rename session'),
 content: TextField(
 controller: controller,
 decoration: const InputDecoration(border: OutlineInputBorder()),
 ),
 actions: [
 TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
 FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Save')),
 ],
 ),
 );
 if (ok == true) {
 sessionManager.renameSession(s.id, controller.text.trim());
 }
 } else if (v == 'duplicate') {
 final id = sessionManager.createSession(title: s.title);
 sessionManager.replaceAllMessages(sessionId: id, messages: s.messages);
 sessionManager.setCurrentSession(id);
 } else if (v == 'delete') {
 sessionManager.deleteSession(s.id);
 }
 },
 itemBuilder: (_) => const [
 PopupMenuItem(value: 'rename', child: Text('Rename')),
 PopupMenuItem(value: 'duplicate', child: Text('Duplicate')),
 PopupMenuItem(
 value: 'delete',
 child: Text('Delete', style: TextStyle(color: Colors.red)),
 ),
 ],
 ),
 );
 },
 ),
 ),
 ],
 ),
 ),
 );
 }
}

class _RightDrawer extends StatefulWidget {
 final AiSettings settings;
 final ChatController chat;
 const _RightDrawer({required this.settings, required this.chat});

 @override
 State<_RightDrawer> createState() => _RightDrawerState();
}

class _RightDrawerState extends State<_RightDrawer> {
 final _modelCtrl = TextEditingController();
 final _tempCtrl = TextEditingController();
 final _maxTokCtrl = TextEditingController();
 final _sysCtrl = TextEditingController();
 final _openAiKeyCtrl = TextEditingController();
 final _geminiKeyCtrl = TextEditingController();

 @override
 void initState() {
 super.initState();
 _sync();
 }

 void _sync() {
 _modelCtrl.text = widget.settings.modelId;
 _tempCtrl.text = widget.settings.temperature.toStringAsFixed(2);
 _maxTokCtrl.text = widget.settings.maxTokens.toString();
 _sysCtrl.text = widget.settings.systemPrompt;
 _openAiKeyCtrl.text = widget.settings.openAiApiKey;
 _geminiKeyCtrl.text = widget.settings.geminiApiKey;
 }

 @override
 Widget build(BuildContext context) {
 return Drawer(
 child: SafeArea(
 child: ListView(
 padding: const EdgeInsets.all(12),
 children: [
 const Text('Provider', style: TextStyle(fontWeight: FontWeight.bold)),
 const SizedBox(height: 8),
 SegmentedButton<AiProviderType>(
 segments: const [
 ButtonSegment(value: AiProviderType.openai, label: Text('OpenAI'), icon: Icon(Icons.api)),
 ButtonSegment(value: AiProviderType.gemini, label: Text('Gemini'), icon: Icon(Icons.auto_awesome)),
 ],
 selected: {widget.settings.provider},
 onSelectionChanged: (s) {
 setState(() => widget.settings.update((cfg) => cfg.provider = s.first));
 },
 ),
 const SizedBox(height: 16),
 if (widget.settings.provider == AiProviderType.openai) ...[
 TextField(
 controller: _openAiKeyCtrl,
 decoration: const InputDecoration(labelText: 'OpenAI API Key', border: OutlineInputBorder()),
 onChanged: (v) => widget.settings.update((s) => s.openAiApiKey = v),
 ),
 const SizedBox(height: 12),
 ],
 if (widget.settings.provider == AiProviderType.gemini) ...[
 TextField(
 controller: _geminiKeyCtrl,
 decoration: const InputDecoration(labelText: 'Gemini API Key', border: OutlineInputBorder()),
 onChanged: (v) => widget.settings.update((s) => s.geminiApiKey = v),
 ),
 const SizedBox(height: 12),
 ],
 TextField(
 controller: _modelCtrl,
 decoration: const InputDecoration(labelText: 'Model ID', border: OutlineInputBorder()),
 onChanged: (v) => widget.settings.update((s) => s.modelId = v),
 ),
 const SizedBox(height: 12),
 Row(
 children: [
 Expanded(
 child: TextField(
 controller: _tempCtrl,
 decoration: const InputDecoration(labelText: 'Temperature (0-2)', border: OutlineInputBorder()),
 keyboardType: const TextInputType.numberWithOptions(decimal: true),
 onChanged: (v) => widget.settings.update((s) => s.temperature = double.tryParse(v) ?? s.temperature),
 ),
 ),
 const SizedBox(width: 12),
 Expanded(
 child: TextField(
 controller: _maxTokCtrl,
 decoration: const InputDecoration(labelText: 'Max tokens', border: OutlineInputBorder()),
 keyboardType: TextInputType.number,
 onChanged: (v) => widget.settings.update((s) => s.maxTokens = int.tryParse(v) ?? s.maxTokens),
 ),
 ),
 ],
 ),
 const SizedBox(height: 12),
 SwitchListTile(
 title: const Text('Streaming mode'),
 value: widget.settings.streaming,
 onChanged: (v) => setState(() => widget.settings.update((s) => s.streaming = v)),
 ),
 SwitchListTile(
 title: const Text('Voice response'),
 value: widget.settings.voiceResponse,
 onChanged: (v) => setState(() => widget.settings.update((s) => s.voiceResponse = v)),
 ),
 const Divider(height: 24),
 Row(
 children: [Expanded(child: 
 const Text('System prompt', style: TextStyle(fontWeight: FontWeight.bold))),
 const Spacer(),
 FilledButton.tonalIcon(
 onPressed: () async {
 final desc = await _ask(context, 'Describe what you need. We will generate a system prompt.');
 if (desc != null && desc.trim().isNotEmpty) {
 await widget.chat.generateSystemPrompt(desc.trim());
 setState(() => _sysCtrl.text = widget.settings.systemPrompt);
 }
 },
 icon: const Icon(Icons.auto_awesome),
 label: const Text('Prompt generator'),
 ),
 ],
 ),
 const SizedBox(height: 8),
 TextField(
 controller: _sysCtrl,
 minLines: 2,
 maxLines: 8,
 decoration: const InputDecoration(border: OutlineInputBorder()),
 onChanged: (v) => widget.settings.update((s) => s.systemPrompt = v),
 ),
 SwitchListTile(
 title: const Text('Persist system message in session'),
 value: widget.settings.persistSystemMessage,
 onChanged: (v) => setState(() => widget.settings.update((s) => s.persistSystemMessage = v)),
 ),
 const SizedBox(height: 20),
 FilledButton.icon(
 onPressed: () async {
 final seed = await _ask(context, 'Enter a short description to generate chat title');
 if (seed == null || seed.trim().isEmpty) return;
 await widget.chat.generateSystemPrompt('Generate 1-3 words title for: $seed');
 },
 icon: const Icon(Icons.title),
 label: const Text('Generate title from prompt'),
 ),
 ],
 ),
 ),
 );
 }

 Future<String?> _ask(BuildContext context, String title) async {
 final c = TextEditingController();
 return showDialog<String?>(
 context: context,
 builder: (_) => AlertDialog(
 title: Text(title),
 content: TextField(
 controller: c,
 minLines: 1,
 maxLines: 6,
 decoration: const InputDecoration(border: OutlineInputBorder()),
 ),
 actions: [
 TextButton(onPressed: () => Navigator.pop(context, null), child: const Text('Cancel')),
 FilledButton(onPressed: () => Navigator.pop(context, c.text), child: const Text('OK')),
 ],
 ),
 );
 }

 @override
 void dispose() {
 _modelCtrl.dispose();
 _tempCtrl.dispose();
 _maxTokCtrl.dispose();
 _sysCtrl.dispose();
 _openAiKeyCtrl.dispose();
 _geminiKeyCtrl.dispose();
 super.dispose();
 }
}