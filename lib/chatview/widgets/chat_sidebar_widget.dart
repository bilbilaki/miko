import 'package:flutter/material.dart';

class ChatSidebarWidget extends StatefulWidget {
  final String selectedModel;
  final List<String> models;
  final Function(String) onModelChanged;
  final VoidCallback onNewChat;

  const ChatSidebarWidget({
    super.key,
    required this.selectedModel,
    required this.models,
    required this.onModelChanged,
    required this.onNewChat,
  });

  @override
  State<ChatSidebarWidget> createState() => _ChatSidebarWidgetState();
}

class _ChatSidebarWidgetState extends State<ChatSidebarWidget> {
  final List<Map<String, dynamic>> _chatHistory = [
    {
      'id': '1',
      'title': 'Flutter Animations Help',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
      'preview': 'Can you help me understand Flutter animations?',
      'isActive': true,
    },
    {
      'id': '2',
      'title': 'State Management',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'preview': 'What\'s the best state management solution?',
      'isActive': false,
    },
    {
      'id': '3',
      'title': 'API Integration',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'preview': 'How to integrate REST APIs in Flutter?',
      'isActive': false,
    },
    {
      'id': '4',
      'title': 'Custom Widgets',
      'timestamp': DateTime.now().subtract(const Duration(days: 2)),
      'preview': 'Creating reusable custom widgets',
      'isActive': false,
    },
    {
      'id': '5',
      'title': 'Performance Optimization',
      'timestamp': DateTime.now().subtract(const Duration(days: 3)),
      'preview': 'Tips for optimizing Flutter app performance',
      'isActive': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        border: Border(
          right: BorderSide(color: Color(0xFF2A2A2A), width: 1),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(),
          _buildModelSelector(),
          _buildNewChatButton(),
          const Divider(color: Color(0xFF2A2A2A), height: 1),
          _buildChatHistory(),
          const Divider(color: Color(0xFF2A2A2A), height: 1),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF10A37F), Color(0xFF1A7F64)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.smart_toy,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Assistant',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Always here to help',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModelSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: widget.selectedModel,
          isExpanded: true,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          dropdownColor: const Color(0xFF2A2A2A),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          onChanged: (String? newValue) {
            if (newValue != null) {
              widget.onModelChanged(newValue);
            }
          },
          items: widget.models.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _getModelColor(value),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(value),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildNewChatButton() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: ElevatedButton.icon(
        onPressed: widget.onNewChat,
        icon: const Icon(Icons.add, size: 20),
        label: const Text('New Chat'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF10A37F),
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildChatHistory() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Recent Chats',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _chatHistory.length,
              itemBuilder: (context, index) {
                final chat = _chatHistory[index];
                return _buildChatHistoryItem(chat);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatHistoryItem(Map<String, dynamic> chat) {
    final isActive = chat['isActive'] as bool;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF2A2A2A) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        title: Text(
          chat['title'],
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey[300],
            fontSize: 14,
            fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text(
              chat['preview'],
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              _formatTimestamp(chat['timestamp']),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 10,
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: Icon(
            Icons.more_horiz,
            color: Colors.grey[600],
            size: 16,
          ),
          onSelected: (value) {
            switch (value) {
              case 'rename':
                _showRenameDialog(chat);
                break;
              case 'delete':
                _showDeleteDialog(chat);
                break;
              case 'pin':
                // Pin chat
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'rename', child: Text('Rename')),
            const PopupMenuItem(value: 'pin', child: Text('Pin')),
            const PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
        onTap: () {
          setState(() {
            for (var c in _chatHistory) {
              c['isActive'] = false;
            }
            chat['isActive'] = true;
          });
        },
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildFooterButton(
            icon: Icons.settings,
            label: 'Settings',
            onPressed: () {},
          ),
          const SizedBox(height: 8),
          _buildFooterButton(
            icon: Icons.help_outline,
            label: 'Help & FAQ',
            onPressed: () {},
          ),
          const SizedBox(height: 8),
          _buildFooterButton(
            icon: Icons.logout,
            label: 'Sign Out',
            onPressed: () {},
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'John Doe',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Pro Plan',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10A37F),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'PRO',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[400], size: 18),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getModelColor(String model) {
    switch (model) {
      case 'GPT-4':
        return const Color(0xFF10A37F);
      case 'GPT-3.5':
        return const Color(0xFF667EEA);
      case 'Claude-3':
        return const Color(0xFFFF6B6B);
      case 'Gemini Pro':
        return const Color(0xFF4ECDC4);
      case 'LLaMA 2':
        return const Color(0xFFFFE66D);
      case 'PaLM 2':
        return const Color(0xFFFF8E53);
      default:
        return Colors.grey;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }

  void _showRenameDialog(Map<String, dynamic> chat) {
    final controller = TextEditingController(text: chat['title']);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text('Rename Chat', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter new name',
            hintStyle: TextStyle(color: Colors.grey),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                chat['title'] = controller.text;
              });
              Navigator.pop(context);
            },
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(Map<String, dynamic> chat) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text('Delete Chat', style: TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to delete "${chat['title']}"?',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _chatHistory.remove(chat);
              });
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}