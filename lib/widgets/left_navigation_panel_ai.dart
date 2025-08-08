import 'package:flutter/material.dart';

class LeftNavigationPanel extends StatelessWidget {
  const LeftNavigationPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: const <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Text(
            'Google AI Studio',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
        ListTile(
          leading: Icon(Icons.chat),
          title: Text('Chat'),
        ),
        ListTile(
          leading: Icon(Icons.stream),
          title: Text('Stream'),
        ),
        ListTile(
          leading: Icon(Icons.create),
          title: Text('Generate Media'),
        ),
        ListTile(
          leading: Icon(Icons.build),
          title: Text('Build'),
        ),
        ListTile(
          leading: Icon(Icons.history),
          title: Text('History'),
        ),
      ],
    );
  }
}
