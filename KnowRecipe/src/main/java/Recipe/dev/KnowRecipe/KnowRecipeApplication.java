package Recipe.dev.KnowRecipe;

import io.github.cdimascio.dotenv.Dotenv;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class KnowRecipeApplication {

    public static void main(String[] args) {
        // Load .env only if it exists (useful for local development)
        Dotenv dotenv = Dotenv.configure().ignoreIfMissing().load();

        // Get environment variables (prioritizing system environment variables)
        String databaseUrl = System.getenv("DATABASE_URL") != null ? System.getenv("DATABASE_URL") : dotenv.get("DATABASE_URL", "");
        String databaseUsername = System.getenv("DATABASE_USERNAME") != null ? System.getenv("DATABASE_USERNAME") : dotenv.get("DATABASE_USERNAME", "");
        String databasePassword = System.getenv("DATABASE_PASSWORD") != null ? System.getenv("DATABASE_PASSWORD") : dotenv.get("DATABASE_PASSWORD", "");
        String frontendUrl = System.getenv("FRONTEND_URL") != null ? System.getenv("FRONTEND_URL") : dotenv.get("FRONTEND_URL", "");

        // Set system properties
        System.setProperty("DATABASE_URL", databaseUrl);
        System.setProperty("DATABASE_USERNAME", databaseUsername);
        System.setProperty("DATABASE_PASSWORD", databasePassword);
        System.setProperty("FRONTEND_URL", frontendUrl);

        SpringApplication.run(KnowRecipeApplication.class, args);
    }
}
