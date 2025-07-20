# AI Infused Mobile & Desktop App Development with .NET MAUI

![alt text](<images/mobile and desktop app development with dotnet maui.png>)

## Session Overview

**Session Code:** BRK123  
**Event:** Microsoft Build 2025  
**Date:** May 19-22, 2025  
**Recording:** https://build.microsoft.com/en-US/sessions/BRK123?source=sessions

**Speakers:**

- David Ortinau (Product Manager, .NET MAUI)
- Beth Massi (Product Manager)
- Gerald Versluis (Community)
- Maddy
- Uma Maheswari Chandrabose (Syncfusion)

## Executive Summary

This session explores the transformative potential of **integrating artificial intelligence into mobile and desktop applications** using **.NET MAUI (Multi-platform App UI)**.<br>
The presentation demonstrated how AI can fundamentally reshape user experiences through intelligent, context-aware, and personalized application behaviors.<br>
The session covered both the development of **AI-infused applications** (agentic apps) and the **AI-enhanced development lifecycle** (agentic DevOps).

## Key Concepts and Technologies

### 1. Building Intelligent Apps

#### Definition and Philosophy

- **Intelligent Apps**: Applications that bring AI functionality to perform unexpected, non-deterministic tasks that depend on various contextual factors
- **Core Principle**: Focus on what you want the computer to do, not how to do it
- **User Intent**: Users express intentions rather than providing step-by-step instructions

#### Three Pillars of AI-Enhanced User Experience

##### 1. Personalization

- Apps adapt to individual user preferences and behaviors
- Real-time UI customization based on user context
- Move beyond "one-size-fits-all" application design
- Support for multiple user mental models within the same application

##### 2. Context Awareness

- Location-based functionality and recommendations
- Calendar integration for time-sensitive suggestions
- Environmental sensors (ambient light, time of day)
- Device capabilities and current state awareness

##### 3. Multi-modal Interactions

- Voice input and speech-to-text capabilities
- Vision/camera-based interactions
- Traditional touch and keyboard inputs
- Seamless switching between interaction modes

### 2. AI Design Principles

Based on peer-reviewed research, the session outlined six critical design principles:

#### 1. Design Responsibly

- Solve real problems, not create flashy features
- Minimize potential harms to users
- Create user agency while preventing self-harm
- Consider ethical implications of AI implementations

#### 2. Design for Mental Models

- Understand how different users conceptualize tasks
- Support multiple approaches to the same workflow
- Adapt to various business needs within the same application
- Consider user expertise levels and preferences

#### 3. Design for Appropriate Trust and Reliance

- Provide transparency in AI decision-making
- Allow users to understand AI reasoning ("why did you prioritize this?")
- Implement explainable AI features
- Balance automation with user oversight

#### 4. Design for Generative Variability

- Accept that AI outputs can be unpredictable
- Implement appropriate guardrails
- Provide user controls to guide AI behavior
- Design for collaborative human-AI interaction

#### 5. Design for Co-creation

- Enable collaborative workflows between users and AI
- Provide tools for users to curate their AI experience
- Support iterative refinement of AI outputs
- Maintain user agency in the creative process

#### 6. Design for Imperfection

- Make uncertainty visible to users
- Provide fallback mechanisms
- Handle errors gracefully
- Set appropriate user expectations

### 3. Technical Implementation

#### Core Technologies Demonstrated

##### Microsoft.Extensions.AI

- Simplified API integration with AI services
- Structured output support (avoiding JSON serialization issues)
- Tool calling capabilities for extending AI functionality
- Multiple model support for different use cases

##### Voice and Audio Processing

- Plugin.MAUI.Audio for cross-platform audio capabilities
- Whisper integration for speech-to-text
- Real-time voice command processing

##### Vision and Image Processing

- MediaPicker integration for camera functionality
- OpenAI Vision API for image analysis
- Recipe-to-shopping-list conversion demonstrations
- Visual task creation from photographs

##### Location and Context Services

- Google Places API integration
- Calendar service connectivity
- GPS and location-based recommendations
- Environmental sensor data utilization

#### On-Device vs. Cloud Processing

**Cloud Benefits:**

- Access to latest, most powerful models
- No device storage constraints
- Continuous model updates

**On-Device Advantages (ONNX Runtime):**

- Reduced latency for real-time interactions
- Privacy preservation
- Offline functionality
- Lower operational costs

### 4. .NET MAUI Hybrid Applications

#### Architecture and Benefits

**Hybrid App Definition:**
- Blend of native and web technologies
- HTML/CSS/JavaScript UI with native device API access
- Cross-platform deployment (iOS, Android, macOS, Windows)
- App store distribution capabilities

**Two Implementation Approaches:**

