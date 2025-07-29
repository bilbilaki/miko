// TODO Implement this library.
import 'package:flutter/material.dart';

class LogViewer extends StatelessWidget {
  final ValueNotifier<String> logNotifier;

  const LogViewer({super.key, required this.logNotifier});

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    
    return AlertDialog(
      title: const Text('Task Log'),
      content: SizedBox(
        width: double.maxFinite,
        child: ValueListenableBuilder<String>(
          valueListenable: logNotifier,
          builder: (context, log, child) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (scrollController.hasClients) {
                scrollController.jumpTo(scrollController.position.maxScrollExtent);
              }
            });
            return Scrollbar(
              controller: scrollController,
              child: SingleChildScrollView(
                controller: scrollController,
                child: SelectableText(log),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
