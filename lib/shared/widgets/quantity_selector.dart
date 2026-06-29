import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class QuantitySelector extends StatelessWidget {
  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onChanged,
    this.compact = false,
  });

  final int quantity;
  final ValueChanged<int> onChanged;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final s = compact ? 30.0 : 38.0;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _btn(Icons.remove_rounded, s, () => onChanged(quantity - 1)),
          SizedBox(
            width: compact ? 28 : 36,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w800, fontSize: compact ? 14 : 16),
            ),
          ),
          _btn(Icons.add_rounded, s, () => onChanged(quantity + 1)),
        ],
      ),
    );
  }

  Widget _btn(IconData icon, double size, VoidCallback onTap) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(icon, size: size * 0.5),
        ),
      );
}
