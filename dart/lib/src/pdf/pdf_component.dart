import 'dart:html' hide Location;
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:angular/security.dart';
import 'package:image/image.dart';
import 'package:js/js.dart';
import 'package:open_card_game/src/card_service.dart';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' hide Image;

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

  static double cm = PdfPageFormat.cm;
  static double totalWidth = 29.7 * cm;
  static double totalHeight = 21.0 * cm;
  static double cardWidth = totalWidth / 4;
  static double cardHeight = totalHeight / 2;

  @override
  void onActivate(_, RouterState current) async {
    List<Card> cardList =
        _deckService.unmap(_deckService.decodeDeck(current.parameters['deck']));
    iframeUrl = await buildPdf(cardList);
    loaded = true;
  }

  Future<SafeResourceUrl> buildPdf(List<Card> cards) async {
    PdfDocument doc = PdfDocument();

    PdfInfo(doc, title: "Card Game Name Deck");

    int pages = (cards.length / 8).ceil();

    List<Future> pageFutures = List<Future>();

    for (int p = 0; p < pages; p++) {
      Iterable<Card> pageCards = cards.skip(p * 8).take(8);
      pageFutures.add(drawPage(doc, pageCards));
    }

    await Future.wait(pageFutures);

    return _sanitizationService.bypassSecurityTrustResourceUrl(
        "data:application/pdf;base64," + base64.encode(doc.save()));
  }

  Future<void> drawPage(PdfDocument doc, Iterable<Card> cards) async {
    PdfPage page = PdfPage(doc,
        pageFormat: PdfPageFormat.a4.landscape
            .applyMargin(left: 0, right: 0, top: 0, bottom: 0));
    PdfGraphics graphics = page.getGraphics();

    Context context = Context(document: doc, page: page, canvas: graphics);

    List<Future> cardFutures = List<Future>();

    for (int i = 0; i < cards.length; i++) {
      var y = (((i / 4).floor() + 1) / 2) * totalHeight;
      var x = ((i % 4) / 4) * totalWidth;

      cardFutures
          .add(drawCard(doc, graphics, context, cards.elementAt(i), x, y));
    }

    await Future.wait(cardFutures);
  }

  Future<void> drawCard(PdfDocument doc, PdfGraphics graphics, Context context,
      Card card, double x, double y) async {
    PdfFont courier = PdfFont.courier(doc);
    graphics.setColor(PdfColor(0, 0, 0));
    //// Geometry
    /// Border
    graphics.drawRect(x, y - cardHeight, cardWidth, cardHeight);
    graphics.strokePath();

    //// Text
    /// Name
    graphics.drawString(courier, 12.0, card.name, x + 20, y - 32);

    /// Type line
    graphics.drawString(courier, 12.0, card.typeLine, x + 20, y - 160);

    /// Card text
    graphics.drawString(courier, 12.0, card.text, x + 20, y - 190);

    SizedBox(width: 100, height: 100, child: Text("Hello World"))
        .paint(context);

    //// Images
    /// Element
    graphics.drawImage(
        await getImage(doc, card.elementImage), x + cardWidth - 35, y - 35, 30);

    /// Picture
    graphics.drawImage(await getImage(doc, card.image), x + 55, y - 140, 100);
  }

  Future<PdfImage> getImage(PdfDocument doc, String location) async {
    Image image = decodeImage(await http.readBytes(location));
    return PdfImage(doc,
        image: image.data.buffer.asUint8List(),
        width: image.width,
        height: image.height);
  }
}
