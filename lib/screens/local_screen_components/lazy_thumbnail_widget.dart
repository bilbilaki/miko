import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../providers/local_provider.dart';

/// A widget that lazily loads thumbnails only when visible on screen.
/// This prevents processing all thumbnails at once when opening large folders.
class LazyThumbnailWidget extends StatefulWidget {
  final String filePath;
  final LocalProvider provider;
  final IconData defaultIcon;
  final Color iconColor;

  const LazyThumbnailWidget({
    super.key,
    required this.filePath,
    required this.provider,
    required this.defaultIcon,
    required this.iconColor,
  });

  @override
  State<LazyThumbnailWidget> createState() => _LazyThumbnailWidgetState();
}

class _LazyThumbnailWidgetState extends State<LazyThumbnailWidget> {
  Uint8List? _thumbnailData;
  bool _isLoading = false;
  bool _hasTriedLoading = false;

  @override
  void didUpdateWidget(LazyThumbnailWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset state if path changed
    if (oldWidget.filePath != widget.filePath) {
      _thumbnailData = null;
      _isLoading = false;
      _hasTriedLoading = false;
    }
  }

  Future<void> _loadThumbnail() async {
    if (_hasTriedLoading || _isLoading) return;

    _hasTriedLoading = true;

    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final results = await widget.provider.getThumbnail(widget.filePath);
      if (!mounted) return;

      final data = results?[0];
      setState(() {
        _thumbnailData = Uint8List.fromList([data ?? 0]);
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use LayoutBuilder + addPostFrameCallback to trigger load when visible
    return LayoutBuilder(
      builder: (context, constraints) {
        // Only start loading if we have some size (meaning we're laid out/visible)
        if (!_hasTriedLoading &&
            constraints.maxWidth > 0 &&
            constraints.maxHeight > 0) {
          // Schedule the load after this frame to avoid setState during build
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _loadThumbnail();
          });
        }

        if (_isLoading && _thumbnailData == null) {
          return Container(
            color: Colors.grey[100],
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  color: widget.iconColor.withOpacity(0.5),
                ),
              ),
            ),
          );
        }

        if (_thumbnailData != null) {
          return Image.memory(
            _thumbnailData!,
            fit: BoxFit.cover,
            gaplessPlayback: true,
            errorBuilder: (context, error, stackTrace) {
              return _buildIconFallback();
            },
          );
        }

        return _buildIconFallback();
      },
    );
  }

  Widget _buildIconFallback() {
    return Container(
      color: Colors.grey[100],
      child: Center(
        child: Icon(widget.defaultIcon, color: widget.iconColor, size: 48),
      ),
    );
  }
}

/// A simpler visibility-aware thumbnail that uses AutomaticKeepAliveClientMixin
/// to cache the loaded state when scrolled off screen temporarily.
class CachedLazyThumbnail extends StatefulWidget {
  final String filePath;
  final LocalProvider provider;
  final IconData defaultIcon;
  final Color iconColor;

  const CachedLazyThumbnail({
    super.key,
    required this.filePath,
    required this.provider,
    required this.defaultIcon,
    required this.iconColor,
  });

  @override
  State<CachedLazyThumbnail> createState() => _CachedLazyThumbnailState();
}

class _CachedLazyThumbnailState extends State<CachedLazyThumbnail>
    with AutomaticKeepAliveClientMixin {
  Uint8List? _thumbnailData;
  bool _isLoading = false;
  bool _loadStarted = false;

  @override
  bool get wantKeepAlive => _thumbnailData != null; // Keep alive if we have data

  @override
  void didUpdateWidget(CachedLazyThumbnail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filePath != widget.filePath) {
      _thumbnailData = null;
      _isLoading = false;
      _loadStarted = false;
      updateKeepAlive();
    }
  }

  void _startLoading() {
    if (_loadStarted) return;
    _loadStarted = true;
    _loadThumbnail();
  }

  Future<void> _loadThumbnail() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final results = await widget.provider.getThumbnail(widget.filePath);
      if (!mounted) return;

      setState(() {
        _thumbnailData = results??Uint8List.fromList([0]);
        _isLoading = false;
      });
      updateKeepAlive();
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    return LayoutBuilder(
      builder: (context, constraints) {
        // Trigger load when widget has size (is visible/laid out)
        if (!_loadStarted && constraints.maxWidth > 0) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _startLoading();
          });
        }

        if (_thumbnailData != null) {
          return Image.memory(
            _thumbnailData!,
            fit: BoxFit.cover,
            gaplessPlayback: true,
            errorBuilder: (_, __, ___) => _buildIcon(),
          );
        }

        if (_isLoading) {
          return Container(
            color: Colors.grey[100],
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  color: widget.iconColor.withOpacity(0.5),
                ),
              ),
            ),
          );
        }

        return _buildIcon();
      },
    );
  }

  Widget _buildIcon() {
    return Container(
      color: Colors.grey[100],
      child: Center(
        child: Icon(widget.defaultIcon, color: widget.iconColor, size: 48),
      ),
    );
  }
}
