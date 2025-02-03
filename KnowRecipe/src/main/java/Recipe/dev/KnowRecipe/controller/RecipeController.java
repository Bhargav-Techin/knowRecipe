package Recipe.dev.KnowRecipe.controller;


import Recipe.dev.KnowRecipe.model.Recipe;
import Recipe.dev.KnowRecipe.model.User;
import Recipe.dev.KnowRecipe.service.RecipeService;
import Recipe.dev.KnowRecipe.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
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
    public ResponseEntity<String> deleteRecipe(@PathVariable Long recipeId, @RequestHeader("Authorization") String jwt) {
        try {
            User user = userService.findUserByJwt(jwt);
            Recipe existingRecipe = recipeService.findRecipeById(recipeId);

            if (existingRecipe.getUser().getEmail().equals(user.getEmail())) {
                recipeService.deleteRecipe(recipeId);
                return ResponseEntity.ok("Recipe deleted successfully");
            } else {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("You are not authorized to delete this recipe.");
            }
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("An error occurred: " + e.getMessage());
        }
    }


    @PutMapping("/update/{recipeId}")
    public Recipe updateRecipe(@RequestBody Recipe recipe, @PathVariable Long recipeId, @RequestHeader("Authorization") String jwt) throws Exception {
        User user = userService.findUserByJwt(jwt);
        Recipe existingRecipe = recipeService.findRecipeById(recipeId);

        if (existingRecipe.getUser().getEmail().equals(user.getEmail())) {
            return recipeService.updateRecipe(recipe, recipeId);
        } else {
            throw new Exception("You are not authorized to update this recipe.");
        }
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

    @GetMapping("/{recipeId}/likes")
    public ResponseEntity<List<Long>> getLikes(@PathVariable Long recipeId) {
        try {
            List<Long> likes = recipeService.getLikes(recipeId);
            return ResponseEntity.ok(likes);
        } catch (Exception e) {
            return ResponseEntity.notFound().build();
        }
    }

}
