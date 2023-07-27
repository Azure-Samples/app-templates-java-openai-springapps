import React, { ReactElement } from 'react';
import { ListGroup } from 'react-bootstrap';

import { CartItem, Status } from '../models';
import { AddItemForm, Error, Item, Loader } from '../components';
import { API_URL } from '../config';

interface ItemListProps {
  /**
   * Callback function to be called when the cart changes to inform the parent component.
   * 
   * @param isCartEmpty - true if the cart is empty, false otherwise
   */
  handleCartChangeCallback: (isCartEmpty: boolean) => void;
}

interface ItemListState {
  items: Array<CartItem>;
  status: Status;
  errorMessage?: string;
}

export class ItemList extends React.Component<ItemListProps, ItemListState> {
  state: ItemListState = {
    items: [] as Array<CartItem>,
    status: Status.LOADING,
  };

  componentDidMount(): void {
    fetch(`${API_URL}/api/cart-items`)
      .then((response) => response.json())
      .then((items) => {
        this.setState({
          items: items,
          status: Status.LOADED
        });
        this.props.handleCartChangeCallback(items.length === 0);
      })
      .catch((error) => this.setState({
        items: [],
        status: Status.ERROR,
        errorMessage: error.message,
      }));
  }

  public addItemToShoppingCart(item: CartItem): void {
    fetch(`${API_URL}/api/cart-items`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(item),
    })
      .then((response) => response.json())
      .then((item) => {
        this.setState({
          items: [
            ...this.state.items,
            item
          ],
          status: Status.LOADED
        });
        this.props.handleCartChangeCallback(false);
      })
      .catch((error) => this.setState({
        items: [],
        status: Status.ERROR,
        errorMessage: error.message,
      }));
  }

  public updateItemInShoppingCart(item: CartItem): void {
    fetch(`${API_URL}/api/cart-items/${item.id}`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(item),
    })
      .then((response) => response.json())
      .then((item) => {
        let items = this.state.items.map((i) => i.id === item.id ? item : i);
        this.setState({
          items: items,
          status: Status.LOADED
        });
        this.props.handleCartChangeCallback(false);
      })
      .catch((error) => this.setState({
        items: [],
        status: Status.ERROR,
        errorMessage: error.message,
      }));
  }

  public removeItemFromShoppingCart(item: CartItem): void {
    fetch(`${API_URL}/api/cart-items/${item.id}`, {
      method: 'DELETE'
    })
      .then((response) => response.text())
      .then((text) => {
        let items = this.state.items.filter((i) => i.id !== item.id);
        this.setState({
          items: items,
          status: Status.LOADED
        });
        this.props.handleCartChangeCallback(items.length === 0);
      })
      .catch((error) => this.setState({
        items: [],
        status: Status.ERROR,
        errorMessage: error.message,
      }));
  }
        
  public clearShoppingCart(): void {
    fetch(`${API_URL}/api/cart-items`, {
      method: 'DELETE',
    })
      .then((response) => response.text())
      .then((text) => {
        this.setState({
          items: [],
          status: Status.LOADED
        });
        this.props.handleCartChangeCallback(true);
      })
      .catch((error) => this.setState({
        items: [],
        status: Status.ERROR,
        errorMessage: error.message,
      }));
  }

  render() {
    const { items, status } = this.state;
    return (
      <ListGroup style={{ width: '100%' }}>
        {status === Status.LOADING && <Loader />}
        {status === Status.ERROR && <Error errorMessage={this.state.errorMessage} />}
        {status === Status.LOADED &&
          <ListGroup style={{ width: '100%' }}>
            {items.length === 0 && <ListGroup.Item>Shopping cart is empty.</ListGroup.Item>}
            {items.map((item: CartItem): ReactElement => (
              <Item 
                key={item.id} 
                item={item}
                updateItemCallback={this.updateItemInShoppingCart.bind(this)}
                deleteItemCallback={this.removeItemFromShoppingCart.bind(this)} />
            ))}
            <ListGroup.Item>
              <AddItemForm addItemCallback={this.addItemToShoppingCart.bind(this)} />
            </ListGroup.Item>
          </ListGroup>
        }
      </ListGroup>
    );
  }
}
