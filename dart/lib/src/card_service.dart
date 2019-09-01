import 'card.dart';

class CardService {
  Future<List<Card>> getAll() async => cardList;

  Future<Card> get(int id) async =>
      (await getAll()).firstWhere((card) => card.id == id);

  final cardList = <Card>[
    Card(11, 'Mr. Nice'),
    Card(12, 'Narco'),
    Card(13, 'Bombasto'),
    Card(14, 'Celeritas'),
    Card(15, 'Magneta'),
    Card(16, 'RubberMan'),
    Card(17, 'Dynama'),
    Card(18, 'Dr IQ'),
    Card(19, 'Magma'),
    Card(20, 'Tornado')
  ];
}
