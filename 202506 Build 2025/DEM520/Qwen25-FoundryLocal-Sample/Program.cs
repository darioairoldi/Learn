using Microsoft.AI.Foundry.Local;
using Microsoft.Extensions.Logging;
using OpenAI;
using OpenAI.Chat;
using System.ClientModel;

namespace Qwen25FoundryLocalSample
{
    /// <summary>
    /// Basic example demonstrating how to load and initialize Qwen2.5 model using Foundry Local
    /// This approach directly uses Foundry Local without .NET Aspire orchestration
    /// </summary>
    class Program
    {
        static async Task Main(string[] args)
        {
            // Configure logging to see what's happening
            using var loggerFactory = LoggerFactory.Create(builder =>
                builder.AddConsole().SetMinimumLevel(LogLevel.Information));
            
            var logger = loggerFactory.CreateLogger<Program>();
            
            try
            {
                await RunBasicFoundryLocalExample(logger);
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "Error running Foundry Local example");
            }
        }

        static async Task RunBasicFoundryLocalExample(ILogger logger)
        {
            logger.LogInformation("Starting Qwen2.5 model initialization with Foundry Local...");

            // Initialize Foundry Local Manager
            var manager = new FoundryLocalManager();

            try
            {
                logger.LogInformation("Starting Foundry Local service...");
                
                // Start the Foundry Local service
                await manager.StartServiceAsync();

                logger.LogInformation("Foundry Local service started successfully!");
                logger.LogInformation("Service URI: {ServiceUri}", manager.ServiceUri);

                // Specify the model alias you want to use
                // Using alias allows Foundry Local to select the best model for your hardware
                var modelAlias = "qwen2.5-0.5b-instruct"; // Use alias for automatic hardware optimization
                
                logger.LogInformation("Loading model: {ModelAlias}", modelAlias);

                // Load the model
                await manager.LoadModelAsync(modelAlias);

                logger.LogInformation("Model loaded successfully!");

                // Create OpenAI client pointing to Foundry Local
                var openAIClient = new OpenAIClient(
                    new ApiKeyCredential(manager.ApiKey), 
                    new OpenAIClientOptions
                    {
                        Endpoint = manager.Endpoint
                    });

                // Example: Simple chat completion
                await DemonstrateChatCompletion(openAIClient, modelAlias, logger);

                // Example: Streaming chat completion
                await DemonstrateStreamingChat(openAIClient, modelAlias, logger);

                logger.LogInformation("Unloading model...");
                await manager.UnloadModelAsync(modelAlias);

            }
            finally
            {
                logger.LogInformation("Stopping Foundry Local service...");
                await manager.StopServiceAsync();
                logger.LogInformation("Example completed successfully!");
            }
        }

        static async Task DemonstrateChatCompletion(OpenAIClient openAIClient, string modelAlias, ILogger logger)
        {
            logger.LogInformation("=== Chat Completion Example ===");

            var messages = new List<ChatMessage>
            {
                new SystemChatMessage("You are a helpful AI assistant running locally on this device."),
                new UserChatMessage("What are the benefits of running AI models locally?")
            };

            try
            {
                var chatClient = openAIClient.GetChatClient(modelAlias);
                var response = await chatClient.CompleteChatAsync(messages);
                
                logger.LogInformation("AI Response: {Response}", response.Value.Content[0].Text);
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "Error during chat completion");
            }
        }

        static async Task DemonstrateStreamingChat(OpenAIClient openAIClient, string modelAlias, ILogger logger)
        {
            logger.LogInformation("=== Streaming Chat Example ===");

            var messages = new List<ChatMessage>
            {
                new SystemChatMessage("You are a helpful AI assistant that provides concise answers."),
                new UserChatMessage("Explain the concept of local AI in 3 sentences.")
            };

            try
            {
                logger.LogInformation("Streaming response:");
                
                var chatClient = openAIClient.GetChatClient(modelAlias);
                
                await foreach (var update in chatClient.CompleteChatStreamingAsync(messages))
                {
                    foreach (var contentPart in update.ContentUpdate)
                    {
                        if (!string.IsNullOrEmpty(contentPart.Text))
                        {
                            Console.Write(contentPart.Text);
                        }
                    }
                }
                
                Console.WriteLine(); // New line after streaming
                logger.LogInformation("Streaming completed");
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "Error during streaming chat");
            }
        }
    }
}
