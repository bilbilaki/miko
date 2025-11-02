import 'package:flutter/material.dart';
import 'package:miko/showcases/model.dart';
import 'package:miko/utils/colors.dart';

/// Widget for displaying spoken languages
class SpokenLanguagesSection extends StatelessWidget {
  final List<SpokenLanguage> languages;

  const SpokenLanguagesSection({
    Key? key,
    required this.languages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (languages.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          'Spoken Languages',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 8,
          children: languages.map((language) {
            return Chip(
              label: Text(language.englishName),
              backgroundColor: Colors.grey[800],
              labelStyle: const TextStyle(color: AppColors.primaryText),
            );
          }).toList(),
        ),
      ],
    );
  }
}
