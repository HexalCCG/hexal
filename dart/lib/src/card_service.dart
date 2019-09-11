import 'dart:core';

import 'package:csv/csv.dart';
import 'package:open_card_game/src/asset_service.dart';

import 'card.dart';

class CardService {
  CardService(this._assetService);
  final AssetService _assetService;
  List<Card> cardList;

  Future<List<Card>> loadCards() async {
    String csv = await _assetService.getCardData();
    List<List<dynamic>> rows =
        const CsvToListConverter().convert(csv).skip(1).toList();

    return rows.map((List<dynamic> rowData) {
      return parseRowData(rowData);
    }).toList();
  }

  Future<List<Card>> getAll() async {
    if (cardList == null) {
      cardList = await loadCards();
    }
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

  Future<Card> getById(int id) async {
    List<Card> list = await getAll();
    return list.singleWhere((Card card) {
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
      case "none":
      case "":
      default:
        return CardDuration.none;
    }
  }

  Map<Element, int> costFromString(String s) {
    Map<Element, int> result = Map<Element, int>();
    if (s != "") {
      List<String> list = s.split(",");
      list.forEach((item) {
        Element e = parseElementLetter(item.substring(item.length - 1));
        int n = int.parse(item.substring(0, item.length - 1));
        result[e] = n;
      });
    }
    return result;
  }

  Element parseElementLetter(String letter) {
    switch (letter) {
      case "s":
        return Element.spirit;
        break;
      case "r":
        return Element.real;
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
