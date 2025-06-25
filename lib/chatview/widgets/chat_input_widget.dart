import 'package:flutter/material.dart';

class ChatInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isTyping;
  final bool isRecording;
  final Animation<double> fabScaleAnimation;
  final Animation<double> fabRotationAnimation;
  final VoidCallback onSend;
  final VoidCallback onStartRecording;
  final VoidCallback onSendFile;
  final VoidCallback onWebSearch;

  const ChatInputWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isTyping,
    required this.isRecording,
    required this.fabScaleAnimation,
    required this.fabRotationAnimation,
    required this.onSend,
    required this.onStartRecording,
    required this.onSendFile,
    required this.onWebSearch,
  });

  @override
  State<ChatInputWidget> createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<ChatInputWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _expandController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _expandAnimation;
  
  bool _showExtraActions = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _expandController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _expandAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _expandController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void didUpdateWidget(ChatInputWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording && !oldWidget.isRecording) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.isRecording && oldWidget.isRecording) {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _expandController.dispose();
    super.dispose();
  }

  void _toggleExtraActions() {
    setState(() {
      _showExtraActions = !_showExtraActions;
    });
    
    if (_showExtraActions) {
      _expandController.forward();
    } else {
      _expandController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        border: Border(
          top: BorderSide(color: Color(0xFF2A2A2A), width: 1),
        ),
      ),
      child: Column(
        children: [
          // Extra Actions Row
          if (_showExtraActions)
            ScaleTransition(
              scale: _expandAnimation,
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: _buildExtraActions(),
              ),
            ),
          
          // Main Input Row
          Row(
            children: [
              // Expand Button
              _buildActionButton(
                icon: _showExtraActions ? Icons.close : Icons.add,
                onPressed: _toggleExtraActions,
                backgroundColor: const Color(0xFF2A2A2A),
              ),
              
              const SizedBox(width: 8),
              
              // Text Input
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: widget.focusNode.hasFocus 
                          ? const Color(0xFF10A37F) 
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: widget.controller,
                          focusNode: widget.focusNode,
                          maxLines: 5,
                          minLines: 1,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Type your message...',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          onSubmitted: (_) => widget.onSend(),
                        ),
                      ),
                      
                      // Emoji Button
                      IconButton(
                        icon: const Icon(Icons.emoji_emotions_outlined, color: Colors.grey),
                        onPressed: () {
                          // Show emoji picker
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(width: 8),
              
              // Send/Record Button
              _buildSendButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExtraActions() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildExtraActionButton(
            icon: Icons.attach_file,
            label: 'File',
            color: const Color(0xFF667EEA),
            onPressed: widget.onSendFile,
          ),
          _buildExtraActionButton(
            icon: Icons.camera_alt,
            label: 'Camera',
            color: const Color(0xFFFF6B6B),
            onPressed: () {
              // Open camera
            },
          ),
          _buildExtraActionButton(
            icon: Icons.photo_library,
            label: 'Gallery',
            color: const Color(0xFF4ECDC4),
            onPressed: () {
              // Open gallery
            },
          ),
          _buildExtraActionButton(
            icon: Icons.search,
            label: 'Web Search',
            color: const Color(0xFFFFE66D),
            onPressed: widget.onWebSearch,
          ),
          _buildExtraActionButton(
            icon: Icons.location_on,
            label: 'Location',
            color: const Color(0xFFFF8E53),
            onPressed: () {
              // Share location
            },
          ),
          _buildExtraActionButton(
            icon: Icons.contact_page,
            label: 'Contact',
            color: const Color(0xFFA8E6CF),
            onPressed: () {
              // Share contact
            },
          ),
          _buildExtraActionButton(
            icon: Icons.poll,
            label: 'Poll',
            color: const Color(0xFFDDA0DD),
            onPressed: () {
              // Create poll
            },
          ),
        ],
      ),
    );
  }

  Widget _buildExtraActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          GestureDetector(
            onTap: onPressed,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSendButton() {
    if (widget.isRecording) {
      return AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.stop,
                color: Colors.white,
                size: 24,
              ),
            ),
          );
        },
      );
    }
    
    if (widget.isTyping) {
      return AnimatedBuilder(
        animation: widget.fabScaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.fabScaleAnimation.value,
            child: RotationTransition(
              turns: widget.fabRotationAnimation,
              child: _buildActionButton(
                icon: Icons.send,
                onPressed: widget.onSend,
                backgroundColor: const Color(0xFF10A37F),
              ),
            ),
          );
        },
      );
    }
    
    return _buildActionButton(
      icon: Icons.mic,
      onPressed: widget.onStartRecording,
      backgroundColor: const Color(0xFF10A37F),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color backgroundColor,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: backgroundColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}