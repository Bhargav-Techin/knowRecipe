import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { tap } from 'rxjs';
import { BehaviorSubject } from 'rxjs/internal/BehaviorSubject';
import { Observable } from 'rxjs/internal/Observable';
import { environment } from '../../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class AuthService {

  private baseURL: string = environment.apiUrl;

  constructor(private http: HttpClient) {
    this.initializeUser();
  }

  authSubject = new BehaviorSubject<any>({
    user: null,
  });

  initializeUser(): void {
    if (this.isLoggedIn()) {
      this.getUserProfile().subscribe((profile) => {
        this.updateUserProfile(profile);
      });
    }
  }

  login(userData: any): Observable<any> {
    return this.http.post<any>(`${this.baseURL}/auth/signin`, userData).pipe(
      tap((response) => {
        localStorage.setItem("jwt", response.jwt);
        this.getUserProfile().subscribe((profile) => {
          this.updateUserProfile(profile);
        });
      })
    );
  }

  register(userData: any): Observable<any> {
    return this.http.post<any>(`${this.baseURL}/auth/signup`, userData).pipe(
      tap((response) => {
        localStorage.setItem("jwt", response.jwt);
        this.getUserProfile().subscribe((profile) => {
          this.updateUserProfile(profile);
        });
      })
    );
  }

  getUserProfile(): Observable<any> {
    const headers = new HttpHeaders({
      Authorization: `Bearer ${localStorage.getItem("jwt")}`
    });
    return this.http.get<any>(`${this.baseURL}/api/user/profile`, { headers }).pipe(
      tap((user) => {
        const currentState = this.authSubject.value;
        this.authSubject.next({ ...currentState, user });
      })
    );
  }

  updateUserProfile(profile: any): void {
    this.authSubject.next({ user: profile });
  }

  logout() {
    localStorage.clear();
    this.authSubject.next({ user: null });
  }

  isLoggedIn(): boolean {
    return !!localStorage.getItem('jwt');
  }
}
