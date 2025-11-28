part of '../settings_page.dart';


class SubtitlesGenSettings extends StatefulWidget {
  const SubtitlesGenSettings({super.key});

  @override
  State<SubtitlesGenSettings> createState() => _SubtitlesGenSettingsState();
}

class _SubtitlesGenSettingsState extends State<SubtitlesGenSettings> {
  late AppSettings _settings;
  final _formKey = GlobalKey<FormState>();
  final _baseUrlController = TextEditingController();
  final _apiKeyController = TextEditingController();
  final _modelIdController = TextEditingController();
  final _batchSizeController = TextEditingController();
  final _maxRetriesController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _baseUrlController.dispose();
    _apiKeyController.dispose();
    _modelIdController.dispose();
    _batchSizeController.dispose();
    _maxRetriesController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final settings = await SettingsService.loadSettings();
    setState(() {
      _settings = settings;
      _baseUrlController.text = settings.baseUrl.isEmpty 
          ? settings.defaultBaseUrl 
          : settings.baseUrl;
      _apiKeyController.text = settings.apiKey;
      _modelIdController.text = settings.modelId;
      _batchSizeController.text = settings.batchSize.toString();
      _maxRetriesController.text = settings.maxRetries.toString();
      _isLoading = false;
    });
  }

  Future<void> _saveSettings() async {
    if (!_formKey.currentState!.validate()) return;

    final newSettings = _settings.copyWith(
      baseUrl: _baseUrlController.text.trim(),
      apiKey: _apiKeyController.text.trim(),
      modelId: _modelIdController.text.trim(),
      batchSize: int.tryParse(_batchSizeController.text) ?? 100,
      maxRetries: int.tryParse(_maxRetriesController.text) ?? 5,
    );

    await SettingsService.saveSettings(newSettings);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved successfully')),
    );
    Navigator.of(context).pop(true);
  }

  Future<void> _resetSettings() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings'),
        content: const Text('Are you sure you want to reset all settings to default?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await SettingsService.resetSettings();
      await _loadSettings();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Settings reset to defaults')),
      );
    }
  }

  void _updateProvider(AiProvider provider) {
    setState(() {
      _settings = _settings.copyWith(provider: provider);
      _baseUrlController.text = _settings.defaultBaseUrl;
    });
  }

  void _updateCache(bool value) {
    setState(() {
      _settings = _settings.copyWith(enableCache: value);
    });
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Widget _buildProviderButton({
    required String label,
    required String iconUrl,
    required String consoleUrl,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.cyanAccent : Colors.grey,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? Colors.cyanAccent.withOpacity(0.1) : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => _launchUrl(consoleUrl),
              child: Image.network(
                iconUrl,
                width: 40,
                height: 40,
                errorBuilder: (_, __, ___) => const Icon(Icons.api, size: 40),
              ),
            ),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetSettings,
            tooltip: 'Reset to defaults',
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'AI Provider',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildProviderButton(
                  label: 'OpenAI',
                  iconUrl: 'https://openai.com/favicon.ico',
                  consoleUrl: 'https://platform.openai.com/api-keys',
                  isSelected: _settings.provider == AiProvider.openai,
                  onTap: () => _updateProvider(AiProvider.openai),
                ),
                _buildProviderButton(
                  label: 'DeepSeek',
                  iconUrl: 'https://www.deepseek.com/favicon.ico',
                  consoleUrl: 'https://platform.deepseek.com/api_keys',
                  isSelected: false,
                  onTap: () {},
                ),
                _buildProviderButton(
                  label: 'X.AI',
                  iconUrl: 'https://x.ai/favicon.ico',
                  consoleUrl: 'https://console.x.ai/',
                  isSelected: false,
                  onTap: () {},
                ),
                _buildProviderButton(
                  label: 'Google AI',
                  iconUrl: 'https://ai.google.dev/static/site-assets/images/share.png',
                  consoleUrl: 'https://aistudio.google.com/apikey',
                  isSelected: _settings.provider == AiProvider.genai,
                  onTap: () => _updateProvider(AiProvider.genai),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _baseUrlController,
              decoration: InputDecoration(
                labelText: 'Base URL',
                hintText: _settings.defaultBaseUrl,
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Base URL is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _apiKeyController,
              decoration: const InputDecoration(
                labelText: 'API Key',
                hintText: 'sk-fhhgfgh...',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'API Key is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _modelIdController,
              decoration: const InputDecoration(
                labelText: 'Model ID',
                hintText: 'gpt-4o-mini, gemini-pro...',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Model ID is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _batchSizeController,
              decoration: const InputDecoration(
                labelText: 'Request Batch Number',
                hintText: '100',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                final num = int.tryParse(value ?? '');
                if (num == null || num < 1) {
                  return 'Must be a positive number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _maxRetriesController,
              decoration: const InputDecoration(
                labelText: 'On Failed Retry',
                hintText: '5',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                final num = int.tryParse(value ?? '');
                if (num == null || num < 0) {
                  return 'Must be a non-negative number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Enable reuse and cache (Experimental)'),
              subtitle: const Text('May reduce API calls but could affect accuracy'),
              value: _settings.enableCache,
              onChanged: _updateCache,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _saveSettings,
                    icon: const Icon(Icons.save),
                    label: const Text('Save Settings'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _resetSettings,
                    icon: const Icon(Icons.restore),
                    label: const Text('Reset'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
