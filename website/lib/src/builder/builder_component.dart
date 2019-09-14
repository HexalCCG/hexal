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
  selector: 'builder',
  templateUrl: 'builder_component.html',
  styleUrls: ['builder_component.css'],
  directives: [coreDirectives, routerDirectives, formDirectives],
  providers: [
    ClassProvider(CardService),
    ClassProvider(DeckService),
    ClassProvider(AssetService)
  ],
  pipes: [commonPipes],
  exports: [Routes, AssetService],
)
class BuilderComponent implements OnInit {
  final CardService _cardService;
  final DeckService _deckService;
  final Router _router;
  BuilderComponent(this._cardService, this._deckService, this._router);

  List<Card> allCards;
  Card selected;
  String selectedElement;
  List<Card> libraryCards;
  Map<Card, int> deckCards = SplayTreeMap<Card, int>(CardService.compareCards);

  String codeBox = "";
  String searchBox = "";
  bool deckCardLimit = true;
  bool sortById = false;

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

  bool deckValid() {
    if (deckSize > 30) {
      return false;
    }
    if (deckCards.keys.fold(0, (i, Card v) {
          if (v.type == Type.hero) {
            return i + deckCards[v];
          } else {
            return i;
          }
        }) >
        1) {
      return false;
    }
    return deckCards.keys.every((Card v) {
      return deckCards[v] <= 2;
    });
  }

  bool additionValid(Card addition) {
    if (deckSize >= 30) {
      return false;
    }
    if (addition.type == Type.hero) {
      return deckCards.keys.every((Card v) {
        return v.type != Type.hero;
      });
    }
    return deckCards[addition] == null || deckCards[addition] < 2;
  }

  void onSelect(Card card, Event event) {
    selected = card;
    event.preventDefault();
  }

  void onAdd(Card card) {
    if (deckCardLimit) {
      if (!additionValid(card)) {
        return;
      }
    }

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

  void toggleSetting(String setting) {
    if (setting == "cardlimit") {
      deckCardLimit = !deckCardLimit;
    }
    if (setting == "sortId") {
      sortById = !sortById;
      filterLibrary();
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
      libraryCards.retainWhere((Card card) {
        return card.element == CardService.elementFromString(selectedElement);
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
    if (sortById) {
      libraryCards.sort(CardService.compareId);
    } else {
      libraryCards.sort(CardService.compareCards);
    }
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
