package com.microsoft.azure.samples.aishoppingcartservice.cartitem;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;

@Entity
public class CartItem {
  @Id
  @GeneratedValue(strategy = GenerationType.AUTO)
  private long id;
  private String name;
  private String category;
  private int quantity;

  public CartItem() {
  }

  public CartItem(final String name, final String category, final int quantity) {
    this.name = name;
    this.category = category;
    this.quantity = quantity;
  }

  public long getId() {
    return this.id;
  }

  public String getName() {
    return this.name;
  }

  public String getCategory() {
    return this.category;
  }

  public int getQuantity() {
    return this.quantity;
  }

  public void setId(final long id) {
    this.id = id;
  }

  public void setName(final String name) {
    this.name = name;
  }

  public void setCategory(final String category) {
    this.category = category;
  }

  public void setQuantity(final int quantity) {
    this.quantity = quantity;
  }

  @Override
  public String toString() {
    return String.format(
        "CartItem[id=%d, name='%s', category='%s', quantity='%d']",
        this.id,
        this.name,
        this.category,
        this.quantity
    );
  }
}
