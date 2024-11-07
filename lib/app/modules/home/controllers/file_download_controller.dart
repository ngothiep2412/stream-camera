import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:get/get.dart';

class FileDownloadController extends GetxController {
  // Download file từ Uint8List (bytes)
  void downloadBytes({
    required Uint8List bytes,
    required String fileName,
    String? mimeType,
  }) {
    // Tạo blob từ bytes
    final blob = html.Blob([bytes], mimeType);
    final url = html.Url.createObjectUrlFromBlob(blob);

    // Tạo thẻ a ẩn để trigger download
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', fileName)
      ..style.display = 'none';

    html.document.body?.children.add(anchor);
    anchor.click();

    // Cleanup
    html.document.body?.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }

  // Download file từ URL
  void downloadFromUrl({
    required String url,
    required String fileName,
  }) async {
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', fileName)
      ..style.display = 'none';

    html.document.body?.children.add(anchor);
    anchor.click();

    html.document.body?.children.remove(anchor);
  }

  // Lưu text thành file
  void saveTextAsFile({
    required String content,
    required String fileName,
    String mimeType = 'text/plain',
  }) {
    final bytes = Uint8List.fromList(content.codeUnits);
    downloadBytes(
      bytes: bytes,
      fileName: fileName,
      mimeType: mimeType,
    );
  }

  // Lưu JSON thành file
  void saveJsonAsFile({
    required Map<String, dynamic> json,
    required String fileName,
  }) {
    final content = jsonEncode(json);
    saveTextAsFile(
      content: content,
      fileName: fileName,
      mimeType: 'application/json',
    );
  }
}
