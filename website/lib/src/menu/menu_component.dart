import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import '../routes.dart';

export '../routes.dart';

@Component(
  selector: 'menu',
  templateUrl: 'menu_component.html',
  styleUrls: ['menu_component.css'],
  directives: [coreDirectives, routerDirectives],
  exports: [Routes],
)
class MenuComponent {}