**1. Blazor WebView**
- Brings Blazor development model to mobile
- Full .NET ecosystem integration
- Built-in authentication, validation, and components
- Tight integration with Visual Studio tooling

**2. Hybrid WebView**
- Support for Angular, React, Vue frameworks
- JavaScript-to-C# interop capabilities
- Web request intercepting (coming in .NET 10 preview 5)
- Broader web technology compatibility

#### Code Reuse Strategy
- Shared Razor Class Library for UI components
- Platform-specific data services
- Common business logic across web and mobile
- Responsive design adaptation

### 5. Partnership Ecosystem: Syncfusion Integration

#### Syncfusion Contribution to .NET MAUI
- **29 free, open-source UI controls** in the toolkit
- **320+ merged PRs** in six months (65% of community contributions)
- **100+ PRs under review** at any given time
- Framework-level bug fixes and community PR reviews
- Daily issue triage and community support

#### New Controls and Features
- Date/Time picker controls family
- Linear and circular progress bars
- AOT (Ahead-of-Time) compilation optimization
- Trimming support for iOS performance
- AI-powered component development

#### Partnership Impact
- Accelerated development cycles through framework access
- Enhanced quality and compatibility testing
- Direct community feedback integration
- Beta version compatibility assurance
- Significant adoption growth in .NET MAUI toolkit usage

### 6. Agentic DevOps: AI-Enhanced Development

#### Visual Studio AI Integration

**GitHub Copilot Agent Mode:**
- Peer-level collaboration with AI
- Automated implementation of feature requests
- Build triggering and output inspection
- Multi-step workflow automation

**Copilot Vision:**
- Design-to-code conversion from images
- XAML generation from UI mockups
- Figma integration through MCP (Model Context Protocol)
- Live preview without debug sessions

**Development Assistance:**
- Automated test generation
- Documentation creation
- Code review and refactoring
- Issue resolution and PR management

#### .NET Aspire Integration with MAUI

**Multi-Project Orchestration:**
- Code-based landscape definition
- Advanced multi-startup project management
- Service discovery and configuration
- Integrated debugging across platforms

**Observability and Monitoring:**
- Centralized logging from MAUI applications
- Error tracking and telemetry
- HTTP call tracing and metrics
- Real-time debugging assistance through Copilot integration

**Development Workflow Enhancement:**
- Unified dashboard for all project components
- Platform-specific deployment options
- Remote simulator support
- Integrated web and mobile testing

## Technical Architecture Patterns

### AI Service Integration Pattern

```csharp
// Microsoft.Extensions.AI simplification
var client = new ChatClient(apiKey, model);
var response = await client.CompleteAsync(prompt, cancellationToken);
```

### Tool Calling Implementation
- Location services integration
- Calendar data access
- Custom business logic hooks
- External API connectivity

### Multi-Modal Input Handling
- Voice command processing pipeline
- Image analysis workflow
- Traditional input fallbacks
- Context switching between modes

### Hybrid Application Structure
- Shared UI component libraries
- Platform-specific service implementations
- Cross-platform data synchronization
- Responsive design principles

## Business Impact and Value Proposition

### Developer Productivity Gains
- Reduced time-to-market for AI features
- Lower barrier to entry for AI integration
- Reusable components across platforms
- Enhanced debugging and monitoring capabilities

### User Experience Improvements
- Personalized application behaviors
- Context-aware feature recommendations
- Natural language interaction capabilities
- Adaptive user interface elements

### Enterprise Benefits
- Cross-platform development efficiency
- Reduced maintenance overhead
- Scalable architecture patterns
- Future-proof technology stack

## Implementation Considerations

### Security and Privacy
- Bring-your-own-key (BYOK) implementations
- Server-side API key management
- User consent for data access
- Local vs. cloud processing decisions

### Performance Optimization
- On-device model deployment strategies
- Caching and offline functionality
- Network request optimization
- Battery life considerations

### Scalability Factors
- Model selection for specific use cases
- Resource allocation strategies
- Cost management for cloud services
- Performance monitoring and optimization

## Future Directions and Roadmap

### Upcoming Features (.NET 10)
- Enhanced web request interception in Hybrid WebView
- Improved Aspire integration for MAUI
- Advanced AI toolkit components
- Expanded MCP server support

### Community and Ecosystem Growth
- Increased partnership opportunities
- Open-source contribution acceleration
- Enhanced documentation and tutorials
- Expanded template library

### AI Technology Evolution
- More sophisticated on-device models
- Improved multi-modal capabilities
- Enhanced privacy-preserving techniques
- Better integration with Microsoft AI services

## Conclusion

The session demonstrated that AI integration in mobile and desktop applications is no longer a complex, enterprise-only capability. With .NET MAUI and the Microsoft AI ecosystem, developers can easily create intelligent, context-aware applications that adapt to user needs and preferences. The combination of powerful AI services, cross-platform development capabilities, and strong community partnerships creates an unprecedented opportunity for innovation in mobile and desktop application development.

