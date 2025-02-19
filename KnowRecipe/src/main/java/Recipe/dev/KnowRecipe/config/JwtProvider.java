package Recipe.dev.KnowRecipe.config;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.util.Date;

@Service
public class JwtProvider {

    private final SecretKey key = Keys.hmacShaKeyFor(JwtConstant.JWT_SECRET.getBytes(StandardCharsets.UTF_8));

    public String generateToken(Authentication auth) {
        String email = auth.getName(); // Extract the email from Authentication object
        return Jwts.builder()
                .setSubject(email) // Set email as the subject
                .claim("email", email) // Add email claim
                .setIssuedAt(new Date())
                // .setExpiration(new Date(System.currentTimeMillis() + 3600000)) // 1 hour validity
               .setExpiration(new Date(System.currentTimeMillis() + (7 * 24 * 60 * 60 * 1000))) // 7 days validity
                .signWith(key, SignatureAlgorithm.HS256) // Use the consistent signing key
                .compact();
    }

    public String getEmailFromJwtToken(String jwt) {
        jwt = jwt.substring(7); // Remove "Bearer " prefix
        Claims claims = Jwts.parserBuilder()
                .setSigningKey(key)
                .build()
                .parseClaimsJws(jwt)
                .getBody();

        return claims.get("email", String.class);
    }
}
