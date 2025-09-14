import 'package:miko/src/models/person/person_detail.dart';
import 'package:miko/src/models/person/combined_credit.dart';

abstract class PersonRepository {
  Future<PersonDetail?> getPersonDetail(int personId, {bool forceRefresh = false});
  Future<PersonCredits?> getPersonCredits(int personId, {bool forceRefresh = false});
}