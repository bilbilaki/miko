import 'package:flutter/material.dart';

class DownloadEpisodeCard extends StatefulWidget {
  final String imageUrl;
  final String episodeNumber; // e.g., "Episode 1"
  final ValueChanged<bool>? onSelected;
  final bool isInitiallySelected;
  final bool isDisabled;

  const DownloadEpisodeCard({
    super.key,
    required this.imageUrl,
    required this.episodeNumber,
    this.onSelected,
    this.isInitiallySelected = false,
    this.isDisabled = false,
  });

  @override
  State<DownloadEpisodeCard> createState() => _DownloadEpisodeCardState();
}

class _DownloadEpisodeCardState extends State<DownloadEpisodeCard> {
  late bool _isSelected;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isInitiallySelected;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isDisabled
          ? null
          : () {
              setState(() {
                _isSelected = !_isSelected;
              });
              widget.onSelected?.call(_isSelected);
            },
      child: Opacity(
        opacity: widget.isDisabled ? 0.5 : 1.0,
        child: Container(
          width: 160,
          margin: const EdgeInsets.only(right: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      widget.imageUrl,
                      width: 160,
                      height: 90,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 160,
                        height: 90,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(child: Icon(Icons.broken_image, color: Colors.white54)),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isSelected ? Theme.of(context).colorScheme.primary : Colors.black54,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Icon(
                              _isSelected ? Icons.check : Icons.circle_outlined,
                              color: _isSelected ? Colors.black : Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                widget.episodeNumber,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}