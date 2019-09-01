class Card {
  Card(this.id, this.name);

  final int id;
  String name;

  @override
  String toString() => '$name';
}
