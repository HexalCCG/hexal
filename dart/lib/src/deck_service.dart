import 'dart:convert';

import 'card.dart';

class DeckService {
  String generateCode(Map<Card, int> deck) {
    String x = "";
    deck.forEach((card, n) {
      x += card.id.toString();
      if (n > 1) {
        x += "x" + n.toString();
      }
      x += ",";
    });
    List<int> bytes = utf8.encode(x);
    String r = base64.encode(bytes);

    return r;
  }

  Map<Card, int> decodeDeck(String code) {
    return null;
  }
}
