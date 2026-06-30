import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

/// Product photo with network image support and a branded gradient fallback.
class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    required this.icon,
    required this.tintIndex,
    this.imageUrl,
    this.radius = AppTheme.radius,
    this.iconSize = 56,
  });

  final IconData icon;
  final int tintIndex;
  final String? imageUrl;
  final double radius;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: CachedNetworkImage(
          imageUrl: imageUrl!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          placeholder: (_, __) => _Placeholder(
            icon: icon,
            tintIndex: tintIndex,
            radius: radius,
            iconSize: iconSize,
          ),
          errorWidget: (_, __, ___) => _Placeholder(
            icon: icon,
            tintIndex: tintIndex,
            radius: radius,
            iconSize: iconSize,
          ),
        ),
      );
    }

    return _Placeholder(
      icon: icon,
      tintIndex: tintIndex,
      radius: radius,
      iconSize: iconSize,
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({
    required this.icon,
    required this.tintIndex,
    required this.radius,
    required this.iconSize,
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
