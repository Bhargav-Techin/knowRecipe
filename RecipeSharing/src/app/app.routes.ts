import { Routes } from '@angular/router';
import { HomePageComponent } from './pages/home-page/home-page.component';
import { AuthComponent } from './pages/auth/auth.component';
import { authGuard } from './auth.guard';

export const routes: Routes = [
    { path: 'home', component: HomePageComponent, canActivate: [authGuard] },
    { path: 'auth', component: AuthComponent },
    { path: '', redirectTo: '/home', pathMatch: 'full' }
  ];
  
