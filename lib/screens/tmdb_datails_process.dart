import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:miko/providers/csv_detail_process_provider.dart';
import 'package:provider/provider.dart';

class TmdbDatailsProcess extends StatelessWidget {
  const TmdbDatailsProcess({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller for the API key text field
    final apiKeyController =
        TextEditingController(text: context.read<ProcessingProvider>().apiKey);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Python Script to Flutter'),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildConfigSection(context, apiKeyController),
            const SizedBox(height: 20),
            _buildActionSection(context),
            const SizedBox(height: 20),
            _buildProgressSection(context),
            const Divider(height: 30),
            const Text('Results',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(child: _buildResultsList()),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigSection(
      BuildContext context, TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: 'TMDB API Key',
        border: OutlineInputBorder(),
        hintText: 'Enter your v3 auth key',
      ),
      onChanged: (value) => context.read<ProcessingProvider>().setApiKey(value),
    );
  }

  Widget _buildActionSection(BuildContext context) {
    return Consumer<ProcessingProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.file_open),
                    label: const Text('Select CSV'),
                    onPressed: provider.isProcessing
                        ? null
                        : () => provider.selectInputFile(),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.download),
                    label: const Text('Export CSV'),
                    onPressed: provider.isProcessing || provider.results.isEmpty
                        ? null
                        : () => provider.exportToCsv(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start Processing'),
              onPressed: provider.isProcessing || provider.totalToProcess == 0
                  ? null
                  : () => provider.startProcessing(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 45),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProgressSection(BuildContext context) {
    return Consumer<ProcessingProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              provider.statusMessage,
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            if (provider.isProcessing)
              LinearProgressIndicator(
                value: provider.progress,
              )
            else if (provider.inputFileName.isNotEmpty)
              Text("File: ${provider.inputFileName}",
                  style: TextStyle(color: Colors.grey.shade600))
          ],
        );
      },
    );
  }

  Widget _buildResultsList() {
    return Consumer<ProcessingProvider>(
      builder: (context, provider, child) {
        if (provider.results.isEmpty && !provider.isProcessing) {
          return const Center(child: Text('No results to display.'));
        }
        return ListView.builder(
          itemCount: provider.results.length,
          itemBuilder: (context, index) {
            final item = provider.results[
                provider.results.length - 1 - index]; // Show latest first
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                leading: item.posterPath.isNotEmpty
                    ? CachedNetworkImage(
                        filterQuality: FilterQuality.high,
                        imageUrl:
                            'https://image.tmdb.org/t/p/w200${item.posterPath}',
                        placeholder: (context, url) => const SizedBox(
                            width: 50,
                            height: 75,
                            child: Center(child: CircularProgressIndicator())),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.movie, size: 40),
                        width: 50,
                        fit: BoxFit.cover,
                      )
                    : const SizedBox(
                        width: 50,
                        height: 75,
                        child: Icon(Icons.movie, size: 40)),
                title: Text(item.seriesName),
                subtitle: Text(
                    '${item.type} • ${item.status} • ★ ${item.voteAverage}'),
                isThreeLine: true,
              ),
            );
          },
        );
      },
    );
  }
}
