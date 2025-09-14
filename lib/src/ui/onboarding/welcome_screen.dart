import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class WelcomeOnboardingScreen extends StatefulWidget {
  const WelcomeOnboardingScreen({super.key, required this.onFinished});
  final VoidCallback onFinished;

  @override
  State<WelcomeOnboardingScreen> createState() => _WelcomeOnboardingScreenState();
}

class _WelcomeOnboardingScreenState extends State<WelcomeOnboardingScreen> {
  final PageController _pc = PageController();
  int _page = 0;

  final List<Map<String, String>> slides = [
    {
      'image': 'https://4kwallpapers.com/images/wallpapers/inosuke-hashibira-1080x1920-22580.png',
      'title': 'Welcome to Animax',
      'subtitle': 'The best streaming anime app of the century to entertain you every day'
    },
    {
      'image': 'https://wallpapers.com/images/hd/moon-inosuke-pfp-22udefacpi4u85yq.jpg',
      'title': 'Discover New Shows',
      'subtitle': 'Personalized recommendations and curated collections'
    },
    {
      'image': 'https://c4.wallpaperflare.com/wallpaper/443/271/794/anime-demon-slayer-kimetsu-no-yaiba-inosuke-hashibira-tanjirou-kamado-zenitsu-agatsuma-hd-wallpaper-preview.jpg',
      'title': 'Watch Anywhere',
      'subtitle': 'Seamless playback across devices'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isPhone = ResponsiveBreakpoints.of(context).isMobile;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pc,
            itemCount: slides.length,
            onPageChanged: (p) => setState(() => _page = p),
            itemBuilder: (context, index) {
              final item = slides[index];
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(item['image']!, fit: BoxFit.cover),
                  Container(color: Colors.black.withOpacity(0.45)),
                  Positioned(
                    left: 24,
                    right: 24,
                    bottom: isPhone ? 80 + bottomPadding : 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['title']!, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 12),
                        Text(item['subtitle']!, style: const TextStyle(fontSize: 16, color: Colors.white70)),
                      ],
                    ),
                  )
                ],
              );
            },
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: isPhone ? 24 : 40,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(slides.length, (i) {
                  final selected = i == _page;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 240),
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: selected ? 36 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: selected ? Colors.greenAccent[400] : Colors.white24,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                })),
                const SizedBox(height: 12),
                SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                      minimumSize: const Size.fromHeight(48),
                    ),
                    onPressed: () {
                      if (_page < slides.length - 1) {
                        _pc.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                      } else {
                        widget.onFinished();
                      }
                    },
                    child: Text(_page < slides.length - 1 ? 'Next' : 'Get Started', style: const TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}