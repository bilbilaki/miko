import 'package:flutter/material.dart';

class ShareBottomSheet extends StatelessWidget {
  const ShareBottomSheet({super.key});

  Widget _buildShareOption(
    BuildContext context,
    String label,
    IconData icon,
    Color iconColor,
  ) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            // TODO: Implement actual sharing logic for each app
            Navigator.of(context).pop(); // Close bottom sheet
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Share to $label tapped')));
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade800.withOpacity(0.6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: iconColor, size: 36),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade700,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Share to',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            mainAxisSpacing: 20,
            crossAxisSpacing: 10,
            children: [
              _buildShareOption(
                context,
                'WhatsApp',
                Icons.message,
                Colors.green,
              ),
              _buildShareOption(
                context,
                'Twitter',
                Icons.telegram,
                Colors.blue,
              ), // Using telegram as placeholder for Twitter bird icon
              _buildShareOption(
                context,
                'Facebook',
                Icons.facebook,
                Colors.blue.shade800,
              ),
              _buildShareOption(
                context,
                'Instagram',
                Icons.camera_alt,
                Colors.pink,
              ), // Placeholder for Instagram icon
              _buildShareOption(
                context,
                'Yahoo',
                Icons.mail,
                Colors.purple,
              ), // Using mail for Yahoo
              _buildShareOption(
                context,
                'Chat',
                Icons.chat_bubble,
                Colors.lightGreen,
              ),
              _buildShareOption(
                context,
                'WeChat',
                Icons.wechat,
                Colors.green.shade600,
              ),
              _buildShareOption(
                context,
                'TikTok',
                Icons.tiktok,
                Colors.black,
              ), // Placeholder for TikTok
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
