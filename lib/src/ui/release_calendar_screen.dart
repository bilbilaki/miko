// File: lib/src/ui/release_calendar_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:miko/src/consts.dart'; // For image base URL
import 'package:miko/src/ui/widgets/calendar_day_chip.dart';
import 'package:miko/src/ui/widgets/release_schedule_tile.dart';
import 'package:lottie/lottie.dart';
import 'package:miko/src/ui/anime_detail_screen.dart'; // For navigation

class ReleaseCalendarScreen extends StatefulWidget {
  const ReleaseCalendarScreen({super.key});

  @override
  State<ReleaseCalendarScreen> createState() => _ReleaseCalendarScreenState();
}

class _ReleaseCalendarScreenState extends State<ReleaseCalendarScreen> {
  DateTime _selectedDate = DateTime.now();

  // Dummy data for release schedule
  final Map<String, List<Map<String, dynamic>>> _dummyReleases = {
    DateFormat('yyyy-MM-dd').format(DateTime.now().add(const Duration(days: 1))): [ // Tomorrow's date
      {
        'time': '00:30',
        'imageUrl': 'https://image.tmdb.org/t/p/w200/vsPzF26FqI8M1s210vY9Nl2QY4f.jpg', // One Piece
        'title': 'One Piece',
        'episodeInfo': 'Episodes 1080',
        'onMyList': false,
        'animeId': 100, // Dummy ID
        'mediaType': 'tv',
      },
      {
        'time': '12:00',
        'imageUrl': 'https://image.tmdb.org/t/p/w200/9kCg7w6f6R3g0m1g8Y5L8S5d0o.jpg', // Jujutsu Kaisen
        'title': 'Jujutsu Kaisen Season 2',
        'episodeInfo': 'Episodes 12',
        'onMyList': true,
        'animeId': 101, // Dummy ID
        'mediaType': 'tv',
      },
      {
        'time': '20:30',
        'imageUrl': 'https://image.tmdb.org/t/p/w200/5kU5A4zK1R2T5X5E4L0L0S5n7dE.jpg', // The Rising Of The Shield Hero
        'title': 'The Rising Of The Shield Hero...',
        'episodeInfo': 'Episodes 20',
        'onMyList': false,
        'animeId': 102, // Dummy ID
        'mediaType': 'tv',
      },
      {
        'time': '22:00',
        'imageUrl': 'https://image.tmdb.org/t/p/w200/wP7D0fWjP1c3z7b4q0n7c9v4S0d.jpg', // Date A Live
        'title': 'Date A Live Season IV',
        'episodeInfo': 'Episodes 12',
        'onMyList': false,
        'animeId': 103, // Dummy ID
        'mediaType': 'tv',
      },
    ],
    // Add more dummy data for other dates if needed
  };

  @override
  Widget build(BuildContext context) {
    final List<DateTime> next7Days = List.generate(7, (index) => DateTime.now().add(Duration(days: index - 1)));
    final formattedSelectedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
    final currentDayReleases = _dummyReleases[formattedSelectedDate];

    return Scaffold(
      backgroundColor: const Color(0xFF0D0F10),
      appBar: AppBar(
        title: const Text('Release Calendar'),
        centerTitle: true,
        backgroundColor: const Color(0xFF0D0F10),
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(left: 16),
          child: const Icon(Icons.ac_unit, color: Color(0xFF0BFF7A), size: 28), // App Logo
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.white),
            onPressed: () {
              // TODO: Implement more options for calendar
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 80, // Height for the calendar strip
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: next7Days.length,
              itemBuilder: (context, index) {
                final date = next7Days[index];
                return CalendarDayChip(
                  date: date,
                  isSelected: DateUtils.isSameDay(date, _selectedDate),
                  onTap: () => setState(() => _selectedDate = date),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: currentDayReleases == null || currentDayReleases.isEmpty
                ? _buildEmptyState(context)
                : _buildReleaseList(context, currentDayReleases),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          'assets/Lottie/no_schedule.json', // Placeholder, replace with your Lottie animation
          repeat: true,
          height: 150,
          width: 150,
        ),
        const SizedBox(height: 24),
        const Text(
          'No Release Schedule',
          style: TextStyle(
            color: Color(0xFF1ED760),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.0),
          child: Text(
            'Sorry, there is no anime release schedule on this date',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildReleaseList(BuildContext context, List<Map<String, dynamic>> releases) {
    return ListView.builder(
      itemCount: releases.length,
      itemBuilder: (context, index) {
        final release = releases[index];
        return ReleaseScheduleTile(
          time: release['time'] as String,
          imageUrl: release['imageUrl'] as String,
          title: release['title'] as String,
          episodeInfo: release['episodeInfo'] as String,
          onMyList: release['onMyList'] as bool,
          onMyListToggle: () {
            setState(() {
              release['onMyList'] = !release['onMyList'];
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Toggled ${release['title']} on My List')),
            );
          },
          onTap: () {
            // Navigate to Anime Detail Screen
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => AnimeDetailScreen(
                  animeId: release['animeId'] as int,
                  mediaType: release['mediaType'] as String,
                ),
              ),
            );
          },
        );
      },
    );
  }
}