package com.microsoft.azure.samples.aishoppingcartservice.cartitem.exception;

public class EmptyCartException extends Exception {
  public EmptyCartException(final String message) {
    super(message);
  }
}
