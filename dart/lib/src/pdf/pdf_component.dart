import 'dart:html' hide Location;
import 'dart:convert';

import 'package:angular/security.dart';
import 'package:image/image.dart' as img;

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../asset_service.dart';
import '../card.dart';
import '../card_service.dart';
import '../deck_service.dart';
import '../routes.dart';

@Component(
  selector: 'pdf_component',
  templateUrl: 'pdf_component.html',
  styleUrls: ['pdf_component.css'],
  directives: [coreDirectives, routerDirectives],
  providers: [
    ClassProvider(CardService),
    ClassProvider(DeckService),
    ClassProvider(AssetService)
  ],
  pipes: [commonPipes],
  exports: [Routes, AssetService],
)
class PdfComponent implements OnActivate {
  final DeckService _deckService;
  final AssetService _assetService;
  final DomSanitizationService _sanitizationService;
  PdfComponent(
      this._deckService, this._assetService, this._sanitizationService);

  SafeResourceUrl iframeUrl;
  int cardsLoaded = 0;
  int cardNumber = 0;
  bool loaded = false;

  static double cm = PdfPageFormat.cm;
  static double totalWidth = 29.7 * cm;
  static double totalHeight = 21.0 * cm;
  static double cardWidth = totalWidth / 4;
  static double cardHeight = totalHeight / 2;

  @override
  void onActivate(_, RouterState current) async {
    List<Card> cardList = await _deckService
        .unmap(await _deckService.decodeDeck(current.parameters['deck']));
    cardNumber = cardList.length;
    iframeUrl = await buildPdf(cardList);
    loaded = true;
  }

  Future<SafeResourceUrl> buildPdf(List<Card> cards) async {
    Document pdf = Document(title: "Card Game Name Deck");

    PdfPageFormat format = PdfPageFormat.a4.landscape
        .copyWith(marginBottom: 0, marginTop: 0, marginLeft: 0, marginRight: 0);

    List<Future<Container>> c = cards.map((card) {
      return buildCard(pdf, card);
    }).toList();
    Future<List<Container>> futures = Future.wait(c);
    List<Container> cardContainers =
        List<Container>.from(await futures, growable: true);

    while (cardContainers.length % 8 != 0) {
      cardContainers.add(Container());
    }
    int pages = (cardContainers.length / 8).ceil();
    for (int p = 0; p < pages; p++) {
      Iterable<Container> pageCards = cardContainers.skip(p * 8).take(8);
      pdf.addPage(Page(
          pageFormat: format,
          build: (Context context) => GridView(
              direction: Axis.horizontal,
              crossAxisCount: 2,
              children: pageCards.toList())));
    }

    return _sanitizationService.bypassSecurityTrustResourceUrl(
        "data:application/pdf;base64," + base64.encode(pdf.save()));
  }

  Future<Container> buildCard(Document pdf, Card card) async {
    Container result = await Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            border:
                BoxBorder(left: true, right: true, top: true, bottom: true)),
        child: Stack(children: [
          Positioned(
              left: 0,
              top: 0,
              child: Text(card.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
          Positioned(
              right: 0,
              top: 0,
              child: LimitedBox(
                  maxHeight: 24,
                  maxWidth: 24,
                  child: Image(await getImage(
                      pdf, AssetService.elementImages[card.element])))),
          Positioned(
              left: 30,
              right: 30,
              top: 40,
              child: Center(
                  child: LimitedBox(
                      maxHeight: 100,
                      child: Image(await getImage(
                          pdf, AssetService.cardImage(card.id)))))),
          Positioned(
              left: 10,
              top: 160,
              child: LimitedBox(
                  maxHeight: 20,
                  child: Text(card.typeLine,
                      style: TextStyle(fontWeight: FontWeight.bold)))),
          Positioned(
              top: 180,
              left: 0,
              right: 0,
              child: Paragraph(
                  text: card.text,
                  style: TextStyle(lineSpacing: 0),
                  textAlign: TextAlign.left,
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero)),
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: await buildCostRow(pdf, card.cost))),
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(card.statsLine,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14))
                  ]))
        ]));
    cardsLoaded += 1;
    return result;
  }

  Future<List<Widget>> buildCostRow(
      Document pdf, Map<Element, int> cost) async {
    Iterable<Future<List<Widget>>> a = cost.keys.map((key) async {
      List<Widget> result = List<Widget>();
      if (cost[key] > 1) {
        result.add(Text(cost[key].toString()));
      }
      result.add(LimitedBox(
          maxHeight: 16,
          maxWidth: 16,
          child: Image(await getImage(pdf, AssetService.elementImages[key]))));
      return result;
    });
    List<List<Widget>> b = await Future.wait(a);
    return b.expand((pair) => pair).toList();
  }

  Future<PdfImage> getImage(Document pdf, String location) async {
    img.Image image = await _assetService.loadImage(location);
    return PdfImage(pdf.document,
        image: image.data.buffer.asUint8List(),
        width: image.width,
        height: image.height);
  }
}
