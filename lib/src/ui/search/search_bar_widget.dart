// TODO Implement this library.
import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController controller;
  final String hintText;
  final VoidCallback onFilterTap;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final bool autofocus;

  const SearchBarWidget({
    super.key,
    required this.controller,
    this.hintText = 'Abcdefghijklm',
    required this.onFilterTap,
    this.onChanged,
    this.onClear,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        height: 50, // Fixed height for the search bar
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            const Icon(Icons.search, color: Colors.white70),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: controller,
                autofocus: autofocus,
                onChanged: onChanged,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero, // Remove default padding
                ),
              ),
            ),
            if (controller.text.isNotEmpty && onClear != null)
              IconButton(
                icon: const Icon(Icons.clear, color: Colors.white70),
                onPressed: onClear,
              ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              width: 2,
              color: Colors.white12,
            ),
            IconButton(
              icon: const Icon(Icons.tune, color: Color(0xFF1ED760)), // Filter icon
              onPressed: onFilterTap,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(66.0); // Including padding
}