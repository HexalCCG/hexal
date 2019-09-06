import 'dart:collection';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_forms/angular_forms.dart';

import '../card.dart';
import '../card_service.dart';
import '../deck_service.dart';
import '../asset_links.dart';
import '../routes.dart';

@Component(
  selector: 'deck-builder',
  templateUrl: 'deck_builder_component.html',
  styleUrls: ['deck_builder_component.css'],
  directives: [coreDirectives, routerDirectives, formDirectives],
  providers: [ClassProvider(CardService), ClassProvider(DeckService)],
  pipes: [commonPipes],
  exports: [Routes, AssetLinks],
)
class DeckBuilderComponent implements OnInit {
  final CardService _cardService;
  final DeckService _deckService;
  final Router _router;
  DeckBuilderComponent(this._cardService, this._deckService, this._router);

  List<Card> allCards;
  Card selected;
  List<Card> libraryCards;
  Map<Card, int> deckCards = SplayTreeMap<Card, int>(compareCards);

  String codeBox = "";

  Future<void> ngOnInit() async {
    allCards = await _cardService.getAll();
    libraryCards = List<Card>()..addAll(allCards);
    libraryCards.sort(compareCards);
  }

  static int compareCards(Card a, Card b) {
    int c;
    c = a.element.index.compareTo(b.element.index);
    if (c == 0) {
      c = a.totalCost.compareTo(b.totalCost);
      if (c == 0) {
        c = a.name.compareTo(b.name);
      }
    }
    return c;
  }

  int nextEight(int n) {
    return (n / 8).ceil() * 8;
  }

  int get deckSize {
    return deckCards.values.fold(0, (a, b) => a + b);
  }

  bool get deckValid {
    if (deckSize > 30) {
      return false;
    } else {
      return deckCards.values.fold(true, (a, b) {
        if (!a) {
          return a;
        } else {
          return b <= 2;
        }
      });
    }
  }

  void onSelect(Card card, Event event) {
    selected = card;
    event.preventDefault();
  }

  void onAdd(Card card) {
    if (deckCards.containsKey(card)) {
      deckCards[card] += 1;
    } else {
      deckCards[card] = 1;
    }
  }

  void onRemove(Card card) {
    if (deckCards.containsKey(card)) {
      if (deckCards[card] > 1) {
        deckCards[card] -= 1;
      } else {
        deckCards.remove(card);
      }
    }
  }

  void clearDeck() {
    deckCards = Map<Card, int>();
    codeBox = "";
  }

  void importCode() {
    deckCards = _deckService.decodeDeck(codeBox);
  }

  void copyCode() {
    if (deckCards.isNotEmpty) {
      codeBox = _deckService.generateCode(deckCards);
    }
  }

  void generatePdf() {
    if (deckCards.isNotEmpty) {
      String c = _deckService.generateCode(deckCards);
      _router.navigate(Routes.pdf.toUrl(),
          NavigationParams(queryParameters: {'deck': '${c}'}));
      //_router.navigate(Routes.pdf.toUrl());
    }
  }
}
