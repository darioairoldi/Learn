using Microsoft.Extensions.AI;

var builder = WebApplication.CreateBuilder(args);

// Add Aspire service defaults (telemetry, health checks, etc.)
builder.AddServiceDefaults();

// Add Aspire Azure AI Inference integration
// This connects to the Foundry Local service configured in the AppHost
builder.Services.AddChatCompletionsClient("chat") // Reference to model defined in app host
    .AsOpenAIClient()      // Convert to Microsoft Extensions AI interface
    .UseFunctionCalling()  // Enable function calling capabilities
    .UseOpenTelemetry();   // Add diagnostic logging through Aspire

// Add services to the container
builder.Services.AddRazorPages();

// Add CORS for development
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
    {
        policy.AllowAnyOrigin()
              .AllowAnyMethod()
              .AllowAnyHeader();
    });
});

var app = builder.Build();

// Configure the HTTP request pipeline
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();
app.UseRouting();
app.UseCors("AllowAll");

// Map Aspire default endpoints
app.MapDefaultEndpoints();

// API endpoint for chat completions
app.MapPost("/api/chat", async (ChatRequest request, IChatCompletionService chatService) =>
{
    try
    {
        var messages = new List<ChatMessage>
        {
            new ChatMessage(ChatRole.System, "You are a helpful AI assistant running locally using Foundry Local and .NET Aspire."),
            new ChatMessage(ChatRole.User, request.Message)
        };

        var response = await chatService.GetChatMessageContentAsync(messages);
        
        return Results.Ok(new { response = response.Content });
    }
    catch (Exception ex)
    {
        return Results.Problem($"Error processing chat request: {ex.Message}");
    }
});

// API endpoint for streaming chat
app.MapPost("/api/chat/stream", async (ChatRequest request, IChatCompletionService chatService) =>
{
    var messages = new List<ChatMessage>
    {
        new ChatMessage(ChatRole.System, "You are a helpful AI assistant. Provide clear, concise responses."),
        new ChatMessage(ChatRole.User, request.Message)
    };

    return Results.Stream(async (stream) =>
    {
        await foreach (var chunk in chatService.GetStreamingChatMessageContentsAsync(messages))
        {
            if (!string.IsNullOrEmpty(chunk.Content))
            {
                var data = System.Text.Encoding.UTF8.GetBytes($"data: {chunk.Content}\n\n");
                await stream.WriteAsync(data);
                await stream.FlushAsync();
            }
        }
        
        var endData = System.Text.Encoding.UTF8.GetBytes("data: [DONE]\n\n");
        await stream.WriteAsync(endData);
    }, "text/plain");
});

app.MapRazorPages();

app.Run();

// Request model for chat API
public record ChatRequest(string Message);
