import 'dart:core';

import 'package:csv/csv.dart';
import 'package:open_card_game/src/asset_links.dart';
import 'package:http/http.dart' as http;

import 'card.dart';

class CardService {
  List<Card> cardList;

  Future<void> init() async {
    String csv = await http.read(AssetLinks.cardData);
    List<List<dynamic>> rows =
        const CsvToListConverter().convert(csv).skip(1).toList();

    cardList = rows.map((List<dynamic> rowData) {
      return parseRowData(rowData);
    }).toList();
  }

  List<Card> getAll() {
    return cardList;
  }

  Card parseRowData(List<dynamic> data) {
    return Card(
        data[0],
        data[1],
        elementFromString(data[2].toLowerCase()),
        typeFromString(data[3].toLowerCase()),
        durationFromString(data[4].toLowerCase()),
        costFromString(data[5]),
        (data[6] == "") ? null : data[6],
        (data[7] == "") ? null : data[7],
        data[8]);
  }

  Card getById(int id) {
    return cardList.singleWhere((Card card) {
      return card.id == id;
    });
  }

  String stringToElement(Element e) {
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

  Element elementFromString(String s) {
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

  Type typeFromString(String s) {
    switch (s) {
      case "creature":
        return Type.creature;
        break;
      case "spell":
        return Type.spell;
        break;
      case "item":
        return Type.item;
        break;
      case "hero":
        return Type.hero;
        break;
      default:
        return null;
    }
  }

  CardDuration durationFromString(String s) {
    switch (s) {
      case "none":
        return CardDuration.none;
        break;
      case "reaction":
        return CardDuration.reaction;
        break;
      case "enchantment":
        return CardDuration.enchantment;
        break;
      case "equipment":
        return CardDuration.equipment;
        break;
      case "field":
        return CardDuration.field;
        break;
      case "permanent":
        return CardDuration.permanent;
        break;
      default:
        return null;
    }
  }

  Map<Element, int> costFromString(String s) {
    Map<Element, int> result = Map<Element, int>();
    List<String> list = s.split(" ");

    list.forEach((item) {
      Element e = parseElementLetter(item.substring(item.length - 1));
      int n = int.parse(item.substring(0, item.length - 1));
      result[e] = n;
    });

    return result;
  }

  Element parseElementLetter(String letter) {
    switch (letter) {
      case "s":
        return Element.spirit;
        break;
      case "a":
        return Element.air;
        break;
      case "w":
        return Element.water;
        break;
      case "f":
        return Element.fire;
        break;
      case "e":
        return Element.earth;
        break;
      default:
        return null;
    }
  }
}
