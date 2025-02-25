import { bootstrapApplication } from '@angular/platform-browser';
import { AppComponent } from './app/app.component';
import { appConfig } from './app/app.config';
import { HTTP_INTERCEPTORS } from '@angular/common/http';
import { TokenInterceptor } from './app/token.interceptor';
import { environment } from './environments/environment';

// Load configuration dynamically
fetch('/assets/config.json')
  .then(response => response.json())
  .then(config => {
    environment.BASE_API_URL = config.BASE_API_URL; // Set API URL dynamically
    bootstrapApplication(AppComponent, {
      providers: [
        ...appConfig.providers,
        { provide: HTTP_INTERCEPTORS, useClass: TokenInterceptor, multi: true }
      ]
    }).catch(err => console.error(err));
  })
  .catch(err => console.error('Failed to load configuration:', err));
