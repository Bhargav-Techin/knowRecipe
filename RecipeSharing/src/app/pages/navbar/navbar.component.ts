import { Component, OnInit } from '@angular/core';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { MatToolbarModule } from '@angular/material/toolbar';
import { AuthService } from '../../services/auth/auth.service';
import { Router } from '@angular/router';
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

  constructor(private authService: AuthService, private router: Router) {
  }

  ngOnInit(): void {
    this.authService.authSubject.subscribe(data => {
      this.user = data.user;
    });
  }

  onLogout(): void {
    if (confirm("Are you sure?")) {
      this.authService.logout();
      this.router.navigate(['/auth']);
    }
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
