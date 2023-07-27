/**
 * Capitalize the first letter of a string and lowercase the rest
 * 
 * @param str string to capitalize
 * @returns string with the first letter capitalized and the rest lowercase
 * @example
 * capitalizeFirstLetter('hello') // Hello
 * capitalizeFirstLetter('HELLO') // Hello
 */
export const capitalizeFirstLetter = (str: string) => {
  return str.charAt(0).toUpperCase() + str.slice(1).toLowerCase();
}