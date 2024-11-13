package Recipe.dev.KnowRecipe.repository;

import Recipe.dev.KnowRecipe.model.Recipe;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface RecipeRepository extends JpaRepository<Recipe, Long> {
    Optional<Recipe> findByUserIdAndTitle(Long userId, String title);
}
