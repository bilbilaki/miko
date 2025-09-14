// File: lib/src/providers/episode_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import 'package:miko/src/core/dio_provider.dart';
import 'package:miko/src/core/hive_manager.dart';

import 'package:miko/src/repositories/episode_repository.dart';
import 'package:miko/src/repositories/episode_repository_impl.dart';

import 'package:miko/src/models/episode/episode_detail.dart';

// Repository provider
final episodeRepositoryProvider = Provider<EpisodeRepository>((ref) {
  final Dio dio = ref.read(dioProvider);
  final hive = ref.read(hiveManagerProvider);
  const apiKey = String.fromEnvironment('TMDB_API_KEY', defaultValue: '');
  return EpisodeRepositoryImpl(dio, hive, apiKey: apiKey);
});

// Episode detail (family by tvId-season-episode encoded as tuple via simple int triple pack)
class EpisodeDetailNotifier extends FamilyAsyncNotifier<EpisodeDetail, List<int>> {
  @override
  Future<EpisodeDetail> build( List<int> args) async {
    // args: [tvId, seasonNumber, episodeNumber]
    final repo = ref.read(episodeRepositoryProvider);
    final tvId = args[0];
    final seasonNumber = args[1];
    final episodeNumber = args[2];
    final detail = await repo.getEpisodeDetail(
      tvId,
      seasonNumber,
      episodeNumber,
    );
    if (detail == null) throw Exception('Episode detail not found'); // Corrected from [0]
    return detail!;
  }
}

final episodeDetailProvider =
    AsyncNotifierProvider.family<EpisodeDetailNotifier, EpisodeDetail, List<int>>(
      EpisodeDetailNotifier.new,
    );