// File: lib/src/ui/comments_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommentsScreen extends ConsumerStatefulWidget {
  final String animeTitle;
  final String commentsCount; // e.g., "29.5K"

  const CommentsScreen({
    super.key,
    required this.animeTitle,
    this.commentsCount = '0',
  });

  @override
  ConsumerState<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();

  // Dummy comments data
  final List<Map<String, dynamic>> _comments = [
    {
      'avatarUrl': 'https://randomuser.me/api/portraits/men/32.jpg',
      'author': 'Willard Purnell',
      'comment': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt 💯💯💯',
      'likes': 938,
      'time': '3 days ago',
    },
    {
      'avatarUrl': 'https://randomuser.me/api/portraits/women/65.jpg',
      'author': 'Hannah Burress',
      'comment': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore 😍',
      'likes': 847,
      'time': '2 days ago',
    },
    {
      'avatarUrl': 'https://randomuser.me/api/portraits/men/70.jpg',
      'author': 'Jamel Eusebio',
      'comment': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut dolore 🤔',
      'likes': 534,
      'time': '4 days ago',
    },
    {
      'avatarUrl': 'https://randomuser.me/api/portraits/women/44.jpg',
      'author': 'Kathryn Murphy',
      'comment': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut 🔥🔥',
      'likes': 534,
      'time': '4 days ago',
    },
    {
      'avatarUrl': 'https://randomuser.me/api/portraits/men/80.jpg',
      'author': 'Benny Spanbauer',
      'comment': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'likes': 420,
      'time': '5 days ago',
    },
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _addComment() {
    if (_commentController.text.trim().isNotEmpty) {
      setState(() {
        _comments.insert(0, {
          'avatarUrl': 'https://randomuser.me/api/portraits/men/1.jpg', // Placeholder for current user
          'author': 'You', // Or actual logged-in user's name
          'comment': _commentController.text.trim(),
          'likes': 0,
          'time': 'Just now',
        });
      });
      _commentController.clear();
      FocusScope.of(context).unfocus(); // Dismiss keyboard
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F10),
      appBar: AppBar(
        title: Text('${widget.commentsCount} Comments'),
        centerTitle: true,
        backgroundColor: const Color(0xFF0D0F10),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.white),
            onPressed: () {
              // TODO: Implement more options for comments screen
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _comments.length,
              itemBuilder: (context, index) {
                final comment = _comments[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: NetworkImage(comment['avatarUrl']!),
                        backgroundColor: Colors.grey.shade700,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  comment['author']!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.more_horiz, color: Colors.white70, size: 20),
                                  onPressed: () {
                                    // TODO: Options for individual comment (report, delete, etc.)
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Options for comment by ${comment['author']}')),
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              comment['comment']!,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.favorite, color: Colors.red.shade400, size: 18),
                                const SizedBox(width: 4),
                                Text(
                                  comment['likes'].toString(),
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  comment['time']!,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.6),
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1), width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Add comment...',
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.emoji_emotions_outlined, color: Colors.white70),
            onPressed: () {
              // TODO: Implement emoji picker
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Emoji picker (not implemented)')));
            },
          ),
          IconButton(
            icon: Icon(Icons.send, color: Theme.of(context).colorScheme.primary),
            onPressed: _addComment,
          ),
        ],
      ),
    );
  }
}