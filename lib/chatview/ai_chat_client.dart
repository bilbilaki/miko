import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'widgets/chat_message_widget.dart';
import 'widgets/chat_input_widget.dart';
import 'widgets/chat_sidebar_widget.dart';
import 'widgets/typing_indicator_widget.dart';

class AIChatClient extends StatefulWidget {
  const AIChatClient({super.key});

  @override
  State<AIChatClient> createState() => _AIChatClientState();
}

class _AIChatClientState extends State<AIChatClient>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _inputFocusNode = FocusNode();
  
  late AnimationController _fabAnimationController;
  late AnimationController _typingAnimationController;
  late AnimationController _slideAnimationController;
  
  late Animation<double> _fabScaleAnimation;
  late Animation<double> _fabRotationAnimation;
  late Animation<Offset> _slideAnimation;
  
  bool _isTyping = false;
  bool _isRecording = false;
  bool _isSidebarVisible = false;
  bool _isAITyping = false;
  String _selectedModel = 'GPT-4';
  
  final List<String> _aiModels = [
    'GPT-4', 'GPT-3.5', 'Claude-3', 'Gemini Pro', 'LLaMA 2', 'PaLM 2'
  ];
  
  final List<Map<String, dynamic>> _messages = [
    {
      'id': '1',
      'content': 'Hello! I\'m your AI assistant. How can I help you today?',
      'isUser': false,
      'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
      'type': 'text',
      'likes': 0,
      'dislikes': 0,
      'isLiked': false,
      'isDisliked': false,
    },
    {
      'id': '2',
      'content': 'Hi there! Can you help me understand Flutter animations?',
      'isUser': true,
      'timestamp': DateTime.now().subtract(const Duration(minutes: 4)),
      'type': 'text',
    },
    {
      'id': '3',
      'content': 'Absolutely! Flutter animations are a powerful way to create engaging user interfaces. Here are the key concepts:\n\n1. **AnimationController** - Controls the animation timeline\n2. **Tween** - Defines the range of values\n3. **AnimatedBuilder** - Rebuilds widgets during animation\n\nWould you like me to show you a specific example?',
      'isUser': false,
      'timestamp': DateTime.now().subtract(const Duration(minutes: 3)),
      'type': 'text',
      'likes': 2,
      'dislikes': 0,
      'isLiked': true,
      'isDisliked': false,
      'codeBlocks': [
        {
          'language': 'dart',
          'code': '''AnimationController controller = AnimationController(
  duration: Duration(seconds: 2),
  vsync: this,
);

Animation<double> animation = Tween<double>(
  begin: 0.0,
  end: 1.0,
).animate(controller);'''
        }
      ]
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _messageController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    _typingAnimationController.dispose();
    _slideAnimationController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _typingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _fabScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.elasticOut,
    ));
    
    _fabRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.25,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  void _onTextChanged() {
    final hasText = _messageController.text.trim().isNotEmpty;
    if (hasText != _isTyping) {
      setState(() {
        _isTyping = hasText;
      });
      
      if (hasText) {
        _fabAnimationController.forward();
      } else {
        _fabAnimationController.reverse();
      }
    }
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final newMessage = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'content': text,
      'isUser': true,
      'timestamp': DateTime.now(),
      'type': 'text',
    };

    setState(() {
      _messages.add(newMessage);
      _isAITyping = true;
    });

    _messageController.clear();
    _scrollToBottom();
    _simulateAIResponse();
  }

  void _simulateAIResponse() {
    _typingAnimationController.repeat();
    
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        final responses = [
          'That\'s a great question! Let me help you with that.',
          'I understand what you\'re looking for. Here\'s my response...',
          'Interesting! Based on your question, I can provide the following insights:',
          'Let me break this down for you step by step.',
          'That\'s a complex topic. Here\'s what I think...',
        ];
        
        final randomResponse = responses[DateTime.now().millisecond % responses.length];
        
        final aiMessage = {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'content': randomResponse,
          'isUser': false,
          'timestamp': DateTime.now(),
          'type': 'text',
          'likes': 0,
          'dislikes': 0,
          'isLiked': false,
          'isDisliked': false,
        };

        setState(() {
          _messages.add(aiMessage);
          _isAITyping = false;
        });
        
        _typingAnimationController.stop();
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _toggleSidebar() {
    setState(() {
      _isSidebarVisible = !_isSidebarVisible;
    });
    
    if (_isSidebarVisible) {
      _slideAnimationController.forward();
    } else {
      _slideAnimationController.reverse();
    }
  }

  void _likeMessage(String messageId) {
    setState(() {
      final messageIndex = _messages.indexWhere((m) => m['id'] == messageId);
      if (messageIndex != -1) {
        final message = _messages[messageIndex];
        if (message['isLiked'] == true) {
          message['likes']--;
          message['isLiked'] = false;
        } else {
          if (message['isDisliked'] == true) {
            message['dislikes']--;
            message['isDisliked'] = false;
          }
          message['likes']++;
          message['isLiked'] = true;
        }
      }
    });
  }

  void _dislikeMessage(String messageId) {
    setState(() {
      final messageIndex = _messages.indexWhere((m) => m['id'] == messageId);
      if (messageIndex != -1) {
        final message = _messages[messageIndex];
        if (message['isDisliked'] == true) {
          message['dislikes']--;
          message['isDisliked'] = false;
        } else {
          if (message['isLiked'] == true) {
            message['likes']--;
            message['isLiked'] = false;
          }
          message['dislikes']++;
          message['isDisliked'] = true;
        }
      }
    });
  }

  void _copyMessage(String content) {
    Clipboard.setData(ClipboardData(text: content));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('Message copied to clipboard'),
          ],
        ),
        backgroundColor: const Color(0xFF10A37F),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareMessage(String content) {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share functionality would be implemented here'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _webSearch(String query) {
    // Implement web search
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Searching web for: $query'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
    });
    
    // Simulate recording
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isRecording = false;
        });
        
        // Add voice message
        final voiceMessage = {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'content': 'Voice message recorded',
          'isUser': true,
          'timestamp': DateTime.now(),
          'type': 'voice',
          'duration': 3,
        };
        
        setState(() {
          _messages.add(voiceMessage);
        });
        
        _scrollToBottom();
      }
    });
  }

  void _sendFile() {
    // Simulate file selection and sending
    final fileMessage = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'content': 'document.pdf',
      'isUser': true,
      'timestamp': DateTime.now(),
      'type': 'file',
      'fileSize': '2.5 MB',
      'fileType': 'PDF',
    };
    
    setState(() {
      _messages.add(fileMessage);
    });
    
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: Stack(
        children: [
          // Main Chat Interface
          Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: Row(
                  children: [
                    // Sidebar
                    if (_isSidebarVisible)
                      SlideTransition(
                        position: _slideAnimation,
                        child: ChatSidebarWidget(
                          selectedModel: _selectedModel,
                          models: _aiModels,
                          onModelChanged: (model) {
                            setState(() {
                              _selectedModel = model;
                            });
                          },
                          onNewChat: () {
                            setState(() {
                              _messages.clear();
                              _messages.add({
                                'id': '1',
                                'content': 'Hello! I\'m your AI assistant. How can I help you today?',
                                'isUser': false,
                                'timestamp': DateTime.now(),
                                'type': 'text',
                                'likes': 0,
                                'dislikes': 0,
                                'isLiked': false,
                                'isDisliked': false,
                              });
                            });
                          },
                        ),
                      ),
                    
                    // Chat Area
                    Expanded(
                      child: Column(
                        children: [
                          // Messages
                          Expanded(
                            child: ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.all(16),
                              itemCount: _messages.length + (_isAITyping ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == _messages.length && _isAITyping) {
                                  return TypingIndicatorWidget(
                                    animationController: _typingAnimationController,
                                  );
                                }
                                
                                final message = _messages[index];
                                return ChatMessageWidget(
                                  message: message,
                                  onLike: () => _likeMessage(message['id']),
                                  onDislike: () => _dislikeMessage(message['id']),
                                  onCopy: () => _copyMessage(message['content']),
                                  onShare: () => _shareMessage(message['content']),
                                  onWebSearch: () => _webSearch(message['content']),
                                );
                              },
                            ),
                          ),
                          
                          // Input Area
                          ChatInputWidget(
                            controller: _messageController,
                            focusNode: _inputFocusNode,
                            isTyping: _isTyping,
                            isRecording: _isRecording,
                            fabScaleAnimation: _fabScaleAnimation,
                            fabRotationAnimation: _fabRotationAnimation,
                            onSend: _sendMessage,
                            onStartRecording: _startRecording,
                            onSendFile: _sendFile,
                            onWebSearch: () => _webSearch(_messageController.text),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          // Floating Action Buttons
          _buildFloatingActions(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        border: Border(
          bottom: BorderSide(color: Color(0xFF2A2A2A), width: 1),
        ),
      ),
      child: Row(
        children: [
          // Menu Button
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: _toggleSidebar,
          ),
          
          const SizedBox(width: 12),
          
          // AI Avatar
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
          
          // AI Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _selectedModel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _isAITyping ? 'Typing...' : 'Online',
                  style: TextStyle(
                    color: _isAITyping ? const Color(0xFF10A37F) : Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          
          // Action Buttons
          IconButton(
            icon: const Icon(Icons.videocam, color: Colors.white70),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.call, color: Colors.white70),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white70),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActions() {
    return Positioned(
      right: 16,
      bottom: 100,
      child: Column(
        children: [
          // Scroll to Bottom
          FloatingActionButton.small(
            heroTag: 'scroll',
            backgroundColor: const Color(0xFF2A2A2A),
            foregroundColor: Colors.white,
            onPressed: _scrollToBottom,
            child: const Icon(Icons.keyboard_arrow_down),
          ),
          
          const SizedBox(height: 8),
          
          // Clear Chat
          FloatingActionButton.small(
            heroTag: 'clear',
            backgroundColor: const Color(0xFF2A2A2A),
            foregroundColor: Colors.white,
            onPressed: () {
              setState(() {
                _messages.clear();
              });
            },
            child: const Icon(Icons.clear_all),
          ),
        ],
      ),
    );
  }
}