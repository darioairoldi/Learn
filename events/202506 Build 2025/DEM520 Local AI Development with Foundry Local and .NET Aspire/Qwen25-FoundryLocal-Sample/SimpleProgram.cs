using Microsoft.AI.Foundry.Local;
using OpenAI;
using OpenAI.Chat;
using System.ClientModel;

namespace Qwen25FoundryLocalSample
{
    /// <summary>
    /// Simple example that automatically discovers and uses available models
    /// </summary>
    public class SimpleProgram
    {
        public static async Task RunAsync()
        {
            // Create a Foundry Local manager
            var manager = new FoundryLocalManager();

            try
            {
                Console.WriteLine("Starting Foundry Local service...");
                
                // Start the Foundry Local service
                await manager.StartServiceAsync();
                
                Console.WriteLine($"Foundry Local service started!");
                Console.WriteLine($"Service URI: {manager.ServiceUri}");
                Console.WriteLine($"API Endpoint: {manager.Endpoint}");

                // Use alias for automatic hardware optimization
                // Let's try some common model aliases that are likely to be available
                var possibleModels = new[] { 
                    "phi-3.5-mini",     // Example from documentation
                    "phi-3-mini",       // Common Phi model
                    "qwen2.5-0.5b",     // Qwen variant
                    "llama-3.2-1b"      // Common Llama variant
                };
                
                string? modelAlias = null;
                
                // Try to find an available model
                Console.WriteLine("Checking available models...");
                var catalogModels = await manager.ListCatalogModelsAsync();
                
                foreach (var testModel in possibleModels)
                {
                    var found = catalogModels.FirstOrDefault(m => 
                        m.Alias?.Equals(testModel, StringComparison.OrdinalIgnoreCase) == true ||
                        m.ModelId.Contains(testModel, StringComparison.OrdinalIgnoreCase));
                        
                    if (found != null)
                    {
                        modelAlias = !string.IsNullOrEmpty(found.Alias) ? found.Alias : found.ModelId;
                        Console.WriteLine($"Found model: {found.DisplayName} (alias: {modelAlias})");
                        break;
                    }
                }
                
                // Fallback to first available model if none of our preferred ones are found
                if (modelAlias == null && catalogModels.Count > 0)
                {
                    var fallbackModel = catalogModels.OrderBy(m => m.FileSizeMb).First();
                    modelAlias = !string.IsNullOrEmpty(fallbackModel.Alias) ? fallbackModel.Alias : fallbackModel.ModelId;
                    Console.WriteLine($"Using fallback model: {fallbackModel.DisplayName} (alias: {modelAlias})");
                }
                
                if (modelAlias == null)
                {
                    Console.WriteLine("No models found in catalog! Please check your Foundry Local installation.");
                    return;
                }
                
                Console.WriteLine($"Loading model: {modelAlias}");
                
                // Load the model (this may take time for first run due to model download)
                await manager.LoadModelAsync(modelAlias);
                
                Console.WriteLine("Model loaded successfully!");

                // Create OpenAI client pointing to Foundry Local endpoint
                var openAIClient = new OpenAIClient(
                    new ApiKeyCredential(manager.ApiKey), 
                    new OpenAIClientOptions
                    {
                        Endpoint = manager.Endpoint
                    });

                // Get chat client for the loaded model
                var chatClient = openAIClient.GetChatClient(modelAlias);

                // Example 1: Simple chat completion
                Console.WriteLine("\n=== Chat Completion Example ===");
                
                var messages = new List<ChatMessage>
                {
                    new SystemChatMessage("You are a helpful AI assistant running locally on this device."),
                    new UserChatMessage("What are the main benefits of running AI models locally instead of using cloud services?")
                };

                var response = await chatClient.CompleteChatAsync(messages);
                Console.WriteLine($"AI Response: {response.Value.Content[0].Text}");

                // Example 2: Streaming chat
                Console.WriteLine("\n=== Streaming Chat Example ===");
                Console.WriteLine("Question: Explain local AI in 2 sentences.");
                Console.Write("AI Response (streaming): ");

                var streamingMessages = new List<ChatMessage>
                {
                    new SystemChatMessage("You are a helpful AI assistant. Provide clear, concise responses."),
                    new UserChatMessage("Explain local AI in 2 sentences.")
                };

                await foreach (var update in chatClient.CompleteChatStreamingAsync(streamingMessages))
                {
                    foreach (var contentPart in update.ContentUpdate)
                    {
                        if (!string.IsNullOrEmpty(contentPart.Text))
                        {
                            Console.Write(contentPart.Text);
                        }
                    }
                }
                
                Console.WriteLine("\n\nStreaming completed!");

                // Clean up: Unload the model
                Console.WriteLine("Unloading model...");
                await manager.UnloadModelAsync(modelAlias);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}");
                Console.WriteLine($"Stack trace: {ex.StackTrace}");
            }
            finally
            {
                // Stop the service
                Console.WriteLine("Stopping Foundry Local service...");
                await manager.StopServiceAsync();
                Console.WriteLine("Done!");
            }
        }
    }
}
