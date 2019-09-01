import 'package:angular/angular.dart';
import 'package:open_card_game/src/card_service.dart';

import '../card.dart';

@Component(
  selector: 'deck-builder',
  templateUrl: 'deck_builder_component.html',
  styleUrls: ['deck_builder_component.css'],
  directives: [coreDirectives],
  providers: [ClassProvider(CardService)],
  pipes: [commonPipes],
)
class DeckBuilderComponent implements OnInit {
  final CardService _cardService;
  List<Card> allCards;
  Card selected;
  List<Card> deck;

  DeckBuilderComponent(this._cardService);

  Future<void> _getCards() async {
    allCards = await _cardService.getAll();
  }

  void ngOnInit() => _getCards();

  void onSelect(Card card) => selected = card;
}
