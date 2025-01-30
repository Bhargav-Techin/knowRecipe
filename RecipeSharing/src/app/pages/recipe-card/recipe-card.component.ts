import { Component, Input, OnInit, OnDestroy, inject } from '@angular/core';
import { MatButtonModule } from '@angular/material/button';
import { MatCardModule } from '@angular/material/card';
import { MatIcon } from '@angular/material/icon';
import { UpdateRecipeFormComponent } from '../update-recipe-form/update-recipe-form.component';
import { MatDialog } from '@angular/material/dialog';
import { CommonModule } from '@angular/common';
import { RecipeService } from '../../services/recipe/recipe.service';
import { AuthService } from '../../services/auth/auth.service';
import { Subscription } from 'rxjs';

@Component({
  selector: 'app-recipe-card',
  standalone: true,
  imports: [MatCardModule, MatButtonModule, MatIcon, CommonModule],
  templateUrl: './recipe-card.component.html',
  styleUrls: ['./recipe-card.component.scss']
})
export class RecipeCardComponent implements OnInit, OnDestroy {
  @Input() recipe: any;
  user: any;
  dialog = inject(MatDialog);
  private subscriptions: Subscription = new Subscription();

  constructor( private authService: AuthService, private recipeService: RecipeService) { }

  ngOnInit(): void {
    this.subscriptions.add(
      this.authService.authSubject.subscribe(data => {
        this.user = data.user;
      })
    );
  }

  ngOnDestroy() {
    this.subscriptions.unsubscribe();
  }

  openDialog() {
      this.dialog.open(UpdateRecipeFormComponent, {
        data:  this.recipe
      });
    
  }

  isUserOwner(): boolean {
    return this.user && this.user.email === this.recipe.user.email;
  }

  ondelete() {
    if (confirm('Are you sure you want to delete the recipe?')) {
      if (this.isUserOwner()) {
        this.recipeService.deleteRecipe(this.recipe.id).subscribe(
          (response) => {
            console.log('Recipe deleted:', response);
          },
          (error) => {
            console.error('Error deleting recipe:', error);
          }
        );
      } else {
        alert('You are not authorized to delete this recipe.');
      }
    }
  }

}
