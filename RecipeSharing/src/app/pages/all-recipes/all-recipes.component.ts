import { Component } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Subscription } from 'rxjs';
import { AuthService } from '../../services/auth/auth.service';
import { RecipeService } from '../../services/recipe/recipe.service';
import { RecipeCardComponent } from "../recipe-card/recipe-card.component";
import { LoaderComponent } from "../../loader/loader.component";

@Component({
  selector: 'app-all-recipes',
  imports: [RecipeCardComponent, LoaderComponent],
  templateUrl: './all-recipes.component.html',
  styleUrl: './all-recipes.component.scss'
})
export class AllRecipesComponent {

    recipes = [];
    private subscriptions: Subscription = new Subscription();
  
    constructor(public dialog: MatDialog, public authService: AuthService, private recipeService: RecipeService) { }
  
    ngOnInit() {
      this.subscriptions.add(
        this.recipeService.getRecipes().subscribe(
          (recipes) => {
            this.recipes = recipes;
          },
        )
      );
      this.subscriptions.add(
        this.recipeService.recipeSubject.subscribe(data => {
          this.recipes = data.recipes;
        })
      );
    }
  
    ngOnDestroy() {
      this.subscriptions.unsubscribe();
    }
  
}
