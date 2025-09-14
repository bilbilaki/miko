import 'package:flutter/material.dart';
import 'package:miko/src/ui/widgets/download_episode_card.dart';
import 'dart:async'; // For Timer

class DownloadBottomSheet extends StatefulWidget {
  final List<Map<String, String>> episodes;
  final String animeTitle;

  const DownloadBottomSheet({
    super.key,
    required this.episodes,
    required this.animeTitle,
  });

  @override
  State<DownloadBottomSheet> createState() => _DownloadBottomSheetState();
}

class _DownloadBottomSheetState extends State<DownloadBottomSheet> {
  String _selectedQuality = '720p';
  List<int> _selectedEpisodeIndices = [];
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  String _downloadStatus = '';
  Timer? _downloadTimer;
  int _downloadedSize = 0;
  int _totalSize = 0;

  @override
  void initState() {
    super.initState();
    _totalSize = _calculateTotalSize();
  }

  @override
  void dispose() {
    _downloadTimer?.cancel();
    super.dispose();
  }

  int _calculateTotalSize() {
    // Placeholder logic for total size calculation
    // In a real app, this would be based on actual episode sizes and quality
    return widget.episodes.length * 200; // e.g., 200 MB per episode
  }

  void _startDownload() {
    if (_selectedEpisodeIndices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one episode to download.')),
      );
      return;
    }

    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.0;
      _downloadedSize = 0;
      _downloadStatus = 'Episode 1 is still downloading...'; // Simplified, could be more dynamic
    });

    int progressIncrement = (_totalSize ~/ 100); // Increment by 1% of total size

    _downloadTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        _downloadedSize += progressIncrement;
        _downloadProgress = _downloadedSize / _totalSize;

        if (_downloadProgress >= 1.0) {
          _downloadProgress = 1.0;
          _downloadedSize = _totalSize;
          _isDownloading = false;
          _downloadTimer?.cancel();
          _downloadStatus = 'Download complete!';
          // Show a snackbar or navigate away
          Navigator.of(context).pop(); // Close the downloading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Download complete!')),
          );
        }
      });
    });

    // Show the downloading progress dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _buildDownloadingDialog(),
    );
  }

  Widget _buildDownloadingDialog() {
    return StatefulBuilder(
      builder: (context, setStateSB) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade900,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Download',
                style: TextStyle(
                  color: Color(0xFF1ED760),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _downloadStatus,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: _downloadProgress,
                backgroundColor: Colors.grey.shade700,
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF1ED760)),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${(_downloadedSize / (1024 * 1024)).toStringAsFixed(1)} / ${(_totalSize / (1024 * 1024)).toStringAsFixed(1)} MB',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Text(
                    '${(_downloadProgress * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    _downloadTimer?.cancel();
                    setState(() => _isDownloading = false);
                    Navigator.of(context).pop(); // Close the downloading dialog
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white.withOpacity(0.12)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Hide'),
                ),
              ),
            ],
          ),
        );
      },
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
            'Download',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Episodes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              DropdownButton<String>(
                value: _selectedQuality,
                dropdownColor: Colors.grey.shade800,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                underline: const SizedBox.shrink(),
                onChanged: _isDownloading
                    ? null
                    : (String? newValue) {
                        if (newValue != null) {
                          setState(() => _selectedQuality = newValue);
                        }
                      },
                items: <String>['720p', '1080p', '480p']
                    .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 130, // Height for horizontal episode cards
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.episodes.length,
              itemBuilder: (context, index) {
                final episode = widget.episodes[index];
                return DownloadEpisodeCard(
                  imageUrl: episode['imageUrl']!,
                  episodeNumber: episode['episodeNumber']!,
                  isInitiallySelected: _selectedEpisodeIndices.contains(index),
                  isDisabled: _isDownloading,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedEpisodeIndices.add(index);
                      } else {
                        _selectedEpisodeIndices.remove(index);
                      }
                    });
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white70,
                    side: BorderSide(color: Colors.white.withOpacity(0.12)),
                    backgroundColor: Colors.grey.shade800,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: _isDownloading ? null : () => Navigator.of(context).pop(),
                  child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: _isDownloading ? null : _startDownload,
                  child: const Text('Download'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}