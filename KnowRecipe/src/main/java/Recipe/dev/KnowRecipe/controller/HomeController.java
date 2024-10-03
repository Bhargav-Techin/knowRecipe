package Recipe.dev.KnowRecipe.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HomeController {

    @GetMapping
    public String homeController(){
        return "Wellcome Bhargav!!";
    }
}
