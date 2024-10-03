package Recipe.dev.KnowRecipe.controller;

import Recipe.dev.KnowRecipe.model.User;
import Recipe.dev.KnowRecipe.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
public class UserController {

    @Autowired
    private UserRepository userRepository;

    @PostMapping("/users")
    public User createUser(@RequestBody User user) throws Exception{
        User isExist=userRepository.findByEmail(user.getEmail());
        if (isExist!=null){
            throw new Exception("email is already exist!!");
        }

        User savedUser = userRepository.save(user);
        return savedUser;
    }

    @DeleteMapping("/users/{userId}")
    public String deleteUser(@PathVariable Long userId) throws Exception{

        Optional<User> isExist=userRepository.findById(userId);
        if (isExist.isEmpty()){
            throw new Exception("no user with this id");
        }
        userRepository.deleteById(userId);
        return "User deleted successfully";
    }
}
