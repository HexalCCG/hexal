import 'dart:html' hide Location;
import 'dart:convert';
import 'dart:typed_data';

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
  selector: 'pdf',
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

  Document pdf;

  TextStyle title;
  TextStyle typeLine;
  TextStyle cardText;
  TextStyle keyword;
  TextStyle statsLine;

  static final double mm = PdfPageFormat.cm / 10;
  static final double pageHeight = 297 * mm;
  static final double pageWidth = 210 * mm;

  static final int hCards = 3;
  static final int vCards = 3;
  static final int pCards = hCards * vCards;

  static final double cardWidth = pageWidth / hCards;
  static final double cardHeight = pageHeight / vCards;

  String pdfName = "Card Game Name Deck";
  PdfPageFormat format =
      PdfPageFormat(pageWidth, pageHeight, marginAll: 15 * mm);

  @override
  void onActivate(_, RouterState current) async {
    List<Card> cardList = await _deckService
        .unmap(await _deckService.decodeDeck(current.parameters['deck']));
    cardNumber = cardList.length;

    /*
    iframeUrl = _sanitizationService.bypassSecurityTrustResourceUrl(
        "data:application/pdf;base64," + base64.encode(await buildPdf(cardList).save()));
    */

    Document a = await buildPdf(cardList);

    final String raw = base64.encode(a.save());

    final List<int> intList = base64.decode(raw);
    final Int8List int8array = Int8List.fromList(intList);
    final Blob b = Blob([int8array], 'application/pdf');

    String url = Url.createObjectUrlFromBlob(b);

    window.open(url, "PDF");

    AnchorElement link = AnchorElement()
      ..href = url
      ..download = 'hexal_deck.pdf'
      ..text = 'Download';

    // Insert the link into the DOM.
    var p = querySelector('#link');
    p.append(link);
  }

  Future<Document> buildPdf(List<Card> cards) async {
    pdf = Document(title: pdfName);
    Font firaRegular = await getFont("assets/fonts/FiraSans-Regular.ttf");
    Font firaBold = await getFont("assets/fonts/FiraSans-Bold.ttf");

    title = TextStyle(font: firaBold, fontSize: 10);
    typeLine = TextStyle(font: firaBold, fontSize: 8);
    cardText = TextStyle(font: firaRegular, lineSpacing: 2, fontSize: 8);
    keyword = TextStyle(font: firaBold, lineSpacing: 2, fontSize: 8);
    statsLine = TextStyle(font: firaBold, fontSize: 14);

    List<Future<Container>> c = cards.map((card) {
      return buildCard(card);
    }).toList();
    Future<List<Container>> futures = Future.wait(c);
    List<Container> cardContainers =
        List<Container>.from(await futures, growable: true);

    while (cardContainers.length % pCards != 0) {
      cardContainers.add(Container());
    }
    int pages = (cardContainers.length / pCards).ceil();
    for (int p = 0; p < pages; p++) {
      Iterable<Container> pageCards =
          cardContainers.skip(p * pCards).take(pCards);
      pdf.addPage(Page(
          pageFormat: format,
          build: (Context context) => GridView(
              direction: Axis.vertical,
              crossAxisCount: hCards,
              children: pageCards.toList())));
    }
    return pdf;
  }

  Future<Container> buildCard(Card card) async {
    Container result = await Container(
        padding: EdgeInsets.all(2 * mm),
        decoration: BoxDecoration(
            border:
                BoxBorder(left: true, right: true, top: true, bottom: true)),
        child: Stack(children: [
          Positioned(left: 0, top: 0, child: Text(card.name, style: title)),
          Positioned(
              right: 0,
              top: 0,
              child: LimitedBox(
                  maxHeight: 6 * mm,
                  maxWidth: 6 * mm,
                  child: Image(await getImage(
                      AssetService.elementImages[card.element])))),
          Positioned(
              left: 0,
              right: 0,
              top: 8 * mm,
              child: Center(
                  child: LimitedBox(
                      maxHeight: 35 * mm,
                      child: Image(
                          await getImage(AssetService.cardImage(card.id)))))),
          Positioned(
              left: 2 * mm,
              right: 2 * mm,
              top: 46 * mm,
              child: LimitedBox(
                  maxHeight: 10 * mm,
                  child: Text(card.typeLine, style: typeLine))),
          Positioned(
              top: 52 * mm,
              left: 0,
              right: 0,
              child: await buildCardText(card.text)),
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: await buildCostRow(card.cost))),
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [Text(card.statsLine, style: statsLine)]))
        ]));
    cardsLoaded += 1;
    return result;
  }

  // Simplified cost row
  /*
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
  */

  // Expanded cost row
  Future<List<Widget>> buildCostRow(Map<Element, int> cost) async {
    Iterable<Future<List<Widget>>> a = cost.keys.map((key) async {
      List<Widget> result = List<Widget>();
      for (int i = 0; i < cost[key]; i++) {
        result.add(LimitedBox(
            maxHeight: 16,
            maxWidth: 16,
            child: Image(await getImage(AssetService.elementImages[key]))));
      }
      return result;
    });
    List<List<Widget>> b = await Future.wait(a);
    return b.expand((pair) => pair).toList();
  }

  Future<RichText> buildCardText(String text) async {
    List<InlineSpan> result = List<InlineSpan>();

    int p = 0;

    for (int i = 0; i < text.length; i++) {
      if (text[i] == "<" || text[i] == "[") {
        if (i > p) {
          result.add(TextSpan(text: text.substring(p, i)));
        }
        p = i + 1;
      }
      if (text[i] == ">") {
        if (i > p) {
          result.add(TextSpan(text: text.substring(p, i), style: keyword));
        }
        p = i + 1;
      }
      if (text[i] == "]") {
        if (i > p) {
          result.add(WidgetSpan(
              child: Image(await getImage(AssetService.elementImages[
                  CardService.elementFromString(
                      text.substring(p, i).toLowerCase())]))));
        }
        p = i + 1;
      }
    }
    if (text.length > p) {
      result.add(TextSpan(text: text.substring(p, text.length)));
    }

    return RichText(text: TextSpan(children: result, style: cardText));
  }

  Future<PdfImage> getImage(String location) async {
    img.Image image = await _assetService.loadImage(location);
    return PdfImage(pdf.document,
        image: image.data.buffer.asUint8List(),
        width: image.width,
        height: image.height);
  }

  Future<Font> getFont(String location) async {
    return _assetService.loadFont(location);
  }
}
