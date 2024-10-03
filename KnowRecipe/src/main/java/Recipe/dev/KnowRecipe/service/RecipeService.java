package Recipe.dev.KnowRecipe.service;

import Recipe.dev.KnowRecipe.model.User;
import Recipe.dev.KnowRecipe.model.Recipe;

import java.util.List;

public interface RecipeService {
    public Recipe createRecipe(Recipe recipe , User user);
    public Recipe findRecipeByid(Long id) throws Exception;

    public void deleteRecipe(Long id) throws Exception;
    public Recipe updateRecipe(Recipe recipe, Long id) throws Exception;
    public List<Recipe>findAllRecipe();
    public Recipe likeRecipe(Long recipeId, User user) throws Exception;
}
