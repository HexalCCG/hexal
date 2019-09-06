import 'dart:convert';

import 'package:angular/angular.dart';

import 'card.dart';
import 'card_service.dart';

@Component(
  selector: 'deck-service',
  template: '',
  directives: [coreDirectives],
  providers: [ClassProvider(CardService)],
  pipes: [commonPipes],
)
class DeckService {
  final CardService _cardService;
  DeckService(this._cardService);

  String generateCode(Map<Card, int> deck) {
    String list = deck.keys.map((card) {
      return card.id.toString() +
          ((deck[card] > 1) ? "x" + deck[card].toString() : "");
    }).join(",");

    List<int> bytes = utf8.encode(list);
    return base64.encode(bytes);
  }

  List<Card> unmap(Map<Card, int> deck) {
    List<Card> r = List<Card>();
    deck.keys.forEach((key) {
      for (int i = 0; i < deck[key]; i++) {
        r.add(key);
      }
    });
    return r;
  }

  Map<Card, int> decodeDeck(String code) {
    List<int> bytes = base64.decode(code);
    String s = utf8.decode(bytes);

    Map<Card, int> r = Map<Card, int>();

    try {
      s.split(",").forEach((String a) {
        print(a);
        List<String> b = a.split("x");
        print(b);
        int n = (b.length == 2) ? int.parse(b[1]) : 1;
        Card c = _cardService.getById(int.parse(b[0]));
        r[c] = n;
      });
      return r;
    } catch (e) {
      return Map<Card, int>();
    }
  }
}
