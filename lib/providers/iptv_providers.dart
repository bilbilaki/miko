import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:miko/data/iptv_repository.dart';
import 'package:miko/models/channel.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Enum for our grouping options
enum ChannelGrouping { category, language, country, subdivision }

// 1. Repository Provider
final iptvRepositoryProvider = Provider<IptvRepository>((ref) => IptvRepository());

// 2. Data Fetching Provider
final channelsProvider = FutureProvider<List<Channel>>((ref) {
  return ref.watch(iptvRepositoryProvider).fetchChannels();
});

// 3. UI State Provider (search, grouping, selected channel)
final iptvUiStateProvider = StateNotifierProvider<IptvUiStateNotifier, IptvUiState>((ref) {
  // Create the media_kit player ONCE and pass it to the notifier.
  final player = Player();
  // Dispose the player when the provider is disposed.
  ref.onDispose(() async {
   await player.dispose();
  });
  return IptvUiStateNotifier(player);
});

class IptvUiState {
  final String searchQuery;
  final ChannelGrouping grouping;
  final Channel? selectedChannel;

  IptvUiState({
    this.searchQuery = '',
    this.grouping = ChannelGrouping.category,
    this.selectedChannel,
  });

  IptvUiState copyWith({
    String? searchQuery,
    ChannelGrouping? grouping,
    Channel? selectedChannel,
  }) {
    return IptvUiState(
      searchQuery: searchQuery ?? this.searchQuery,
      grouping: grouping ?? this.grouping,
      selectedChannel: selectedChannel ?? this.selectedChannel,
    );
  }
}

class IptvUiStateNotifier extends StateNotifier<IptvUiState> {
  final Player player; // The media_kit player

  IptvUiStateNotifier(this.player) : super(IptvUiState());

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setGrouping(ChannelGrouping newGrouping) {
    state = state.copyWith(grouping: newGrouping);
  }

  void selectChannel(Channel? channel) {
    state = state.copyWith(selectedChannel: channel);
    if (channel != null) {
      // Play the new channel
      player.open(Media(channel.streamUrl));
    } else {
      // Stop playback if no channel is selected
      player.stop();
    }
  }
}

// 4. Favorites & Watchlist Providers (with persistence)
final favoritesProvider = StateNotifierProvider<PreferenceNotifier, Set<String>>((ref) {
  return PreferenceNotifier('favorites');
});

final watchlistProvider = StateNotifierProvider<PreferenceNotifier, Set<String>>((ref) {
  return PreferenceNotifier('watchlist');
});

class PreferenceNotifier extends StateNotifier<Set<String>> {
  final String _key;
  late SharedPreferences _prefs;

  PreferenceNotifier(this._key) : super({}) {
    _init();
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    final items = _prefs.getStringList(_key);
    if (items != null) {
      state = items.toSet();
    }
  }

  Future<void> add(String channelId) async {
    state = {...state, channelId};
    await _prefs.setStringList(_key, state.toList());
  }

  Future<void> remove(String channelId) async {
    state = state..remove(channelId);
    await _prefs.setStringList(_key, state.toList());
  }

  void toggle(String channelId) {
    if (state.contains(channelId)) {
      remove(channelId);
    } else {
      add(channelId);
    }
  }
}