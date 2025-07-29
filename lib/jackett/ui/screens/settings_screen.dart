// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miko/jackett/models/jackett_config.dart';
import 'package:miko/jackett/providers/jackett_providers.dart';
import 'package:miko/jackett/services/config_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configs = ref.watch(jackettConfigsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView.builder(
        itemCount: configs.length,
        itemBuilder: (context, index) {
          final config = configs[index];
          return ListTile(
            title: Text(config.name),
            subtitle: Text(config.url),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showConfigDialog(context, ref, config: config),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
                  onPressed: () => _deleteConfig(context, ref, config),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showConfigDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _deleteConfig(BuildContext context, WidgetRef ref, JackettConfig config) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete the configuration "${config.name}"?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: Text('Delete', style: TextStyle(color: Theme.of(context).colorScheme.error)),
            onPressed: () {
              ref.read(configServiceProvider).deleteConfig(config.key);
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showConfigDialog(BuildContext context, WidgetRef ref, {JackettConfig? config}) {
    final formKey = GlobalKey<FormState>();
    final isEditing = config != null;
    final nameController = TextEditingController(text: isEditing ? config.name : '');
    final urlController = TextEditingController(text: isEditing ? config.url : '');
    final apiKeyController = TextEditingController(text: isEditing ? config.apiKey : '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isEditing ? 'Edit Configuration' : 'Add Configuration'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
                ),
                TextFormField(
                  controller: urlController,
                  decoration: const InputDecoration(labelText: 'Jackett URL', hintText: 'http://127.0.0.1:9117'),
                   validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter a URL';
                    if (!Uri.tryParse(value)!.isAbsolute ?? true) return 'Please enter a valid URL';
                    return null;
                   },
                ),
                TextFormField(
                  controller: apiKeyController,
                  decoration: const InputDecoration(labelText: 'API Key'),
                  validator: (value) => value!.isEmpty ? 'Please enter an API key' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          FilledButton(
            child: Text(isEditing ? 'Save' : 'Add'),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final newConfig = JackettConfig(
                  name: nameController.text.trim(),
                  url: urlController.text.trim(),
                  apiKey: apiKeyController.text.trim(),
                );
                final configService = ref.read(configServiceProvider);
                if (isEditing) {
                  configService.updateConfig(config.key, newConfig);
                } else {
                  configService.addConfig(newConfig);
                }
                Navigator.of(ctx).pop();
              }
            },
          ),
        ],
      ),
    );
  }
}