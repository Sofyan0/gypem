import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfViewPage extends StatelessWidget {
  final String path;

  PdfViewPage({required this.path});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Petunjuk Teknis"),
      ),
      body: PDFView(
        filePath: path,
      ),
    );
  }
}