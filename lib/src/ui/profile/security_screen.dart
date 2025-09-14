import 'package:flutter/material.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool _faceIdEnabled = false;
  bool _rememberMeEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F10),
      appBar: AppBar(
        title: const Text('Security'),
        backgroundColor: const Color(0xFF0D0F10),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        children: [
          _buildOptionTile(
            title: 'Face ID',
            subtitle: 'Enable Face ID for faster login',
            trailing: Switch(
              value: _faceIdEnabled,
              onChanged: (value) {
                setState(() {
                  _faceIdEnabled = value;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Face ID ${value ? 'enabled' : 'disabled'}')),
                );
              },
              activeColor: Theme.of(context).colorScheme.primary,
            ),
          ),
          _buildOptionTile(
            title: 'Remember Me',
            subtitle: 'Keep me logged in',
            trailing: Switch(
              value: _rememberMeEnabled,
              onChanged: (value) {
                setState(() {
                  _rememberMeEnabled = value;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Remember Me ${value ? 'enabled' : 'disabled'}')),
                );
              },
              activeColor: Theme.of(context).colorScheme.primary,
            ),
          ),
          _buildOptionTile(
            title: 'Change Password',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Navigate to Change Password screen')),
              );
            },
          ),
          _buildOptionTile(
            title: 'Change PIN',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Navigate to Change PIN screen')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing else const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
          ],
        ),
      ),
    );
  }
}