package com.microsoft.azure.samples.aishoppingcartservice.cartitem.exception;

public class CartItemNotFoundException extends Exception {
  public CartItemNotFoundException(final Long id) {
    super("Could not find cart item " + id);
  }
}
