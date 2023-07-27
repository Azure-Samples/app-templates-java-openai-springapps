# Getting Started with AI Shopping Cart Service

This is the AI Shopping Cart Service sample app project. It is a simple microservice that provides a REST API to manage a shopping cart. It is used in the [AI Shopping Cart Front-end](../frontend/README.md) sample app.

**Note: This project is a sample app that is not suited to be used in production.**

This project was bootstrapped with [Spring Initializr](https://start.spring.io/). Please find below information about this Spring Boot microservice and how to run it locally. To deploy it to [Azure Spring Apps](https://learn.microsoft.com/en-us/azure/spring-apps/), please use the [Azure Developer CLI](https://learn.microsoft.com/en-us/azure/developer/azure-developer-cli/overview) as described in the [AI Shopping Cart README](../../README.md).

## Dependencies

This microservice uses the following dependencies:

- [Azure OpenAI](https://learn.microsoft.com/en-us/azure/ai-services/openai/): This is the OpenAI API that is used to generate the AI nutrition analysis of the shopping cart and the top 3 recipes based on the shopping cart content. It was designed to use [GPT-4 model](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/models#gpt-4) with 8k tokens.
- [PostgreSQL](https://www.postgresql.org/): This is the database that is used to store the shopping cart state. [Azure Database for PostgreSQL Flexible Server](https://docs.microsoft.com/en-us/azure/postgresql/flexible-server/overview) is used to deploy AI Shopping Cart sample app.

## Pre-requisites

### Dvelopment Tools

The following pre-requisites are required to run this sample app locally:

- [Java 17](https://learn.microsoft.com/en-us/java/openjdk/install)

For Maven, a wrapper is provided in the project. This project was developped and deployed with Maven 3.8.8.

### Required Properties

There are 6 properties that must be set before running the app. These properties can be set in the [application.properties](src/main/resources/application.properties) file or as environment variables. The description of these properties can be found in the [additional spring configuration metadata file](src/main/resources/META-INF/additional-spring-configuration-metadata.json). The following table describes these properties:

| Property | Environment Variable | Description |
| --- | --- | --- |
| `spring.datasource.url` | `SPRING_DATASOURCE_URL` | The JDBC URL of the PostgreSQL database. The URL format is: `jdbc:postgresql://[host]:[port]/[database]?sslmode=require` |
| `spring.datasource.username` | `SPRING_DATASOURCE_USERNAME` | The username to connect to the PostgreSQL database. |
| `spring.datasource.password` | `SPRING_DATASOURCE_PASSWORD` | The password to connect to the PostgreSQL database. |
| `azure.openai.api-key` | `AZURE_OPENAI_API_KEY` | The API key to connect to the Azure OpenAI API. |
| `azure.openai.endpoint` | `AZURE_OPENAI_ENDPOINT` | The endpoint to connect to the Azure OpenAI API. |
| `azure.openai.deployment.id` | `AZURE_OPENAI_DEPLOYMENT_ID` | The deployment ID of the Azure OpenAI model to use for chat completion. |

There are 2 additional properties that can be set to change the behavior of the app:

| Property | Environment Variable | Description |
| --- | --- | --- |
| `azure.openai.temperature` | `AZURE_OPENAI_TEMPERATURE` | The temperature to use for chat completion. The default value is 0.7. |
| `azure.openai.top.p` | `AZURE_OPENAI_TOP_P` | The top P value to use for chat completion. The default value is 1.0. |


## Running the app locally

To run the app locally, you can use the following command:

```bash
mvnw spring-boot:run
```

You can also build the app and run it with the following commands:

```bash
mvnw clean package
java -jar target/ai-shopping-cart-service-1.0.0-SNAPSHOT.jar
```
