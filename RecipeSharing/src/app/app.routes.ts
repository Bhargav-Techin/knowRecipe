import { Routes } from '@angular/router';
import { HomePageComponent } from './pages/home-page/home-page.component';
import { AuthComponent } from './pages/auth/auth.component';
import { authGuard } from './auth.guard';
import { AllRecipesComponent } from './pages/all-recipes/all-recipes.component';
import { MyRecipesComponent } from './pages/my-recipes/my-recipes.component';

export const routes: Routes = [
    { path: 'home',
      component: HomePageComponent,
      children: [
        { path: '', component: AllRecipesComponent },
        { path: 'my-recipes', component: MyRecipesComponent }
      ], canActivate: [authGuard] },
    { path: 'auth', component: AuthComponent },
    { path: '', redirectTo: '/home', pathMatch: 'full' }
  ];
  
