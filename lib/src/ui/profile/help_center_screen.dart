import 'package:flutter/material.dart';
import 'package:miko/src/ui/search/search_bar_widget.dart'; // Reusing search bar
import 'package:miko/src/ui/widgets/faq_item.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _currentSearchQuery = '';
  String _selectedFaqCategory = 'General';

  final List<String> _faqCategories = ['General', 'Account', 'Service', 'Video'];

  final List<Map<String, String>> _allFaqs = [
    {
      'category': 'General',
      'question': 'What is Animax?',
      'answer': 'Animax is a streaming service that offers a wide variety of anime titles, from classic series to the latest releases. You can watch anytime, anywhere, on any device.'
    },
    {
      'category': 'Account',
      'question': 'How to remove anime on wishlist?',
      'answer': 'To remove an anime from your wishlist, go to "My List", find the anime, and tap the remove icon or option.'
    },
    {
      'category': 'Service',
      'question': 'How do I subscribe to premium?',
      'answer': 'You can subscribe to Animax Premium through the "Join Premium!" section on your Profile screen, or by visiting our website.'
    },
    {
      'category': 'Video',
      'question': 'How do I can download anime?',
      'answer': 'To download anime, navigate to the anime\'s detail page, tap the "Download" button, select episodes and quality, then confirm.'
    },
    {
      'category': 'Service',
      'question': 'How to unsubscribe from premium?',
      'answer': 'You can unsubscribe from premium by going to your "Profile", then "Subscription" settings, and following the instructions there.'
    },
    {
      'category': 'Account',
      'question': 'Can I change my email address?',
      'answer': 'Yes, you can change your email address by going to "Edit Profile" in your profile settings.'
    },
    {
      'category': 'Video',
      'question': 'What video qualities are available?',
      'answer': 'We offer various video qualities including 480p, 720p, and 1080p, depending on your subscription and device capabilities.'
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, String>> get _filteredFaqs {
    return _allFaqs.where((faq) {
      final matchesCategory = _selectedFaqCategory == 'All' || faq['category'] == _selectedFaqCategory;
      final matchesQuery = _currentSearchQuery.isEmpty ||
          (faq['question']?.toLowerCase().contains(_currentSearchQuery.toLowerCase()) ?? false) ||
          (faq['answer']?.toLowerCase().contains(_currentSearchQuery.toLowerCase()) ?? false);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  void _onSearchQueryChanged(String query) {
    setState(() {
      _currentSearchQuery = query;
    });
  }

  // void _onKeyPress(String key) {
  //   _searchController.text += key.toLowerCase();
  //   _onSearchQueryChanged(_searchController.text);
  // }

  // void _onDelete() {
  //   if (_searchController.text.isNotEmpty) {
  //     _searchController.text = _searchController.text.substring(0, _searchController.text.length - 1);
  //     _onSearchQueryChanged(_searchController.text);
  //   }
  // }

  // void _onSpace() {
  //   _searchController.text += ' ';
  //   _onSearchQueryChanged(_searchController.text);
  // }

  // void _onShift() {
  //   // Not implemented for this keyboard
  //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Shift key not implemented on this keyboard')));
  // }

  // void _onNumbers() {
  //   // Not implemented for this keyboard
  //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Numbers key not implemented on this keyboard')));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F10),
      appBar: AppBar(
        title: const Text('Help Center'),
        centerTitle: true,
        backgroundColor: const Color(0xFF0D0F10),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.white),
            onPressed: () {
              // TODO: More options for Help Center
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).colorScheme.primary,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'FAQ'),
            Tab(text: 'Contact us'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFaqTab(),
                _buildContactUsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqTab() {
    final filteredFaqs = _filteredFaqs;
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: _faqCategories.map((category) {
              final isSelected = category == _selectedFaqCategory;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedFaqCategory = category;
                      });
                    }
                  },
                  selectedColor: Theme.of(context).colorScheme.primary,
                  backgroundColor: Colors.grey.shade800,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.black : Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade700,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        SearchBarWidget(
          controller: _searchController,
          onChanged: _onSearchQueryChanged,
          onClear: () {
            _searchController.clear();
            _onSearchQueryChanged('');
          },
          onFilterTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Filter not implemented for FAQ search')),
            );
          },
          hintText: 'Search',
          autofocus: false, // Prevents keyboard from popping up immediately
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: filteredFaqs.length,
            itemBuilder: (context, index) {
              final faq = filteredFaqs[index];
              return FaqItem(
                question: faq['question']!,
                answer: faq['answer']!,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildContactUsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Need more help?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Contact us directly and we will get back to you as soon as possible.',
            style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
          ),
          const SizedBox(height: 24),
          TextFormField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Your Name',
              filled: true,
              fillColor: Colors.grey.shade900,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'Your Email',
              filled: true,
              fillColor: Colors.grey.shade900,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            style: const TextStyle(color: Colors.white),
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Your Message',
              filled: true,
              fillColor: Colors.grey.shade900,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Message sent! (Placeholder)')),
                );
                // TODO: Implement sending the message
              },
              child: const Text('Send Message'),
            ),
          ),
        ],
      ),
    );
  }
}