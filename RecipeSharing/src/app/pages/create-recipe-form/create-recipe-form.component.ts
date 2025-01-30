import { ChangeDetectionStrategy, Component, OnInit, inject } from '@angular/core';
import { FormBuilder, FormGroup, FormsModule, ReactiveFormsModule, Validators } from '@angular/forms';
import { MatDialogRef, MatDialogActions, MatDialogClose, MatDialogTitle, MatDialogContent } from '@angular/material/dialog';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatSelectModule } from '@angular/material/select';
import { MatButtonModule } from '@angular/material/button';
import { RecipeService } from '../../services/recipe/recipe.service';
import { SnackbarService } from '../../services/snackbar/snackbar.service';

@Component({
  selector: 'app-create-recipe-form',
  standalone: true,
  imports: [MatButtonModule, MatDialogActions, MatDialogClose, MatDialogTitle, MatDialogContent, MatFormFieldModule, MatInputModule, MatSelectModule, FormsModule, ReactiveFormsModule],
  templateUrl: './create-recipe-form.component.html',
  styleUrls: ['./create-recipe-form.component.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class CreateRecipeFormComponent implements OnInit {
  recipeForm: FormGroup | any;

  constructor(
    private fb: FormBuilder,
    public dialogRef: MatDialogRef<CreateRecipeFormComponent>,
    private recipeService: RecipeService,
    private snackbar: SnackbarService
  ) {}

  ngOnInit(): void {
    this.recipeForm = this.fb.group({
      title: ['', Validators.required],
      veg: ['', Validators.required],
      image: ['', Validators.required],
      description: ['', [Validators.required, Validators.maxLength(500)]]
    });
  }

  onSubmitCreateRecipe(): void {
    if (this.recipeForm.valid) {
      this.recipeService.createRecipe(this.recipeForm.value).subscribe({
        next: () => {
          this.snackbar.show('Recipe created successfully!', 'Close', 'success-snackbar');
          this.dialogRef.close(true);
        },
        error: (err: any) => {
          this.snackbar.show('Failed to create recipe. ' + err.error.error, 'Close', 'error-snackbar');
          console.error("Error details:", err.error);
        }
      });
    }
  }
}
