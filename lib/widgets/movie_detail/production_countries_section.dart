import 'package:flutter/material.dart';
import 'package:miko/showcases/model.dart';
import 'package:miko/utils/colors.dart';

/// Widget for displaying production countries
class ProductionCountriesSection extends StatelessWidget {
  final List<ProductionCountry> countries;

  const ProductionCountriesSection({
    super.key,
    required this.countries,
  });

  @override
  Widget build(BuildContext context) {
    if (countries.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          'Production Countries',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 8,
          children: countries.map((country) {
            return Chip(
              label: Text(country.name),
              backgroundColor: Colors.grey[800],
              labelStyle: const TextStyle(color: AppColors.primaryText),
            );
          }).toList(),
        ),
      ],
    );
  }
}
