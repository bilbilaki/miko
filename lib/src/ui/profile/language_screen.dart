import 'package:flutter/material.dart';
import 'package:miko/src/ui/widgets/language_radio_tile.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selectedLanguage = 'English (US)'; // Default selected language

  final List<String> _suggestedLanguages = [
    'English (US)',
    'English (UK)',
  ];

  final List<String> _otherLanguages = [
    'Mandarin',
    'Hindi',
    'Spanish',
    'French',
    'Arabic',
    'Bengali',
    'Russian',
    'Indonesian',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F10),
      appBar: AppBar(
        title: const Text('Language'),
        backgroundColor: const Color(0xFF0D0F10),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: Text(
              'Suggested',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ..._suggestedLanguages.map(
            (lang) => LanguageRadioTile(
              title: lang,
              value: lang,
              groupValue: _selectedLanguage,
              onChanged: (value) => setState(() => _selectedLanguage = value!),
            ),
          ),
          const Divider(indent: 16, endIndent: 16, color: Colors.white10),
          const Padding(
            padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
            child: Text(
              'Language',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ..._otherLanguages.map(
            (lang) => LanguageRadioTile(
              title: lang,
              value: lang,
              groupValue: _selectedLanguage,
              onChanged: (value) => setState(() => _selectedLanguage = value!),
            ),
          ),
        ],
      ),
    );
  }
}