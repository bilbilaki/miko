// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:miko/src/ui/widgets/notification_tile.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  // Dummy data for notifications
  final List<Map<String, dynamic>> dummyNotifications = const [
    {
      'imageUrl': 'https://image.tmdb.org/t/p/w200/vsPzF26FqI8M1s210vY9Nl2QY4f.jpg', // One Piece
      'title': 'One Piece',
      'status': 'Update',
      'date': '12/20/2024',
    },
    {
      'imageUrl': 'https://image.tmdb.org/t/p/w200/9kCg7w6f6R3g0m1g8Y5L8S5d0o.jpg', // Jujutsu Kaisen
      'title': 'Jujutsu Kaisen Season 2',
      'status': 'Update',
      'date': '12/18/2024',
    },
    {
      'imageUrl': 'https://image.tmdb.org/t/p/w200/y202K1J7U9O4E7D0b0v9R5s5d4Q.jpg', // Dragon Ball Super: Super Hero
      'title': 'Dragon Ball Super: Super Hero',
      'status': 'New Release',
      'date': '12/17/2024',
    },
    {
      'imageUrl': 'https://image.tmdb.org/t/p/w200/5kU5A4zK1R2T5X5E4L0L0S5n7dE.jpg', // The Rising Of The Shield Hero
      'title': 'The Rising Of The Shield Hero: Sea...',
      'status': 'Update',
      'date': '12/15/2024',
    },
    {
      'imageUrl': 'https://image.tmdb.org/t/p/w200/wP7D0fWjP1c3z7b4q0n7c9v4S0d.jpg', // Idol Bu Show
      'title': 'Idol Bu Show Movie',
      'status': 'New Release',
      'date': '12/14/2024',
    },
    {
      'imageUrl': 'https://image.tmdb.org/t/p/w200/wP7D0fWjP1c3z7b4q0n7c9v4S0d.jpg', // Date A Live
      'title': 'Date A Live Season IV',
      'status': 'Update',
      'date': '12/12/2024',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F10),
      appBar: AppBar(
        title: const Text('Notification'),
        centerTitle: true,
        backgroundColor: const Color(0xFF0D0F10),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {
              // TODO: Implement more options for notifications
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        itemCount: dummyNotifications.length,
        itemBuilder: (context, index) {
          final notification = dummyNotifications[index];
          return NotificationTile(
            imageUrl: notification['imageUrl'] as String,
            title: notification['title'] as String,
            status: notification['status'] as String,
            date: notification['date'] as String,
            onTap: () {
              // TODO: Implement navigation to relevant content on notification tap
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Tapped on notification for ${notification['title']}')),
              );
            },
          );
        },
      ),
    );
  }
}