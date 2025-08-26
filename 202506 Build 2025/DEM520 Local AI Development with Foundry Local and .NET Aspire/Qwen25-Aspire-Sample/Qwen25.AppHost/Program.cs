using Microsoft.Extensions.Hosting;

var builder = DistributedApplication.CreateBuilder(args);

// Configure the Foundry Local resource
// This will handle model download, hardware detection, and service lifecycle
var foundryResource = builder.AddFoundryLocalResource("ai")
    .AddModel("chat", "Qwen2.5-0.5B"); // Model family specification

// Alternative model options:
// .AddModel("chat", "Qwen2.5-1.5B") // Larger model for better quality
// .AddModel("chat", "Qwen2.5-3B")   // Even larger model

// Add the web application that will consume the AI service
builder.AddProject<Projects.WebApp>("webapp")
    .WithReference(foundryResource)  // Pass reference to the Foundry resource
    .WaitFor(foundryResource);       // Wait for model download before starting

var app = builder.Build();

app.Run();
