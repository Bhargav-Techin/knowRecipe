import { Component, OnInit, OnDestroy } from '@angular/core';
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
export class AllRecipesComponent implements OnInit, OnDestroy {

  recipes = [];
  isLoading = true;
  private subscriptions: Subscription = new Subscription();

  constructor(public dialog: MatDialog, public authService: AuthService, private recipeService: RecipeService) { }

  ngOnInit() {
    this.fetchRecipes();
    this.subscribeToRecipeUpdates();
  }

  ngOnDestroy() {
    this.subscriptions.unsubscribe();
  }

  fetchRecipes() {
    this.subscriptions.add(
      this.recipeService.getRecipes().subscribe({
        next: (recipes) => {
          this.recipes = recipes;
          this.isLoading = false; // Update loading state after recipes are loaded
        },
        error: (error) => {
          console.error('Error fetching recipes:', error);
          this.isLoading = false; // Update loading state on error
        }
      })
    );
  }

  subscribeToRecipeUpdates() {
    this.subscriptions.add(
      this.recipeService.recipeSubject.subscribe({
        next: (data) => {
          this.recipes = data.recipes;
          // Do not update the isLoading flag here to avoid premature setting
        },
        error: (error) => {
          console.error('Error fetching updated recipes:', error);
        }
      })
    );
  }
}
