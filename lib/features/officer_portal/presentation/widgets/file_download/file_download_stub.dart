/// No-op fallback for platforms without a browser download surface.
library;

import 'dart:typed_data';

/// Always returns `false` — there's no browser to hand a file to.
bool downloadTextFile({
  required String filename,
  required String content,
  required String mimeType,
}) => false;

/// Always returns `false` — there's no browser to hand a file to.
bool downloadBytesFile({
  required String filename,
  required Uint8List bytes,
  required String mimeType,
}) => false;
