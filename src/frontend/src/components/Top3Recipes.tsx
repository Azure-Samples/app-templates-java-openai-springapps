import React from 'react';

import { Status } from '../models';
import { Error, Loader, NutriscoreBar } from '.';
import { Card } from 'react-bootstrap';
import { API_URL } from '../config';

interface RecipesProps {
}

interface Recipe {
  name: string;
  ingredients: Array<string>;
  instructions: Array<string>;
  nutriscore: string;
}

interface RecipesState {
  recipes: Array<Recipe>;
  status: Status;
  errorMessage?: string;
}

export class Top3Recipes extends React.Component<RecipesProps, RecipesState> {
  state: RecipesState = {
    recipes: [] as Array<Recipe>,
    status: Status.LOADING,
  };

  componentDidMount(): void {
    fetch(`${API_URL}/api/cart-items/top-3-recipes`)
      .then((response) => response.json())
      .then((data) => this.setState({
        recipes: data.recipes,
        status: Status.LOADED
      }))
      .catch((error) => this.setState({
        recipes: [] as Array<Recipe>,
        status: Status.ERROR,
        errorMessage: error.message,
      }));
  }

  getRecipeHtml(recipe: Recipe): JSX.Element {
    return (
      <Card key={recipe.name} className='mt-3'>
        <Card.Body>
          <Card.Title>{recipe.name}</Card.Title>
          <NutriscoreBar nutriscore={recipe.nutriscore} />
          <h5>Ingredients</h5>
          <ul>{recipe.ingredients.map((ingredient) => <li>{ingredient}</li>)}</ul>
          <h5>Instructions</h5>
          {recipe.instructions.map((instruction) => <Card.Text>{instruction}</Card.Text>)}
        </Card.Body>
      </Card>
    );
  }

  getHtmlForRecipes(): Array<JSX.Element> {
    return this.state.recipes.map((recipe) => this.getRecipeHtml(recipe));
  }

  render() {
    const { status } = this.state;
    return (
      <Card className='mb-3'>
        <Card.Body>
          <Card.Title>Top 3 Recipes</Card.Title>
          {status === Status.LOADING && <Loader />}
          {status === Status.ERROR && <Error errorMessage={this.state.errorMessage} />}
          {status === Status.LOADED && this.getHtmlForRecipes()}
        </Card.Body>
      </Card>
    );
  }
}