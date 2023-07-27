package com.microsoft.azure.samples.aishoppingcartservice.openai;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import com.azure.ai.openai.OpenAIClient;
import com.azure.ai.openai.OpenAIClientBuilder;
import com.azure.ai.openai.models.ChatChoice;
import com.azure.ai.openai.models.ChatCompletions;
import com.azure.ai.openai.models.ChatCompletionsOptions;
import com.azure.ai.openai.models.ChatMessage;
import com.azure.ai.openai.models.ChatRole;
import com.azure.core.credential.AzureKeyCredential;

import com.microsoft.azure.samples.aishoppingcartservice.cartitem.CartItem;

public class ShoppingCartAiRecommendations {
  private static final String THE_BASKET_IS = "The basket is: ";

  private final OpenAIClient openAIClient;
  private final String azureOpenAiModelDeploymentId;
  private final double temperature;
  private final double topP;

  public ShoppingCartAiRecommendations(final String azureOpenAiApiKey,
                                       final String azureOpenAiEndpoint,
                                       final String azureOpenAiModelDeploymentId,
                                       final double temperature,
                                       final double topP) {
    this.openAIClient = new OpenAIClientBuilder()
        .credential(new AzureKeyCredential(azureOpenAiApiKey))
        .endpoint(azureOpenAiEndpoint)
        .buildClient();
    this.azureOpenAiModelDeploymentId = azureOpenAiModelDeploymentId;
    this.temperature = temperature;
    this.topP = topP;
  }

  public String getAINutritionAnalysis(final List<CartItem> cartItems) {
    return getChatCompletion(SystemMessageConstants.AI_NUTRITION_ANALYSIS, cartItems);
  }

  public String getTop3Recipes(final List<CartItem> cartItems) {
    return getChatCompletion(SystemMessageConstants.RECIPES, cartItems);
  }

  private String getChatCompletion(final String systemMessage, final List<CartItem> cartItems) {
    final List<ChatMessage> chatMessages = Arrays.asList(
        generateSystemChatMessage(systemMessage),
        generateUserChatMessageWithCartItems(cartItems)
    );
    final ChatCompletionsOptions chatCompletionsOptions = new ChatCompletionsOptions(chatMessages)
        .setTemperature(this.temperature)
        .setTopP(this.topP)
        .setN(1); // Number of chat completion choices to be generated
    final ChatCompletions chatCompletions =
        this.openAIClient.getChatCompletions(this.azureOpenAiModelDeploymentId, chatCompletionsOptions);
    return chatCompletions
        .getChoices()
        .stream()
        .map(ChatChoice::getMessage)
        .map(ChatMessage::getContent)
        .collect(Collectors.joining("\n"));
  }

  private ChatMessage generateSystemChatMessage(final String systemMessage) {
    final ChatMessage chatMessage = new ChatMessage(ChatRole.SYSTEM);
    chatMessage.setContent(systemMessage);
    return chatMessage;
  }

  private ChatMessage generateUserChatMessageWithCartItems(final List<CartItem> cartItems) {
    final ChatMessage chatMessage = new ChatMessage(ChatRole.USER);
    final String messageContent = THE_BASKET_IS + getCartItemsAsStringWithCommaSeparatedValues(cartItems);
    chatMessage.setContent(messageContent);
    return chatMessage;
  }

  private String getCartItemsAsStringWithCommaSeparatedValues(final List<CartItem> cartItems) {
    return cartItems
        .stream()
        .map(CartItem::getName)
        .collect(Collectors.joining(","));
  }
}
