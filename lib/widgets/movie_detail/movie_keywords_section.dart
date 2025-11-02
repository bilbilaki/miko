import 'package:flutter/material.dart';
import 'package:miko/showcases/model.dart';
import 'package:miko/showcases/movies_by_keyword_screen.dart';
import 'package:miko/showcases/movie_service.dart';
import 'package:miko/showcases/utils/haptic_helper.dart';

/// Widget for displaying movie keywords as chips
class MovieKeywordsSection extends StatelessWidget {
  final List<Keyword> keywords;
  final MovieService movieService;

  const MovieKeywordsSection({
    Key? key,
    required this.keywords,
    required this.movieService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (keywords.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          'Keywords',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: keywords.map((keyword) {
            return ActionChip(
              label: Text(keyword.name),
              backgroundColor: Colors.grey[800],
              labelStyle: const TextStyle(color: Colors.white70),
              onPressed: () {
                HapticHelper.performHapticFeedback();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MoviesByKeywordScreen(
                      keywordId: keyword.id,
                      keywordName: keyword.name,
                      movieService: movieService,
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
