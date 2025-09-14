import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

part 'watch_providers.freezed.dart';
part 'watch_providers.g.dart';
//part 'watch_providers.hive.dart';

@injectable
@freezed
@HiveType(typeId: 122)
abstract class WatchProvider with _$WatchProvider {
  @JsonSerializable()
  const factory WatchProvider({
    @HiveField(0) required int providerId,
    @HiveField(1) required String providerName,
    @HiveField(2) @JsonKey(name: 'logo_path') String? logoPath,
    @HiveField(3) @JsonKey(name: 'display_priority') int? displayPriority,
    @HiveField(4) String? type, // local convenience (e.g., 'flatrate', 'rent', 'buy')
  }) = _WatchProvider;

  factory WatchProvider.fromJson(Map<String, dynamic> json) => _$WatchProviderFromJson(json);
}

/// Country-specific provider entry (flatrate / rent / buy lists)
@injectable
@freezed
@HiveType(typeId: 123)
abstract class WatchProviderCountry with _$WatchProviderCountry {
  @JsonSerializable(explicitToJson: true)
  const factory WatchProviderCountry({
    @HiveField(0) @JsonKey(name: 'link') String? link,
    @HiveField(1) @JsonKey(name: 'flatrate') List<WatchProvider>? flatrate,
    @HiveField(2) @JsonKey(name: 'rent') List<WatchProvider>? rent,
    @HiveField(3) @JsonKey(name: 'buy') List<WatchProvider>? buy,
    @HiveField(4) @JsonKey(name: 'ads') List<WatchProvider>? ads,
  }) = _WatchProviderCountry;

  factory WatchProviderCountry.fromJson(Map<String, dynamic> json) => _$WatchProviderCountryFromJson(json);
}

@injectable
@freezed
@HiveType(typeId: 124)
abstract class WatchProvidersResponse with _$WatchProvidersResponse {
  @JsonSerializable()
  const factory WatchProvidersResponse({
    @HiveField(0) required int id,
    // Map of country code to WatchProviderCountry
    @HiveField(1) @JsonKey(name: 'results') required Map<String, WatchProviderCountry> results,
  }) = _WatchProvidersResponse;

  factory WatchProvidersResponse.fromJson(Map<String, dynamic> json) => _$WatchProvidersResponseFromJson(json);
}