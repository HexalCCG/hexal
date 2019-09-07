import 'package:open_card_game/src/asset_links.dart';
import 'package:open_card_game/src/localisation.dart';

enum Element { fire, earth, air, water, spirit }
enum Type { creature, spell, item, hero }
enum CardDuration { none, reaction, enchantment, equipment, field, permanent }
enum Stat { attack, health }

class Card {
  Card(this.id, this.name, this.element, this.type, this.cardDuration,
      this.cost, this.stats, this.text) {
    totalCost = cost.values.fold(0, (a, b) => a + b);
  }

  int id;
  String name;
  Element element;

  Type type;
  CardDuration cardDuration;

  Map<Element, int> cost;
  int totalCost;
  Map<Stat, int> stats;

  String text;

  String get typeLine {
    String r;
    r = Localisation.type[type];
    if (cardDuration != CardDuration.none) {
      r += " - " + Localisation.cardDuration[cardDuration];
    }
    return r;
  }

  String get image {
    return AssetLinks.cardImage(id);
  }

  String get elementImage {
    return AssetLinks.elementImages[element];
  }
}
