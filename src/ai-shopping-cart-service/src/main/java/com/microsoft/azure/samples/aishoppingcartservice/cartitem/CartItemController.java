package com.microsoft.azure.samples.aishoppingcartservice.cartitem;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import com.microsoft.azure.samples.aishoppingcartservice.cartitem.exception.CartItemNotFoundException;
import com.microsoft.azure.samples.aishoppingcartservice.cartitem.exception.EmptyCartException;
import com.microsoft.azure.samples.aishoppingcartservice.openai.ShoppingCartAiRecommendations;

@RestController
@RequestMapping("/api/cart-items")
public class CartItemController {
  private static final Logger log = LoggerFactory.getLogger(CartItemController.class);
  private static final String AI_NUTRITION_ANALYSIS_EXCEPTION_MESSAGE = "AI nutrition analysis cannot be performed on an empty cart.";
  private static final String TOP_3_RECIPES_EXEPTION_MESSAGE = "Top 3 recipes cannot be generated for an empty cart.";

  private final CartItemRepository cartItemRepository;
  private final ShoppingCartAiRecommendations shoppingCartAiRecommendations;

  public CartItemController(final CartItemRepository cartItemRepository,
                            final ShoppingCartAiRecommendations shoppingCartAiRecommendations) {
    this.cartItemRepository = cartItemRepository;
    this.shoppingCartAiRecommendations = shoppingCartAiRecommendations;
  }

  @CrossOrigin
  @PostMapping
  @ResponseStatus(HttpStatus.CREATED)
  public CartItem addCartItem(@RequestBody final CartItem cartItem) {
    log.info("Creating cart item: {}", cartItem);
    return this.cartItemRepository.save(cartItem);
  }

  @CrossOrigin
  @GetMapping
  public Iterable<CartItem> getCartItems() {
    log.info("Getting all cart items");
    return this.cartItemRepository.findAll();
  }

  @CrossOrigin
  @PutMapping("/{id}")
  public CartItem updateCartItem(@PathVariable("id") final Long id,
                                 @RequestBody final CartItem cartItem) throws CartItemNotFoundException {
    log.info("Updating cart item: {}", cartItem);
    final CartItem existingCartItem = this.cartItemRepository.findById(id)
        .orElseThrow(() -> new CartItemNotFoundException(id));
    existingCartItem.setName(cartItem.getName());
    existingCartItem.setCategory(cartItem.getCategory());
    existingCartItem.setQuantity(cartItem.getQuantity());
    return this.cartItemRepository.save(existingCartItem);
  }

  @CrossOrigin
  @DeleteMapping("/{id}")
  public void removeCartItem(@PathVariable("id") final Long id) throws CartItemNotFoundException {
    log.info("Deleting cart item with id: {}", id);
    this.cartItemRepository.deleteById(id);
  }

  @CrossOrigin
  @DeleteMapping
  public void removeAllCartItems() {
    log.info("Deleting all cart items");
    this.cartItemRepository.deleteAll();
  }

  @CrossOrigin
  @GetMapping(value = "/ai-nutrition-analysis", produces = "application/json")
  public String getAiNutritionAnalysis() throws EmptyCartException {
    log.info("Getting AI nutrition analysis");
    return this.shoppingCartAiRecommendations.getAINutritionAnalysis(
        getAllCartItems(AI_NUTRITION_ANALYSIS_EXCEPTION_MESSAGE));
  }

  @CrossOrigin
  @GetMapping(value = "/top-3-recipes", produces = "application/json")
  public String getTop3Recipes() throws EmptyCartException {
    log.info("Getting top 3 recipes");
    return this.shoppingCartAiRecommendations.getTop3Recipes(
        getAllCartItems(TOP_3_RECIPES_EXEPTION_MESSAGE));
  }

  private List<CartItem> getAllCartItems(final String exceptionMessage) throws EmptyCartException {
    final List<CartItem> cartItems = this.cartItemRepository.findAll();
    if (cartItems.isEmpty()) {
      throw new EmptyCartException(exceptionMessage);
    }
    return cartItems;
  }
}
