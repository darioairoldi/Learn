# Streamlining Application Testing with .NET Aspire and Playwright

## Session Overview

**Session Code:** DEM508  
**Speaker:** Jeff Fritz  
**Topic:** Streamlining Application Testing with .NET Aspire and Playwright  
**Event:** Microsoft Build 2025  

This session demonstrates how to effectively combine **.NET Aspire** and **Playwright** to create robust, end-to-end testing solutions for distributed applications.<br> The presentation provides practical examples, source code, and real-world scenarios to help developers implement these technologies in their testing workflows.

## Key Technologies

### .NET Aspire
![alt text](<images/000.00 dnetaspire.png>)
**.NET Aspire** is a comprehensive set of libraries, frameworks, and tools designed for building observable, production-ready distributed application systems.<br> 
It provides:
- **Smart Defaults**: Pre-configured settings that follow best practices for distributed systems
- **Application Orchestration**: Simplified management of multiple services and components
- **Developer Dashboard**: A centralized interface for monitoring and managing applications
- **Service Discovery**: Automated service registration and discovery capabilities
- **Container Integrations**: Seamless integration with various databases and services through containers

### Playwright
![alt text](<images/001.01 playwright.png>)
Playwright is a modern, cross-platform testing framework that enables reliable end-to-end testing across multiple browsers and operating systems:

- **Cross-Browser Support**: Works with **Chromium**, **Firefox**, and **WebKit**
- **Multi-Platform**: Supports Windows, macOS, and Linux
- **Fast and Reliable**: Optimized for speed and consistency
- **Language Support**: APIs available for multiple programming languages, including .NET and C#
- **End-to-End Testing**: Simulates real user interactions for comprehensive application validation

## Integration Architecture

### Infrastructure Components

The integration between **.NET Aspire** and **Playwright** requires several infrastructure components:

#### 1. Playwright Manager

- Manages **browser interactions** and configurations
- Handles **timeout settings and browser initialization**
- Provides options for headless or visible browser execution
- Creates and manages browser contexts for test isolation

#### 2. Aspire Manager

- **Configures distributed applications** for testing
- Manages application lifecycle (startup, shutdown)
- **Provides service discovery** and **URL management**
- Handles integration with the **.NET Aspire dashboard**

#### 3. Base Test Class
- Abstract foundation for all Playwright tests
- Combines Aspire and Playwright managers
- Provides common test infrastructure and utilities
- Handles test setup and teardown operations

### Test Workflow

The testing workflow follows this pattern:

1. **Initialize**: Start .NET Aspire application and Playwright browser
2. **Navigate**: Direct browser to application endpoints
3. **Interact**: Perform user actions (clicks, form inputs, navigation)
4. **Validate**: Assert expected outcomes and behaviors
5. **Cleanup**: Shut down services and close browser sessions

## Practical Implementation

### Example Application: Weather Hub

The demonstration uses a Weather Hub application that:

- Integrates with the United States National Weather Service APIs
- Displays current weather information
- Provides search functionality for different cities
- Uses QuickGrid for data presentation

### Test Example: City Search Validation

```csharp
[Theory]
[InlineData("Seattle", "Seattle")]
[InlineData("Portland", "Portland")]
[InlineData("San Francisco", "San Francisco")]
[InlineData("Los Angeles", "Los Angeles")]
[InlineData("Denver", "Denver")]
public async Task SearchForCity(string searchTerm, string expectedLocation)
{
    await WithPageAsync(async page =>
    {
        await page.GotoAsync("/");
        await page.ClickAsync("column-options");
        await page.SearchAndValidateAsync(searchTerm, expectedLocation);
    });
}
```

This test:

- Uses xUnit Theory with InlineData for parameterized testing
- Navigates to the root of the Weather Hub application
- Interacts with the column options in the QuickGrid
- Searches for specific cities and validates the results

## Advanced Testing Scenarios

### Exploratory Testing with Playwright MCP

The session introduces the concept of using Playwright MCP (Model Context Protocol) for exploratory testing:

- **Discovery Capabilities**: Automatically explore application functionality
- **Dynamic Interaction**: Adapt test behavior based on application state
- **Enhanced Validation**: Perform comprehensive checks beyond predefined test cases

### Feature Development Testing

The demonstration includes adding new features to the application:

- **Weather Summarization**: Integration with Azure OpenAI services
- **Background Images**: Dynamic UI enhancements based on weather data
- **Real-time Validation**: Testing new features as they're developed

## Best Practices

### Test Organization

- Use abstract base classes for common test infrastructure
- Implement proper resource management (IDisposable pattern)
- Separate concerns between application management and test execution

### Configuration Management

- Use environment-specific configurations
- Implement flexible timeout settings
- Support both headless and visible browser modes for different scenarios

### Error Handling

- Implement proper cleanup in case of test failures
- Use try-finally blocks for resource management
- Provide meaningful error messages for debugging

