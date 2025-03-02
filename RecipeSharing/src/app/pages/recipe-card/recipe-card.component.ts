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
import { SnackbarService } from '../../services/snackbar/snackbar.service';
import { LoaderService } from '../../services/loader/loader.service';
import {MatProgressSpinnerModule} from '@angular/material/progress-spinner';

@Component({
  selector: 'app-recipe-card',
  standalone: true,
  imports: [MatCardModule, MatButtonModule, MatIcon, CommonModule, MatProgressSpinnerModule],
  templateUrl: './recipe-card.component.html',
  styleUrls: ['./recipe-card.component.scss']
})
export class RecipeCardComponent implements OnInit, OnDestroy {

  @Input() recipe: any;
  user: any;
  dialog = inject(MatDialog);
  private subscriptions: Subscription = new Subscription();
  isFavorite: boolean = false;
  likeNumber: number = 0;

  constructor( private authService: AuthService, private recipeService: RecipeService, private snackbar: SnackbarService, private loaderService: LoaderService) { }

  ngOnInit(): void {
    this.subscriptions.add(
      this.authService.authSubject.subscribe(data => {
        this.user = data.user;
      })
    );

    this.recipeService.getLikes(this.recipe.id).subscribe((likes) => {
      this.isFavorite = likes.includes(this.user.id);
      this.likeNumber = likes.length;
    });
  }

  ngOnDestroy() {
    this.subscriptions.unsubscribe();
  }

  openDialog() {
    this.dialog.open(UpdateRecipeFormComponent, {
      data: this.recipe
    });
  }

  isUserOwner(): boolean {
    return this.user && this.user.email === this.recipe.user.email;
  }

  toggleFavorite() {
    this.loaderService.show();
    this.recipeService.likeRecipe(this.recipe.id).subscribe(
      (likedRecipe: any) => {
        this.isFavorite = likedRecipe.likes.includes(this.user.id);
        this.likeNumber = likedRecipe.likes.length;
        this.loaderService.hide(); // Hide Loader after success
      },
      (error) => {
        this.loaderService.hide(); // Hide Loader on error
        this.snackbar.show('Failed to like the recipe. Please try again.' + error.error, 'Close', 'error-snackbar');
      }
    );
  }

  ondelete() {
    if (confirm('Are you sure you want to delete the recipe?')) {
      if (this.isUserOwner()) {
        this.loaderService.show(); // Show Loader before deleting recipe
        this.recipeService.deleteRecipe(this.recipe.id).subscribe(
          (response) => {
            this.loaderService.hide(); // Hide Loader after deleting recipe
            this.snackbar.show(response, 'Close', 'success-snackbar');
          },
          (error) => {
            this.loaderService.hide(); // Hide Loader on error
            this.snackbar.show('Failed to delete the recipe. Please try again.' + error.error, 'Close', 'error-snackbar');
          }
        );
      } else {
        alert('You are not authorized to delete this recipe.');
      }
    }
  }
}
