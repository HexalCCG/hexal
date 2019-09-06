import 'dart:html';
import 'dart:convert';

import 'package:open_card_game/src/card_service.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import '../asset_links.dart';
import '../card.dart';
import '../deck_service.dart';
import '../routes.dart';

@Component(
  selector: 'pdf_component',
  templateUrl: 'pdf_component.html',
  styleUrls: ['pdf_component.css'],
  directives: [coreDirectives, routerDirectives],
  providers: [ClassProvider(CardService), ClassProvider(DeckService)],
  pipes: [commonPipes],
  exports: [Routes, AssetLinks],
)
class PdfComponent implements OnInit {
  final CardService _cardService;
  final DeckService _deckService;
  PdfComponent(this._cardService, this._deckService);

  String iframeUrl = "";
  bool loaded = false;

  void ngOnInit() async {
    /*
    String deckCode = Uri.base.queryParameters['deck'];
    List<Card> deck = _deckService.unmap(_deckService.decodeDeck(deckCode));
    iframeUrl = await buildPdf(deck);
    loaded = true;
    */
  }

  Future<String> buildPdf(List<Card> cards) async {
    final pdf = Document();

    pdf.addPage(Page(
        pageFormat: PdfPageFormat.a4,
        build: (Context context) {
          return Center(
            child: Text(cards.toString()),
          ); // Center
        })); // Page

    String url = "data:application/pdf;base64," + base64.encode(pdf.save());

    return url;
  }
}
