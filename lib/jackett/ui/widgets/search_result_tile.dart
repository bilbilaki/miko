import 'package:flutter/material.dart';
import 'package:flutter_link_previewer/flutter_link_previewer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:miko/jackett/core/utils/file_size_formatter.dart';
import 'package:miko/jackett/models/torznab_result_item.dart';
import 'package:miko/jackett/providers/jackett_providers.dart';

class SearchResultTile extends ConsumerWidget {
  final TorznabResultItem item;

  const SearchResultTile({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final linkHandler = ref.read(linkHandlerProvider);
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.title, style: textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildInfoChip(icon: Icons.unfold_more_sharp, text: formatBytes(item.size, 2)),
                if (item.seeders != null)
                  _buildInfoChip(icon: Icons.arrow_upward, text: item.seeders.toString(), color: Colors.green),
                if (item.peers != null)
                  _buildInfoChip(icon: Icons.arrow_downward, text: item.peers.toString(), color: Colors.orange),
                if (item.grabs != null)
                  _buildInfoChip(icon: Icons.download, text: item.grabs.toString(), color: Colors.blue),
              ],
            ),
            if (item.pubDate != null) ...[
              const SizedBox(height: 8),
              Text(
                'Published: ${DateFormat.yMMMd().add_jm().format(item.pubDate!)}',
                style: textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              )
            ],
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Only show preview button if the link is a standard webpage.
                if (item.isWebpage)
                  TextButton.icon(
                    icon: const Icon(Icons.preview_outlined, size: 20),
                    label: const Text('Preview'),
                    onPressed: () => _showPreviewDialog(context, item.link),
                  ),
                const Spacer(),
                IconButton(
                  tooltip: 'Copy Link',
                  icon: const Icon(Icons.copy, size: 20),
                  onPressed: () {
                    linkHandler.copyToClipboard(item.actionableLink);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Link copied to clipboard!'), duration: Duration(seconds: 2)),
                    );
                  },
                ),
                IconButton(
                  tooltip: 'Share Link',
                  icon: const Icon(Icons.share, size: 20),
                  onPressed: () => linkHandler.shareLink(item.actionableLink),
                ),
                FilledButton.icon(
                  icon: Icon(item.hasMagnet ? Icons.games_rounded : Icons.open_in_new, size: 20),
                  label: const Text('Open'),
                  onPressed: () => linkHandler.openLink(item.actionableLink),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String text, Color? color}) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
            color: (color ?? Colors.grey).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: (color ?? Colors.grey).withOpacity(0.3))),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color ?? Colors.grey[700]),
            const SizedBox(width: 4),
            Text(text, style: TextStyle(fontSize: 12, color: color ?? Colors.grey[800])),
          ],
        ));
  }

  void _showPreviewDialog(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding: const EdgeInsets.all(8),
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: LinkPreview(
            enableAnimation: true,
            text: url,
            maxWidth: MediaQuery.of(context).size.width,
            onLinkPreviewDataFetched: (data) {},
          ),
        ),
      ),
    );
  }
}