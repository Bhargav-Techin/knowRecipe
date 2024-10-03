package Recipe.dev.KnowRecipe.repository;

import Recipe.dev.KnowRecipe.model.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Long> {
    User findByEmail(String email);
}
