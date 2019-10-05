import 'dart:core';
import 'package:http/http.dart';

import 'package:image/image.dart';
import 'package:pdf/widgets.dart' hide Image;

import 'card.dart';

class AssetService {
  Map<String, Future<Image>> imageMap = Map<String, Future<Image>>();
  Map<String, Future<Font>> fontMap = Map<String, Future<Font>>();
  Future<String> cardData;

  static Map<Element, String> elementImages = {
    Element.spirit: "assets/icons/element-spirit.png",
    Element.fire: "assets/icons/element-fire.png",
    Element.air: "assets/icons/element-air.png",
    Element.earth: "assets/icons/element-earth.png",
    Element.water: "assets/icons/element-water.png",
    Element.any: "assets/icons/element-any.png"
  };

  static String cardImage(int id) {
    if (id > maxID) {
      return "assets/card-images/280x280/placeholder.png";
    }
    return "assets/card-images/280x280/" +
        id.toString().padLeft(3, '0') +
        ".png";
  }

  static int maxID = 250;
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

  Future<Font> loadFont(String location) {
    if (!fontMap.containsKey(location)) {
      fontMap[location] = readBytes(location)
          .then((data) => Font.ttf(data.buffer.asByteData()));
    }
    return fontMap[location];
  }
}
