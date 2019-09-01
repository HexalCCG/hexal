import 'package:angular/angular.dart';

import 'package:angular_router/angular_router.dart';
import 'package:open_card_game/src/route_paths.dart';
import 'hero.dart';
import 'hero_service.dart';
import 'hero_component.dart';

@Component(
  selector: 'my-heroes',
  templateUrl: 'hero_list_component.html',
  styleUrls: ['hero_list_component.css'],
  directives: [coreDirectives, HeroComponent],
  providers: [ClassProvider(HeroService)],
  pipes: [commonPipes],
)
class HeroListComponent implements OnInit {
  final HeroService _heroService;
  final Router _router;
  List<Hero> heroes;
  Hero selected;

  HeroListComponent(this._heroService, this._router);

  Future<void> _getHeroes() async {
    heroes = await _heroService.getAll();
  }

  void ngOnInit() => _getHeroes();

  void onSelect(Hero hero) => selected = hero;

  String _heroUrl(int id) =>
      RoutePaths.hero.toUrl(parameters: {idParam: '$id'});

  Future<NavigationResult> gotoDetail() =>
      _router.navigate(_heroUrl(selected.id));
}
