/**
 * CartItem interface
 * 
 * @description CartItem interface defines the structure of the cart item
 * @export
 * @interface CartItem
 * @property {number} id - unique id for the item
 * @property {string} name - name of the item
 * @property {string} category - category of the item
 * @property {number} quantity - quantity of the item
 */
export interface CartItem {
  id?: number;
  name: string;
  category: string;
  quantity: number;
}