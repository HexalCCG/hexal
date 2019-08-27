import 'dart:html';
import 'dart:async';

void main() {
  querySelector('#input')
      .querySelector('#input_submit')
      .onClick
      .listen((event) => submitForm(event));
}

Future<void> submitForm(Event e) async {
  e.preventDefault();

  window.open("/pdf_view.html?string=1111", "PDF View");
}
