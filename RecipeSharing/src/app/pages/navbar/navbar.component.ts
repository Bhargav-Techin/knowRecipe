import { Component, OnInit } from '@angular/core';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { MatToolbarModule } from '@angular/material/toolbar';
import { AuthService } from '../../services/auth/auth.service';
import { NavigationEnd, Router } from '@angular/router';
import { MatMenuModule } from '@angular/material/menu';
import { MatListModule } from '@angular/material/list';

@Component({
  selector: 'app-navbar',
  standalone: true,
  imports: [MatToolbarModule, MatButtonModule, MatIconModule, MatButtonModule, MatMenuModule, MatListModule],
  templateUrl: './navbar.component.html',
  styleUrl: './navbar.component.scss'
})
export class NavbarComponent implements OnInit {

  user: any = null;
  currentRoute: string = '';
  isHome: boolean = true;

  constructor(private authService: AuthService, private router: Router) {
  }

  ngOnInit(): void {
    this.authService.authSubject.subscribe(data => {
      this.user = data.user;
    });

    this.router.events.subscribe(event => {
      if (event instanceof NavigationEnd) {
        this.currentRoute = event.urlAfterRedirects;
        this.isHome = this.currentRoute === '/home'; // ✅ Update isHome on reload
      }
    });

    // ✅ Set isHome when component initializes (for direct page reloads)
    this.isHome = this.router.url === '/home';
  }


  onLogout(): void {
    if (confirm("Are you sure?")) {
      this.authService.logout();
      this.router.navigate(['/landing-page']);
    }
  }

  nevigateToMyRecipe() {
    this.router.navigate(['/home/my-recipes']);
    this.isHome = false;
  }

  nevigateToHome() {
    this.router.navigate(['/home']);
    this.isHome = true;
  }

  getInitials(fullName: string | null | undefined): string {
    if (!fullName) {
      return ''; // Return an empty string if fullName is null or undefined
    }
    return fullName.split(' ')
      .map(name => name.charAt(0).toUpperCase())
      .join('');
  }

}
