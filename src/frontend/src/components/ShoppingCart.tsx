import React from 'react';
import { Button, ButtonGroup, ButtonToolbar, Container } from 'react-bootstrap';
import { ItemList, AiNutritionAnalysis, Top3Recipes } from '../components';

interface ShoppingCartProps {
};

enum DisplaySmartRecommendation {
  NONE,
  AI_NUTRITION_ANALYSIS,
  RECIPES
}

interface ShoppingCartState {
  displaySmartRecommendation: DisplaySmartRecommendation;
  disableToolbar: boolean;
};

export class ShoppingCart extends React.Component<ShoppingCartProps, ShoppingCartState> {
  state: ShoppingCartState = {
    displaySmartRecommendation: DisplaySmartRecommendation.NONE as DisplaySmartRecommendation,
    disableToolbar: true
  };

  private itemList: ItemList | null = null;

  public handleCartChange = (isCartEmpty: boolean): void => {
    if (isCartEmpty) {
      this.setState({
        ...this.state,
        displaySmartRecommendation: DisplaySmartRecommendation.NONE,
        disableToolbar: true
      });
    } else {
      this.setState({
        ...this.state,
        displaySmartRecommendation: DisplaySmartRecommendation.NONE,
        disableToolbar: false
      });
    }
  }

  displayNutriscore = (event: React.MouseEvent<HTMLButtonElement, MouseEvent>): void => {
    this.setState({
      ...this.state,
      displaySmartRecommendation: DisplaySmartRecommendation.AI_NUTRITION_ANALYSIS
    });
  }

  displayRecipes = (event: React.MouseEvent<HTMLButtonElement, MouseEvent>): void => {
    this.setState({
      ...this.state,
      displaySmartRecommendation: DisplaySmartRecommendation.RECIPES
    });
  }

  clearShoppingCart = (event: React.MouseEvent<HTMLButtonElement, MouseEvent>): void => {
    if (this.itemList) {
      this.itemList.clearShoppingCart();
    }
  }

  render() {
    const { displaySmartRecommendation, disableToolbar } = this.state;
    return (
      <>
      <ButtonToolbar className='justify-content-end' style={{ maxWidth: '600px', marginTop: '2em', padding: '0' }}>
        <Button variant='light' onClick={this.clearShoppingCart} disabled={disableToolbar}><i className='bi bi-cart-x'></i></Button>
        <ButtonGroup style={{ marginLeft: '0.5em' }}>
          <Button variant='light' onClick={this.displayNutriscore} disabled={disableToolbar}><i className='bi bi-clipboard-data'></i></Button>
          <Button variant='light' onClick={this.displayRecipes} disabled={disableToolbar}><i className='bi bi-robot'></i></Button>
        </ButtonGroup>
      </ButtonToolbar>
      <Container style={{ maxWidth: '600px', marginTop: '1em', padding: '0' }} className='d-flex align-items-center justify-content-center'>
        <ItemList ref={instance => this.itemList = instance} handleCartChangeCallback={this.handleCartChange} />
      </Container>
      <Container style={{ maxWidth: '600px', marginTop: '1em', padding: '0' }}>
        {displaySmartRecommendation === DisplaySmartRecommendation.AI_NUTRITION_ANALYSIS && <AiNutritionAnalysis />}
        {displaySmartRecommendation === DisplaySmartRecommendation.RECIPES && <Top3Recipes />}
      </Container>
      </>
    );
  }
}
