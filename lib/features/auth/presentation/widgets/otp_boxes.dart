import 'package:flutter/material.dart';

/// Row of code-entry cells that mirror the entered digits. Firebase Phone
/// Auth always delivers a **6-digit** SMS code, so the default length is 6.
/// The screen owns a single hidden [TextField] behind these boxes so the
/// system keyboard opens and SMS auto-read still works.
class OtpBoxes extends StatelessWidget {
  const OtpBoxes({super.key, required this.value, this.length = 6});

  final String value;
  final int length;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          _Box(digit: i < value.length ? value[i] : null),
        ],
      ],
    );
  }
}

class _Box extends StatelessWidget {
  const _Box({this.digit});
  final String? digit;

  @override
  Widget build(BuildContext context) {
    final filled = digit != null;
    return Container(
      width: 44,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: filled ? const Color(0xFF175235) : const Color(0xFFDFEADF),
          width: 1.5,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        digit ?? '_',
        style: TextStyle(
          fontSize: 26,
          fontWeight: filled ? FontWeight.w600 : FontWeight.w400,
          color: filled ? const Color(0xFF1C2B24) : const Color(0xFFAFC4B3),
        ),
      ),
    );
  }
}
