import 'dart:core'; // Ensure core types are available

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For clipboard functionality


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Extract Examples',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ExtractionExamplesScreen(),
    );
  }
}

class ExtractionExamplesScreen extends StatelessWidget {
  const ExtractionExamplesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Extract All The Things!'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          MethodCard(
            title: 'Phone Numbers',
            description: 'Extracts phone numbers from the provided text using regular expressions.',
            exampleText: 'Contact us at +1234567890 or 123-456-7890. My friend\'s number is 555-123-4567.',
            methodCall: Extract.phoneNumbers,
            outputDescription: 'Extracted phone numbers:',
          ),
          MethodCard(
            title: 'URLs',
            description: 'Extracts URLs from the provided text using regular expressions.',
            exampleText: 'Explore more at http://www.example.org and https://another-example.com/page?id=123. Also visit example.net.',
            methodCall: Extract.urls,
            outputDescription: 'Extracted URLs:',
          ),
          MethodCard(
            title: 'All Dates',
            description: 'Extracts various common date formats from the provided text.',
            exampleText: 'Meeting scheduled for 31-Dec-2023 or 01.15.2024. Event on 12/31/2023. Project deadline Jan 31, 2025.',
            methodCall: Extract.allDates,
            outputDescription: 'Extracted dates:',
          ),
          SpecificWordsMethodCard(),
          MethodCard(
            title: 'Addresses',
            description: 'Extracts addresses from the provided text using a regular expression pattern.',
            exampleText: 'My home is at 123 Pine St, City, State 12345. Office at 567 Elm Road, Smalltown, CA 90210.',
            methodCall: Extract.addresses,
            outputDescription: 'Extracted addresses:',
          ),
          NumericValuesMethodCard(),
          HashtagsMentionsMethodCard(),
          FilePathsMethodCard(),
          SpecialCharactersMethodCard(),
          KeywordsPhrasesMethodCard(),
          SentencesParagraphsMethodCard(),
          MethodCard(
            title: 'Acronyms/Abbreviations',
            description: 'Extracts acronyms or abbreviations (sequences of uppercase letters) from the provided text.',
            exampleText: 'The NASA is an acronym for National Aeronautics and Space Administration. UNO is also a known organization.',
            methodCall: Extract.acronymsAbbreviations,
            outputDescription: 'Extracted acronyms/abbreviations:',
          ),
          MethodCard(
            title: 'SSNs',
            description: 'Extracts Social Security Numbers (SSNs) in the format `###-##-####` from the provided text.',
            exampleText: 'The document contains SSNs like 123-45-6789 and 987-65-4321, but not 123456789 (missing hyphens).',
            methodCall: Extract.ssns,
            outputDescription: 'Extracted SSNs:',
          ),
          MethodCard(
            title: 'IP Addresses',
            description: 'Extracts IP addresses (IPv4) from the given text.',
            exampleText: 'The text includes IPs like 192.168.0.1 and 10.0.0.1. Invalid IP: 999.999.999.999.',
            methodCall: Extract.iPAddresses,
            outputDescription: 'Extracted IP addresses:',
          ),
          MethodCard(
            title: 'Credit Card Numbers',
            description: 'Extracts potential credit card numbers (13-16 digits, with or without spaces/dashes).',
            exampleText: 'The text contains credit card numbers like 4111-1111-1111-1111 or 5123 4567 8910 1234. Maybe 1234567890123.',
            methodCall: Extract.creditCardNumbers,
            outputDescription: 'Extracted credit card numbers:',
          ),
          CodeSnippetsMethodCard(),
          MethodCard(
            title: 'Units of Measurement',
            description: 'Identifies and extracts various units of measurement from a given text (e.g., "5 kg", "10 meters").',
            exampleText: 'The parcel weighs about 5 kg and is 10 meters long. Temp: 25°C. Volume: 1.5 L.',
            methodCall: Extract.unitsOfMeasurement,
            outputDescription: 'Extracted units of measurement:',
          ),
          MethodCard(
            title: 'Product Codes/IDs',
            description: 'Identifies and extracts product codes or IDs (alphanumeric strings, 6+ chars).',
            exampleText: 'The product code is ABC123XYZ456. Another one is PCODE789.',
            methodCall: Extract.productCodesIDs,
            outputDescription: 'Extracted product codes/IDs:',
          ),
          MethodCard(
            title: 'Sentiment Keywords',
            description: 'Identifies specific sentiment-related keywords from a given text (e.g., good, bad, excellent, poor).',
            exampleText: 'The product was excellent, but the service was poor. It was a good experience, not terrible.',
            methodCall: Extract.sentimentKeywords,
            outputDescription: 'Extracted sentiment keywords:',
          ),
          MethodCard(
            title: 'Time',
            description: 'Extracts time-related patterns from the provided text (HH:MM or HH:MM:SS).',
            exampleText: 'The meeting is scheduled at 14:30. Please arrive on time. Lunch is at 12:00:00.',
            methodCall: Extract.time,
            outputDescription: 'Extracted times:',
          ),
          MethodCard(
            title: 'Company Names',
            description: 'Extracts potential company names based on capitalization and common suffixes.',
            exampleText: 'The meeting is with Acme Corporation and XYZ Enterprises. Also, Apple Inc. and Google LLC.',
            methodCall: Extract.companyNames,
            outputDescription: 'Extracted company names:',
          ),
          MethodCard(
            title: 'Job Titles',
            description: 'Extracts potential job titles from the provided text (common hardcoded titles).',
            exampleText: 'The team consists of a Software Engineer, Project Manager, and Designer. Also a Data Scientist.',
            methodCall: Extract.jobTitles,
            outputDescription: 'Extracted job titles:',
          ),
          MethodCard(
            title: 'VINs',
            description: 'Extracts Vehicle Identification Numbers (VINs) (17 alphanumeric chars, excluding I, O, Q).',
            exampleText: 'The VINs for the cars are ABCDEFG123456789 and XYZ9876543210HJK. Invalid: 123I4567890123456.',
            methodCall: Extract.vins,
            outputDescription: 'Extracted VINs:',
          ),
          MethodCard(
            title: 'Twitter Handles',
            description: 'Extracts potential Twitter handles (starts with @).',
            exampleText: 'Contact us via @example_handle or follow @the_twitter! Not a handle: @@bad.',
            methodCall: Extract.twitterHandles,
            outputDescription: 'Extracted Twitter handles:',
          ),
          MethodCard(
            title: 'YouTube Video IDs',
            description: 'Extracts potential YouTube video IDs (11 alphanumeric chars) from URLs.',
            exampleText: 'Check out this video: https://youtu.be/abcdefghijk and https://www.youtube.com/watch?v=lmnopqrstuv. Invalid: https://youtu.be/short.',
            methodCall: Extract.youTubeVideoIDs,
            outputDescription: 'Extracted YouTube Video IDs:',
          ),
          MethodCard(
            title: 'ISBNs',
            description: 'Extracts potential ISBNs (10-digit and 13-digit formats).',
            exampleText: 'The ISBNs in the text are ISBN-13: 978-1-56619-909-4 and ISBN-10: 0-306-40615-2. Another: 978-0321765723.',
            methodCall: Extract.isbns,
            outputDescription: 'Extracted ISBNs:',
          ),
          MethodCard(
            title: 'HTML Tags & Attributes',
            description: 'Extracts HTML tags with their attributes and content.',
            exampleText: '<p class="example">This is a paragraph.</p><div><span>Hello</span></div><img src="img.jpg" alt="Image">',
            methodCall: Extract.htmlTagsAttributes,
            outputDescription: 'Extracted HTML tags:',
          ),
          MethodCard(
            title: 'Hex Color Codes',
            description: 'Extracts hexadecimal color codes (e.g., #FF0000, #ABC).',
            exampleText: 'The colors used are #FF0000 (red) and #00FF00 (green). Also #ABC. Not a color: #1234.',
            methodCall: Extract.hexColorCodes,
            outputDescription: 'Extracted Hex Color Codes:',
          ),
          MethodCard(
            title: 'Statistical Data',
            description: 'Identifies specific statistical terms (e.g., mean, median, mode, range).',
            exampleText: 'The mean and median values were calculated for the dataset. Also, mode and range are important.',
            methodCall: Extract.statisticalData,
            outputDescription: 'Extracted Statistical Data:',
          ),
          TwitterFacebookPostIDsCard(),
          MethodCard(
            title: 'Employee IDs',
            description: 'Extracts potential employee identification codes (alphanumeric, 5+ characters).',
            exampleText: 'The employee IDs are E12345, A987654, and X56789. Also EMPID001 and ID-007.',
            methodCall: Extract.employeeIDs,
            outputDescription: 'Extracted Employee IDs:',
          ),
          MethodCard(
            title: 'Bank Account Numbers',
            description: 'Extracts potential bank account numbers (9 to 18 digits).',
            exampleText: 'Please verify account numbers: 123456789 and 9876543210. Another is 123456789012. Not: 12345.',
            methodCall: Extract.bankAccountNumbers,
            outputDescription: 'Extracted Bank Account Numbers:',
          ),
          MethodCard(
            title: 'API Endpoints',
            description: 'Extracts potential API endpoints (starts with / followed by alphanumeric/hyphen/underscore).',
            exampleText: 'The API endpoints are /users/get and /posts/all. Other: /api/v1/data-fetch.',
            methodCall: Extract.apiEndpoints,
            outputDescription: 'Extracted API Endpoints:',
          ),
          MethodCard(
            title: 'OS Paths',
            description: 'Extracts potential operating system paths (Windows style, e.g., C:\\...).',
            exampleText: 'The file paths are C:\\Users\\User\\Documents\\file.txt and D:\\Folder\\image.jpg. Not: /home/user.',
            methodCall: Extract.osPaths,
            outputDescription: 'Extracted OS Paths:',
          ),
          TwitterFacebookPostContentCard(), // Note will be added in UI that it extracts IDs as per doc example
          MethodCard(
            title: 'Software Version Numbers',
            description: 'Extracts potential software version numbers (digits separated by periods).',
            exampleText: 'The software versions are 1.0, 2.3.4, and 5.6.7.8. Also v1.0.0-beta and Release 2023.11.',
            methodCall: Extract.softwareVersionNumbers,
            outputDescription: 'Extracted Software Version Numbers:',
          ),
          MethodCard(
            title: 'Ordinal Numbers',
            description: 'Extracts ordinal numbers (e.g., first, second, third, 1st, 2nd, 3rd).',
            exampleText: 'The first, second, and third positions are important. Also 1st, 22nd, 103rd, 4th place.',
            methodCall: Extract.ordinalNumbers,
            outputDescription: 'Extracted Ordinal Numbers:',
          ),
          MethodCard(
            title: 'Meta Tags',
            description: 'Extracts HTML meta tags from the provided text.',
            exampleText: '<meta charset="UTF-8"><meta name="description" content="Sample description"><meta property="og:title" content="My Page">',
            methodCall: Extract.metaTags,
            outputDescription: 'Extracted Meta Tags:',
          ),
          MethodCard(
            title: 'Stock Ticker Symbols',
            description: 'Extracts potential stock ticker symbols (2 to 5 uppercase letters).',
            exampleText: 'The stock symbols mentioned are AAPL, GOOGL, and TSLA. Also MSFT and AMZN. Not LONGCODE.',
            methodCall: Extract.stockTickerSymbols,
            outputDescription: 'Extracted Stock Ticker Symbols:',
          ),
          MethodCard(
            title: 'Hash Values',
            description: 'Extracts potential hash values (32, 40, or 64 hex characters).',
            exampleText: 'The hash values found are A1B2C3D4E5F6A7B8C9D0E1F2A3B4C5D6 (MD5), F00BAARF00BAARF00BAARF00BAARF00BAAR (SHA-1), and FF00112233445566778899AABBCCDDEEFF00112233445566778899AABBCCDDEEFF (SHA-256).',
            methodCall: Extract.hashValues,
            outputDescription: 'Extracted Hash Values:',
          ),
          MethodCard(
            title: 'Chemical Compound Names',
            description: 'Extracts potential chemical compound names (capitalized words, possibly multi-word).',
            exampleText: 'The chemical compounds include Water, Oxygen, and Hydrochloric acid. Also, Sodium Chloride and Carbon Dioxide.',
            methodCall: Extract.chemicalCompoundNames,
            outputDescription: 'Extracted Chemical Compound Names:',
          ),
          MethodCard(
            title: 'MIME Types',
            description: 'Extracts potential MIME types (e.g., text/plain, image/jpeg).',
            exampleText: 'The MIME types detected are text/plain, image/jpeg, and application/json. Also audio/mp3 and video/mp4.',
            methodCall: Extract.mimeTypes,
            outputDescription: 'Extracted MIME Types:',
          ),
          MethodCard(
            title: 'HTTP Status Codes',
            description: 'Extracts potential HTTP status codes (three consecutive digits).',
            exampleText: 'The HTTP status codes returned were 200, 404, and 500. Not a code: 12.',
            methodCall: Extract.httpStatusCodes,
            outputDescription: 'Extracted HTTP Status Codes:',
          ),
          MethodCard(
            title: 'Coordinates',
            description: 'Extracts potential geographical coordinates (latitude and longitude).',
            exampleText: 'The coordinates found were 40.7128° N, 74.0060° W and -33.8688° S, 151.2093° E. Simple: 10.123, -20.456.',
            methodCall: Extract.coordinates,
            outputDescription: 'Extracted Coordinates:',
          ),
          ExtractProgrammingKeywordsCard(),
        ],
      ),
    );
  }
}

