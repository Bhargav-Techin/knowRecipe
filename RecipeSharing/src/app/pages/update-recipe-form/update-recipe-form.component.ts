import { ChangeDetectionStrategy, Component, inject, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, FormsModule, ReactiveFormsModule, Validators } from '@angular/forms';
import { MatDialogRef, MatDialogActions, MatDialogClose, MatDialogTitle, MatDialogContent, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatSelectModule } from '@angular/material/select';
import { MatButtonModule } from '@angular/material/button';
import { RecipeService } from '../../services/recipe/recipe.service';
import { SnackbarService } from '../../services/snackbar/snackbar.service';
import { Subscription } from 'rxjs';
import { AuthService } from '../../services/auth/auth.service';
import { LoaderService } from '../../services/loader/loader.service'; // ✅ Import LoaderService

@Component({
  selector: 'app-update-recipe-form',
  standalone: true,
  imports: [MatButtonModule, MatDialogActions, MatDialogClose, MatDialogTitle, MatDialogContent, MatFormFieldModule, MatInputModule, MatSelectModule, FormsModule, ReactiveFormsModule],
  templateUrl: './update-recipe-form.component.html',
  styleUrls: ['./update-recipe-form.component.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class UpdateRecipeFormComponent implements OnInit {
  recipeForm: FormGroup | any;
  recipeData = inject(MAT_DIALOG_DATA);
  user: any;
  private subscriptions: Subscription = new Subscription();

  constructor(
    private fb: FormBuilder,
    public dialogRef: MatDialogRef<UpdateRecipeFormComponent>,
    private recipeService: RecipeService,
    private authService: AuthService,
    private snackbar: SnackbarService,
    private loaderService: LoaderService // ✅ Inject LoaderService
  ) { }

  ngOnInit(): void {
    this.recipeForm = this.fb.group({
      id: this.recipeData.id,
      title: [this.recipeData.title, Validators.required],
      veg: [JSON.stringify(this.recipeData.veg), Validators.required],
      image: [this.recipeData.image, Validators.required],
      description: [this.recipeData.description, [Validators.required, Validators.maxLength(500)]]
    });

    this.subscriptions.add(
      this.authService.authSubject.subscribe(data => {
        this.user = data.user;
      })
    );
  }

  isUserOwner(): boolean {
    return this.user && this.user.email === this.recipeData.user.email;
  }

  onSubmitUpdateRecipe(): void {
    if (this.isUserOwner()) {
      if (this.recipeForm.valid) {
        const updatedRecipe = this.recipeForm.value;

        const isTitleUnchanged = updatedRecipe.title === this.recipeData.title;
        const isDescriptionUnchanged = updatedRecipe.description === this.recipeData.description;
        const isVegUnchanged = updatedRecipe.veg === this.recipeData.veg.toString(); // Convert to string for comparison
        const isImageUnchanged = updatedRecipe.image === this.recipeData.image;

        const isUnchanged = isTitleUnchanged && isDescriptionUnchanged && isVegUnchanged && isImageUnchanged;

        if (isUnchanged) {
          this.snackbar.show('No changes detected in the recipe.', 'Close', 'info-snackbar');
        } else {
          this.dialogRef.close(true);
          this.loaderService.show(); // ✅ Show Loader before making API request
          this.recipeService.updateRecipe(updatedRecipe).subscribe({
            next: () => {
              this.loaderService.hide(); // ✅ Hide Loader after success
              this.snackbar.show('Recipe updated successfully!', 'Close', 'success-snackbar');
            },
            error: (err: any) => {
              this.loaderService.hide(); // ✅ Hide Loader on error
              this.snackbar.show('Failed to update recipe. ' + err.error.error, 'Close', 'error-snackbar');
              console.error("Error details:", err.error);
            }
          });
        }
      }
    } else {
      this.snackbar.show('You are not authorized to update this recipe!', 'Close', 'error-snackbar');
    }
  }
}
