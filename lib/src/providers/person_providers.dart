import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import 'package:miko/src/core/dio_provider.dart';
import 'package:miko/src/core/hive_manager.dart';

import 'package:miko/src/repositories/person_repository.dart';
import 'package:miko/src/repositories/person_repository_impl.dart';

import 'package:miko/src/models/person/person_detail.dart';
import 'package:miko/src/models/person/combined_credit.dart';

// Repository provider
final personRepositoryProvider = Provider<PersonRepository>((ref) {
  final Dio dio = ref.read(dioProvider);
  final hive = ref.read(hiveManagerProvider);
  const apiKey = String.fromEnvironment('TMDB_API_KEY', defaultValue: '');
  return PersonRepositoryImpl(dio, hive, apiKey: apiKey);
});

// Person Detail
class PersonDetailNotifier extends FamilyAsyncNotifier<PersonDetail, int> {
  @override
  Future<PersonDetail> build(int personId) async {
    final repo = ref.read(personRepositoryProvider);
    final detail = await repo.getPersonDetail(personId);
    if (detail == null) throw Exception('Person not found');
    return detail;
  }
}

final personDetailProvider = AsyncNotifierProvider.family<PersonDetailNotifier, PersonDetail, int>(PersonDetailNotifier.new);

// Person Credits
class PersonCreditsNotifier extends FamilyAsyncNotifier<PersonCredits, int> {
  @override
  Future<PersonCredits> build(int personId) async {
    final repo = ref.read(personRepositoryProvider);
    final credits = await repo.getPersonCredits(personId);
    if (credits == null) throw Exception('Credits not found');
    return credits;
  }
}

final personCreditsProvider = AsyncNotifierProvider.family<PersonCreditsNotifier, PersonCredits, int>(PersonCreditsNotifier.new);