/// A generic Flutter Card widget for methods that primarily take a single String input.
class MethodCard extends StatefulWidget {
  final String title;
  final String description;
  final String exampleText;
  final Function methodCall; // The Extract static method to call
  final String outputDescription;

  const MethodCard({
    super.key,
    required this.title,
    required this.description,
    required this.exampleText,
    required this.methodCall,
    required this.outputDescription,
  });

  @override
  State<MethodCard> createState() => _MethodCardState();
}

class _MethodCardState extends State<MethodCard> {
  final TextEditingController _textController = TextEditingController();
  List<String> _results = [];

  @override
  void initState() {
    super.initState();
    _textController.text = widget.exampleText;
  }

  void _extract() {
    setState(() {
      _results = widget.methodCall(_textController.text);
    });
  }

  void _saveResults() {
    if (_results.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _results.join('\n')));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Results copied to clipboard!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No results to copy.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8.0),
            Text(widget.description),
            const SizedBox(height: 16.0),
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Input Text',
                hintText: 'Enter text here...',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _textController.clear(),
                ),
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _extract,
                  child: const Text('Extract'),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy Results'),
                  onPressed: _saveResults,
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Text(
              widget.outputDescription,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4.0),
              ),
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 50, maxHeight: 200),
              child: SingleChildScrollView(
                child: Text(
                  _results.isEmpty ? 'No results yet.' : _results.join('\n'),
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Text('Number of examples: ${_results.length}'),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}

/// Specialized MethodCard for `specificWords` with a 'word' input.
class SpecificWordsMethodCard extends StatefulWidget {
  const SpecificWordsMethodCard({super.key});

  @override
  State<SpecificWordsMethodCard> createState() => _SpecificWordsMethodCardState();
}

class _SpecificWordsMethodCardState extends State<SpecificWordsMethodCard> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _wordController = TextEditingController();
  List<String> _results = [];

  @override
  void initState() {
    super.initState();
    _textController.text = 'The term "apple" refers to a fruit named apple. Apple is red.';
    _wordController.text = 'apple';
  }

  void _extract() {
    setState(() {
      _results = Extract.specificWords(_textController.text, _wordController.text);
    });
  }

  void _saveResults() {
    if (_results.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _results.join('\n')));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Results copied to clipboard!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No results to copy.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Specific Words',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8.0),
            const Text('Extracts occurrences of a specific word from the provided text (case-insensitive).'),
            const SizedBox(height: 16.0),
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Input Text',
                hintText: 'Enter text here...',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _textController.clear(),
                ),
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _wordController,
              decoration: InputDecoration(
                labelText: 'Word to Extract',
                hintText: 'e.g., apple',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _wordController.clear(),
                ),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _extract,
                  child: const Text('Extract'),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy Results'),
                  onPressed: _saveResults,
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Text(
              'Extracted words:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4.0),
              ),
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 50, maxHeight: 200),
              child: SingleChildScrollView(
                child: Text(
                  _results.isEmpty ? 'No results yet.' : _results.join('\n'),
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Text('Number of examples: ${_results.length}'),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _wordController.dispose();
    super.dispose();
  }
}

