/// Cross-platform file download — real on web, a no-op elsewhere.
library;

import 'dart:typed_data';

import 'file_download_stub.dart' if (dart.library.html) 'file_download_web.dart' as impl;

/// Downloads text [content] as [filename]. Returns whether the platform
/// could actually hand the file to something (true on web, false
/// otherwise).
bool downloadTextFile({
  required String filename,
  required String content,
  String mimeType = 'text/csv',
}) => impl.downloadTextFile(filename: filename, content: content, mimeType: mimeType);

/// Downloads binary [bytes] as [filename]. Returns whether the platform
/// could actually hand the file to something (true on web, false
/// otherwise).
bool downloadBytesFile({
  required String filename,
  required Uint8List bytes,
  String mimeType = 'application/octet-stream',
}) => impl.downloadBytesFile(filename: filename, bytes: bytes, mimeType: mimeType);
