import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewScreen extends StatelessWidget {
  String? pdf;
  PdfViewScreen(this.pdf);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfPdfViewer.network(pdf!),
    );
  }
}
