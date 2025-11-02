import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Widget for displaying external links (website, IMDb)
class ExternalLinksSection extends StatelessWidget {
  final String? homepage;
  final String? imdbId;

  const ExternalLinksSection({
    Key? key,
    this.homepage,
    this.imdbId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Don't show if no links are available
    if ((homepage == null || homepage!.isEmpty) && imdbId == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          'External Links',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 16,
          children: [
            if (homepage != null && homepage!.isNotEmpty)
              OutlinedButton.icon(
                icon: const Icon(Icons.language),
                label: const Text('Official Website'),
                onPressed: () async {
                  if (await canLaunchUrl(Uri.parse(homepage!))) {
                    await launchUrl(Uri.parse(homepage!));
                  }
                },
              ),
            if (imdbId != null)
              OutlinedButton.icon(
                icon: const Icon(Icons.movie),
                label: const Text('IMDb'),
                onPressed: () async {
                  final imdbUrl = 'https://www.imdb.com/title/$imdbId/';
                  if (await canLaunchUrl(Uri.parse(imdbUrl))) {
                    await launchUrl(Uri.parse(imdbUrl));
                  }
                },
              ),
          ],
        ),
      ],
    );
  }
}
