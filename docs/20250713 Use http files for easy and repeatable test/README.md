# Using HTTP Files for API Testing

**HTTP files** are a great way to test your web API calls directly from your code editor, offering a lightweight alternative to Postman. They're especially helpful for documenting and version-controlling your API tests alongside your code.

## Table of Contents

- [Getting Started with HTTP Files](#getting-started-with-http-files)
  - [1. Install the Required Extension in VS Code](#1-install-the-required-extension-in-vs-code)
  - [2. Create an HTTP File](#2-create-an-http-file)
  - [3. Write Your First HTTP Request](#3-write-your-first-http-request)
  - [4. Add Headers and Body](#4-add-headers-and-body)
  - [5. Execute Requests](#5-execute-requests)
- [Advanced Features](#advanced-features)
  - [Variables and Environments](#variables-and-environments)
  - [Multiple Requests in One File](#multiple-requests-in-one-file)
  - [Response Handling](#response-handling)
  - [Using Response Variables](#using-response-variables)
  - [File Uploads](#file-uploads)
- [Benefits Over Postman](#benefits-over-postman)
- [References](#references)
- [Appendixes](#appendixes)
  - [Appendix A: REST Client Main Features](#appendix-a-rest-client-main-features)

## Getting Started with HTTP Files

### 1. Install the Required Extension in VS Code

First, install the "REST Client" extension by Huachao Mao:

1. Open VS Code
2. Go to Extensions (Ctrl+Shift+X)
3. Search for <mark>`REST Client`</mark>
4. Click "Install"


### 2. Create an HTTP File

Create a new file with `.http` or `.rest` extension in your project:

### 3. Write Your First HTTP Request

Here's a simple GET request:

```http
### Get all items
GET https://api.example.com/items
```

### 4. Add Headers and Body

For a POST request with JSON body:

```http
### Create new item
POST https://api.example.com/items
Content-Type: application/json

{
  "name": "New Item",
  "description": "This is a test item"
}
```

### 5. Execute Requests

To execute a request:
- Click the "Send Request" link that appears above each request
- Or use the shortcut `Ctrl+Alt+R` (Windows/Linux) or `Cmd+Alt+R` (Mac)

## Advanced Features

### Variables and Environments

Define variables with <mark>`@`</mark> to reuse values:

```http
@baseUrl = https://api.example.com
@authToken = Bearer your-token-here

### Get all items
GET {{baseUrl}}/items
Authorization: {{authToken}}
```

### Multiple Requests in One File

Separate requests with <mark>`###`</mark>:

```http
### Get all items
GET {{baseUrl}}/items

### Get specific item
GET {{baseUrl}}/items/123

### Create new item
POST {{baseUrl}}/items
Content-Type: application/json

{
  "name": "Test Item"
}
```

### Response Handling

Store and use response values from previous requests.<br>
The <mark>`# @name`</mark> comment assigns a name to the request, allowing you to reference its response in subsequent requests:

```http
### Create item and capture ID
# @name createItem
POST {{baseUrl}}/items
Content-Type: application/json

{
  "name": "New Item"
}

### Get the created item using the response ID
GET {{baseUrl}}/items/{{createItem.response.body.id}}
```

**How it works:**
- `# @name createItem` assigns the name "createItem" to the first request
- When executed, the response is stored and can be referenced as `createItem`
- `{{createItem.response.body.id}}` extracts the `id` field from the response body
- This allows you to chain requests where later requests depend on data from earlier ones

**Response object structure:**
- `createItem.response.body` - The response body (JSON object)
- `createItem.response.headers` - Response headers
- `createItem.response.status` - HTTP status code

### Using Response Variables

```http
### Login
# @name login
POST {{baseUrl}}/login
Content-Type: application/json

{
  "username": "user",
  "password": "pass"
}

### Use token from login response
GET {{baseUrl}}/secure-endpoint
Authorization: Bearer {{login.response.body.token}}
```

### File Uploads

```http
### Upload file
POST {{baseUrl}}/upload
Content-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW

------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="file"; filename="test.txt"
Content-Type: text/plain

< ./test.txt
------WebKitFormBoundary7MA4YWxkTrZu0gW--
```




## Benefits Over Postman

1. **Lightweight**: No need for a separate application
2. **Version Control**: Store API tests alongside your code
3. **Easy Sharing**: Share requests as simple text files
4. **Environment Integration**: Works directly in your development environment
5. **Text-based**: Easy to review changes in pull requests

## References

1. [REST Client Extension Documentation](https://marketplace.visualstudio.com/items?itemName=humao.rest-client)  
   Official documentation from the extension author that provides detailed instructions on how to use the REST Client extension, including all available features and syntax options.

2. [VS Code REST Client GitHub Repository](https://github.com/Huachao/vscode-restclient)  
   The source repository contains examples, issue tracking, and the latest development updates for the extension. Useful for understanding the implementation details and finding solutions to common problems.

3. [HTTP/1.1 Specification (RFC 7230-7235)](https://datatracker.ietf.org/doc/html/rfc7230)  
   The official HTTP protocol specification that defines the syntax and semantics of HTTP/1.1 messages. Understanding this helps write more accurate and standard-compliant HTTP requests.

4. [REST Client vs. Postman: A Comparative Analysis](https://blog.bitsrc.io/vs-code-extensions-for-testing-api-calls-e981ba65eeb4)  
   An in-depth comparison between REST Client and other API testing tools like Postman, highlighting the strengths and limitations of each approach.

5. [Advanced HTTP Request Testing Patterns](https://medium.com/@walmyrlimaesilv/vs-code-how-to-make-http-rest-api-requests-inside-visual-studio-code-a325a26aaed6)  
   This guide covers advanced patterns for organizing and automating API tests using HTTP files, including environment management and test sequencing.

6. [Environment Variables in REST Client](https://github.com/Huachao/vscode-restclient/blob/master/README.md#environment-variables)  
   A specific guide on how to use environment variables in REST Client, which is crucial for managing different environments (development, testing, production) in your API tests.

## Appendixes

### Appendix A: REST Client Main Features

| Feature Category | Feature | Purpose | How to Use |
|------------------|---------|---------|------------|
| **Request Execution** | Send/Cancel/Rerun HTTP request | Execute HTTP requests directly in editor and view responses | Click "Send Request" link above request or use Ctrl+Alt+R |
| **Request Execution** | View response in separate pane | Display formatted response with syntax highlighting | Response automatically appears in split pane after execution |
| **GraphQL Support** | Send GraphQL queries | Execute GraphQL operations with variable support | Write GraphQL query in request body with variables section |
| **cURL Integration** | Send cURL commands | Convert and execute cURL commands directly | Paste cURL command in .http file or copy request as cURL |
| **History Management** | Auto save request history | Keep track of all executed requests | Access via command palette "Rest Client: Request History" |
| **Multi-Request Files** | Compose multiple requests | Organize related API calls in single file | Separate requests with `###` delimiter |
| **Response Handling** | View image responses | Display images directly in response pane | Automatic for image content types |
| **Response Handling** | Save responses to disk | Export response data for further analysis | Right-click response pane and select save options |
| **Response Formatting** | Fold/unfold response body | Collapse/expand response sections | Click fold/unfold icons in response pane |
| **Response Formatting** | Customize response font | Adjust readability of response display | Configure in VS Code settings under Rest Client |
| **Response Filtering** | Preview specific response parts | Show only headers, body, or full response | Use response tabs (Headers/Body/Full) |
| **Authentication** | Basic Auth support | Simple username/password authentication | Add `Authorization: Basic base64(user:pass)` header |
| **Authentication** | Digest Auth support | More secure challenge-response authentication | Handled automatically when server requests digest auth |
| **Authentication** | SSL Client Certificates | Certificate-based authentication | Configure in settings with certificate paths |
| **Authentication** | Azure AD integration | Microsoft identity platform authentication | Use `{{$aadToken}}` system variable |
| **Authentication** | AWS Signature v4 | AWS service authentication | Configure AWS credentials and use signature headers |
| **Variables** | Environment variables | Manage different deployment environments | Define in `.vscode/settings.json` or environment files |
| **Variables** | Custom variables | Reusable values throughout requests | Define with `@variableName = value` syntax |
| **Variables** | System variables | Built-in dynamic values | Use `{{$guid}}`, `{{$timestamp}}`, etc. |
| **Variables** | Prompt variables | Interactive input during execution | Define with `@variable = {{$prompt variableName}}` |
| **Variables** | Auto-completion | IntelliSense for variables | Start typing `{{` to see available variables |
| **Variables** | Variable diagnostics | Error detection for undefined variables | Red underlines for missing variables |
| **Variables** | Go to definition | Navigate to variable declarations | Ctrl+click on variable usage |
| **System Variables** | GUID generation | Generate unique identifiers | `{{$guid}}` |
| **System Variables** | Random integers | Generate random numbers in range | `{{$randomInt min max}}` |
| **System Variables** | Timestamps | Current timestamp in various formats | `{{$timestamp}}`, `{{$datetime}}` |
| **System Variables** | Environment access | Access system environment variables | `{{$processEnv variableName}}` |
| **System Variables** | Dotenv support | Load variables from .env files | `{{$dotenv variableName}}` |
| **Environment Management** | Environment switching | Switch between dev/test/prod configs | Use environment selector in status bar |
| **Environment Management** | Shared environments | Common variables across environments | Define in shared environment section |
| **Code Generation** | Generate code snippets | Convert requests to various languages | Right-click request and select "Generate Code Snippet" |
| **Session Management** | Cookie persistence | Maintain session across requests | Automatic cookie handling between requests |
| **Network** | Proxy support | Route requests through proxy servers | Configure proxy settings in VS Code |
| **SOAP Support** | SOAP request support | Send SOAP web service requests | Use SOAP envelope templates and snippets |
| **Language Support** | HTTP syntax highlighting | Color-coded request and response syntax | Automatic for .http and .rest files |
| **Language Support** | Auto-completion | IntelliSense for HTTP methods, headers | Start typing to see suggestions |
| **Language Support** | Comment support | Document requests with comments | Lines starting with `#` or `//` |
| **Language Support** | JSON/XML formatting | Auto-indent and format request bodies | Automatic formatting for structured data |
| **Language Support** | Code snippets | Quick templates for common requests | Type snippet name and press Tab |
| **Navigation** | Symbol navigation | Jump to variable definitions | Use Go to Definition (F12) |
| **Navigation** | CodeLens integration | Actionable links above requests | Click "Send Request" link |
| **Editor Features** | Request folding | Collapse/expand request blocks | Click fold icons or use Ctrl+Shift+[ |
| **Markdown Integration** | Fenced code blocks | HTTP requests in markdown files | Use ```http code blocks |