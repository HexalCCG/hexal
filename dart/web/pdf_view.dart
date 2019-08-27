import 'dart:html';
import 'dart:convert';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

void main() {
  String data = Uri.base.queryParameters['string'];
  final pdf = Document();

  pdf.addPage(Page(
      pageFormat: PdfPageFormat.a4,
      build: (Context context) {
        return Center(
          child: Text(data),
        ); // Center
      })); // Page

  String url = "data:application/pdf;base64," + base64.encode(pdf.save());

  IFrameElement output = querySelector('#pdf_iframe');
  output.src = url;
}
