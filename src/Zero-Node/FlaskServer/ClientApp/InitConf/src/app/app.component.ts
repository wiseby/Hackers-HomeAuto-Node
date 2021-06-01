import { Component } from '@angular/core';
import { FormControl, FormGroup, Validators } from '@angular/forms';
import { faArrowDown, faArrowLeft, faArrowRight, faCoffee, faEthernet, faLeaf, faMicrochip, faMobile, faServer } from '@fortawesome/free-solid-svg-icons';
import { HttpclientService } from './httpclient.service';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  faCoffee = faCoffee;
  faServer = faServer;
  faLeaf = faLeaf;
  faMobile = faMobile;
  faMicrochip = faMicrochip;
  faEthernet = faEthernet;
  faArrowDown = faArrowDown;
  faArrowRight = faArrowRight;
  faArrowLeft = faArrowLeft;

  public howToDropped = true;


  title = 'InitConf';

  public confForm = new FormGroup({
    serverAddress: new FormControl('', [Validators.required]),
    serverPort: new FormControl('', [Validators.minLength(2)]),
    nodeName: new FormControl('', [Validators.required]),
    nodeAddress: new FormControl('', [Validators.minLength(5)]),
  });

  constructor(private httpService: HttpclientService) {
    
    
  }

  public onSubmit(): void {
    this.confForm.markAllAsTouched();
  }

  public toggleHowTo(): void {
    this.howToDropped = !this.howToDropped;
  }
}
