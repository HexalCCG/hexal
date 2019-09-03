import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import '../routes.dart';

export '../routes.dart';

@Component(
  selector: 'card-browse',
  templateUrl: 'browse_component.html',
  styleUrls: ['browse_component.css'],
  directives: [coreDirectives, routerDirectives],
  exports: [Routes],
)
class BrowseComponent {}
