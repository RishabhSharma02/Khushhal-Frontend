import 'package:flutter/material.dart';

/// Lightweight shimmer with no extra deps.
///
/// Wraps [child] (a plain container/skeleton) and animates a light band
/// across it via a shader mask. Uses only Flutter primitives so we don't
/// pull in `shimmer` package.
class ShimmerBox extends StatefulWidget {
  const ShimmerBox({
    super.key,
    this.baseColor = const Color(0xFFE7ECE7),
    this.highlightColor = const Color(0xFFF6F9F6),
    this.duration = const Duration(milliseconds: 1200),
    required this.child,
  });

  final Color baseColor;
  final Color highlightColor;
  final Duration duration;
  final Widget child;

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: widget.duration)..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, _) {
        // -1 → +2 sweeps the highlight from off-screen left to off-screen right.
        final t = -1.0 + 3.0 * _c.value;
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (rect) => LinearGradient(
            begin: Alignment(t - 0.3, 0),
            end: Alignment(t + 0.3, 0),
            colors: [widget.baseColor, widget.highlightColor, widget.baseColor],
            stops: const [0.0, 0.5, 1.0],
          ).createShader(rect),
          child: widget.child,
        );
      },
    );
  }
}

/// Grey rounded placeholder — pair with [ShimmerBox].
class SkeletonBar extends StatelessWidget {
  const SkeletonBar({super.key, this.height = 14, this.width = double.infinity, this.radius = 8});

  final double height;
  final double width;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: const Color(0xFFE7ECE7),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
