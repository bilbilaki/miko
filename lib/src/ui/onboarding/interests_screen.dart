import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:miko/src/providers/onboarding_provider.dart';

class InterestsScreen extends ConsumerStatefulWidget {
  const InterestsScreen({super.key, required this.onFinish});
  final VoidCallback onFinish;

  @override
  ConsumerState<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends ConsumerState<InterestsScreen> {
  final List<String> all = [
    'Action','Drama','Comedy','Ecchi','Adventure','Mecha','Romance','Science','Music','School','Seinen','Shoujo','Fantasy','Mystery','Vampire','Isekai','Shounen','Television','Superheroes','Magic','Game','Slice of Life'
  ];

  final Set<String> selected = {};

  @override
  void initState() {
    super.initState();
    // optionally load saved interests
    Future.microtask(() async {
      final controller = ref.read(onboardingControllerProvider);
      final saved = await controller.loadInterests();
      if (saved != null) setState(() => selected.addAll(saved));
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPhone = ResponsiveBreakpoints.of(context).isMobile;
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.white)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isPhone ? double.infinity : 720),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Choose Your Interest', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text("Choose your interests and get the best anime recommendations. Don't worry, you can always change it later.", style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: all.map((t) {
                          final isSel = selected.contains(t);
                          return ChoiceChip(
                            label: Text(t, style: TextStyle(color: isSel ? Colors.black : Colors.green)),
                            selected: isSel,
                            onSelected: (v) => setState(() => v ? selected.add(t) : selected.remove(t)),
                            backgroundColor: Colors.transparent,
                            selectedColor: Colors.green,
                            side: const BorderSide(color: Colors.green),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white10),
                            backgroundColor: Colors.grey[800],
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () async {
                            final controller = ref.read(onboardingControllerProvider);
                            await controller.markSeen();
                            widget.onFinish();
                          },
                          child: const Text('Skip', style: TextStyle(color: Colors.white70)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(vertical: 16)),
                          onPressed: () async {
                            final controller = ref.read(onboardingControllerProvider);
                            await controller.saveInterests(selected.toList());
                            await controller.markSeen();
                            widget.onFinish();
                          },
                          child: const Text('Continue'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}