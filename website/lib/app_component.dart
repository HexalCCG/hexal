import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'src/routes.dart';

@Component(
  selector: 'ocg-app',
  templateUrl: 'app_component.html',
  styleUrls: ['app_component.css'],
  directives: [routerDirectives],
  exports: [Routes],
)
class AppComponent {}
