import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:miko/models/channel.dart';
import 'package:miko/providers/iptv_providers.dart';

class IptvScreen extends ConsumerWidget {
  const IptvScreen({super.key});

  /// Breakpoint for switching between narrow and wide screen layouts.
  static const double _breakpoint = 700;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
 
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > _breakpoint) {
            // Wider screen layout (e.g., tablet, desktop)
            return Row(
              children: [
                // Left pane for player view
                Expanded(
                  flex: 3, // Player takes 60% of width (3 out of 5 parts)
                  child: Column(
                    children: [
                      _TinyPlayer(),
                      // Optionally, add more player-related controls or info here
                    ],
                  ),
                ),
                // Right pane for controls and channel list
                Expanded(
                  flex: 2, // Controls and list take 40% of width (2 out of 5 parts)
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(left: BorderSide(color: Theme.of(context).dividerColor, width: 0.5)),
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    child:  Column(
                      children: [
                        _Controls(),
                        Expanded(child: _ChannelListView()),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            // Narrow screen layout (e.g., portrait phone)
            return  Column(
              children: [
                _TinyPlayer(),
                _Controls(),
                Expanded(child: _ChannelListView()),
              ],
            );
          }
        },
      ),
    );
  }
}
// The Tiny Player Widget
class _TinyPlayer extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedChannel = ref.watch(iptvUiStateProvider.select((s) => s.selectedChannel));
    final player = ref.watch(iptvUiStateProvider.notifier).player;
    final controller = VideoController(player);

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade800, width: 4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: selectedChannel == null
              ? _TvOffScreen()
              : Video(
                  controller: controller,
                  // The tiny square button for fullscreen is built-in!
                ),
        ),
      ),
    );
  }
}

class _TvOffScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1a1a1a),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.tv_off_outlined, color: Colors.grey, size: 50),
            SizedBox(height: 8),
            Text(
              'Select a channel to play',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}


// Search and Grouping Controls
class _Controls extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(iptvUiStateProvider);
    final uiNotifier = ref.read(iptvUiStateProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Column(
        children: [
          CupertinoSearchTextField(
            onChanged: (value) => uiNotifier.setSearchQuery(value),
          ),
          const SizedBox(height: 8),
          CupertinoSlidingSegmentedControl<ChannelGrouping>(
            groupValue: uiState.grouping,
            onValueChanged: (value) {
              if (value != null) {
                uiNotifier.setGrouping(value);
              }
            },
            children: const {
              ChannelGrouping.category: Text('Category'),
              ChannelGrouping.language: Text('Language'),
              ChannelGrouping.country: Text('Country'),
              ChannelGrouping.subdivision: Text('Region'),
            },
          )
        ],
      ),
    );
  }
}

// The Main Channel List
class _ChannelListView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channelsAsyncValue = ref.watch(channelsProvider);
    final uiState = ref.watch(iptvUiStateProvider);

    return channelsAsyncValue.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (allChannels) {
        // Apply search filter
        final filteredChannels = allChannels.where((channel) {
          return channel.name.toLowerCase().contains(uiState.searchQuery.toLowerCase());
        }).toList();

        if (filteredChannels.isEmpty) {
          return const Center(child: Text('No channels found.'));
        }

        // Use the grouped_list package
        return GroupedListView<Channel, String>(
          elements: filteredChannels,
          groupBy: (channel) {
            switch (uiState.grouping) {
              case ChannelGrouping.category: return channel.category;
              case ChannelGrouping.language: return channel.language;
              case ChannelGrouping.country: return channel.country;
              case ChannelGrouping.subdivision: return channel.subdivision;
            }
          },
          groupSeparatorBuilder: (String groupByValue) => Container(
            color: Theme.of(context).primaryColor.withOpacity(0.2),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              groupByValue,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          itemBuilder: (context, channel) {
            return _ChannelListItem(channel: channel);
          },
          itemComparator: (item1, item2) => item1.name.compareTo(item2.name),
          order: GroupedListOrder.ASC,
          useStickyGroupSeparators: true,
          floatingHeader: true,
        );
      },
    );
  }
}

// A single item in the list
class _ChannelListItem extends ConsumerWidget {
  final Channel channel;
  const _ChannelListItem({required this.channel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedChannel = ref.watch(iptvUiStateProvider.select((s) => s.selectedChannel));
    final favorites = ref.watch(favoritesProvider);
    final watchlist = ref.watch(watchlistProvider);

    final isFavorite = favorites.contains(channel.id);
    final isWatchlisted = watchlist.contains(channel.id);
    final isSelected = selectedChannel?.id == channel.id;

    return ListTile(
      tileColor: isSelected ? Theme.of(context).primaryColor.withOpacity(0.3) : null,
      leading: channel.logoUrl.isNotEmpty
          ? Image.network(
              channel.logoUrl,
              width: 50,
              height: 50,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.live_tv, size: 30),
            )
          : const Icon(Icons.live_tv, size: 30),
      title: Text(channel.name),
      subtitle: Text('${channel.country} | ${channel.category}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: () => ref.read(favoritesProvider.notifier).toggle(channel.id),
          ),
          IconButton(
            icon: Icon(
              isWatchlisted ? Icons.bookmark : Icons.bookmark_border,
              color: isWatchlisted ? Colors.amber : null,
            ),
            onPressed: () => ref.read(watchlistProvider.notifier).toggle(channel.id),
          ),
        ],
      ),
      onTap: () {
        ref.read(iptvUiStateProvider.notifier).selectChannel(channel);
      },
    );
  }
}