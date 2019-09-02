import 'dart:core';

import 'card.dart';

class Localisation {
  static Map element = {
    Element.fire: "Fire",
    Element.earth: "Earth",
    Element.air: "Air",
    Element.water: "Water",
    Element.spirit: "Spirit"
  };
  static Map type = {
    Type.creature: "Creature",
    Type.spell: "Spell",
    Type.item: "Item",
    Type.hero: "Hero"
  };
  static Map cardDuration = {
    CardDuration.none: "",
    CardDuration.reaction: "Reaction",
    CardDuration.enchantment: "Enchantment",
    CardDuration.equipment: "Equipment",
    CardDuration.field: "Field",
    CardDuration.permanent: "Permanent"
  };
}
