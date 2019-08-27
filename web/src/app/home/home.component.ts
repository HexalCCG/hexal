import { Component, OnInit } from '@angular/core';
import { PdfMakeWrapper } from 'pdfmake-wrapper';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.sass']
})
export class HomeComponent implements OnInit {

  constructor() { }

  ngOnInit() {
    this.generateHelloWorld();
  }

  public generateHelloWorld(): void {
    const pdf: PdfMakeWrapper = new PdfMakeWrapper();

    pdf.add('Hello world!');

    pdf.create().open();
  }

}
