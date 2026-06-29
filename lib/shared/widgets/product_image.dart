import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

/// Branded gradient tile that stands in for a product photo.
/// Swap for a real image (Image.network / cached) once a media provider
/// or backend with image URLs is connected.
class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    required this.icon,
    required this.tintIndex,
    this.radius = AppTheme.radius,
    this.iconSize = 56,
  });

  final IconData icon;
  final int tintIndex;
  final double radius;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final tint = AppColors.tints[tintIndex % AppColors.tints.length];
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          colors: tint,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          icon,
          size: iconSize,
          color: Colors.white.withValues(alpha: 0.85),
          shadows: [
            Shadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
      ),
    );
  }
}
