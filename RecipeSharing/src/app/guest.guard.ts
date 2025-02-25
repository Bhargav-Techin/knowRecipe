import { inject } from '@angular/core';
import { CanActivateFn, Router } from '@angular/router';
import { AuthService } from './services/auth/auth.service';

export const guestGuard: CanActivateFn = (route, state) => {
  const authService = inject<AuthService>(AuthService);
  const router = inject<Router>(Router);

  if (authService.isLoggedIn()) {
    router.navigate(['/home']); // Redirect logged-in users to home
    return false;
  } else {
    return true; // Allow access to auth page
  }
};
