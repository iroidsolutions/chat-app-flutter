import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

class PdfViewScreen extends StatefulWidget {
  String? pdf;
  PdfViewScreen(this.pdf);

  @override
  State<PdfViewScreen> createState() => _PdfViewScreenState();
}

class _PdfViewScreenState extends State<PdfViewScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImage();
  }

  getImage() async {
    var dir = await getApplicationDocumentsDirectory();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
