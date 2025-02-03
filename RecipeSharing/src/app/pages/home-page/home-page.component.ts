import { Component } from '@angular/core';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { CreateRecipeFormComponent } from '../create-recipe-form/create-recipe-form.component';
import { MatDialog } from '@angular/material/dialog';
import { AuthService } from '../../services/auth/auth.service';
import { NavbarComponent } from "../navbar/navbar.component";
import { RecipeService } from '../../services/recipe/recipe.service';
import { Subscription } from 'rxjs';
import { FooterComponent } from '../footer/footer.component';
import { RouterOutlet } from '@angular/router';

@Component({
  selector: 'app-home-page',
  standalone: true,
  imports: [MatIconModule, MatButtonModule, NavbarComponent, FooterComponent, RouterOutlet],
  templateUrl: './home-page.component.html',
  styleUrls: ['./home-page.component.scss'],
})
export class HomePageComponent {

  constructor(public dialog: MatDialog, public authService: AuthService, private recipeService: RecipeService) { }


  openDialog() {
    const dialogRef = this.dialog.open(CreateRecipeFormComponent);
  
    dialogRef.afterClosed().subscribe(result => {
      if (result) {
        this.recipeService.getRecipes().subscribe();
      }
    });
  }
  


}
