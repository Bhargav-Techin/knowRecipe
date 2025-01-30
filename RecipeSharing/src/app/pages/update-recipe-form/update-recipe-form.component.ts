import { ChangeDetectionStrategy, Component, inject, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, FormsModule, ReactiveFormsModule, Validators } from '@angular/forms';
import { MatDialogRef, MatDialogActions, MatDialogClose, MatDialogTitle, MatDialogContent, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatSelectModule } from '@angular/material/select';
import { MatButtonModule } from '@angular/material/button';

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

  constructor(private fb: FormBuilder) { }

  ngOnInit(): void {
    this.recipeForm = this.fb.group({
      title: [this.recipeData.title, Validators.required],
      veg: [false, Validators.required],
      image: [this.recipeData.image, Validators.required],
      description: [this.recipeData.description, Validators.required]
    });
  }

  onSubmit(): void {
    if (this.recipeForm.valid) {
      console.log(this.recipeForm.value);
    }
  }
}
