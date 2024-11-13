package Recipe.dev.KnowRecipe.controller;

import Recipe.dev.KnowRecipe.model.User;
import Recipe.dev.KnowRecipe.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;


@RestController
public class UserController {

    @Autowired
    private UserService userService;

    @PostMapping("/api/users")
    public User createUser(@RequestBody User user) throws Exception{
        return userService.createUser(user);
    }

    @GetMapping("api/user/{userId}")
    public User findUserById(@PathVariable Long userId) throws Exception{
        return userService.findUserById(userId);
    }

    @DeleteMapping("/api/users/{userId}")
    public String deleteUser(@PathVariable Long userId) throws Exception{
        return userService.deleteUser(userId);
    }
}
