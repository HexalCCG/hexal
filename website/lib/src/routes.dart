import 'package:angular_router/angular_router.dart';

import 'menu/menu_component.template.dart' as menu_template;
import 'builder/builder_component.template.dart' as builder_template;
import 'pdf/pdf_component.template.dart' as pdf_template;
import 'browse/browse_component.template.dart' as browse_template;
import 'rules/rules_component.template.dart' as rules_template;
import 'credits/credits_component.template.dart' as credits_template;

class Routes {
  static final default_path = RouteDefinition.redirect(
    path: '',
    redirectTo: menu.toUrl(),
  );
  static final menu = RouteDefinition(
    routePath: RoutePath(path: 'menu'),
    component: menu_template.MenuComponentNgFactory,
  );
  static final builder = RouteDefinition(
    routePath: RoutePath(path: 'builder'),
    component: builder_template.BuilderComponentNgFactory,
  );
  static final pdf = RouteDefinition(
    routePath: RoutePath(path: 'pdf/:deck'),
    component: pdf_template.PdfComponentNgFactory,
  );
  static final browse = RouteDefinition(
    routePath: RoutePath(path: 'browse'),
    component: browse_template.BrowseComponentNgFactory,
  );
  static final rules = RouteDefinition(
    routePath: RoutePath(path: 'rules'),
    component: rules_template.RulesComponentNgFactory,
  );
  static final credits = RouteDefinition(
    routePath: RoutePath(path: 'credits'),
    component: credits_template.CreditsComponentNgFactory,
  );

  static final all = <RouteDefinition>[
    default_path,
    menu,
    builder,
    pdf,
    browse,
    rules,
    credits
  ];
}
