import 'dart:collection';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:open_card_game/src/deck_service.dart';

import '../card.dart';
import '../card_service.dart';
import '../asset_links.dart';
import '../routes.dart';

@Component(
  selector: 'deck-builder',
  templateUrl: 'deck_builder_component.html',
  styleUrls: ['deck_builder_component.css'],
  directives: [coreDirectives, routerDirectives],
  providers: [ClassProvider(CardService), ClassProvider(DeckService)],
  pipes: [commonPipes],
  exports: [Routes, AssetLinks],
)
class DeckBuilderComponent implements OnInit {
  final CardService _cardService;
  final DeckService _deckService;
  DeckBuilderComponent(this._cardService, this._deckService);

  List<Card> allCards;
  Card selected;
  List<Card> libraryCards;
  Map<Card, int> deckCards = SplayTreeMap<Card, int>(compareCards);

  String toolbarMessage = "";

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

  void clearDeck() => deckCards = Map<Card, int>();

  void importCode() {
    toolbarMessage = "Deck code imported";
  }

  void copyCode() {
    if (deckCards.isNotEmpty) {
      String code = _deckService.generateCode(deckCards);
      toolbarMessage = "Deck code copied";
    }
  }

  void generatePdf() {
    if (deckCards.isNotEmpty) {
      print(_deckService.generateCode(deckCards));
    }
  }
}
