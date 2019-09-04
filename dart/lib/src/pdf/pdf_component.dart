import 'dart:html';
import 'dart:convert';

import 'package:open_card_game/src/card_service.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import '../asset_links.dart';
import '../routes.dart';

@Component(
  selector: 'pdf_component',
  templateUrl: 'pdf_component.html',
  styleUrls: ['pdf_component.css'],
  directives: [coreDirectives, routerDirectives],
  providers: [ClassProvider(CardService)],
  pipes: [commonPipes],
  exports: [Routes, AssetLinks],
)
class PdfComponent implements OnInit {
  final CardService _cardService;
  PdfComponent(this._cardService);

  String iframeUrl = "";
  bool loaded = false;

  void ngOnInit() {
    // TODO: implement ngOnInit
  }

  void buildPdf() {
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
}
