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
    - [1. Inline Variables (Same File)](#1-inline-variables-same-file)
    - [2. Variable Organization in Same File](#2-variable-organization-in-same-file)
    - [3. Environment-Specific Files (Not Version Controlled)](#3-environment-specific-files-not-version-controlled)
    - [4. Template Files for Team Sharing](#4-template-files-for-team-sharing)
    - [5. VS Code Environment Variables (Recommended for Multiple Environments)](#5-vs-code-environment-variables-recommended-for-multiple-environments)
    - [Best Practices for Variable Organization](#best-practices-for-variable-organization)
  - [Multiple Requests in One File](#multiple-requests-in-one-file)
  - [Response Handling](#response-handling)
  - [Using Response Variables](#using-response-variables)
  - [File Uploads](#file-uploads)
  - [cURL Integration](#curl-integration)
- [Benefits Over Postman](#benefits-over-postman)
- [Azure AD Authentication for Protected APIs](#azure-ad-authentication-for-protected-apis)
  - [Method 1: Client Credentials Flow (Service-to-Service)](#method-1-client-credentials-flow-service-to-service)
  - [Method 2: Authorization Code Flow with PKCE (Interactive)](#method-2-authorization-code-flow-with-pkce-interactive)
  - [Method 3: Using REST Client's Built-in Azure AD Support](#method-3-using-rest-clients-built-in-azure-ad-support)
  - [Method 4: Environment-Specific Configuration](#method-4-environment-specific-configuration)
  - [Method 5: Token Refresh Pattern](#method-5-token-refresh-pattern)
  - [Security Best Practices](#security-best-practices)
  - [Common Token Response Structure](#common-token-response-structure)
- [References](#references)
- [Appendixes](#appendixes)
  - [Appendix A: REST Client Main Features](#appendix-a-rest-client-main-features)

## Getting Started with `REST Client` .http Files

### 1. Install the `REST Client` Extension in VS Code

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
- Click the "<mark>Send Request</mark>" link that appears above each request
- Or use the shortcut <mark>`Ctrl+Alt+R`</mark> (Windows/Linux) or `Cmd+Alt+R` (Mac)

## Advanced Features

### Variables and Environments

Define variables with <mark>`@`</mark> to reuse values. Variables can be organized in multiple ways depending on your needs:

#### 1. Inline Variables (Same File)

Define variables directly in your HTTP file:

```http
@baseUrl = https://api.example.com
@authToken = Bearer your-token-here

### Get all items
GET {{baseUrl}}/items
Authorization: {{authToken}}
```

#### 2. Variable Organization in Same File

For better organization, group variables at the top of your HTTP file:

**`api-tests.http`:**

```http
### Variables section
@baseUrl = https://api.example.com
@version = v1
@contentType = application/json

### Get all items
GET {{baseUrl}}/{{version}}/items
Content-Type: {{contentType}}

### Create new item
POST {{baseUrl}}/{{version}}/items
Content-Type: {{contentType}}

{
  "name": "Test Item"
}
```

#### 3. Environment-Specific Files (Not Version Controlled)

Create environment-specific variable files that contain sensitive or environment-specific data. **Add these to `.gitignore`** to keep them out of version control:

**`.gitignore`:**

```gitignore
# HTTP file environment variables
*.env.http
.env.*.http
secrets.http
local-variables.http
```

**`dev.env.http` (not versioned):**

```http
@baseUrl = https://localhost:7001
@clientSecret = dev-secret-key
@dbConnectionString = Server=localhost;Database=DevDB
```

**`prod.env.http` (not versioned):**

```http
@baseUrl = https://api.production.com
@clientSecret = prod-secret-key
@dbConnectionString = Server=prod-server;Database=ProdDB
```

**`api-tests.http` (versioned):**

```http
### Copy variables from dev.env.http manually when needed
@baseUrl = https://localhost:7001
@clientSecret = dev-secret-key

### Shared variables that can be version controlled
@apiVersion = v2
@userAgent = MyApp/1.0

### API calls using manually copied and shared variables
GET {{baseUrl}}/{{apiVersion}}/health
User-Agent: {{userAgent}}
```

#### 4. Template Files for Team Sharing

Create template files that team members can copy and customize:

**`variables.template.http` (versioned):**

```http
# Copy this file to variables.local.http and fill in your values
@baseUrl = https://your-api-domain.com
@clientId = your-client-id-here
@clientSecret = your-client-secret-here
@tenantId = your-tenant-id-here
```

**Team workflow:**
1. Copy `variables.template.http` to `variables.local.http`
2. Fill in actual values in `variables.local.http`
3. Copy and paste variables from `variables.local.http` into your HTTP files as needed

#### 5. VS Code Environment Variables (Recommended for Multiple Environments)

Instead of file imports, use VS Code's built-in environment variable system for managing different environments:

**In `.vscode/settings.json`:**

```json
{
  "rest-client.environmentVariables": {
    "development": {
      "baseUrl": "https://localhost:7001",
      "apiKey": "dev-api-key-here"
    },
    "production": {
      "baseUrl": "https://api.production.com", 
      "apiKey": "prod-api-key-here"
    }
  }
}
```

environment selection in vscode happens with <mark>Ctrl+Shift+P</mark> and selecting "<mark>Rest Client: Switch Environment</mark>"

| Step | Screenshot |
|------|------------|
| Ctrl+Shift+P | ![alt text](<images/001.01 VisualStudioCode command.png>) |
| Rest Client: Switch Environment | ![alt text](<images/001.02 Switch environment.png>) |

**In your HTTP files:**

```http
### Use environment variables (switch environments in VS Code status bar)
GET {{baseUrl}}/api/data
Authorization: Bearer {{apiKey}}
```

**How to switch environments:**
1. Look for "No Environment" in VS Code status bar (bottom)
2. Click it to select "development" or "production"
3. Variables automatically switch based on your selection

#### Best Practices for Variable Organization

**Version Control Strategy:**
- ✅ **DO commit**: Template files, shared non-sensitive variables
- ❌ **DON'T commit**: Environment-specific files with secrets, local customizations

**File Naming Conventions:**
- `*.template.http` - Template files for team sharing
- `*.env.http` - Environment-specific variables (add to .gitignore)
- `*.local.http` - Local developer overrides (add to .gitignore)
- `shared-*.http` - Common variables safe for version control

**Security Guidelines:**
- Never commit API keys, passwords, or connection strings
- Use placeholder values in template files
- Document required variables in your README
- Consider using VS Code's built-in environment variables for sensitive data

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

### cURL Integration

The REST Client extension provides seamless integration with cURL, allowing you to import cURL commands or export your HTTP requests as cURL commands. This bidirectional conversion makes it easy to work with both formats.

#### Converting cURL to HTTP Files

You can paste cURL commands directly into your HTTP files, and the REST Client will understand and execute them:

```http
### Direct cURL command in HTTP file
curl -X POST https://api.example.com/items \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer {{token}}" \
  -d '{"name": "Test Item", "description": "Created from cURL"}'
```

**Alternative syntax** - Convert cURL to standard HTTP format:

```http
### Converted from cURL
POST https://api.example.com/items
Content-Type: application/json
Authorization: Bearer {{token}}

{
  "name": "Test Item",
  "description": "Created from cURL"
}
```

#### Exporting HTTP Requests as cURL

Right-click on any HTTP request in your file and select **"Copy Request as cURL"** to get the equivalent cURL command. This is useful for:

- Sharing requests with team members who prefer command line
- Running requests in CI/CD pipelines
- Debugging requests in terminal environments
- Documentation that requires cURL examples

**Example export result:**

```bash
curl --request POST \
  --url https://api.example.com/items \
  --header 'Content-Type: application/json' \
  --header 'Authorization: Bearer your-token-here' \
  --data '{
  "name": "Test Item",
  "description": "Created from HTTP file"
}'
```

#### Using Variables with cURL

Variables defined in your HTTP files work seamlessly with both HTTP syntax and cURL commands:

```http
@baseUrl = https://api.example.com
@authToken = Bearer abc123

### Using variables in cURL command
curl -X GET "{{baseUrl}}/items" \
  -H "Authorization: {{authToken}}"

### Same request in HTTP syntax
GET {{baseUrl}}/items
Authorization: {{authToken}}
```

#### Advanced cURL Features Support

The REST Client supports most cURL features including:

**File uploads:**
```http
curl -X POST "{{baseUrl}}/upload" \
  -F "file=@./document.pdf" \
  -F "description=Important document"
```

**Custom headers and authentication:**
```http
curl -X GET "{{baseUrl}}/secure-data" \
  -H "X-API-Key: {{apiKey}}" \
  -H "User-Agent: MyApp/1.0" \
  --basic -u "{{username}}:{{password}}"
```

**Following redirects and handling cookies:**
```http
curl -X POST "{{baseUrl}}/login" \
  -L \
  -c cookies.txt \
  -d "username={{user}}&password={{pass}}"
```

#### Supported cURL Options

The REST Client supports these commonly used cURL options:

| cURL Option | Description | HTTP File Equivalent |
|-------------|-------------|---------------------|
| `-X, --request` | HTTP method | `GET`, `POST`, `PUT`, etc. |
| `-H, --header` | Custom headers | Header lines below method |
| `-d, --data` | Request body data | Body section after empty line |
| `-F, --form` | Form data | `Content-Type: multipart/form-data` |
| `-u, --user` | Basic authentication | `Authorization: Basic` header |
| `-b, --cookie` | Send cookies | `Cookie:` header |
| `-c, --cookie-jar` | Save cookies | Automatic cookie handling |
| `-L, --location` | Follow redirects | Automatic redirect following |
| `-k, --insecure` | Skip SSL verification | REST Client settings |
| `-v, --verbose` | Verbose output | Response details panel |

#### Benefits of cURL Integration

1. **Flexibility**: Use whichever syntax you prefer - HTTP or cURL
2. **Team Compatibility**: Easily share between HTTP file users and cURL users
3. **CI/CD Integration**: Export requests for use in automated pipelines
4. **Legacy Support**: Import existing cURL-based documentation and scripts
5. **Learning Bridge**: Helps transition between command-line and GUI-based API testing

#### Best Practices for cURL Integration

- **Use variables**: Keep cURL commands maintainable with variable substitution
- **Document both formats**: Provide both HTTP and cURL examples in team documentation
- **Consistent formatting**: Use line continuation (`\`) for readable multi-line cURL commands
- **Environment awareness**: Ensure variables work correctly when exporting to cURL
- **Security**: Be cautious when sharing exported cURL commands that might contain sensitive data


## Benefits Over Postman

1. **Lightweight**: No need for a separate application
2. **Version Control**: Store API tests alongside your code
3. **Easy Sharing**: Share requests as simple text files
4. **Environment Integration**: Works directly in your development environment
5. **Text-based**: Easy to review changes in pull requests

## Azure AD Authentication for Protected APIs

When your API is protected by Azure AD authentication, you need to obtain an access token before making requests. Here are several approaches using HTTP files:

### Method 1: Client Credentials Flow (Service-to-Service)

For service-to-service authentication using client credentials:

```http
### Variables for Azure AD
@tenantId = b92a****-****-****-****-************
@clientId = 7cb9****-****-****-****-************
@clientSecret = your-client-secret-here
@scope = api://{{clientId}}/.default
@baseUrl = https://your-api-domain.com

### Get Azure AD Token (Client Credentials)
# @name getToken
POST https://login.microsoftonline.com/{{tenantId}}/oauth2/v2.0/token
Content-Type: application/x-www-form-urlencoded

grant_type=client_credentials
&client_id={{clientId}}
&client_secret={{clientSecret}}
&scope={{scope}}

### Use the token to call protected API
GET {{baseUrl}}/api/protected-endpoint
Authorization: Bearer {{getToken.response.body.access_token}}
```

### Method 2: Authorization Code Flow with PKCE (Interactive)

For user authentication scenarios where you need to authenticate as a specific user rather than as an application.

**What is PKCE?**

- **PKCE** (Proof Key for Code Exchange, pronounced "pixie") is a security extension for OAuth 2.0
- Protects against authorization code interception attacks
- Essential for public clients (SPAs, mobile apps) that can't securely store secrets
- Uses a dynamically generated code verifier/challenge pair for enhanced security

**Why "Interactive"?**

- Requires manual user interaction (opening browser, logging in, copying authorization code)
- Cannot be fully automated like client credentials flow
- Suitable for testing user-specific API endpoints that require delegated permissions

```http
### Step 1: Generate PKCE parameters (manual)
# Generate a code verifier (random string 43-128 chars): 
# Example: dBjftJeZ4CVP-mB92K27uhbUJU1p1r_wW1gFWFOEjXk
@codeVerifier = dBjftJeZ4CVP-mB92K27uhbUJU1p1r_wW1gFWFOEjXk
# Code challenge (SHA256 base64url of verifier): 
# Example: E9Melhoa2OwvFrEMTJguCHaoeK1t8URWbuGJSstw-cM
@codeChallenge = E9Melhoa2OwvFrEMTJguCHaoeK1t8URWbuGJSstw-cM

### Step 2: Generate Authorization URL (paste in browser)
# Manual step: Open this URL in browser, log in, and copy the authorization code from redirect
# https://login.microsoftonline.com/{{tenantId}}/oauth2/v2.0/authorize?client_id={{clientId}}&response_type=code&redirect_uri=http://localhost:8080/signin-oidc&response_mode=query&scope={{scope}}&state=12345&code_challenge={{codeChallenge}}&code_challenge_method=S256

### Step 3: Exchange authorization code for token
# @name getTokenFromCode
POST https://login.microsoftonline.com/{{tenantId}}/oauth2/v2.0/token
Content-Type: application/x-www-form-urlencoded

grant_type=authorization_code
&client_id={{clientId}}
&code=PASTE_AUTHORIZATION_CODE_HERE
&redirect_uri=http://localhost:8080/signin-oidc
&scope={{scope}}
&code_verifier={{codeVerifier}}

### Use the token to call protected API
GET {{baseUrl}}/api/protected-endpoint
Authorization: Bearer {{getTokenFromCode.response.body.access_token}}
```

**Security Benefits of PKCE:**

- **No client secret required**: Safer for public clients
- **Dynamic verification**: Each flow uses unique verifier/challenge pairs  
- **Interception protection**: Even if authorization code is stolen, it's useless without the code verifier
- **Recommended practice**: Microsoft recommends PKCE for all OAuth flows, even confidential clients

### Method 3: Using REST Client's Built-in Azure AD Support

The REST Client extension has built-in support for Azure AD:

```http
### Using system variable for Azure AD token
@tenantId = b92a****-****-****-****-************
@clientId = 7cb9****-****-****-****-************

### Call protected API with automatic token
GET {{baseUrl}}/api/protected-endpoint
Authorization: Bearer {{$aadToken tenantId clientId}}
```

### Method 4: Environment-Specific Configuration

Create environment-specific configurations in VS Code settings:

**In `.vscode/settings.json`:**

```json
{
  "rest-client.environmentVariables": {
    "development": {
      "baseUrl": "https://localhost:7001",
      "tenantId": "b92a****-****-****-****-************",
      "clientId": "7cb9****-****-****-****-************",
      "clientSecret": "dev-client-secret"
    },
    "production": {
      "baseUrl": "https://api.production.com",
      "tenantId": "b92a****-****-****-****-************",
      "clientId": "7cb9****-****-****-****-************",
      "clientSecret": "prod-client-secret"
    }
  }
}
```

**Then use in your HTTP file:**

```http
### Get token for current environment
# @name getEnvToken
POST https://login.microsoftonline.com/{{tenantId}}/oauth2/v2.0/token
Content-Type: application/x-www-form-urlencoded

grant_type=client_credentials
&client_id={{clientId}}
&client_secret={{clientSecret}}
&scope=api://{{clientId}}/.default

### Call API with environment-specific token
GET {{baseUrl}}/api/data
Authorization: Bearer {{getEnvToken.response.body.access_token}}
```

### Method 5: Token Refresh Pattern

Handle token expiration with refresh tokens:

```http
### Initial authentication
# @name initialAuth
POST https://login.microsoftonline.com/{{tenantId}}/oauth2/v2.0/token
Content-Type: application/x-www-form-urlencoded

grant_type=authorization_code
&client_id={{clientId}}
&code=AUTHORIZATION_CODE_HERE
&redirect_uri=http://localhost:8080/signin-oidc
&scope={{scope}}

### Refresh token when needed
# @name refreshAuth
POST https://login.microsoftonline.com/{{tenantId}}/oauth2/v2.0/token
Content-Type: application/x-www-form-urlencoded

grant_type=refresh_token
&client_id={{clientId}}
&refresh_token={{initialAuth.response.body.refresh_token}}
&scope={{scope}}

### Use current valid token
GET {{baseUrl}}/api/secure-data
Authorization: Bearer {{refreshAuth.response.body.access_token}}
```

### Security Best Practices

1. **Never commit secrets**: Use environment variables or VS Code settings for sensitive data
2. **Token expiration**: Check `expires_in` field and refresh tokens appropriately
3. **Scope principle**: Request only the minimum required scopes
4. **HTTPS only**: Always use HTTPS for token requests
5. **Secure storage**: Store tokens securely and clear them when done

### Common Token Response Structure

Azure AD token responses typically include:

```json
{
  "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIs...",
  "token_type": "Bearer",
  "expires_in": 3599,
  "refresh_token": "0.ARcA6KAC2wDFZEOPiD...",
  "scope": "access_as_user"
}
```

You can reference these values in subsequent requests:

- `{{tokenRequest.response.body.access_token}}`
- `{{tokenRequest.response.body.expires_in}}`
- `{{tokenRequest.response.body.refresh_token}}`

## References

1. [REST Client Extension Documentation](https://marketplace.visualstudio.com/items?itemName=humao.rest-client)  
   Official documentation from the extension author that provides detailed instructions on how to use the REST Client extension, including all available features and syntax options. Essential reading for understanding the full capabilities of the extension.

2. [VS Code REST Client GitHub Repository](https://github.com/Huachao/vscode-restclient)  
   The source repository contains examples, issue tracking, and the latest development updates for the extension. Useful for understanding the implementation details, finding solutions to common problems, and tracking feature requests.

3. [GitHub Issue #845: Support for including variables from separate files](https://github.com/Huachao/vscode-restclient/issues/845)  
   This open issue discusses the requested feature for importing variables from external files using `< ./file.http` syntax. Important for understanding current limitations and why file imports are not supported in the REST Client extension.

4. [Microsoft .http Files Documentation](https://learn.microsoft.com/en-us/aspnet/core/test/http-files?view=aspnetcore-9.0)  
   Microsoft's official documentation for .http files in Visual Studio and Visual Studio Code. Provides an alternative perspective on HTTP file usage, particularly useful for ASP.NET Core developers who want to understand Microsoft's implementation and recommendations.

5. [HTTP/1.1 Specification (RFC 7230-7235)](https://datatracker.ietf.org/doc/html/rfc7230)  
   The official HTTP protocol specification that defines the syntax and semantics of HTTP/1.1 messages. Understanding this specification helps write more accurate and standard-compliant HTTP requests and troubleshoot protocol-level issues.

6. [OAuth 2.0 Authorization Framework (RFC 6749)](https://datatracker.ietf.org/doc/html/rfc6749)  
   The official OAuth 2.0 specification that defines the authorization framework used in the Azure AD authentication examples. Essential for understanding the security flows demonstrated in this guide.

7. [OAuth 2.0 for Public Clients (RFC 7636) - PKCE](https://datatracker.ietf.org/doc/html/rfc7636)  
   The PKCE (Proof Key for Code Exchange) specification that extends OAuth 2.0 for enhanced security in public clients. Relevant for understanding the PKCE authentication flow examples provided in the Azure AD section.

8. [REST Client vs. Postman: A Comparative Analysis](https://blog.bitsrc.io/vs-code-extensions-for-testing-api-calls-e981ba65eeb4)  
   An in-depth comparison between REST Client and other API testing tools like Postman, highlighting the strengths and limitations of each approach. Helps developers choose the right tool for their workflow.

9. [Advanced HTTP Request Testing Patterns](https://medium.com/@walmyrlimaesilv/vs-code-how-to-make-http-rest-api-requests-inside-visual-studio-code-a325a26aaed6)  
   This guide covers advanced patterns for organizing and automating API tests using HTTP files, including environment management and test sequencing. Provides practical examples for complex testing scenarios.

10. [Environment Variables in REST Client](https://github.com/Huachao/vscode-restclient/blob/master/README.md#environment-variables)  
    A specific guide on how to use environment variables in REST Client, which is crucial for managing different environments (development, testing, production) in your API tests. Direct reference to the official implementation details.

11. [cURL Manual and Documentation](https://curl.se/docs/manual.html)  
    Comprehensive documentation for cURL command-line tool. Relevant for understanding the cURL integration features demonstrated in this guide and for users transitioning between HTTP files and command-line tools.

12. [Azure Active Directory v2.0 Protocols](https://docs.microsoft.com/en-us/azure/active-directory/develop/v2-protocols)  
    Microsoft's documentation on Azure AD authentication protocols and endpoints. Essential reference for implementing the Azure AD authentication examples shown in this guide, including client credentials and PKCE flows.

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
| **Markdown Integration** | Fenced code blocks | HTTP requests in markdown files | Use ```http code blocks