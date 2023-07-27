import React from 'react';
import { Badge, Button, Form, FormControl, InputGroup, ListGroup } from 'react-bootstrap';

import { CartItem } from '../models';
import { capitalizeFirstLetter } from '../utils/stringUtils';

interface ItemProps {
  item: CartItem;
  updateItemCallback: (item: CartItem) => void;
  deleteItemCallback: (item: CartItem) => void;
}

interface ItemState {
  isMouseOver: boolean;
}

export class Item extends React.Component<ItemProps, ItemState> {
  state: ItemState = {
    isMouseOver: false
  };

  handleOnMouseEnter(event: React.MouseEvent<HTMLLIElement, MouseEvent>) {
    event.preventDefault();
    event.currentTarget.style.backgroundColor = '#e9ecef';
    this.setState({ isMouseOver: true });
  }

  handeOnMouseLeave(event: React.MouseEvent<HTMLLIElement, MouseEvent>) {
    event.preventDefault();
    event.currentTarget.style.backgroundColor = 'white';
    this.setState({ isMouseOver: false });
  }

  handleOnClickOnTrash(event: React.MouseEvent<HTMLSpanElement, MouseEvent>) {
    event.preventDefault();
    this.props.deleteItemCallback(this.props.item);
  }

  handleOnSubmit(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault();
    this.setState({ isMouseOver: false });
    const form = event.target as HTMLFormElement;
    const nameOfItemToAdd = form.elements.namedItem('nameOfItemToAdd') as HTMLInputElement;
    const quantityOfItemToAdd = form.elements.namedItem('quantityOfItemToAdd') as HTMLInputElement;
    const item: CartItem = {
      id: this.props.item.id,
      name: capitalizeFirstLetter(nameOfItemToAdd.value),
      category: this.props.item.category,
      quantity: quantityOfItemToAdd.valueAsNumber
    };
    this.props.updateItemCallback(item);
  }

  render() {
    const { item } = this.props;
    const { isMouseOver } = this.state;
    return (
      <ListGroup.Item key={item.id} onMouseEnter={this.handleOnMouseEnter.bind(this)} onMouseLeave={this.handeOnMouseLeave.bind(this)}>
        {!isMouseOver && capitalizeFirstLetter(item.name)}
        <Badge className='float-end' hidden={isMouseOver}>{item.quantity}</Badge>
        <Form onSubmit={this.handleOnSubmit.bind(this)} hidden={!isMouseOver}>
          <InputGroup>
            <FormControl name='nameOfItemToAdd' aria-label='Item name' placeholder='Item name' defaultValue={item.name} />
            <InputGroup.Text>x</InputGroup.Text>
            <FormControl type='number' name='quantityOfItemToAdd' aria-label='Item quantity' placeholder='Item quantity' defaultValue={item.quantity} style={{ maxWidth: '60px'}} />
            <Button type='submit' variant='outline-secondary'><i className='bi bi-cart-check'></i></Button>
            <Button
              variant='outline-secondary'
              onClick={this.handleOnClickOnTrash.bind(this)}>
                <i className='bi bi-trash3'></i>
            </Button>
          </InputGroup>
        </Form>
      </ListGroup.Item>
    );
  }
}