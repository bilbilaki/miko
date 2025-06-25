import 'package:flutter/material.dart';

class ToolbarWidget extends StatelessWidget {
  final String selectedLanguage;
  final String selectedTheme;
  final List<String> languages;
  final List<String> themes;
  final bool isRunning;
  final Function(String) onLanguageChanged;
  final Function(String) onThemeChanged;
  final VoidCallback onRun;
  final VoidCallback onDuplicate;
  final VoidCallback onFindReplace;
  final VoidCallback onToggleFileExplorer;
  final VoidCallback onToggleTerminal;

  const ToolbarWidget({
    super.key,
    required this.selectedLanguage,
    required this.selectedTheme,
    required this.languages,
    required this.themes,
    required this.isRunning,
    required this.onLanguageChanged,
    required this.onThemeChanged,
    required this.onRun,
    required this.onDuplicate,
    required this.onFindReplace,
    required this.onToggleFileExplorer,
    required this.onToggleTerminal,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = selectedTheme == 'Dark';
    
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF3C3C3C) : const Color(0xFFF3F3F3),
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xFF3E3E42) : const Color(0xFFE0E0E0),
          ),
        ),
      ),
      child: Row(
        children: [
          // Language Selector
          _buildDropdown(
            value: selectedLanguage,
            items: languages,
            onChanged: onLanguageChanged,
            icon: Icons.code,
            isDark: isDark,
          ),
          
          const SizedBox(width: 8),
          
          // Theme Selector
          _buildDropdown(
            value: selectedTheme,
            items: themes,
            onChanged: onThemeChanged,
            icon: Icons.palette,
            isDark: isDark,
          ),
          
          const SizedBox(width: 16),
          
          // Separator
          Container(
            width: 1,
            height: 30,
            color: isDark ? const Color(0xFF3E3E42) : const Color(0xFFE0E0E0),
          ),
          
          const SizedBox(width: 16),
          
          // Action Buttons
          _buildToolbarButton(
            icon: isRunning ? Icons.stop : Icons.play_arrow,
            label: isRunning ? 'Stop' : 'Run',
            onPressed: onRun,
            color: isRunning ? Colors.red : Colors.green,
            isDark: isDark,
          ),
          
          const SizedBox(width: 8),
          
          _buildToolbarButton(
            icon: Icons.content_copy,
            label: 'Duplicate',
            onPressed: onDuplicate,
            isDark: isDark,
          ),
          
          const SizedBox(width: 8),
          
          _buildToolbarButton(
            icon: Icons.find_replace,
            label: 'Find/Replace',
            onPressed: onFindReplace,
            isDark: isDark,
          ),
          
          const SizedBox(width: 8),
          
          _buildToolbarButton(
            icon: Icons.save,
            label: 'Save',
            onPressed: () {},
            isDark: isDark,
          ),
          
          const SizedBox(width: 8),
          
          _buildToolbarButton(
            icon: Icons.undo,
            label: 'Undo',
            onPressed: () {},
            isDark: isDark,
          ),
          
          const SizedBox(width: 8),
          
          _buildToolbarButton(
            icon: Icons.redo,
            label: 'Redo',
            onPressed: () {},
            isDark: isDark,
          ),
          
          const Spacer(),
          
          // View Toggle Buttons
          _buildToolbarButton(
            icon: Icons.folder_open,
            label: 'Explorer',
            onPressed: onToggleFileExplorer,
            isDark: isDark,
          ),
          
          const SizedBox(width: 8),
          
          _buildToolbarButton(
            icon: Icons.terminal,
            label: 'Terminal',
            onPressed: onToggleTerminal,
            isDark: isDark,
          ),
          
          const SizedBox(width: 8),
          
          _buildToolbarButton(
            icon: Icons.bug_report,
            label: 'Debug',
            onPressed: () {},
            isDark: isDark,
          ),
          
          const SizedBox(width: 8),
          
          _buildToolbarButton(
            icon: Icons.extension,
            label: 'Extensions',
            onPressed: () {},
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required Function(String) onChanged,
    required IconData icon,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2D30) : Colors.white,
        border: Border.all(
          color: isDark ? const Color(0xFF3E3E42) : const Color(0xFFE0E0E0),
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
          const SizedBox(width: 4),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 14,
              ),
              dropdownColor: isDark ? const Color(0xFF2D2D30) : Colors.white,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
              items: items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbarButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    Color? color,
    required bool isDark,
  }) {
    return Tooltip(
      message: label,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            icon,
            size: 20,
            color: color ?? (isDark ? Colors.white70 : Colors.black54),
          ),
        ),
      ),
    );
  }
}