package Recipe.dev.KnowRecipe.controller;


import Recipe.dev.KnowRecipe.model.Recipe;
import Recipe.dev.KnowRecipe.model.User;
import Recipe.dev.KnowRecipe.service.RecipeService;
import Recipe.dev.KnowRecipe.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/recipes")
public class RecipeController {


    @Autowired
    private RecipeService recipeService;
    @Autowired
    private UserService userService;


    @PostMapping()
    public Recipe createRecipe(@RequestBody Recipe recipe , @RequestHeader("Authorization") String jwt) throws Exception {
        User user = userService.findUserByJwt(jwt);
        return recipeService.createRecipe(recipe,user.getId());
    }

    @GetMapping("/{recipeId}")
    public Recipe findRecipeById(@PathVariable Long recipeId) throws Exception {
        return recipeService.findRecipeById(recipeId);
    }

    @DeleteMapping("/{recipeId}")
    public String deleteRecipe(@PathVariable Long recipeId) throws Exception {
        recipeService.deleteRecipe(recipeId);
        return "recipe deleted successfully";
    }

    @PutMapping("/update/{recipeId}")
    public Recipe updateRecipe(@RequestBody Recipe recipe, @PathVariable Long recipeId) throws Exception{
        return recipeService.updateRecipe(recipe,recipeId);
    }

    @GetMapping()
    public List<Recipe> findAllRecipe(){
        return recipeService.findAllRecipe();
    }

    @PutMapping("/{recipeId}/like")
    public Map<String, Object> likeRecipe(@PathVariable Long recipeId, @RequestHeader("Authorization") String jwt) throws Exception {
        User user = userService.findUserByJwt(jwt);
        return recipeService.likeRecipe(recipeId, user.getId());
    }

}
