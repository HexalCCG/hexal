import 'dart:core';
import 'package:http/http.dart';

import 'package:image/image.dart';

import 'card.dart';

class AssetService {
  Map<String, Future<Image>> imageMap = Map<String, Future<Image>>();
  Future<String> cardData;

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

  static String cardImage(int id) {
    return "assets/card-images/280x280/" +
        id.toString().padLeft(3, '0') +
        ".png";
  }

  static String cardDataLocation = "assets/data/cards.csv";

  Future<String> getCardData() {
    if (cardData == null) {
      cardData = read(cardDataLocation);
    }
    return cardData;
  }

  Future<Image> loadImage(String location) {
    if (!imageMap.containsKey(location)) {
      imageMap[location] =
          readBytes(location).then((data) => decodeImage(data));
    }
    return imageMap[location];
  }
}
