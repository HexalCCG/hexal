import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:open_card_game/app_component.template.dart' as ng;

import 'main.template.dart' as self;

@GenerateInjector(
  routerProvidersHash, // You can use routerProviders in production
)
final InjectorFactory injector = self.injector$Injector;

void main() {
  runApp(ng.AppComponentNgFactory, createInjector: injector);
}

/*
void main() {
  runApp(ng.AppComponentNgFactory);

  querySelector('#input')
      .querySelector('#input_submit')
      .onClick
      .listen((event) => submitForm(event));
}

Future<void> submitForm(Event e) async {
  e.preventDefault();

  window.open("/pdf_view.html?string=1111", "PDF View");
}
*/
