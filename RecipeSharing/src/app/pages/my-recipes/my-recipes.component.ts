import { Component, Input, OnInit, OnDestroy } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Subscription } from 'rxjs';
import { AuthService } from '../../services/auth/auth.service';
import { RecipeService } from '../../services/recipe/recipe.service';
import { RecipeCardComponent } from '../recipe-card/recipe-card.component';
import { MatListModule } from '@angular/material/list';

@Component({
  selector: 'app-my-recipes',
  imports: [RecipeCardComponent, MatListModule],
  templateUrl: './my-recipes.component.html',
  styleUrls: ['./my-recipes.component.scss']
})
export class MyRecipesComponent implements OnInit, OnDestroy {
  recipes = [];
  user: any;
  private subscriptions: Subscription = new Subscription();

  constructor(public dialog: MatDialog, public authService: AuthService, private recipeService: RecipeService) { }

  ngOnInit() {
    this.subscriptions.add(
      this.authService.authSubject.subscribe(data => {
        this.user = data.user;
        this.loadUserRecipes();
      })
    );

    this.subscriptions.add(
      this.recipeService.recipeSubject.subscribe(data => {
        this.recipes = data.recipes.filter((recipe: any)  => this.isUserOwner(recipe));
      })
    );
  }

  ngOnDestroy() {
    this.subscriptions.unsubscribe();
  }

  loadUserRecipes() {
    this.subscriptions.add(
      this.recipeService.getRecipes().subscribe(
        (recipes) => {
          this.recipes = recipes.filter((recipe: any) => this.isUserOwner(recipe));
        },
      )
    );
  }

  isUserOwner(recipe: any): boolean {
    return this.user && this.user.email === recipe.user.email;
  }
}
