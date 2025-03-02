import { ChangeDetectionStrategy, Component, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule, FormControl, FormGroup, Validators } from '@angular/forms';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatIcon } from '@angular/material/icon';
import { MatDialogModule } from '@angular/material/dialog';
import { AuthService } from '../../services/auth/auth.service';
import { Router } from '@angular/router';
import { SnackbarService } from '../../services/snackbar/snackbar.service';
import { LoaderService } from '../../services/loader/loader.service'; // ✅ Import LoaderService

@Component({
  selector: 'app-auth',
  templateUrl: './auth.component.html',
  styleUrls: ['./auth.component.scss'],
  imports: [CommonModule, MatFormFieldModule, MatInputModule, FormsModule, ReactiveFormsModule, MatIcon, MatDialogModule],
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class AuthComponent {

  isRegistered: boolean = false;
  user: any = null;
  hide = signal(true);

  constructor(
    public authService: AuthService,
    private router: Router,
    private snackbar: SnackbarService,
    private loaderService: LoaderService // ✅ Inject LoaderService
  ) {}

  // Registration form
  registrationForm = new FormGroup({
    fullName: new FormControl('', [Validators.required]),
    email: new FormControl('', [Validators.required, Validators.email]),
    password: new FormControl('', [Validators.required])
  });

  // Login form
  loginForm = new FormGroup({
    email: new FormControl('', [Validators.required, Validators.email]),
    password: new FormControl('', [Validators.required])
  });

  clickEvent(event: MouseEvent) {
    this.hide.set(!this.hide());
    event.stopPropagation();
  }

  goToLandingPage() {
    this.router.navigate(['/landing-page']);
  }

  onSubmitRegistration(): void {
    if (this.registrationForm.valid) {
      this.loaderService.show(); // ✅ Show Loader
      this.authService.register(this.registrationForm.value).subscribe({
        next: (response: any) => {
          localStorage.setItem("jwt", response.jwt);
          this.authService.getUserProfile().subscribe((profile: any) => {
            this.authService.updateUserProfile(profile);
          });
          this.loaderService.hide(); // ✅ Hide Loader after navigation
          this.snackbar.show(response.message, 'Close', 'success-snackbar');
          this.router.navigate(['/home']).then(() => {
          });
        },
        error: (err: any) => {
          this.loaderService.hide(); // ✅ Hide Loader on error
          this.snackbar.show('Registration failed. ' + err.error.error, 'Close', 'error-snackbar');
          console.error("Error details:", err.error);
        }
      });
    }
  }

  onSubmitLogin(): void {
    if (this.loginForm.valid) {
      this.loaderService.show(); // ✅ Show Loader
      const loginData = {
        email: this.loginForm.get('email')!.value,
        password: this.loginForm.get('password')!.value
      };
      this.authService.login(loginData).subscribe({
        next: (response: any) => {
          localStorage.setItem("jwt", response.jwt);
          this.authService.getUserProfile().subscribe((profile: any) => {
            this.authService.updateUserProfile(profile);
          });
          this.loaderService.hide(); // ✅ Hide Loader after navigation
          this.snackbar.show(response.message, 'Close', 'success-snackbar');
          this.router.navigate(['/home']).then(() => {
          });
        },
        error: (err: any) => {
          this.loaderService.hide(); // ✅ Hide Loader on error
          this.snackbar.show('Check credentials and try again. ' + err.error.error, 'Close', 'error-snackbar');
          console.error("Error details:", err.error);
        }
      });
    }
  }
}
