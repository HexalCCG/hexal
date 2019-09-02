import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import '../card.dart';
import '../card_list.dart';
import '../asset_links.dart';
import '../routes.dart';

@Component(
  selector: 'deck-builder',
  templateUrl: 'deck_builder_component.html',
  styleUrls: ['deck_builder_component.css'],
  directives: [coreDirectives, routerDirectives],
  providers: [ClassProvider(CardList)],
  pipes: [commonPipes],
  exports: [Routes, AssetLinks],
)
class DeckBuilderComponent implements OnInit {
  final CardList _cardList;
  List<Card> allCards;
  Card selected;
  List<Card> libraryCards;
  Map<Card, int> deckCards = Map<Card, int>();

  DeckBuilderComponent(this._cardList);

  Future<void> _getCards() async {
    allCards = await _cardList.getAll();
  }

  Future<void> ngOnInit() async {
    await _getCards();
    libraryCards = List<Card>()..addAll(allCards);
    libraryCards.sort(compareCards);
  }

  int compareCards(Card a, Card b) {
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

  int nextEight(int n) {
    return (n / 8).ceil() * 8;
  }
}
