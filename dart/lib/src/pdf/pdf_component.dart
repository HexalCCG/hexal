import 'dart:html' hide Location;
import 'dart:convert';

import 'package:angular/security.dart';
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
class PdfComponent implements OnActivate {
  final CardService _cardService;
  final DeckService _deckService;
  final Location _location;
  final DomSanitizationService _sanitizationService;
  PdfComponent(this._cardService, this._deckService, this._location,
      this._sanitizationService);

  SafeResourceUrl iframeUrl;
  bool loaded = false;

  @override
  void onActivate(_, RouterState current) async {
    List<Card> cardList =
        _deckService.unmap(_deckService.decodeDeck(current.parameters['deck']));
    iframeUrl = await buildPdf(cardList);
    loaded = true;
  }

  Future<SafeResourceUrl> buildPdf(List<Card> cards) async {
    final pdf = Document();

    pdf.addPage(Page(
        pageFormat: PdfPageFormat.a4,
        build: (Context context) {
          return Center(
            child: Text(cards.toString()),
          ); // Center
        })); // Page

    return _sanitizationService.bypassSecurityTrustResourceUrl(
        "data:application/pdf;base64," + base64.encode(pdf.save()));
  }
}
