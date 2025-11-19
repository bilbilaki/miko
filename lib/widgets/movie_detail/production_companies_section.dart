import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:miko/showcases/model.dart';
import 'package:miko/utils/colors.dart';

/// Widget for displaying production companies
class ProductionCompaniesSection extends StatelessWidget {
  final List<ProductionCompany> companies;

  const ProductionCompaniesSection({
    Key? key,
    required this.companies,
  }) : super(key: key);

  void _performHapticFeedback() {
    if (Platform.isAndroid) {
      HapticFeedback.lightImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (companies.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          'Production Companies',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 80,
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (Platform.isAndroid &&
                  scrollInfo is ScrollUpdateNotification) {
                if (scrollInfo.scrollDelta != null &&
                    scrollInfo.scrollDelta! != 0) {
                  _performHapticFeedback();
                }
              }
              return false;
            },
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: companies.length,
              itemBuilder: (context, index) {
                final company = companies[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (company.logoPath != null)
                        SizedBox(
                          height: 40,
                          width: 80,
                          child: CachedNetworkImage(
                            filterQuality: FilterQuality.high,
                            imageUrl: company.fullLogoPath,
                            fit: BoxFit.contain,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 1,
                                color: AppColors.accentColor,
                              ),
                            ),
                            errorWidget: (context, url, error) => const Center(
                              child: Icon(
                                Icons.image_not_supported_outlined,
                                size: 30,
                                color: AppColors.secondaryText,
                              ),
                            ),
                            fadeInDuration: const Duration(milliseconds: 200),
                            fadeOutDuration: const Duration(milliseconds: 100),
                          ),
                        )
                      else
                        const SizedBox(
                          height: 40,
                          width: 80,
                          child: Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              size: 30,
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: 80,
                        child: Text(
                          company.name,
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.primaryText,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
