import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class RatingStars extends StatelessWidget {
  const RatingStars({
    super.key,
    required this.rating,
    this.reviewCount,
    this.size = 15,
  });

  final double rating;
  final int? reviewCount;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded, size: size + 2, color: AppColors.warning),
        const SizedBox(width: 3),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(fontSize: size, fontWeight: FontWeight.w700),
        ),
        if (reviewCount != null) ...[
          const SizedBox(width: 4),
          Text(
            '($reviewCount)',
            style: TextStyle(fontSize: size - 1, color: AppColors.inkMuted),
          ),
        ],
      ],
    );
  }
}
