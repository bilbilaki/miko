import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miko/jackett/models/jackett_config.dart';
import 'package:miko/jackett/models/search_params.dart';
import 'package:miko/jackett/models/torznab_result_item.dart';
import 'package:miko/jackett/services/config_service.dart';
import 'package:miko/jackett/services/jackett_api_service.dart';
import 'package:miko/jackett/services/link_handler_service.dart';

// Provides the link handler service instance
final linkHandlerProvider = Provider((ref) => LinkHandlerService());

// Manages the list of saved Jackett configurations
final jackettConfigsProvider = StateNotifierProvider<JackettConfigsNotifier, List<JackettConfig>>((ref) {
  return JackettConfigsNotifier(ref.watch(configServiceProvider));
});

class JackettConfigsNotifier extends StateNotifier<List<JackettConfig>> {
  final ConfigService _configService;
  JackettConfigsNotifier(this._configService) : super(_configService.getConfigs()) {
    _configService.watch().listen((event) {
      state = _configService.getConfigs();
    });
  }
}


// Holds the key of the currently active Jackett configuration
final activeConfigKeyProvider = StateProvider<dynamic>((ref) {
  final configs = ref.watch(configServiceProvider).getConfigs();
  return configs.isNotEmpty ? configs.first.key : null;
});

// Provides an instance of the JackettApiService for the active configuration
final jackettApiProvider = Provider<JackettApiService?>((ref) {
  final activeKey = ref.watch(activeConfigKeyProvider);
  final configService = ref.watch(configServiceProvider);
  
  if (activeKey != null) {
    final activeConfig = configService.getConfig(activeKey);
    if (activeConfig != null) {
      final apiService = JackettApiService(config: activeConfig);
      ref.onDispose(() => apiService.dispose());
      return apiService;
    }
  }
  return null;
});

// Manages the state of a search operation (loading, data, error)
final searchProvider = StateNotifierProvider.autoDispose<SearchNotifier, AsyncValue<List<TorznabResultItem>>>((ref) {
  return SearchNotifier(ref);
});

class SearchNotifier extends StateNotifier<AsyncValue<List<TorznabResultItem>>> {
  final Ref _ref;
  SearchNotifier(this._ref) : super(const AsyncValue.data([]));

  Future<void> performSearch(SearchParams params) async {
    state = const AsyncValue.loading();
    final apiService = _ref.read(jackettApiProvider);

    if (apiService == null) {
      state = AsyncValue.error('No active Jackett configuration selected.', StackTrace.current);
      return;
    }

    state = await AsyncValue.guard(() => apiService.search(params: params));
  }

  void clearSearch() {
    state = const AsyncValue.data([]);
  }
}