/// Specialized MethodCard for `numericValues` with an 'includeDecimals' checkbox.
class NumericValuesMethodCard extends StatefulWidget {
  const NumericValuesMethodCard({super.key});

  @override
  State<NumericValuesMethodCard> createState() => _NumericValuesMethodCardState();
}

class _NumericValuesMethodCardState extends State<NumericValuesMethodCard> {
  final TextEditingController _textController = TextEditingController();
  List<String> _results = [];
  bool _includeDecimals = false;

  @override
  void initState() {
    super.initState();
    _textController.text = 'The product cost is \$50.99, and the count is 100. Sales tax is 0.07.';
  }

  void _extract() {
    setState(() {
      _results = Extract.numericValues(_textController.text, includeDecimals: _includeDecimals);
    });
  }

  void _saveResults() {
    if (_results.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _results.join('\n')));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Results copied to clipboard!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No results to copy.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Numeric Values',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8.0),
            const Text('Extracts numeric values from text, with an option to include decimals.'),
            const SizedBox(height: 16.0),
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Input Text',
                hintText: 'Enter text here...',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _textController.clear(),
                ),
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Checkbox(
                  value: _includeDecimals,
                  onChanged: (bool? value) {
                    setState(() {
                      _includeDecimals = value!;
                    });
                  },
                ),
                const Text('Include Decimals'),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _extract,
                  child: const Text('Extract'),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy Results'),
                  onPressed: _saveResults,
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Text(
              'Extracted numeric values:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4.0),
              ),
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 50, maxHeight: 200),
              child: SingleChildScrollView(
                child: Text(
                  _results.isEmpty ? 'No results yet.' : _results.join('\n'),
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Text('Number of examples: ${_results.length}'),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}

/// Specialized MethodCard for `hashtagsMentions` with an 'includeMentions' checkbox.
class HashtagsMentionsMethodCard extends StatefulWidget {
  const HashtagsMentionsMethodCard({super.key});

  @override
  State<HashtagsMentionsMethodCard> createState() => _HashtagsMentionsMethodCardState();
}

class _HashtagsMentionsMethodCardState extends State<HashtagsMentionsMethodCard> {
  final TextEditingController _textController = TextEditingController();
  List<String> _results = [];
  bool _includeMentions = true;

  @override
  void initState() {
    super.initState();
    _textController.text = 'This is a #hashtag and a @mention in a sentence. Another #flutter and @dash.';
  }

  void _extract() {
    setState(() {
      _results = Extract.hashtagsMentions(_textController.text, includeMentions: _includeMentions);
    });
  }

  void _saveResults() {
    if (_results.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _results.join('\n')));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Results copied to clipboard!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No results to copy.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hashtags & Mentions',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8.0),
            const Text('Extracts hashtags and optionally mentions from the provided text.'),
            const SizedBox(height: 16.0),
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Input Text',
                hintText: 'Enter text here...',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _textController.clear(),
                ),
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Checkbox(
                  value: _includeMentions,
                  onChanged: (bool? value) {
                    setState(() {
                      _includeMentions = value!;
                    });
                  },
                ),
                const Text('Include Mentions'),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _extract,
                  child: const Text('Extract'),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy Results'),
                  onPressed: _saveResults,
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Text(
              'Extracted items:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4.0),
              ),
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 50, maxHeight: 200),
              child: SingleChildScrollView(
                child: Text(
                  _results.isEmpty ? 'No results yet.' : _results.join('\n'),
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Text('Number of examples: ${_results.length}'),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}

/// Specialized MethodCard for `filePaths` with a 'separator' dropdown.
class FilePathsMethodCard extends StatefulWidget {
  const FilePathsMethodCard({super.key});

  @override
  State<FilePathsMethodCard> createState() => _FilePathsMethodCardState();
}

class _FilePathsMethodCardState extends State<FilePathsMethodCard> {
  final TextEditingController _textController = TextEditingController();
  List<String> _results = [];
  String _separator = '/'; // Default separator

  @override
  void initState() {
    super.initState();
    _textController.text = 'The file paths are /path/to/file1.txt and /directory/path/file2.jpg. Also C:\\Users\\Doc\\data.csv.';
  }

  void _extract() {
    setState(() {
      _results = Extract.filePaths(_textController.text, separator: _separator);
    });
  }

  void _saveResults() {
    if (_results.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _results.join('\n')));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Results copied to clipboard!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No results to copy.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'File Paths',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8.0),
            const Text('Extracts file paths from text based on a specified separator.'),
            const SizedBox(height: 16.0),
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Input Text',
                hintText: 'Enter text here...',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _textController.clear(),
                ),
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _separator,
                    decoration: const InputDecoration(
                      labelText: 'Path Separator',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: '/', child: Text('Forward Slash (/)')),
                      DropdownMenuItem(value: '\\', child: Text('Backslash (\\)')),
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        _separator = newValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _extract,
                  child: const Text('Extract'),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy Results'),
                  onPressed: _saveResults,
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Text(
              'Extracted file paths:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4.0),
              ),
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 50, maxHeight: 200),
              child: SingleChildScrollView(
                child: Text(
                  _results.isEmpty ? 'No results yet.' : _results.join('\n'),
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Text('Number of examples: ${_results.length}'),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}

/// Specialized MethodCard for `specialCharacters` with a 'characterSet' input.
class SpecialCharactersMethodCard extends StatefulWidget {
  const SpecialCharactersMethodCard({super.key});

  @override
  State<SpecialCharactersMethodCard> createState() => _SpecialCharactersMethodCardState();
}

class _SpecialCharactersMethodCardState extends State<SpecialCharactersMethodCard> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _charSetController = TextEditingController();
  List<String> _results = [];

  @override
  void initState() {
    super.initState();
    _textController.text = 'The @# text! *& contains specific characters #%^ with numbers 123.';
    _charSetController.text = r'[^\w\s]'; // Default: any non-word, non-whitespace char
  }

  void _extract() {
    setState(() {
      _results = Extract.specialCharacters(_textController.text, characterSet: _charSetController.text);
    });
  }

  void _saveResults() {
    if (_results.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _results.join('\n')));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Results copied to clipboard!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No results to copy.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Special Characters',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8.0),
            const Text('Extracts special characters from text based on a regular expression character set.'),
            const SizedBox(height: 16.0),
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Input Text',
                hintText: 'Enter text here...',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _textController.clear(),
                ),
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _charSetController,
              decoration: InputDecoration(
                labelText: 'Character Set Regex',
                hintText: r'e.g., [^\w\s] for all special characters',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _charSetController.clear(),
                ),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _extract,
                  child: const Text('Extract'),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy Results'),
                  onPressed: _saveResults,
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Text(
              'Extracted characters:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4.0),
              ),
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 50, maxHeight: 200),
              child: SingleChildScrollView(
                child: Text(
                  _results.isEmpty ? 'No results yet.' : _results.join('\n'),
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Text('Number of examples: ${_results.length}'),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _charSetController.dispose();
    super.dispose();
  }
}

