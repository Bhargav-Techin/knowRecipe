import { Component, OnInit, OnDestroy } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Subscription } from 'rxjs';
import { AuthService } from '../../services/auth/auth.service';
import { RecipeService } from '../../services/recipe/recipe.service';
import { RecipeCardComponent } from '../recipe-card/recipe-card.component';
import { MatListModule } from '@angular/material/list';
import { LoaderComponent } from "../../loader/loader.component";

@Component({
  selector: 'app-my-recipes',
  imports: [RecipeCardComponent, MatListModule, LoaderComponent],
  templateUrl: './my-recipes.component.html',
  styleUrls: ['./my-recipes.component.scss']
})
export class MyRecipesComponent implements OnInit, OnDestroy {
  recipes = [];
  user: any;
  isLoading = true;
  private subscriptions: Subscription = new Subscription();

  constructor(public dialog: MatDialog, public authService: AuthService, private recipeService: RecipeService) { }

  ngOnInit() {
    this.subscriptions.add(
      this.authService.authSubject.subscribe(data => {
        this.user = data.user;
        if (this.user) {
          this.loadRecipesOfOwner();
        }
      })
    );
  }
  

  ngOnDestroy() {
    this.subscriptions.unsubscribe();
  }

  loadRecipesOfOwner() {
    this.subscriptions.add(
      this.recipeService.getRecipes().subscribe(
        (allRecipes) => {
          this.recipes = allRecipes.filter((recipe: any) => this.isUserOwner(recipe));
          this.isLoading = false;
        },
      )
    );
  }

  isUserOwner(recipe: any): boolean {
    return this.user && this.user.email === recipe.user.email;
  }
}
