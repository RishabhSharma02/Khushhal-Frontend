import 'package:flutter/material.dart';

/// Row of 4 dots that fill in as the user types. Matches design 1g2 / 1g3:
/// filled dot = solid `#175235`, empty = 2px `#AFC4B3` outline.
class PinDots extends StatelessWidget {
  const PinDots({super.key, required this.filled, this.length = 4});

  final int filled;
  final int length;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < length; i++) ...[
          if (i > 0) const SizedBox(width: 16),
          _Dot(active: i < filled),
        ],
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.active});
  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? const Color(0xFF175235) : null,
        border: active ? null : Border.all(color: const Color(0xFFAFC4B3), width: 2),
      ),
    );
  }
}