/// Specialized MethodCard for `keywordsPhrases` with a 'keyword' input and 'caseSensitive' checkbox.
class KeywordsPhrasesMethodCard extends StatefulWidget {
  const KeywordsPhrasesMethodCard({super.key});

  @override
  State<KeywordsPhrasesMethodCard> createState() => _KeywordsPhrasesMethodCardState();
}

class _KeywordsPhrasesMethodCardState extends State<KeywordsPhrasesMethodCard> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _keywordController = TextEditingController();
  List<String> _results = [];
  bool _caseSensitive = false;

  @override
  void initState() {
    super.initState();
    _textController.text = 'The quick brown fox jumps over the lazy dog. THE keyword is important.';
    _keywordController.text = 'the';
  }

  void _extract() {
    setState(() {
      _results = Extract.keywordsPhrases(_textController.text, _keywordController.text, caseSensitive: _caseSensitive);
    });
  }

  void _saveResults() {
    if (_results.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _results.join('\n')));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Results copied to clipboard!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No results to copy.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Keywords/Phrases',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8.0),
            const Text('Extracts occurrences of a specific keyword or phrase, with case sensitivity option.'),
            const SizedBox(height: 16.0),
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Input Text',
                hintText: 'Enter text here...',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _textController.clear(),
                ),
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _keywordController,
              decoration: InputDecoration(
                labelText: 'Keyword/Phrase to Extract',
                hintText: 'e.g., the',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _keywordController.clear(),
                ),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Checkbox(
                  value: _caseSensitive,
                  onChanged: (bool? value) {
                    setState(() {
                      _caseSensitive = value!;
                    });
                  },
                ),
                const Text('Case Sensitive'),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _extract,
                  child: const Text('Extract'),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy Results'),
                  onPressed: _saveResults,
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Text(
              'Extracted items:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4.0),
              ),
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 50, maxHeight: 200),
              child: SingleChildScrollView(
                child: Text(
                  _results.isEmpty ? 'No results yet.' : _results.join('\n'),
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Text('Number of examples: ${_results.length}'),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _keywordController.dispose();
    super.dispose();
  }
}

/// Specialized MethodCard for `sentencesParagraphs` with a 'separator' dropdown.
class SentencesParagraphsMethodCard extends StatefulWidget {
  const SentencesParagraphsMethodCard({super.key});

  @override
  State<SentencesParagraphsMethodCard> createState() => _SentencesParagraphsMethodCardState();
}

class _SentencesParagraphsMethodCardState extends State<SentencesParagraphsMethodCard> {
  final TextEditingController _textController = TextEditingController();
  List<String> _results = [];
  String _separator = '.'; // Default for sentences

  @override
  void initState() {
    super.initState();
    _textController.text = 'This is a sample text. It contains multiple sentences. This is a new paragraph.\nAnother paragraph starts here.';
  }

  void _extract() {
    setState(() {
      _results = Extract.sentencesParagraphs(_textController.text, separator: _separator);
    });
  }

