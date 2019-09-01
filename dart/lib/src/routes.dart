import 'package:angular_router/angular_router.dart';

import 'deck_builder/deck_builder_component.template.dart'
    as deck_builder_template;
import 'menu/menu_component.template.dart' as menu_template;

class Routes {
  static final menu = RouteDefinition(
    routePath: RoutePath(path: 'menu'),
    component: menu_template.MenuComponentNgFactory,
  );
  static final deck_builder = RouteDefinition(
    routePath: RoutePath(path: 'build'),
    component: deck_builder_template.DeckBuilderComponentNgFactory,
  );
  static final default_path = RouteDefinition.redirect(
    path: '',
    redirectTo: menu.toUrl(),
  );

  static final all = <RouteDefinition>[
    menu,
    deck_builder,
    default_path,
  ];
}
