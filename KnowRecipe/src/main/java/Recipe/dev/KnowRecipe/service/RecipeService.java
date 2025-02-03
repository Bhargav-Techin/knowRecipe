package Recipe.dev.KnowRecipe.service;

import Recipe.dev.KnowRecipe.model.User;
import Recipe.dev.KnowRecipe.model.Recipe;

import java.util.List;
import java.util.Map;

public interface RecipeService {
    public Recipe createRecipe(Recipe recipe , Long userId) throws Exception;
    public Recipe findRecipeById(Long id) throws Exception;

    public void deleteRecipe(Long id) throws Exception;
    public Recipe updateRecipe(Recipe recipe, Long id) throws Exception;
    public List<Recipe>findAllRecipe();
    public Map<String, Object> likeRecipe(Long recipeId, Long userId) throws Exception;
    public List<Long> getLikes(Long recipeId) throws Exception;
}
