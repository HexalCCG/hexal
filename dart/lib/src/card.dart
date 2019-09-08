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

  String get statsLine {
    if (stats[Stat.attack] != null && stats[Stat.health] != null) {
      return stats[Stat.attack].toString() +
          " / " +
          stats[Stat.health].toString();
    } else {
      return "";
    }
  }

  String get image {
    return AssetLinks.cardImage(id);
  }

  String get elementImage {
    return AssetLinks.elementImages[element];
  }

  static String elementString(Element e) {
    switch (e) {
      case Element.fire:
        return "fire";
        break;
      case Element.earth:
        return "earth";
        break;
      case Element.air:
        return "air";
        break;
      case Element.water:
        return "water";
        break;
      case Element.spirit:
        return "spirit";
        break;
      default:
        return null;
    }
  }

  static Element elementFromString(String s) {
    switch (s) {
      case "fire":
        return Element.fire;
        break;
      case "earth":
        return Element.earth;
        break;
      case "air":
        return Element.air;
        break;
      case "water":
        return Element.water;
        break;
      case "spirit":
        return Element.spirit;
        break;
      default:
        return null;
    }
  }
}
