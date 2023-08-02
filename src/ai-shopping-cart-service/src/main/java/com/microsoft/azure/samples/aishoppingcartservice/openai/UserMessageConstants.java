package com.microsoft.azure.samples.aishoppingcartservice.openai;

public final class UserMessageConstants {
  /**
   * These sentences are added at the end of the user message for the AI Nutrition Analysis to make sure that
   * GPT-3.5 Turbo model returns only a JSON with the right format and no other text. This is not use for GPT-4 model.
   */
  public static final String GPT_3_5_AI_NUTRITION_ANALYSIS_POSTFIX = "Return only a JSON with the following format: { nutriscore: \"\", explanation: \"\", recommendation: \"\"}. Do not add any other text.";

  /**
   * These sentences are added at the end of the user message for top 3 recipes to make sure that GPT-3.5 Turbo model
   * returns only a JSON with the right format and no other text. It also ensures that it returns recipes even if it
   * 'considers' that the basket (i.e. shopping cart) is too small. This is not use for GPT-4 model.
   */
  public static final String GPT_3_5_RECIPES_POSTFIX = "Even if the basket is too small, propose 3 recipes. Return only a JSON with the following format: { recipes: [ { name: \"\", ingredients: [], instructions: [], nutriscore: \"\", }]}. Do not add any other text.";

  private UserMessageConstants() {
  }
}
