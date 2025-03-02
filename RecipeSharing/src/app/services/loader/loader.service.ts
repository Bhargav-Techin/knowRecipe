import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class LoaderService {
  private isLoadingSubject = new BehaviorSubject<boolean>(false);
  isLoading$ = this.isLoadingSubject.asObservable(); // Observable for components to subscribe

  constructor() {}

  show() {
    this.isLoadingSubject.next(true); // Set loading to true
  }

  hide() {
    this.isLoadingSubject.next(false); // Set loading to false
  }
}
