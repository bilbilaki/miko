import 'package:flutter/material.dart';
import 'package:miko/widgets/left_navigation_panel_ai.dart';
import 'package:miko/widgets/right_settings_panel.dart';
import 'package:miko/widgets/input_area.dart';
import 'package:miko/core/ai/ai_task_orchestrator.dart';
import 'package:miko/core/session/session_manager.dart';
import 'package:miko/data/models/session_models.dart'; // For SessionEvent
import 'package:miko/services/ai_service_provider.dart';
import 'package:miko/widgets/chat_message.dart';

class AICoreScreen extends StatefulWidget {
  const AICoreScreen({super.key});

  @override
  State<AICoreScreen> createState() => _AICoreScreenState();
}

class _AICoreScreenState extends State<AICoreScreen> {
  late final AITaskOrchestrator _orchestrator;
  late final SessionManager _sessionManager;
  final TextEditingController _promptController = TextEditingController();
  final List<SessionEvent> _chatHistory = []; // Simple chat history for display

  @override
  void initState() {
    super.initState();
    _orchestrator = AiServiceProvider().aiTaskOrchestrator;
    _sessionManager = AiServiceProvider().sessionManager;

    // Listen to session changes to update chat history
    _sessionManager.stream.listen((sessionStateData) {
      setState(() {
        _chatHistory.clear();
        _chatHistory.addAll(sessionStateData.session.displayHistory);
      });
    });
  }

  void _sendPrompt() {
    final prompt = _promptController.text;
    if (prompt.isNotEmpty) {
      _orchestrator.processUserRequest(userPrompt: prompt);
      _promptController.clear();
    }
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google AI Studio'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              );
            },
          ),
        ],
      ),
      drawer: const Drawer(
        child: LeftNavigationPanel(),
      ),
      endDrawer: const Drawer(
        width: 300,
        child: RightSettingsPanel(),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            // Large screen layout
            return Row(
              children: [
                // Left Navigation Panel (persistent)
                const SizedBox(
                  width: 200,
                  child: LeftNavigationPanel(),
                ),
                // Main Content Area
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          child: ListView.builder(
                            itemCount: _chatHistory.length,
                            itemBuilder: (context, index) {
                              return ChatMessage(event: _chatHistory[index]);
                            },
                          ),
                        ),
                      ),
                      // Input Area
                      SizedBox(
                        height: 100,
                        child: InputArea(
                          controller: _promptController,
                          onSend: _sendPrompt,
                        ),
                      ),
                    ],
                  ),
                ),
                // Right Settings Panel (persistent)
                const SizedBox(
                  width: 300,
                  child: RightSettingsPanel(),
                ),
              ],
            );
          } else {
            // Small screen layout (main content only, drawers handle navigation/settings)
            return Column(
              children: [
                Expanded(
                  child: Container(
                    child: ListView.builder(
                      itemCount: _chatHistory.length,
                      itemBuilder: (context, index) {
                        return ChatMessage(event: _chatHistory[index]);
                      },
                    ),
                  ),
                ),
                // Input Area
                SizedBox(
                  height: 100,
                  child: InputArea(
                    controller: _promptController,
                    onSend: _sendPrompt,
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}