  void _saveResults() {
    if (_results.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _results.join('\n')));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Results copied to clipboard!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No results to copy.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sentences/Paragraphs',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8.0),
            const Text('Extracts sentences or paragraphs based on a specified separator.'),
            const SizedBox(height: 16.0),
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Input Text',
                hintText: 'Enter text here...',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _textController.clear(),
                ),
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _separator,
                    decoration: const InputDecoration(
                      labelText: 'Separator',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: '.', child: Text('Period (.) for Sentences')),
                      DropdownMenuItem(value: '\n', child: Text('Newline (\\n) for Paragraphs')),
                      DropdownMenuItem(value: '!', child: Text('Exclamation Mark (!)')),
                      DropdownMenuItem(value: '?', child: Text('Question Mark (?)')),
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        _separator = newValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _extract,
                  child: const Text('Extract'),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy Results'),
                  onPressed: _saveResults,
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Text(
              'Extracted items:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4.0),
              ),
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 50, maxHeight: 200),
              child: SingleChildScrollView(
                child: Text(
                  _results.isEmpty ? 'No results yet.' : _results.join('\n'),
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Text('Number of examples: ${_results.length}'),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}

/// Specialized MethodCard for `codeSnippets` with a 'language' dropdown.
class CodeSnippetsMethodCard extends StatefulWidget {
  const CodeSnippetsMethodCard({super.key});

  @override
  State<CodeSnippetsMethodCard> createState() => _CodeSnippetsMethodCardState();
}

class _CodeSnippetsMethodCardState extends State<CodeSnippetsMethodCard> {
  final TextEditingController _textController = TextEditingController();
  List<String> _results = [];
  String _language = ''; // Default to empty string for all languages

  @override
  void initState() {
    super.initState();
    _textController.text = '''Here is a Dart code snippet:
```dart
void main() {
  print("Hello, world!");
}
```
And a Python one:
```python
print("Hello from Python!")
```
Some generic code:
```
var x = 10;
```
''';
  }

  void _extract() {
    setState(() {
      _results = Extract.codeSnippets(_textController.text, language: _language);
    });
  }

  void _saveResults() {
    if (_results.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _results.join('\n\n--- Code Snippet ---\n\n'))); // Special separator for clarity
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Results copied to clipboard!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No results to copy.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Code Snippets',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8.0),
            const Text('Extracts code blocks enclosed in triple backticks, optionally filtered by language.'),
            const SizedBox(height: 16.0),
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Input Text',
                hintText: 'Enter text here...',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _textController.clear(),
                ),
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _language.isEmpty ? null : _language,
                    decoration: const InputDecoration(
                      labelText: 'Programming Language (optional)',
                      hintText: 'Select a language or leave blank for all',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: '', child: Text('All Languages')),
                      DropdownMenuItem(value: 'dart', child: Text('Dart')),
                      DropdownMenuItem(value: 'python', child: Text('Python')),
                      DropdownMenuItem(value: 'java', child: Text('Java')),
                      DropdownMenuItem(value: 'javascript', child: Text('JavaScript')),
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        _language = newValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _extract,
                  child: const Text('Extract'),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy Results'),
                  onPressed: _saveResults,
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Text(
              'Extracted code snippets:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4.0),
              ),
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 50, maxHeight: 200),
              child: SingleChildScrollView(
                child: Text(
                  _results.isEmpty ? 'No results yet.' : _results.join('\n\n--- Code Snippet ---\n\n'),
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Text('Number of examples: ${_results.length}'),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}

/// Specialized MethodCard for `twiiterAndFacebookPostIDs` with a 'platform' dropdown.
class TwitterFacebookPostIDsCard extends StatefulWidget {
  const TwitterFacebookPostIDsCard({super.key});

  @override
  State<TwitterFacebookPostIDsCard> createState() => _TwitterFacebookPostIDsCardState();
}

class _TwitterFacebookPostIDsCardState extends State<TwitterFacebookPostIDsCard> {
  final TextEditingController _textController = TextEditingController();
  List<String> _results = [];
  String _platform = 'Twitter'; // Default platform

  @override
  void initState() {
    super.initState();
    _textController.text = 'Check out this Twitter post: https://twitter.com/user/status/1234567890. And a Facebook post: https://www.facebook.com/user/posts/9876543210. Invalid URL: https://example.com/status/123.';
  }

  void _extract() {
    setState(() {
      _results = Extract.twiiterAndFacebookPostIDs(_textController.text, _platform);
    });
  }

  void _saveResults() {
    if (_results.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _results.join('\n')));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Results copied to clipboard!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No results to copy.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Twitter/Facebook Post IDs',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8.0),
            const Text('Extracts post IDs from Twitter or Facebook URLs based on the specified platform.'),
            const SizedBox(height: 16.0),
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Input Text',
                hintText: 'Enter text here...',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _textController.clear(),
                ),
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _platform,
                    decoration: const InputDecoration(
                      labelText: 'Platform',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Twitter', child: Text('Twitter')),
                      DropdownMenuItem(value: 'Facebook', child: Text('Facebook')),
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        _platform = newValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _extract,
                  child: const Text('Extract'),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy Results'),
                  onPressed: _saveResults,
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Text(
              'Extracted Post IDs:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4.0),
              ),
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 50, maxHeight: 200),
              child: SingleChildScrollView(
                child: Text(
                  _results.isEmpty ? 'No results yet.' : _results.join('\n'),
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Text('Number of examples: ${_results.length}'),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}

/// Specialized MethodCard for `twitterAndFacebookPostContent` which *as per documentation example* extracts IDs.
class TwitterFacebookPostContentCard extends StatefulWidget {
  const TwitterFacebookPostContentCard({super.key});

  @override
  State<TwitterFacebookPostContentCard> createState() => _TwitterFacebookPostContentCardState();
}

class _TwitterFacebookPostContentCardState extends State<TwitterFacebookPostContentCard> {
  final TextEditingController _textController = TextEditingController();
  List<String> _results = [];
  String _platform = 'Twitter'; // Default platform

  @override
  void initState() {
    super.initState();
    _textController.text = 'Twitter post with ID 1234567890: This is actual tweet content. Facebook post with ID 9876543210: This is some lengthy facebook post content.';
  }

  void _extract() {
    setState(() {
      // As noted, the documentation's example for this method extracts "IDs" not "content".
      // If the intent was truly content extraction, a more advanced (and likely external) NLP library would be needed.
      // Sticking to the example provided, which appears to re-use the ID extraction.
      _results = Extract.twitterAndFacebookPostContent(_textController.text, _platform);
    });
  }

  void _saveResults() {
    if (_results.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _results.join('\n')));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Results copied to clipboard!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No results to copy.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Twitter/Facebook Post Content (Note: Example extracts IDs)',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8.0),
            const Text('Note: The documentation example for `twitterAndFacebookPostContent` extracts IDs, not actual post content. This UI follows that example.'),
            const SizedBox(height: 16.0),
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Input Text',
                hintText: 'Enter text here...',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _textController.clear(),
                ),
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _platform,
                    decoration: const InputDecoration(
                      labelText: 'Platform',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Twitter', child: Text('Twitter')),
                      DropdownMenuItem(value: 'Facebook', child: Text('Facebook')),
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        _platform = newValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _extract,
                  child: const Text('Extract'),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy Results'),
                  onPressed: _saveResults,
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Text(
              'Extracted Post IDs (as per example in docs):',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4.0),
              ),
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 50, maxHeight: 200),
              child: SingleChildScrollView(
                child: Text(
                  _results.isEmpty ? 'No results yet.' : _results.join('\n'),
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Text('Number of examples: ${_results.length}'),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}

/// Specialized MethodCard for `extractProgrammingKeywords` with a 'language' dropdown.
class ExtractProgrammingKeywordsCard extends StatefulWidget {
  const ExtractProgrammingKeywordsCard({super.key});

  @override
  State<ExtractProgrammingKeywordsCard> createState() => _ExtractProgrammingKeywordsCardState();
}

class _ExtractProgrammingKeywordsCardState extends State<ExtractProgrammingKeywordsCard> {
  final TextEditingController _textController = TextEditingController();
  List<String> _results = [];
  String _language = 'Dart'; // Default Language for keywords

  @override
  void initState() {
    super.initState();
    _textController.text = 'The code snippet contains keywords like abstract, dynamic, and if. A class is defined with a new variable.';
  }

  void _extract() {
    setState(() {
      _results = Extract.extractProgrammingKeywords(_textController.text, _language);
    });
  }

  void _saveResults() {
    if (_results.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _results.join('\n')));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Results copied to clipboard!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No results to copy.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Extract Programming Keywords',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8.0),
            const Text('Extracts programming keywords from text based on a specified programming language.'),
            const SizedBox(height: 16.0),
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Input Text (Code Snippet)',
                hintText: 'Enter code or text here...',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _textController.clear(),
                ),
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _language,
                    decoration: const InputDecoration(
                      labelText: 'Programming Language',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Dart', child: Text('Dart')),
                      DropdownMenuItem(value: 'Python', child: Text('Python')),
                      DropdownMenuItem(value: 'Java', child: Text('Java')),
                      DropdownMenuItem(value: 'JavaScript', child: Text('JavaScript')),
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        _language = newValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _extract,
                  child: const Text('Extract'),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy Results'),
                  onPressed: _saveResults,
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Text(
              'Extracted Keywords:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4.0),
              ),
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 50, maxHeight: 200),
              child: SingleChildScrollView(
                child: Text(
                  _results.isEmpty ? 'No results yet.' : _results.join('\n'),
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Text('Number of examples: ${_results.length}'),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
/// A mock implementation of the Extract class, providing static methods
/// for various text extraction tasks using regular expressions.
///
/// This class simulates the functionality described in the provided
/// documentation for demonstration purposes in a Flutter UI.
class Extract {
  /// Extracts phone numbers from the provided [text].
  ///
  /// Example: `+1234567890`, `123-456-7890`, `(123) 456-7890`.
  static List<String> phoneNumbers(String text) {
    RegExp regExp = RegExp(
      r'\+\d{1,3}\s?\d{3}-\d{3}-\d{4}|\b\d{3}[-.\s]?\d{3}[-.\s]?\d{4}\b',
    );
    return regExp.allMatches(text).map((m) => m.group(0)!).toList();
  }

  /// Extracts URLs from the provided [text].
  ///
  /// Matches URLs starting with `http://` or `https://`.
  static List<String> urls(String text) {
    RegExp regExp = RegExp(
      r'https?:\/\/(?:www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b(?:[-a-zA-Z0-9()@:%_\+.~#?&//=]*)',
      caseSensitive: false,
    );
    return regExp.allMatches(text).map((m) => m.group(0)!).toList();
  }

  /// Extracts various date formats from the provided [text].
  ///
  /// Example patterns: `DD/MM/YYYY`, `Jan 31, 2023`, `2023-12-31`, `31-Dec-2023`.
  static List<String> allDates(String text) {
    final List<RegExp> datePatterns = [
      RegExp(r'\b\d{1,2}\/\d{1,2}\/\d{2,4}\b'), // MM/DD/YY or MM/DD/YYYY
      RegExp(r'\b\d{1,2}-\d{1,2}-\d{2,4}\b'), // MM-DD-YY or MM-DD-YYYY
      RegExp(r'\b\d{4}-\d{1,2}-\d{1,2}\b'), // YYYY-MM-DD
      RegExp(r'\b\d{1,2}\.\d{1,2}\.\d{2,4}\b'), // DD.MM.YY or DD.MM.YYYY
      RegExp(r'\b(?:Jan(?:uary)?|Feb(?:ruary)?|Mar(?:ch)?|Apr(?:il)?|May|Jun(?:e)?|Jul(?:y)?|Aug(?:ust)?|Sep(?:tember)?|Oct(?:ober)?|Nov(?:ember)?|Dec(?:ember)?)\s+\d{1,2},\s+\d{4}\b', caseSensitive: false), // Month DD, YYYY
      RegExp(r'\b\d{1,2}-(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)-\d{2,4}\b', caseSensitive: false), // DD-Mon-YY or DD-Mon-YYYY
    ];
    Set<String> extractedDates = {};
    for (var pattern in datePatterns) {
      pattern.allMatches(text).forEach((match) {
        extractedDates.add(match.group(0)!);
      });
    }
    return extractedDates.toList();
  }

  /// Extracts occurrences of a specific [word] from the [text].
  ///
  /// The search is case-insensitive and matches whole words.
  static List<String> specificWords(String text, String word) {
    if (word.isEmpty) return [];
    RegExp regExp = RegExp(r'\b' + RegExp.escape(word) + r'\b', caseSensitive: false);
    return regExp.allMatches(text).map((m) => m.group(0)!).toList();
  }

  /// Extracts addresses from the provided [text].
  ///
  /// This regex is a simplistic heuristic for common address patterns.
  /// A robust address parser would be significantly more complex.
  static List<String> addresses(String text) {
    // This regex attempts to find patterns like "Number StreetName, City, State ZIP"
    // It's a placeholder and won't be comprehensive for all address formats.
    RegExp regExp = RegExp(
      r'\b\d{1,5}\s(?:[A-Z][a-z]+\s?){1,3}(?:Street|St|Road|Rd|Avenue|Ave|Boulevard|Blvd|Lane|Ln|Drive|Dr|Court|Ct|Place|Pl|Square|Sq|Terrace|Tr|Way|Wy|Circle|Cir)\b(?:,?\s(?:Apt|Apartment|Unit|Suite)\s\w+)?(?:,?\s[A-Za-z\s]+,?\s[A-Z]{2}\s\d{5}(?:-\d{4})?)?\b',
      caseSensitive: false,
    );
    return regExp.allMatches(text).map((m) => m.group(0)!).toList();
  }

  /// Extracts numeric values from the provided [text].
  ///
  /// If [includeDecimals] is true, decimal numbers are also included.
  static List<String> numericValues(String text, {bool includeDecimals = false}) {
    RegExp regExp;
    if (includeDecimals) {
      regExp = RegExp(r'\b\d+(\.\d+)?\b');
    } else {
      regExp = RegExp(r'\b\d+\b');
    }
    return regExp.allMatches(text).map((m) => m.group(0)!).toList();
  }

  /// Extracts hashtags and optionally mentions from the provided [text].
  ///
  /// If [includeMentions] is true, both hashtags (`#word`) and mentions (`@user`) are extracted.
  static List<String> hashtagsMentions(String text, {bool includeMentions = true}) {
    List<String> extracted = [];
    RegExp hashtagRegExp = RegExp(r'#\w+');
    extracted.addAll(hashtagRegExp.allMatches(text).map((m) => m.group(0)!));
    if (includeMentions) {
      RegExp mentionRegExp = RegExp(r'@\w+');
      extracted.addAll(mentionRegExp.allMatches(text).map((m) => m.group(0)!));
    }
    return extracted;
  }

  /// Extracts file paths from the provided [text] based on the [separator].
  ///
  /// Supports both forward slash (`/`) and backslash (`\`) separators.
  static List<String> filePaths(String text, {String separator = '/'}) {
    RegExp regExp;
    if (separator == '/') {
      regExp = RegExp(r'(?:\/(?:[a-zA-Z0-9_\-.]+|\s)+)+[a-zA-Z0-9_\-.]*');
    } else if (separator == '\\') {
      regExp = RegExp(r'(?:[A-Za-z]:\\|\\)((?:[a-zA-Z0-9_\-\.]+|\s)+[a-zA-Z0-9_\-.]*)');
    } else {
      // General purpose for custom separators, less robust for complex paths
      regExp = RegExp(r'(?:' + RegExp.escape(separator) + r'(?:[a-zA-Z0-9_\-.]+|\s)+)+[a-zA-Z0-9_\-.]*');
    }
    return regExp.allMatches(text).map((m) => m.group(0)!).toList();
  }

  /// Extracts special characters from the provided [text] based on a [characterSet] regex.
  ///
  /// Default [characterSet] `r'[^\w\s]'` extracts any non-word, non-whitespace character.
  static List<String> specialCharacters(String text, {String characterSet = r'[^\w\s]'}) {
    RegExp regExp = RegExp(characterSet);
    return regExp.allMatches(text).map((m) => m.group(0)!).toList();
  }

  /// Extracts occurrences of a specific [keyword] or phrase from the [text].
  ///
  /// Can be configured for [caseSensitive] or case-insensitive search.
  static List<String> keywordsPhrases(String text, String keyword, {bool caseSensitive = false}) {
    if (keyword.isEmpty) return [];
    RegExp regExp = RegExp(r'\b' + RegExp.escape(keyword) + r'\b', caseSensitive: caseSensitive);
    return regExp.allMatches(text).map((m) => m.group(0)!).toList();
  }

  /// Extracts sentences or paragraphs from the given [text] using a [separator].
  ///
  /// Default [separator] is `.` for sentences. Use `\n` for paragraphs.
  static List<String> sentencesParagraphs(String text, {String separator = '.'}) {
    if (separator == '\n') {
      return text
          .split(RegExp(r'\n(?=\S)')) // Split by newline only if followed by non-whitespace (new paragraph)
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
    } else {
      return text
          .split(RegExp(RegExp.escape(separator) + r'\s*')) // Split by separator and any following whitespace
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
    }
  }

  /// Extracts acronyms or abbreviations (sequences of two or more uppercase letters).
  static List<String> acronymsAbbreviations(String text) {
    RegExp regExp = RegExp(r'\b[A-Z]{2,}\b');
    return regExp.allMatches(text).map((m) => m.group(0)!).toList();
  }

  /// Extracts Social Security Numbers (SSNs) in the format `###-##-####`.
  static List<String> ssns(String text) {
    RegExp regExp = RegExp(r'\b\d{3}-\d{2}-\d{4}\b');
    return regExp.allMatches(text).map((m) => m.group(0)!).toList();
  }

  /// Extracts IPv4 addresses in the format `###.###.###.###`.
  static List<String> iPAddresses(String text) {
    RegExp regExp = RegExp(r'\b(?:\d{1,3}\.){3}\d{1,3}\b');
    return regExp.allMatches(text).map((m) => m.group(0)!).toList();
  }

  /// Extracts potential credit card numbers (13 to 16 digits, optionally separated by spaces or dashes).
  static List<String> creditCardNumbers(String text) {
    RegExp regExp = RegExp(r'\b(?:\d[ -]*?){13,16}\b');
    return regExp.allMatches(text).map((m) => m.group(0)!).toList();
  }

  /// Extracts code snippets enclosed in triple backticks (```).
  ///
  /// Can be filtered by a specific [language] tag (e.g., `dart`, `python`).
  static List<String> codeSnippets(String text, {String language = ''}) {
    List<String> snippets = [];
    RegExp regExp;
    if (language.isEmpty) {
      regExp = RegExp(r'```(?:\w+)?\n([\s\S]*?)\n```');
    } else {
      regExp = RegExp('```${RegExp.escape(language)}\n([\\s\\S]*?)\n```');
    }
    regExp.allMatches(text).forEach((match) {
      if (match.group(1) != null) {
        snippets.add(match.group(1)!);
      }
    });
    return snippets;
  }

  /// Extracts various units of measurement (e.g., "5 kg", "10 meters", "20°C").
  static List<String> unitsOfMeasurement(String text) {
    RegExp regExp = RegExp(r'\b\d+(?:\.\d+)?\s*(?:mm|cm|m|km|in|ft|yd|mi|g|kg|mg|ton|lb|oz|ml|l|gal|qt|pt|cup|fl\.oz|tsp|tbsp|°C|°F|K|mph|kmh|hz|khz|mhz|ghz)\b', caseSensitive: false);
    return regExp.allMatches(text).map((m) => m.group(0)!).toList();
  }

  /// Extracts product codes or IDs (alphanumeric strings, typically 6 or more characters).
  static List<String> productCodesIDs(String text) {
    RegExp regExp = RegExp(r'\b[A-Z0-9]{6,}\b');
    return regExp.allMatches(text).map((m) => m.group(0)!).toList();
  }

  /// Extracts specific sentiment-related keywords (e.g., "good," "bad," "excellent").
  static List<String> sentimentKeywords(String text) {
    RegExp regExp = RegExp(r'\b(?:good|bad|excellent|poor|great|awesome|terrible|amazing|horrible|positive|negative|superb|dreadful)\b', caseSensitive: false);
    return regExp.allMatches(text).map((m) => m.group(0)!).toList();
  }

  /// Extracts time patterns in 24-hour format (HH:MM or HH:MM:SS).
  static List<String> time(String text) {
    RegExp regExp = RegExp(r'\b(?:[01]?\d|2[0-3]):[0-5]\d(?::[0-5]\d)?\b');
    return regExp.allMatches(text).map((m) => m.group(0)!).toList();
  }

  /// Extracts potential company names based on capitalization and common suffixes.
  ///
  /// This is a heuristic and will not be exhaustive.
  static List<String> companyNames(String text) {
    RegExp regExp = RegExp(
      r'\b(?:[A-Z][a-z]+(?: [A-Z][a-z]+)*(?: Corporation|Corp|Inc|Company|Co|LLC|Ltd|Group|Holdings|Solutions|Technologies|Systems|Labs|Ventures|Associates|Partners|Global|International|Digital|Soft))\b',
    );
    return regExp.allMatches(text).map((m) => m.group(0)!).toList();
  }

  /// Extracts potential job titles from the provided text using a list of common titles.
  ///
  /// This implementation uses a hardcoded list of common job titles.
  static List<String> jobTitles(String text) {
    final List<String> commonTitles = [
      'Software Engineer',
      'Project Manager',
      'Designer',
      'Data Scientist',
      'Marketing Manager',
      'Accountant',
      'Human Resources',
      'Analyst',
      'Developer',
      'Manager',
      'Director',
      'CEO',
      'CTO',
      'CFO',
    ];
    RegExp regExp = RegExp(r'\b(?:' + commonTitles.map(RegExp.escape).join('|') + r')\b', caseSensitive: false);
    return regExp.allMatches(text).map((m) => m.group(0)!).toList();
  }

  /// Extracts Vehicle Identification Numbers (VINs) (17 alphanumeric characters, excluding I, O, Q).
  static List<String> vins(String text) {
    RegExp regExp = RegExp(r'\b(?![IOQioq])[A-HJ-NP-Z0-9]{17}\b');
    return regExp.allMatches(text).map((m) => m.group(0)!).toList();
  }

  /// Extracts potential Twitter handles (starts with `@` followed by alphanumeric characters or underscores).
  static List<String> twitterHandles(String text) {
    RegExp regExp = RegExp(r'@\w{1,15}\b');
    return regExp.allMatches(text).map((m) => m.group(0)!).toList();
  }

  /// Extracts potential YouTube video IDs (11 alphanumeric characters) from various YouTube URL formats.
  static List<String> youTubeVideoIDs(String text) {
    RegExp regExp = RegExp(r'(?:youtube\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})');
    return regExp.allMatches(text).map((m) => m.group(1)!).toList();
  }

  /// Extracts potential International Standard Book Numbers (ISBNs) (10-digit and 13-digit formats).
  static List<String> isbns(String text) {
    RegExp regExp = RegExp(
      r'\b(?:ISBN(?:-13)?:?\s*(?:97[89][ -]?)(?:\d[ -]?){9}[\dX])|\b(?:ISBN(?:-10)?:?\s*(?:\d[ -]?){9}[\dX])\b',
      caseSensitive: false,
    );
    return regExp.allMatches(text).map((m) => m.group(0)!).toList();
  }

  /// Extracts HTML tags along with their attributes and content.
  ///
  /// This is a basic regex and may not handle all complex or malformed HTML.
  static List<String> htmlTagsAttributes(String text) {
    RegExp regExp = RegExp(r'<[^>]+>|<\/[^>]+>|<[^>]*?>', caseSensitive: false);
    return regExp.allMatches(text).map((m) => m.group(0)!).toList();
  }

  /// Extracts hexadecimal color codes (e.g., `#FF0000`, `#ABC`).
  static List<String> hexColorCodes(String text) {
    RegExp regExp = RegExp(r'#([0-9a-fA-F]{3}|[0-9a-fA-F]{6})\b');
    return regExp.allMatches(text).map((m) => m.group(0)!).toList();
  }

  /// Identifies specific statistical terms (e.g., 'mean', 'median', 'mode', 'range').
  static List<String> statisticalData(String text) {
    RegExp regExp = RegExp(r'\b(?:mean|median|mode|range|variance|standard deviation|std dev)\b', caseSensitive: false);
    return regExp.allMatches(text).map((m) => m.group(0)!).toList();
  }

  /// Extracts post IDs from either Twitter or Facebook URLs based on the [platform].
  static List<String> twiiterAndFacebookPostIDs(String text, String platform) {
    RegExp regExp;
    if (platform.toLowerCase() == 'twitter') {
      regExp = RegExp(r'twitter\.com\/\w+\/status\/(\d+)');
    } else if (platform.toLowerCase() == 'facebook') {
      regExp = RegExp(r'facebook\.com\/\w+\/posts\/(\d+)');
    } else {
      return [];
    }
    return regExp.allMatches(text).map((m) => m.group(1)!).where((id) => id != null).toList();
  }

  /// Extracts potential employee identification codes (alphanumeric, typically 5 or more characters long).
  static List<String> employeeIDs(String text) {
    RegExp regExp = RegExp(r'\b[A-Za-z]{1,4}\d{4,9}\b|\b\d{5,10}\b'); // e.g., E12345, A987654. Also pure digits.
    return regExp.allMatches(text).map((m) => m.group(0)!).toList();
  }

  /// Extracts potential bank account numbers (typically 9 to 18 digits long).
  static List<String> bankAccountNumbers(String text) {
    RegExp regExp = RegExp(r'\b\d{9,18}\b');
    return regExp.allMatches(text).map((m) => m.group(0)!).toList();
  }

  /// Extracts potential API endpoints (starts with `/` followed by alphanumeric characters, hyphens, and underscores).
  static List<String> apiEndpoints(String text) {
    RegExp regExp = RegExp(r'\/(?:[a-zA-Z0-9_\-]+\/?)+');
    return regExp.allMatches(text).map((m) => m.group(0)!).toList();
  }

  /// Extracts potential operating system paths (Windows style: `C:\path\to\file.txt`).
  static List<String> osPaths(String text) {
    RegExp regExp = RegExp(r'\b[A-Za-z]:\\(?:[^\\/:*?"<>|\r\n]+\\)*[^\\/:*?"<>|\r\n]*\b');
    return regExp.allMatches(text).map((m) => m.group(0)!).toList();
  }

  /// Extracts content (IDs as per doc example) related to Twitter or Facebook posts based on [platform].
  ///
  /// NOTE: The provided documentation example for this method extracts **IDs**, not actual post content.
  /// This implementation reflects that, reusing the ID extraction logic.
  /// True content extraction would require more advanced natural language processing.
  static List<String> twitterAndFacebookPostContent(String text, String platform) {
    // As per the provided documentation's example, this extracts post IDs.
    // If actual *content* were desired, a more complex (and perhaps NLP-based) approach would be needed.
    // We are adhering to the explicit example provided that returns ['1234567890'].
    return twiiterAndFacebookPostIDs(text, platform);
  }

  /// Extracts potential software version numbers (digits separated by periods, e.g., `1.0`, `2.3.4`).
  static List<String> softwareVersionNumbers(String text) {
    RegExp regExp = RegExp(r'\b\d+(?:\.\d+)+\b');
    return regExp.allMatches(text).map((m) => m.group(0)!).toList();
  }

  /// Extracts ordinal numbers (e.g., `1st`, `2nd`, `third`, `first`).
  static List<String> ordinalNumbers(String text) {
    RegExp regExp = RegExp(r'\b(?:\d+(?:st|nd|rd|th)|first|second|third|fourth|fifth|sixth|seventh|eighth|ninth|tenth|eleventh|twelfth)\b', caseSensitive: false);
    return regExp.allMatches(text).map((m) => m.group(0)!).toList();
  }

  /// Extracts HTML meta tags (e.g., `<meta charset="UTF-8">`).
  static List<String> metaTags(String text) {
    RegExp regExp = RegExp(r'<meta\s+[^>]*\/?>', caseSensitive: false);
    return regExp.allMatches(text).map((m) => m.group(0)!).toList();
  }

  /// Extracts potential stock ticker symbols (2 to 5 uppercase letters).
  static List<String> stockTickerSymbols(String text) {
    RegExp regExp = RegExp(r'\b[A-Z]{2,5}\b');
    return regExp.allMatches(text).map((m) => m.group(0)!).toList();
  }

  /// Extracts potential hash values (MD5, SHA-1, SHA-256) based on their typical hexadecimal lengths.
  static List<String> hashValues(String text) {
    RegExp regExp = RegExp(r'\b[0-9a-fA-F]{32}\b|\b[0-9a-fA-F]{40}\b|\b[0-9a-fA-F]{64}\b');
    return regExp.allMatches(text).map((m) => m.group(0)!).toList();
  }

  /// Extracts potential chemical compound names (capitalized words, possibly multi-word).
  ///
  /// This is a simplistic heuristic; proper chemical name recognition is complex.
  static List<String> chemicalCompoundNames(String text) {
    RegExp regExp = RegExp(r'\b[A-Z][a-z]+(?:\s[A-Z]?[a-z]+)*\b');
    return regExp.allMatches(text).map((m) => m.group(0)!).toList();
  }

  /// Extracts potential MIME types (e.g., `text/plain`, `image/jpeg`).
  static List<String> mimeTypes(String text) {
    RegExp regExp = RegExp(r'\b[a-zA-Z0-9_\-]+/[a-zA-Z0-9_\-]+\b', caseSensitive: false);
    return regExp.allMatches(text).map((m) => m.group(0)!).toList();
  }

  /// Extracts potential HTTP status codes (three consecutive digits).
  static List<String> httpStatusCodes(String text) {
    RegExp regExp = RegExp(r'\b\d{3}\b');
    return regExp.allMatches(text).map((m) => m.group(0)!).toList();
  }

  /// Extracts potential geographical coordinates (latitude and longitude values).
  static List<String> coordinates(String text) {
    RegExp regExp = RegExp(
      r'-?\d{1,3}(?:\.\d+)?(?:°\s*[NnSsEeWw])?[,\s]+-?\d{1,3}(?:\.\d+)?(?:°\s*[NnSsEeWw])?',
    );
    return regExp.allMatches(text).map((m) => m.group(0)!).toList();
  }

  /// Extracts programming keywords from the provided [text] based on the specified [language].
  ///
  /// Supports a predefined list of keywords for 'Dart', 'Java', 'Python', 'JavaScript'.
  static List<String> extractProgrammingKeywords(String text, String language) {
    final Map<String, List<String>> keywordList = {
      'dart': [
        'abstract', 'as', 'assert', 'async', 'await', 'break', 'case', 'catch', 'class',
        'const', 'continue', 'covariant', 'default', 'deferred', 'do', 'dynamic', 'else',
        'enum', 'export', 'extends', 'extension', 'external', 'factory', 'false', 'final',
        'finally', 'for', 'function', 'get', 'hide', 'if', 'implements', 'import', 'in',
        'interface', 'is', 'late', 'library', 'mixin', 'new', 'null', 'on', 'operator',
        'part', 'required', 'rethrow', 'return', 'set', 'show', 'static', 'super', 'switch',
        'sync', 'this', 'throw', 'true', 'try', 'typedef', 'var', 'void', 'when', 'while',
        'with', 'yield'
      ],
      'java': ['abstract', 'continue', 'for', 'new', 'switch', 'assert', 'default', 'goto', 'package', 'synchronized', 'boolean', 'do', 'if', 'private', 'this', 'break', 'double', 'implements', 'protected', 'throw', 'byte', 'else', 'import', 'public', 'throws', 'case', 'enum', 'instanceof', 'return', 'transient', 'catch', 'extends', 'int', 'short', 'try', 'char', 'final', 'interface', 'static', 'void', 'class', 'finally', 'long', 'strictfp', 'volatile', 'const', 'float', 'native', 'super', 'while'],
      'python': ['False', 'None', 'True', 'and', 'as', 'assert', 'async', 'await', 'break', 'class', 'continue', 'def', 'del', 'elif', 'else', 'except', 'finally', 'for', 'from', 'global', 'if', 'import', 'in', 'is', 'lambda', 'nonlocal', 'not', 'or', 'pass', 'raise', 'return', 'try', 'while', 'with', 'yield'],
      'javascript': ['abstract', 'arguments', 'await', 'boolean', 'break', 'byte', 'case', 'catch', 'char', 'class', 'const', 'continue', 'debugger', 'default', 'delete', 'do', 'double', 'else', 'enum', 'eval', 'export', 'extends', 'false', 'final', 'finally', 'float', 'for', 'function', 'goto', 'if', 'implements', 'import', 'in', 'instanceof', 'int', 'interface', 'let', 'long', 'native', 'new', 'null', 'package', 'private', 'protected', 'public', 'return', 'short', 'static', 'super', 'switch', 'synchronized', 'this', 'throw', 'throws', 'transient', 'true', 'try', 'typeof', 'var', 'void', 'volatile', 'while', 'with', 'yield'],
    };

    List<String> keywords = keywordList[language.toLowerCase()] ?? [];
    if (keywords.isEmpty) return [];

    List<String> foundKeywords = [];
    for (String keyword in keywords) {
      RegExp regExp = RegExp(r'\b' + RegExp.escape(keyword) + r'\b', caseSensitive: false);
      regExp.allMatches(text).forEach((match) {
        foundKeywords.add(match.group(0)!);
      });
    }
    return foundKeywords;
  }
}