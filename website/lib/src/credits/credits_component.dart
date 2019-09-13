import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import '../card_service.dart';
import '../routes.dart';

export '../routes.dart';

@Component(
  selector: 'credits',
  templateUrl: 'credits_component.html',
  styleUrls: ['credits_component.css'],
  directives: [coreDirectives, routerDirectives],
  providers: [ClassProvider(CardService)],
  exports: [Routes],
)
class CreditsComponent {}
