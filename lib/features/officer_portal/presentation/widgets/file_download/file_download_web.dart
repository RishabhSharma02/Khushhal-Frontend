/// Browser download via an object URL + a throwaway anchor click.
///
/// Only ever imported behind `if (dart.library.html)` from
/// `file_download.dart`, so it's never compiled into non-web builds.
library;

// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';

/// Downloads [content] as [filename] in the browser. Always returns `true`.
bool downloadTextFile({
  required String filename,
  required String content,
  required String mimeType,
}) => downloadBytesFile(
  filename: filename,
  bytes: Uint8List.fromList(utf8.encode(content)),
  mimeType: mimeType,
);

/// Downloads [bytes] as [filename] in the browser. Always returns `true`.
bool downloadBytesFile({
  required String filename,
  required Uint8List bytes,
  required String mimeType,
}) {
  final html.Blob blob = html.Blob(<Object>[bytes], mimeType);
  final String url = html.Url.createObjectUrlFromBlob(blob);
  final html.AnchorElement anchor = html.AnchorElement(href: url)
    ..setAttribute('download', filename)
    ..style.display = 'none';
  html.document.body?.append(anchor);
  anchor.click();
  anchor.remove();
  html.Url.revokeObjectUrl(url);
  return true;
}
