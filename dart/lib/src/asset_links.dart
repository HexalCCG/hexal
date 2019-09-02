import 'dart:core';

import 'card.dart';

class AssetLinks {
  static Map<Element, String> elementImages = {
    Element.spirit: "assets/icons/element-spirit.png",
    Element.fire: "assets/icons/element-fire.png",
    Element.air: "assets/icons/element-air.png",
    Element.earth: "assets/icons/element-earth.png",
    Element.water: "assets/icons/element-water.png"
  };

  static String spiritImage = elementImages[Element.spirit];
  static String fireImage = elementImages[Element.fire];
  static String airImage = elementImages[Element.air];
  static String earthImage = elementImages[Element.earth];
  static String waterImage = elementImages[Element.water];
}
