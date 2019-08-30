import 'dart:html';
import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_app/app_component.template.dart' as ng;

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