The key takeaway is that AI-infused applications represent a fundamental shift in how we think about user interfaces and user experiences. Rather than designing static applications that work the same way for everyone, developers can now create dynamic, personalized experiences that evolve with user behavior and context.

## References

### Microsoft Documentation and Resources

**1. Microsoft AI Development Hub**  
URL: https://aka.ms/ai-dev-hub  
*This comprehensive resource provides getting-started guides, best practices, and implementation examples for integrating AI into .NET applications. Essential for understanding Microsoft's AI development philosophy and accessing tools like Microsoft.Extensions.AI.*

**2. .NET MAUI Official Documentation**  
URL: https://docs.microsoft.com/en-us/dotnet/maui/  
*Complete documentation for .NET MAUI development, including hybrid application patterns, platform-specific implementations, and cross-platform development best practices showcased in the session.*

**3. Microsoft AI Principles and Responsible AI**  
URL: https://www.microsoft.com/en-us/ai/responsible-ai  
*Foundational resource for understanding Microsoft's approach to ethical AI development, directly referenced in the session's design principles section. Critical for implementing responsible AI features.*

**4. Azure AI Foundry Model Catalog**  
URL: https://azure.microsoft.com/en-us/products/ai-studio/  
*Comprehensive catalog of AI models available through Azure, helping developers select appropriate models for specific use cases as demonstrated in the multi-model approach shown in the session.*

### Development Tools and Frameworks

**5. Microsoft.Extensions.AI Documentation**  
URL: https://learn.microsoft.com/en-us/dotnet/api/microsoft.extensions.ai  
*Technical documentation for the AI extension library demonstrated in the session, providing simplified integration patterns for AI services in .NET applications.*

**6. .NET Aspire Documentation**  
URL: https://learn.microsoft.com/en-us/dotnet/aspire/  
*Complete guide to .NET Aspire orchestration platform, essential for understanding the agentic DevOps concepts and multi-project development workflows demonstrated.*

**7. Blazor Hybrid Apps Documentation**  
URL: https://docs.microsoft.com/en-us/aspnet/core/blazor/hybrid/  
*Detailed implementation guide for Blazor hybrid applications within .NET MAUI, covering the shared UI component architecture presented in the session.*

### AI Design and User Experience Research

**8. "Design Guidelines for AI-Assisted User Interfaces" - CHI Conference Proceedings**  
URL: https://dl.acm.org/doi/10.1145/3411764.3445365  
*Peer-reviewed research paper that forms the foundation for the six AI design principles discussed in the session. Essential reading for understanding evidence-based AI UX design.*

**9. Jakob Nielsen's AI UX Research**  
URL: https://www.nngroup.com/articles/ai-paradigm-change/  
*Research by usability expert Jakob Nielsen on AI as a new user interface paradigm, directly cited in the session as foundational thinking for AI-enhanced user experiences.*

### Third-Party Integrations and Partnerships

**10. Syncfusion .NET MAUI Toolkit**  
URL: https://www.syncfusion.com/maui-controls  
*Free, open-source UI controls library demonstrated extensively in the session, providing professional-grade components for .NET MAUI applications with AI-ready design patterns.*

**11. OpenAI API Documentation**  
URL: https://platform.openai.com/docs  
*Technical reference for OpenAI services integration, covering the vision API and chat completion features demonstrated in the AI-infused task management application.*

**12. ONNX Runtime for Mobile**  
URL: https://onnxruntime.ai/docs/get-started/with-mobile.html  
*Implementation guide for on-device AI model execution using ONNX Runtime, addressing the performance and privacy considerations discussed for local vs. cloud AI processing.*

### Community and Learning Resources

**13. .NET MAUI Community Toolkit**  
URL: https://github.com/CommunityToolkit/Maui  
*Open-source toolkit providing additional controls and utilities for .NET MAUI development, complementing the ecosystem approach demonstrated in the session.*

**14. Model Context Protocol (MCP) Specification**  
URL: https://modelcontextprotocol.io/  
*Technical specification for MCP servers, enabling enhanced AI assistant capabilities through external service integration as demonstrated with Figma connectivity.*

**15. GitHub Copilot for Visual Studio Documentation**  
URL: https://docs.github.com/en/copilot/using-github-copilot/using-github-copilot-in-visual-studio  
*Comprehensive guide to GitHub Copilot integration in Visual Studio, covering the agentic DevOps workflows and AI-assisted development techniques showcased.*

---

*This document captures the comprehensive insights from Microsoft Build 2025 Session BRK123, providing both conceptual understanding and practical implementation guidance for AI-infused mobile and desktop application development using .NET MAUI.*