### Performance Optimization

- Reuse browser instances where possible
- Implement parallel test execution strategies
- Use appropriate wait strategies for dynamic content

## Development Workflow Integration

### Visual Studio Code Integration

- Utilize built-in testing capabilities
- Real-time test execution and results viewing
- Integrated debugging support for failed tests

### Continuous Integration

- Automated test execution in CI/CD pipelines
- Headless browser execution for server environments
- Test result reporting and artifact collection

## Benefits of Integration

### Comprehensive Testing

- End-to-end validation of entire application workflows
- Testing of microservices interactions
- Database and external service integration testing

### Development Efficiency

- Rapid feedback on application changes
- Automated regression testing
- Simplified test environment setup

### Quality Assurance

- Consistent testing across different environments
- Reliable cross-browser compatibility validation
- Automated user experience testing

## Conclusion

The integration of .NET Aspire and Playwright provides a powerful foundation for modern application testing. By combining Aspire's distributed application management capabilities with Playwright's robust browser automation, developers can create comprehensive testing solutions that validate entire application workflows.

This approach is particularly valuable for:

- Distributed microservices architectures
- Complex user interfaces with multiple interaction points
- Applications requiring cross-browser compatibility
- Systems with multiple integrated services and databases

The session demonstrates that with proper infrastructure setup, teams can achieve reliable, maintainable, and efficient end-to-end testing that scales with application complexity.

## References

### 1. .NET Aspire Official Documentation

**Link:** [Microsoft .NET Aspire Documentation](https://learn.microsoft.com/en-us/dotnet/aspire/)  
**Relevance:** This is the primary resource for understanding .NET Aspire's architecture, components, and implementation patterns. Essential for developers wanting to implement distributed application orchestration and understand the framework's capabilities demonstrated in the session.

### 2. Playwright for .NET Documentation

**Link:** [Playwright for .NET](https://playwright.dev/dotnet/)  
**Relevance:** Comprehensive guide to Playwright's .NET implementation, covering installation, API usage, and advanced testing scenarios. Critical for understanding the browser automation capabilities showcased in the session and implementing similar testing strategies.

### 3. Microsoft Build 2025 Session Repository

**Link:** [Jeff Fritz's GitHub Repository](https://github.com/csharpfritz)  
**Relevance:** Contains the actual source code demonstrated in the session, providing practical examples of integrating .NET Aspire with Playwright. Valuable for hands-on learning and understanding the implementation details discussed.

### 4. End-to-End Testing Best Practices

**Link:** [Microsoft Testing Guidelines](https://learn.microsoft.com/en-us/dotnet/core/testing/)  
**Relevance:** Covers testing methodologies and best practices for .NET applications, providing context for the testing strategies demonstrated in the session and helping developers implement effective testing workflows.

### 5. Playwright Cross-Browser Testing Guide

**Link:** [Playwright Cross-Browser Testing](https://playwright.dev/docs/browsers)  
**Relevance:** Detailed information about Playwright's cross-browser capabilities mentioned in the session, including setup instructions for different browsers and platforms. Essential for implementing the multi-browser testing scenarios discussed.

### 6. Distributed Application Testing Patterns

**Link:** [Microservices Testing Strategies](https://learn.microsoft.com/en-us/dotnet/architecture/microservices/multi-container-microservice-net-applications/test-aspnet-core-services)  
**Relevance:** Provides architectural guidance for testing distributed applications, complementing the .NET Aspire and Playwright integration demonstrated in the session. Helps developers understand when and how to apply these testing approaches.

### 7. Visual Studio Code Testing Extensions

**Link:** [VS Code Testing Extensions](https://marketplace.visualstudio.com/items?itemName=ms-dotnettools.csharp)  
**Relevance:** Information about the testing capabilities in Visual Studio Code that were demonstrated in the session, including test discovery, execution, and debugging features that enhance the development workflow.

### 8. Azure OpenAI Integration for Testing

**Link:** [Azure OpenAI Service Documentation](https://learn.microsoft.com/en-us/azure/ai-services/openai/)  
**Relevance:** Covers the Azure OpenAI services integration mentioned in the session's advanced scenarios, providing context for testing applications that incorporate AI capabilities and dynamic content generation.

### 9. xUnit Testing Framework

**Link:** [xUnit.net Documentation](https://xunit.net/)  
**Relevance:** Documentation for the testing framework used in the session examples, including Theory and InlineData attributes demonstrated in the parameterized testing scenarios. Essential for understanding the test structure and execution patterns.

### 10. Container Integration Testing

**Link:** [Testing with Docker Containers](https://learn.microsoft.com/en-us/dotnet/architecture/microservices/multi-container-microservice-net-applications/integration-tests)  
**Relevance:** Covers testing strategies for containerized applications, which aligns with .NET Aspire's container integration capabilities discussed in the session. Valuable for understanding how to test distributed applications with multiple service dependencies.
