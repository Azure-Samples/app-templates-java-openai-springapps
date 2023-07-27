/**
 * Generates a random id
 * 
 * @param prefix Prefix to add to the id
 * @returns A random id
 * @example
 * generateId('prefix-') // prefix-3j4h5j6
 * generateId() // 3j4h5j6
 */
export const generateId = (prefix: string = ''): string => {
  const id = Math.random().toString(36).substring(2, 9);;
  return `${prefix}${id}`;
}