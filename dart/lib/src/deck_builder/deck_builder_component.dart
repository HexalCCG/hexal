import 'dart:collection';
import 'dart:core';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:open_card_game/src/card.dart';

import '../card.dart';
import '../card_service.dart';
import '../deck_service.dart';
import '../asset_service.dart';
import '../routes.dart';

@Component(
  selector: 'deck-builder',
  templateUrl: 'deck_builder_component.html',
  styleUrls: ['deck_builder_component.css'],
  directives: [coreDirectives, routerDirectives, formDirectives],
  providers: [
    ClassProvider(CardService),
    ClassProvider(DeckService),
    ClassProvider(AssetService)
  ],
  pipes: [commonPipes],
  exports: [Routes, AssetService],
)
class DeckBuilderComponent implements OnInit {
  final CardService _cardService;
  final DeckService _deckService;
  final Router _router;
  DeckBuilderComponent(this._cardService, this._deckService, this._router);

  List<Card> allCards;
  Card selected;
  String selectedElement;
  List<Card> libraryCards;
  Map<Card, int> deckCards = SplayTreeMap<Card, int>(compareCards);

  String codeBox = "";
  String searchBox = "";

  Future<void> ngOnInit() async {
    allCards = await _cardService.getAll();
    filterLibrary();
  }

  int nextMultiple(int n) {
    int multiple = 9;
    return (n / multiple).ceil() * multiple;
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

  void libraryElement(String string) {
    if (selectedElement == string) {
      selectedElement = null;
    } else {
      selectedElement = string;
    }
    filterLibrary();
  }

  void filterLibrary() {
    libraryCards = List<Card>()..addAll(allCards);
    if (selectedElement != null) {
      libraryCards.removeWhere((Card card) {
        return card.element != _cardService.elementFromString(selectedElement);
      });
    }
    if (searchBox != "") {
      libraryCards.retainWhere((Card card) {
        return card.searchableText
            .toLowerCase()
            .replaceAll(RegExp(r'\W+'), '')
            .contains(searchBox.toLowerCase().replaceAll(RegExp(r'\W+'), ''));
      });
    }
    libraryCards.sort(compareCards);
  }

  static int compareCards(Card a, Card b) {
    int c;

    c = a.element.index.compareTo(b.element.index);
    if (c != 0) {
      return c;
    }

    if ((a.type == Type.hero) && !(b.type == Type.hero)) {
      return 1;
    } else if (!(a.type == Type.hero) && (b.type == Type.hero)) {
      return -1;
    }

    c = a.totalCost.compareTo(b.totalCost);
    if (c != 0) {
      return c;
    }

    return a.name.compareTo(b.name);
  }

  void clearDeck() {
    deckCards = Map<Card, int>();
    codeBox = "";
  }

  void importCode() async {
    if (codeBox != "") {
      deckCards = await _deckService.decodeDeck(codeBox);
    }
  }

  void exportCode() {
    if (deckCards.isNotEmpty) {
      codeBox = _deckService.generateCode(deckCards);
    }
  }

  void generatePdf() {
    if (deckCards.isNotEmpty) {
      String c = _deckService.generateCode(deckCards);
      _router.navigate(Routes.pdf.toUrl({"deck": '$c'}));
    }
  }
}
