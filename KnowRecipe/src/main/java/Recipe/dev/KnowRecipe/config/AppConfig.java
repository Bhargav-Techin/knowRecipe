package Recipe.dev.KnowRecipe.config;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.www.BasicAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;

import java.util.Collections;
import java.util.List;

import static org.springframework.security.config.Customizer.withDefaults;

@Configuration
@EnableWebSecurity
public class AppConfig {

    @Value("${frontend.url}")
    private String frontendUrl;

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .csrf(csrf -> csrf.disable()) // Disable CSRF protection for stateless authentication
                .cors(cors -> cors.configurationSource(corsConfigarationSource())) // Enable CORS
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS)) // Use
                                                                                                              // stateless
                                                                                                              // sessions
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/auth/**").permitAll() // Allow public access to login and register
                        .requestMatchers("/api/**").authenticated() // Protect all other API endpoints
                        .anyRequest().permitAll() // Allow other non-API requests
                )
                .addFilterBefore(new JwtTokenValidator(), BasicAuthenticationFilter.class) // Add custom JWT validation
                                                                                           // filter
                .httpBasic(withDefaults()); // Optional: Enable basic authentication for testing (can remove in
                                            // production)

        return http.build();
    }

    @Value("${frontend.url}")
    private String frontendUrls; // Changed to hold comma-separated URLs

    // ...

    private CorsConfigurationSource corsConfigarationSource() {
        return request -> {
            CorsConfiguration cfg = new CorsConfiguration();

            List<String> allowedOrigins = List.of(frontendUrls.split(","));
            cfg.setAllowedOrigins(allowedOrigins);

            cfg.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE", "OPTIONS"));
            cfg.setAllowedHeaders(List.of("Authorization", "Content-Type"));
            cfg.setExposedHeaders(List.of("Authorization"));
            cfg.setMaxAge(3600L);
            cfg.setAllowCredentials(true); // If you are sending cookies or Authorization headers

            return cfg;
        };
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
