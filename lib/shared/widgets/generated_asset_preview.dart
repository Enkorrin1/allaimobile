import 'package:flutter/material.dart';

class GeneratedAssetPreview extends StatelessWidget {
  const GeneratedAssetPreview({
    required this.accentColor,
    required this.fallbackIcon,
    this.url,
    this.thumbnailUrl,
    this.isVideo = false,
    super.key,
  });

  final String? url;
  final String? thumbnailUrl;
  final bool isVideo;
  final Color accentColor;
  final IconData fallbackIcon;

  @override
  Widget build(BuildContext context) {
    final source = thumbnailUrl ?? url;
    final hasRemoteImage = source != null && source.startsWith('http');

    return Semantics(
      label: 'generated asset preview',
      image: true,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (hasRemoteImage)
              Image.network(
                source,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _GeneratedPreviewSurface(
                      accentColor: accentColor,
                      fallbackIcon: fallbackIcon,
                    ),
              )
            else
              _GeneratedPreviewSurface(
                accentColor: accentColor,
                fallbackIcon: fallbackIcon,
              ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    accentColor.withValues(alpha: 0.28),
                    Colors.transparent,
                    accentColor.withValues(alpha: 0.18),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 12,
              bottom: 12,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.30),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    isVideo ? Icons.play_arrow : Icons.image_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GeneratedPreviewSurface extends StatelessWidget {
  const _GeneratedPreviewSurface({
    required this.accentColor,
    required this.fallbackIcon,
  });

  final Color accentColor;
  final IconData fallbackIcon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.12),
        gradient: RadialGradient(
          center: Alignment.topLeft,
          radius: 1.1,
          colors: [
            accentColor.withValues(alpha: 0.30),
            accentColor.withValues(alpha: 0.10),
            Theme.of(context).colorScheme.surfaceContainerHighest,
          ],
        ),
      ),
      child: Center(
        child: Icon(
          fallbackIcon,
          size: 64,
          color: accentColor.withValues(alpha: 0.82),
        ),
      ),
    );
  }
}
