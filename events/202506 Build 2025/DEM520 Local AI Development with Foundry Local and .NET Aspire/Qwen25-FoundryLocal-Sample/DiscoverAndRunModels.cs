using Microsoft.AI.Foundry.Local;
using OpenAI;
using OpenAI.Chat;
using System.ClientModel;

namespace Qwen25FoundryLocalSample
{
    /// <summary>
    /// Comprehensive example that lists all available models and runs with the best available one
    /// </summary>
    public class DiscoverAndRunModels
    {
        public static async Task Main(string[] args)
        {
            // Check if user wants to run the simple version
            if (args.Length > 0 && args[0].Equals("simple", StringComparison.OrdinalIgnoreCase))
            {
                await SimpleProgram.RunAsync();
                return;
            }

            // Run the full discovery version by default
            await RunDiscoveryAsync();
        }

        public static async Task RunDiscoveryAsync()
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

                // First, let's see what models are available
                Console.WriteLine("\n=== Available Models in Catalog ===");
                var catalogModels = await manager.ListCatalogModelsAsync();
                
                if (catalogModels.Count == 0)
                {
                    Console.WriteLine("No models found in catalog. You may need to update your Foundry Local installation.");
                    return;
                }
                
                // Display available models
                Console.WriteLine($"Found {catalogModels.Count} models:");
                foreach (var model in catalogModels.Take(10)) // Show first 10 models
                {
                    Console.WriteLine($"  - {model.ModelId} ({model.DisplayName}) - Size: {model.FileSizeMb}MB");
                    if (!string.IsNullOrEmpty(model.Alias))
                        Console.WriteLine($"    Alias: {model.Alias}");
                }
                
                // Look for a suitable model (prefer smaller ones for demo)
                var qwenModels = catalogModels.Where(m => 
                    m.ModelId.Contains("qwen", StringComparison.OrdinalIgnoreCase) ||
                    m.DisplayName.Contains("qwen", StringComparison.OrdinalIgnoreCase))
                    .OrderBy(m => m.FileSizeMb)
                    .ToList();
                
                var phiModels = catalogModels.Where(m => 
                    m.ModelId.Contains("phi", StringComparison.OrdinalIgnoreCase) ||
                    m.DisplayName.Contains("phi", StringComparison.OrdinalIgnoreCase))
                    .OrderBy(m => m.FileSizeMb)
                    .ToList();
                
                // Choose the best available model
                string modelToUse;
                if (qwenModels.Any())
                {
                    var selectedModel = qwenModels.First();
                    modelToUse = !string.IsNullOrEmpty(selectedModel.Alias) ? selectedModel.Alias : selectedModel.ModelId;
                    Console.WriteLine($"\n=== Using Qwen model: {selectedModel.DisplayName} ===");
                }
                else if (phiModels.Any())
                {
                    var selectedModel = phiModels.First();
                    modelToUse = !string.IsNullOrEmpty(selectedModel.Alias) ? selectedModel.Alias : selectedModel.ModelId;
                    Console.WriteLine($"\n=== Using Phi model: {selectedModel.DisplayName} ===");
                }
                else
                {
                    // Fallback to first available model
                    var selectedModel = catalogModels.OrderBy(m => m.FileSizeMb).First();
                    modelToUse = !string.IsNullOrEmpty(selectedModel.Alias) ? selectedModel.Alias : selectedModel.ModelId;
                    Console.WriteLine($"\n=== Using first available model: {selectedModel.DisplayName} ===");
                }
                
                Console.WriteLine($"Loading model: {modelToUse}");
                Console.WriteLine("Note: First run will download the model, which may take several minutes...");
                
                // Load the model (this may take time for first run due to model download)
                await manager.LoadModelAsync(modelToUse);
                
                Console.WriteLine("Model loaded successfully!");

                // Create OpenAI client pointing to Foundry Local endpoint
                var openAIClient = new OpenAIClient(
                    new ApiKeyCredential(manager.ApiKey), 
                    new OpenAIClientOptions
                    {
                        Endpoint = manager.Endpoint
                    });

                // Get chat client for the loaded model
                var chatClient = openAIClient.GetChatClient(modelToUse);

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
                await manager.UnloadModelAsync(modelToUse);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}");
                if (ex.InnerException != null)
                    Console.WriteLine($"Inner exception: {ex.InnerException.Message}");
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
