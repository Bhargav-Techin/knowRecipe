package Recipe.dev.KnowRecipe.service;


import Recipe.dev.KnowRecipe.model.Recipe;
import Recipe.dev.KnowRecipe.model.User;
import Recipe.dev.KnowRecipe.repository.RecipeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
public class RecipeServiceImplementation implements RecipeService {
    @Autowired
    private RecipeRepository recipeRepository;
    @Autowired
    private UserService userService;

    @Override
    public Recipe createRecipe(Recipe recipe, Long userId) throws Exception {
        User user = userService.findUserById(userId);
        Optional<Recipe> existingRecipe = recipeRepository.findByUserIdAndTitle(userId, recipe.getTitle());
        if (existingRecipe.isPresent()) {
            throw new Exception("A recipe with the same title already exists for this user");
        }
        Recipe createdRecipe = new Recipe();
        createdRecipe.setTitle(recipe.getTitle());
        createdRecipe.setImage(recipe.getImage());
        createdRecipe.setDescription(recipe.getDescription());
        createdRecipe.setVeg(recipe.isVeg());
        createdRecipe.setUser(user);
        createdRecipe.setCreateAt(LocalDateTime.now());

        return recipeRepository.save(createdRecipe);
    }

    @Override
    public Recipe findRecipeById(Long id) throws Exception {
        Optional<Recipe> opt = recipeRepository.findById(id);
        if (opt.isPresent()) {
            return opt.get();
        }
        throw new Exception("Recipe does not exist with id:" + id);
    }

    @Override
    public void deleteRecipe(Long id) throws Exception {
        findRecipeById(id);
        recipeRepository.deleteById(id);
    }

    @Override
    public Recipe updateRecipe(Recipe recipe, Long id) throws Exception {
        Recipe oldRecipe = findRecipeById(id);
        if (recipe.getTitle() != null) {
            oldRecipe.setTitle(recipe.getTitle());
        }
        if (recipe.getImage() != null) {
            oldRecipe.setImage(recipe.getImage());
        }
        if (recipe.getDescription() != null) {
            oldRecipe.setDescription(recipe.getDescription());
        }
        if (recipe.isVeg() != oldRecipe.isVeg()) {
            oldRecipe.setVeg(recipe.isVeg());
        }
        return recipeRepository.save(oldRecipe);
    }

    @Override
    public List<Recipe> findAllRecipe() {
        return recipeRepository.findAll();
    }

    @Override
    public Map<String, Object> likeRecipe(Long recipeId, Long userId) throws Exception {
        Recipe recipe = findRecipeById(recipeId);

        User user = userService.findUserById(userId);

        if (recipe.getLikes().contains(user.getId())) {
            recipe.getLikes().remove(user.getId());
        } else {
            recipe.getLikes().add(user.getId());
        }

        recipeRepository.save(recipe);

        Map<String, Object> response = new HashMap<>();
        response.put("recipeId", recipeId);
        response.put("likes", recipe.getLikes());
        return response;
    }


}
