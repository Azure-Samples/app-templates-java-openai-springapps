import { Button, Form, FormControl, InputGroup } from 'react-bootstrap';

import { CartItem } from '../models';
import { capitalizeFirstLetter } from '../utils/stringUtils';

interface AddItemFormProps {
  addItemCallback: (item: CartItem) => void;
}

export const AddItemForm = ({ addItemCallback }: AddItemFormProps) => {
  const handleOnSubmit = (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    const form = event.target as HTMLFormElement;
    const nameOfItemToAdd = form.elements.namedItem('nameOfItemToAdd') as HTMLInputElement;
    const quantityOfItemToAdd = form.elements.namedItem('quantityOfItemToAdd') as HTMLInputElement;
    const item: CartItem = {
      name: capitalizeFirstLetter(nameOfItemToAdd.value),
      category: 'unknown',
      quantity: quantityOfItemToAdd.valueAsNumber
    };
    addItemCallback(item);
    nameOfItemToAdd.value = '';
    quantityOfItemToAdd.value = '1';
  };

  return (
    <Form onSubmit={handleOnSubmit}>
      <InputGroup>
        <FormControl name='nameOfItemToAdd' aria-label='Item name' placeholder='Item name' />
        <InputGroup.Text>x</InputGroup.Text>
        <FormControl type='number' name='quantityOfItemToAdd' aria-label='Item quantity' placeholder='Item quantity' defaultValue={1} style={{ maxWidth: '60px'}} />
        <Button type='submit' variant='outline-secondary'><i className='bi bi-cart-plus'></i></Button>
      </InputGroup>
    </Form>
  );
}