package com.microsoft.azure.samples.aishoppingcartservice;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.microsoft.azure.samples.aishoppingcartservice.openai.ShoppingCartAiRecommendations;

@Configuration
public class AiShoppingCartServiceConfiguration {
  @Value("${azure.openai.apikey}")
  private String azureOpenAiApiKey;
  @Value("${azure.openai.endpoint}")
  private String azureOpenAiEndpoint;
  @Value("${azure.openai.deployment.id}")
  private String azureOpenAiModelDeploymentId;
  @Value("${azure.openai.temperature}")
  private double temperature;
  @Value("${azure.openai.top.p}")
  private double topP;
  @Value("${azure.openai.is.gpt4}")
  private boolean isGpt4;

  @Bean
  public ShoppingCartAiRecommendations shoppingCartRecommendations() {
    return new ShoppingCartAiRecommendations(
        this.azureOpenAiApiKey,
        this.azureOpenAiEndpoint,
        this.azureOpenAiModelDeploymentId,
        this.temperature,
        this.topP,
        this.isGpt4);
  }
}
