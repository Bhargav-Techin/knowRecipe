import { Component, OnInit, OnDestroy } from '@angular/core';
import { RecipeCardComponent } from '../recipe-card/recipe-card.component';
import { CommonModule } from '@angular/common';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { CreateRecipeFormComponent } from '../create-recipe-form/create-recipe-form.component';
import { MatDialog } from '@angular/material/dialog';
import { AuthService } from '../../services/auth/auth.service';
import { NavbarComponent } from "../navbar/navbar.component";
import { RecipeService } from '../../services/recipe/recipe.service';
import { Subscription } from 'rxjs';
import { FooterComponent } from '../footer/footer.component';

@Component({
  selector: 'app-home-page',
  standalone: true,
  imports: [RecipeCardComponent, MatIconModule, MatButtonModule, NavbarComponent, FooterComponent],
  templateUrl: './home-page.component.html',
  styleUrls: ['./home-page.component.scss'],
})
export class HomePageComponent implements OnInit, OnDestroy {
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

  openDialog() {
    const dialogRef = this.dialog.open(CreateRecipeFormComponent);
  
    dialogRef.afterClosed().subscribe(result => {
      if (result) {
        this.recipeService.getRecipes().subscribe();
      }
    });
  }
  


}
