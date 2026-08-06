/// The mint "why we ask" note used across setup and the money flows.
library;

import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Soft mint panel carrying one short explanation in plain words.
///
/// The mocks put one of these wherever the app asks for something or shows a
/// number it should justify: why location (1h), just-the-count (1i), what
/// picking dairy loaded (1k), what doing the plan achieves (1s).
class InfoNote extends StatelessWidget {
  /// Creates a note.
  const InfoNote({super.key, required this.text});

  /// The explanation.
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: AppPalette.mintNote,
        border: Border.all(color: AppPalette.mintNoteBorder),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12.5,
          height: 1.45,
          color: AppPalette.mintNoteInk,
        ),
      ),
    );
  }
}
