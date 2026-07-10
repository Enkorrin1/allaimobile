import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

const allAiNeon = Color(0xFFE6FF00);
const allAiBlack = Color(0xFF000000);
const allAiPanel = Color(0xFF111111);
const allAiPanelSoft = Color(0xFF1C1C1F);
const allAiMuted = Color(0xFF9B9BA1);

class NeonMediaCard extends StatelessWidget {
  const NeonMediaCard({
    required this.title,
    required this.imageUrl,
    this.subtitle,
    this.width = 160,
    this.height = 220,
    this.borderRadius = 16,
    this.onTap,
    this.centerContent = false,
    this.ctaLabel,
    super.key,
  });

  final String title;
  final String? subtitle;
  final String imageUrl;
  final double width;
  final double height;
  final double borderRadius;
  final VoidCallback? onTap;
  final bool centerContent;
  final String? ctaLabel;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);

    return SizedBox(
      width: width,
      height: height,
      child: Material(
        color: allAiPanel,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                fadeInDuration: const Duration(milliseconds: 180),
                placeholder: (context, url) => const _MediaPlaceholder(),
                errorWidget: (context, url, error) => const _MediaPlaceholder(),
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x03000000),
                      Color(0x22000000),
                      Color(0xD9000000),
                    ],
                    stops: [0, 0.54, 1],
                  ),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: radius,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.07),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: centerContent
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.end,
                  crossAxisAlignment: centerContent
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: centerContent ? 2 : 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: centerContent
                          ? TextAlign.center
                          : TextAlign.start,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: centerContent ? 28 : 20,
                        fontWeight: FontWeight.w900,
                        height: 1.08,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        subtitle!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: centerContent
                            ? TextAlign.center
                            : TextAlign.start,
                        style: const TextStyle(
                          color: Color(0xD9FFFFFF),
                          fontSize: 12,
                          height: 1.2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    if (ctaLabel != null) ...[
                      const SizedBox(height: 18),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 12,
                        ),
                        decoration: const ShapeDecoration(
                          color: allAiNeon,
                          shape: StadiumBorder(),
                        ),
                        child: Text(
                          ctaLabel!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NeonPillButton extends StatelessWidget {
  const NeonPillButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.height = 58,
    this.expand = true,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double height;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final child = SizedBox(
      height: height,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: allAiNeon,
          disabledBackgroundColor: allAiNeon.withValues(alpha: 0.45),
          foregroundColor: Colors.black,
          disabledForegroundColor: Colors.black.withValues(alpha: 0.55),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 24),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );

    if (!expand) return child;
    return SizedBox(width: double.infinity, child: child);
  }
}

class NeonSectionHeader extends StatelessWidget {
  const NeonSectionHeader({
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onActionPressed,
    super.key,
  });

  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  height: 1.08,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: allAiMuted,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (actionLabel != null && onActionPressed != null)
          TextButton.icon(
            onPressed: onActionPressed,
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
            label: Text(actionLabel!),
            iconAlignment: IconAlignment.end,
            icon: const Icon(Icons.chevron_right_rounded, size: 26),
          ),
      ],
    );
  }
}

class _MediaPlaceholder extends StatelessWidget {
  const _MediaPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2C2C30), Color(0xFF111113)],
        ),
      ),
    );
  }
}
