import 'package:open_card_game/src/asset_service.dart';
import 'package:open_card_game/src/localisation.dart';

enum Element { fire, earth, air, water, spirit, any }
enum Type { creature, spell, item, hero, token }
enum CardDuration { none, reaction, enchantment, equipment, field, permanent }

class Card {
  Card(this.id, this.name, this.element, this.type, this.cardDuration,
      this.cost, this.attack, this.health, this.text) {
    totalCost = cost.values.fold(0, (a, b) => a + b);
  }

  int id;
  String name;
  Element element;

  Type type;
  CardDuration cardDuration;

  Map<Element, int> cost;
  int totalCost;
  int attack;
  int health;

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
    if (attack != null && health != null) {
      if (type == Type.creature || type == Type.token) {
        return attack.toString() + " / " + health.toString();
      } else {
        return (attack >= 0 ? "+" + attack.toString() : attack.toString()) +
            " / " +
            (health >= 0 ? "+" + health.toString() : health.toString());
      }
    } else {
      return "";
    }
  }

  String get image {
    return AssetService.cardImage(id);
  }

  String get elementImage {
    return AssetService.elementImages[element];
  }

  String get paddedId {
    return id.toString().padLeft(3, "0");
  }

  String get searchableText {
    return paddedId + " " + name + " " + typeLine + " " + text;
  }
}
