import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable, tap } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class RecipeService {

  private baseURL: string = 'http://localhost:5454';

  constructor(private http: HttpClient) { }

  recipeSubject = new BehaviorSubject<any>({
    recipes: [],
    loading: false,
    newRecipe: null
  });

  private getHeaders(): HttpHeaders {
    const token = new HttpHeaders({
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${localStorage.getItem('jwt')}`
    });
    return token;
  }

  getRecipes(): Observable<any> {
    const headers = this.getHeaders();
    return this.http.get(`${this.baseURL}/api/recipes`, { headers }).pipe(
      tap((recipes) => {
        const currentState = this.recipeSubject.value;
        this.recipeSubject.next({ ...currentState, recipes, loading: false });
      })
    );
}


  createRecipe(recipe: any): Observable<any> {
    const headers = this.getHeaders();
    return this.http.post(`${this.baseURL}/api/recipes`, recipe, { headers }).pipe(
      tap((newRecipe) => {
        const currentState = this.recipeSubject.value;
        this.recipeSubject.next({ ...currentState, recipes: [newRecipe, ...currentState.recipes] });
      })
    );
  }

  updateRecipe(recipe: any): Observable<any> {
    const headers = this.getHeaders();
    return this.http.put(`${this.baseURL}/api/recipes/update/${recipe.id}`, recipe, { headers }).pipe(
      tap((updatedRecipe: any) => {
        const currentState = this.recipeSubject.value;
        const updatedRecipes = currentState.recipes.map((item: any) => item.id === updatedRecipe.id ? updatedRecipe : item);
        this.recipeSubject.next({ ...currentState, recipes: updatedRecipes });
      })
    );
  }

  deleteRecipe(id: any): Observable<any> {
    const headers = this.getHeaders();
    return this.http.delete(`${this.baseURL}/api/recipes/${id}`, { headers, responseType: 'text' }).pipe(
      tap(() => {
        const currentState = this.recipeSubject.value;
        const updatedRecipes = currentState.recipes.filter((item: any) => item.id !== id);
        this.recipeSubject.next({ ...currentState, recipes: updatedRecipes });
      })
    );
  }
  

  likeRecipe(id: any): Observable<any> {
    const headers = this.getHeaders();
    return this.http.put(`${this.baseURL}/api/recipe/${id}/like`, {}, { headers }).pipe(
      tap((likedRecipe: any) => {
        const currentState = this.recipeSubject.value;
        const updatedRecipes = currentState.recipes.map((item: any) => item.id === likedRecipe.id ? likedRecipe : item);
        this.recipeSubject.next({ ...currentState, recipes: updatedRecipes });
      })
    );
  }
}
