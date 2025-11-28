import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:world_picker/world_picker.dart';

import '../models/subtitletranslator/subtitle_item.dart';
import '../services/settings_service.dart';
import '../services/translate.dart';
import '../utils/subtitle_parser.dart';
import 'search_subtitle_screen.dart';
import 'settings_page.dart';

class SubtitleGeneration extends StatefulWidget {
  final SubtitleFile? initialSubtitle;
  
  const SubtitleGeneration({super.key, this.initialSubtitle});

  @override
  State<SubtitleGeneration> createState() => _SubtitleGenerationState();
}

class SubtitleFile {
  final String path;
  final String fileName;
  List<SubtitleItem> subtitles;
  bool isTranslating;
  bool translationComplete;
  double progress;
  int completedCount;
  final bool isVttFormat; // Track original format

  SubtitleFile({
    required this.path,
    required this.fileName,
    required this.subtitles,
    this.isTranslating = false,
    this.translationComplete = false,
    this.progress = 0,
    this.completedCount = 0,
    this.isVttFormat = false,
  });
}

class _SubtitleGenerationState extends State<SubtitleGeneration> {
  Country? _selectedCountry;
  List<SubtitleFile> _files = [];
  int _currentFileIndex = 0;
  bool _overrideOriginal = false;
  int _batchSize = 100;
  int _maxRetries = 5;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    
    // Add initial subtitle if provided
    if (widget.initialSubtitle != null) {
      _files.add(widget.initialSubtitle!);
      _currentFileIndex = 0;
    }
  }

  Future<void> _loadSettings() async {
    final settings = await SettingsService.loadSettings();
    setState(() {
      _batchSize = settings.batchSize;
      _maxRetries = settings.maxRetries;
    });
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['srt', 'vtt'],
    );

    if (result != null && result.files.isNotEmpty) {
      final newFiles = <SubtitleFile>[];
      
      for (final platformFile in result.files) {
        if (platformFile.path != null) {
          final file = File(platformFile.path!);
          try {
            final content = await file.readAsString();
            final subtitles = parseSubtitles(content);
            final isVtt = platformFile.path!.toLowerCase().endsWith('.vtt');
            
            newFiles.add(SubtitleFile(
              path: platformFile.path!,
              fileName: platformFile.name,
              subtitles: subtitles,
              isVttFormat: isVtt,
            ));
          } catch (_) {
            // Skip invalid files
          }
        }
      }

      if (newFiles.isNotEmpty) {
        setState(() {
          _files.addAll(newFiles);
          _currentFileIndex = _files.length - newFiles.length;
        });
      }
    }
  }

  Future<void> _pickDirectory() async {
    final directoryPath = await FilePicker.platform.getDirectoryPath();

    if (directoryPath != null) {
      final directory = Directory(directoryPath);
      final newFiles = <SubtitleFile>[];

      // Recursively scan for .srt and .vtt files
      await for (final entity in directory.list(recursive: true, followLinks: false)) {
        if (entity is File) {
          final path = entity.path.toLowerCase();
          if (path.endsWith('.srt') || path.endsWith('.vtt')) {
            try {
              final content = await entity.readAsString();
              final subtitles = parseSubtitles(content);
              final fileName = entity.path.split(Platform.pathSeparator).last;
              final isVtt = path.endsWith('.vtt');
              
              newFiles.add(SubtitleFile(
                path: entity.path,
                fileName: fileName,
                subtitles: subtitles,
                isVttFormat: isVtt,
              ));
            } catch (_) {
              // Skip invalid files
            }
          }
        }
      }

      if (newFiles.isNotEmpty) {
        setState(() {
          _files.addAll(newFiles);
          _currentFileIndex = _files.length - newFiles.length;
        });
        
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Found ${newFiles.length} subtitle file(s)')),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No subtitle files found in directory')),
        );
      }
    }
  }

  Future<void> _startTranslation() async {
    if (_files.isEmpty) return;

    final systemMessage = _buildSystemMessage();

    for (var i = 0; i < _files.length; i++) {
      if (_files[i].translationComplete) continue;

      setState(() {
        _files[i].isTranslating = true;
        _files[i].translationComplete = false;
        _files[i].progress = 0;
        _files[i].completedCount = 0;
        _currentFileIndex = i;
      });

      await _translateSubtitlesInBatches(i, systemMessage);

      if (!mounted) return;

      setState(() {
        _files[i].isTranslating = false;
        _files[i].translationComplete = true;
        _files[i].progress = 1.0;
      });
    }
  }

  String _buildSystemMessage() {
    return '''You are a professional subtitle translator. Detect the topic and tone of each subtitle block automatically, optimize the phrasing for readability, and produce a translation in ${_selectedCountry?.languages.first.name} that keeps the timing context intact. Return only the translated text with no additional commentary.''';
  }

  Future<void> _translateSubtitlesInBatches(
    int fileIndex,
    String systemMessage,
  ) async {
    final subtitles = _files[fileIndex].subtitles;
    final total = subtitles.length;

    for (var batchStart = 0; batchStart < total; batchStart += _batchSize) {
      final batchEnd = min(batchStart + _batchSize, total);
      final futures = <Future<void>>[];

      for (var index = batchStart; index < batchEnd; index++) {
        futures.add(_handleSingleTranslation(
          fileIndex,
          index,
          systemMessage,
          total,
        ));
      }

      await Future.wait(futures);
    }
  }

  Future<void> _handleSingleTranslation(
    int fileIndex,
    int index,
    String systemMessage,
    int total,
  ) async {
    final item = _files[fileIndex].subtitles[index];
    final translation = await _translateWithRetry(item.content, systemMessage);

    if (!mounted) return;

    setState(() {
      _files[fileIndex].subtitles[index] = item.copyWith(
        translatedContent: translation.isNotEmpty ? translation : item.content,
      );
      _files[fileIndex].completedCount += 1;
      _files[fileIndex].progress = total > 0 
          ? _files[fileIndex].completedCount / total 
          : 0;
    });
  }

  Future<String> _translateWithRetry(
    String content,
    String systemMessage,
  ) async {
    var attempt = 0;

    while (attempt < _maxRetries) {
      try {
        final translation = await TranslationService.translate(
          content,
          systemMessage,
        );
        if (translation.isNotEmpty) {
          return translation;
        }
      } catch (_) {
        // ignore and retry
      }

      attempt += 1;
      if (attempt < _maxRetries) {
        await Future.delayed(const Duration(milliseconds: 400));
      }
    }

    return content;
  }

  Future<void> _saveTranslatedFiles() async {
    if (_files.isEmpty) return;

    Directory? androidExportDirectory;
    if (!_overrideOriginal && Platform.isAndroid) {
      final selectedDirectory = await FilePicker.platform.getDirectoryPath(
        dialogTitle: 'Select folder for translated subtitles',
      );

      if (selectedDirectory == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Export cancelled. No folder selected.')),
          );
        }
        return;
      }

      androidExportDirectory = Directory(selectedDirectory);
    }

    var savedFileCount = 0;

    for (final subtitleFile in _files) {
      if (!subtitleFile.translationComplete) continue;

      final serialized = _serializeSubtitleFile(subtitleFile);
      final savePath = await _resolveSavePath(
        subtitleFile: subtitleFile,
        androidExportDirectory: androidExportDirectory,
      );

      if (savePath == null) {
        continue;
      }

      await _writeFileSafely(savePath, serialized);
      savedFileCount += 1;
    }

    if (!mounted || savedFileCount == 0) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _overrideOriginal
              ? 'Files overwritten successfully.'
              : 'Translation saved successfully.',
        ),
      ),
    );
  }

  String _serializeSubtitleFile(SubtitleFile subtitleFile) {
    final buffer = StringBuffer();

    if (subtitleFile.isVttFormat) {
      buffer.writeln('WEBVTT');
      buffer.writeln();

      for (final item in subtitleFile.subtitles) {
        final text = (item.translatedContent?.trim().isNotEmpty ?? false)
            ? item.translatedContent!.trim()
            : item.content.trim();

        buffer.writeln('${item.startTime} --> ${item.endTime}');
        buffer.writeln(text);
        buffer.writeln();
      }
    } else {
      for (final item in subtitleFile.subtitles) {
        final text = (item.translatedContent?.trim().isNotEmpty ?? false)
            ? item.translatedContent!.trim()
            : item.content.trim();

        buffer.writeln(item.number);
        buffer.writeln('${item.startTime} --> ${item.endTime}');
        buffer.writeln(text);
        buffer.writeln();
      }
    }

    return buffer.toString();
  }

  Future<String?> _resolveSavePath({
    required SubtitleFile subtitleFile,
    Directory? androidExportDirectory,
  }) async {
    if (_overrideOriginal) {
      return subtitleFile.path;
    }

    final suggestedName = _sanitizeFileName('translated_${subtitleFile.fileName}');
    final extension = subtitleFile.isVttFormat ? '.vtt' : '.srt';
    final ensuredName = suggestedName.toLowerCase().endsWith(extension)
        ? suggestedName
        : '$suggestedName$extension';

    if (Platform.isAndroid && androidExportDirectory != null) {
      return '${androidExportDirectory.path}/$ensuredName';
    }

    return FilePicker.platform.saveFile(
      dialogTitle: 'Save translated subtitles - ${subtitleFile.fileName}',
      fileName: ensuredName,
      type: FileType.custom,
      allowedExtensions: [extension.replaceFirst('.', '')],
    );
  }

  String _sanitizeFileName(String name) {
    final sanitized = name
        .replaceAll(RegExp(r'[\\/:*?"<>|]'), '_')
        .replaceAll(RegExp(r'\s+'), '_')
        .trim();
    return sanitized.isNotEmpty ? sanitized : 'translated_subtitle';
  }

  Future<void> _writeFileSafely(String path, String contents) async {
    final file = File(path);
    await file.parent.create(recursive: true);
    await file.writeAsString(contents, flush: true);
  }

  Widget _buildSubtitleList() {
    if (_files.isEmpty) {
      return const Center(child: Text('No file selected'));
    }

    final currentFile = _files[_currentFileIndex];

    return ListView.builder(
      itemCount: currentFile.subtitles.length,
      itemBuilder: (context, index) {
        final item = currentFile.subtitles[index];
        final displayText = (item.translatedContent?.trim().isNotEmpty ?? false)
            ? item.translatedContent!.trim()
            : item.content;

        return Card(
          elevation: 1,
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            title: Text(
              '${item.number}\n${item.startTime} --> ${item.endTime}',
            ),
            subtitle: Text(displayText),
            trailing: item.translatedContent != null
                ? const Icon(Icons.translate, color: Colors.green)
                : const SizedBox.shrink(),
          ),
        );
      },
    );
  }

  Widget _buildFileTabs() {
    if (_files.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _files.length,
        itemBuilder: (context, index) {
          final file = _files[index];
          final isSelected = index == _currentFileIndex;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(file.fileName),
              selected: isSelected,
              onSelected: (_) {
                setState(() {
                  _currentFileIndex = index;
                });
              },
              avatar: file.translationComplete
                  ? const Icon(Icons.check_circle, size: 16)
                  : null,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentFile = _files.isNotEmpty ? _files[_currentFileIndex] : null;
    final isAnyTranslating = _files.any((f) => f.isTranslating);
    final allComplete = _files.isNotEmpty && _files.every((f) => f.translationComplete);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Subtitle Translator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search Subtitles',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SearchSubtitleScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SubtitlesGenSettings(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                WorldPickerIcon(
                  options: WorldPickerOptions(inputDecoration: InputDecoration(fillColor: Colors.black)),
                  onSelect: (country) {
                    
                    setState(() {
                      _selectedCountry = country;
                    });
                  },
                  selectedCountry: _selectedCountry,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: (_files.isEmpty || isAnyTranslating)
                        ? null
                        : _startTranslation,
                    child: const Text('Translate All Files'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: isAnyTranslating ? null : _pickFile,
                    child: Text(_files.isEmpty 
                        ? 'Select Subtitle Files' 
                        : 'Add More Files'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isAnyTranslating ? null : _pickDirectory,
                    icon: const Icon(Icons.folder_open),
                    label: const Text('Select Directory'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    dense: true,
                    title: const Text('Override original'),
                    value: _overrideOriginal,
                    onChanged: (value) {
                      setState(() {
                        _overrideOriginal = value ?? false;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildFileTabs(),
            const SizedBox(height: 12),
            if (currentFile != null && currentFile.isTranslating) ...[
              LinearProgressIndicator(value: currentFile.progress),
              const SizedBox(height: 6),
              Text(
                'Translating ${currentFile.fileName}: ${currentFile.completedCount} of ${currentFile.subtitles.length} entries (${(currentFile.progress * 100).clamp(0, 100).toStringAsFixed(0)}%)',
              ),
            ] else if (allComplete) ...[
              LinearProgressIndicator(value: 1),
              const SizedBox(height: 6),
              Text('All ${_files.length} files translated!'),
            ],
            const SizedBox(height: 12),
            Expanded(child: _buildSubtitleList()),
            if (allComplete)
              ElevatedButton.icon(
                onPressed: _saveTranslatedFiles,
                icon: const Icon(Icons.save),
                label: Text(_overrideOriginal 
                    ? 'Override Original Files' 
                    : 'Save All Translated Files'),
              ),
          ],
        ),
      ),
    );
  }
}
