# Using HTTP Files for API Testing (Visual Studio)

## Table of Contents

- [📖 Introduction](#-introduction)
- [🚀 Getting Started](#-getting-started)
  - [Prerequisites](#prerequisites)
  - [Creating an HTTP File](#creating-an-http-file)
- [📝 Basic HTTP Request Syntax](#-basic-http-request-syntax)
  - [Simple GET Request](#simple-get-request)
  - [Request with Headers](#request-with-headers)
  - [POST Request with JSON Body](#post-request-with-json-body)
  - [Multiple Requests in One File](#multiple-requests-in-one-file)
- [⚡ Advanced Features](#-advanced-features)
  - [Using Variables](#using-variables)
  - [Environment-Specific Variables](#environment-specific-variables)
  - [Request Comments](#request-comments)
  - [File Upload](#file-upload)
- [🔗 Request Chaining and Multiple Request Files](#-request-chaining-and-multiple-request-files)
  - [Request Chaining in Visual Studio](#request-chaining-in-visual-studio)
  - [Request Chaining in VSCode (For Comparison)](#request-chaining-in-vscode-for-comparison)
  - [Managing Multiple HTTP Files](#managing-multiple-http-files)
  - [Sharing Variables Across Files](#sharing-variables-across-files)
  - [Cross-File Workflow Example](#cross-file-workflow-example)
- [▶️ Executing Requests](#️-executing-requests)
  - [Running a Request](#running-a-request)
  - [Viewing Responses](#viewing-responses)
- [🧪 Testing Workflows](#-testing-workflows)
  - [Authentication Flow](#authentication-flow)
  - [CRUD Operations Testing](#crud-operations-testing)
- [✅ Best Practices](#-best-practices)
  - [1. Organize Your HTTP Files](#1-organize-your-http-files)
  - [2. Use Meaningful Names and Comments](#2-use-meaningful-names-and-comments)
  - [3. Version Control Your HTTP Files](#3-version-control-your-http-files)
  - [4. Separate Sensitive Data](#4-separate-sensitive-data)
  - [5. Test Edge Cases](#5-test-edge-cases)
- [⚖️ Visual Studio vs VSCode Differences in Handling .http Files](#️-visual-studio-vs-vscode-differences-in-handling-http-files)
  - [IDE Integration](#ide-integration)
  - [Feature Differences](#feature-differences)
  - [Variables Support Comparison](#variables-support-comparison)
  - [Settings and Configuration](#settings-and-configuration)
  - [Request Execution](#request-execution)
  - [Response Viewing](#response-viewing)
  - [When to Use Which](#when-to-use-which)
  - [Migration Considerations](#migration-considerations)
- [🔄 Integration with CI/CD](#-integration-with-cicd)
  - [Generate Tests from HTTP Files](#generate-tests-from-http-files)
  - [Use as Living Documentation](#use-as-living-documentation)
- [🔧 Troubleshooting](#-troubleshooting)
  - [Common Issues](#common-issues)
- [🎯 Conclusion](#-conclusion)
- [📚 Additional Resources](#-additional-resources)

## 📖 Introduction

HTTP files (`.http` or `.rest`) provide a simple, text-based way to define and execute HTTP requests directly within <mark>Visual Studio</mark>.<br>
This approach offers developers a lightweight alternative to traditional API testing tools like **Postman** or **Insomnia**, keeping API tests version-controlled alongside your code.

Visual Studio's built-in support for HTTP files makes it easy to test APIs during development without leaving your IDE, streamlining the development workflow and improving productivity.

## 🚀 Getting Started

### Prerequisites

- Visual Studio 2022 (version 17.0 or later)
- A web API project or access to an API endpoint

### Creating an HTTP File

1. Right-click on your project or solution in Solution Explorer
2. Select **Add** > **New Item**
3. Search for "HTTP" or scroll to find **HTTP File**
4. Name your file (e.g., `api-tests.http`)
5. Click **Add**

## 📝 Basic HTTP Request Syntax

### Simple GET Request

```http
GET https://api.example.com/users
```

### Request with Headers

```http
GET https://api.example.com/users
Accept: application/json
Authorization: Bearer your-token-here
```

### POST Request with JSON Body

```http
POST https://api.example.com/users
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john.doe@example.com",
  "role": "developer"
}
```

### Multiple Requests in One File

Separate multiple requests with `###`:

```http
### Get all users
GET https://api.example.com/users

### Get specific user
GET https://api.example.com/users/123

### Create new user
POST https://api.example.com/users
Content-Type: application/json

{
  "name": "Jane Smith",
  "email": "jane.smith@example.com"
}

### Update user
PUT https://api.example.com/users/123
Content-Type: application/json

{
  "name": "Jane Smith Updated",
  "email": "jane.smith@example.com"
}

### Delete user
DELETE https://api.example.com/users/123
```

## ⚡ Advanced Features

### Using Variables

Define variables at the top of your file:

```http
@baseUrl = https://api.example.com
@userId = 123
@token = eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

### Get user by ID
GET {{baseUrl}}/users/{{userId}}
Authorization: Bearer {{token}}
```

### Environment-Specific Variables

Variables in HTTP files allow you to parameterize your requests, making them reusable across different environments and scenarios.

#### How Variables Are Defined

Variables use a simple declaration syntax:

```http
@variableName = value
```

Variables can contain:
- URLs and endpoints
- Authentication tokens
- API keys
- Request parameters
- Port numbers
- Any other string values

#### Where Variables Can Be Defined

**1. Same HTTP File (Inline Variables)**

The most common approach is defining variables directly in your `.http` file:

```http
# Define variables at the top
@baseUrl = https://api.example.com
@apiVersion = v1
@userId = 123

# Use variables in requests
GET {{baseUrl}}/{{apiVersion}}/users/{{userId}}
```

**2. Environment-Specific Variables (Comment/Uncomment Pattern)**

You can maintain multiple environment configurations in the same file using comments:

```http
# Development Environment
@baseUrl = https://localhost:5001
@apiKey = dev-api-key-12345

# Staging Environment (commented out)
# @baseUrl = https://staging-api.example.com
# @apiKey = staging-api-key-67890

# Production Environment (commented out)
# @baseUrl = https://api.example.com
# @apiKey = prod-api-key-abcde

### Test endpoint
GET {{baseUrl}}/api/health
X-API-Key: {{apiKey}}
```

**3. Separate Configuration Files**

For better organization and security, you can split variables into separate files:

**config-dev.http**:
```http
@baseUrl = https://localhost:5001
@apiKey = dev-key-123
@timeout = 30
```

**config-prod.http**:
```http
@baseUrl = https://api.production.com
@apiKey = prod-key-xyz
@timeout = 60
```

**api-tests.http**:
```http
# Note: Visual Studio doesn't automatically import from other files
# You need to manually copy variables or maintain them separately
# Copy the appropriate config here based on your environment

@baseUrl = https://localhost:5001
@apiKey = dev-key-123

### Test request
GET {{baseUrl}}/api/users
X-API-Key: {{apiKey}}
```

**4. External Environment Files (http-client.env.json)**

✅ **Visual Studio Support**: Visual Studio 2022 supports `http-client.env.json` and `http-client.private.env.json` files for managing environment-specific variables externally.

**http-client.env.json** (committed to repository):
```json
{
  "dev": {
    "baseUrl": "https://localhost:5001",
    "apiVersion": "v1",
    "timeout": "30"
  },
  "staging": {
    "baseUrl": "https://staging-api.example.com",
    "apiVersion": "v1",
    "timeout": "45"
  },
  "production": {
    "baseUrl": "https://api.production.com",
    "apiVersion": "v1",
    "timeout": "60"
  }
}
```

**http-client.private.env.json** (excluded from version control via `.gitignore`):
```json
{
  "dev": {
    "apiKey": "dev-secret-key-123",
    "clientSecret": "dev-client-secret"
  },
  "staging": {
    "apiKey": "staging-secret-key-456",
    "clientSecret": "staging-client-secret"
  },
  "production": {
    "apiKey": "prod-secret-key-789",
    "clientSecret": "prod-client-secret"
  }
}
```

**Usage in your .http file:**
```http
### Test request using environment variables
# Select environment from dropdown in Visual Studio
GET {{baseUrl}}/{{apiVersion}}/api/users
X-API-Key: {{apiKey}}
```

**How to switch environments in Visual Studio:**
![alt text](<images/02.001 Visual Studio environment selector.png>)



1. Look for the environment dropdown in the HTTP editor toolbar
2. Select your desired environment (dev, staging, production)
3. Variables from both `http-client.env.json` and `http-client.private.env.json` are merged
4. Execute your request with the selected environment's variables

**File Location:**
- Place `http-client.env.json` and `http-client.private.env.json` in the same directory as your `.http` files
- Or in the solution root directory

**Key Benefits:**
- ✅ Separate public config from secrets
- ✅ Easy environment switching via UI
- ✅ Variables merge from both files
- ✅ Private file can be gitignored

**Important: Add to .gitignore:**
```gitignore
# Exclude private environment variables
http-client.private.env.json
```

**5. Sensitive Data Separation (Alternative Pattern)**

For security, create a separate file for sensitive variables and exclude it from version control:

**secrets.http** (add to `.gitignore`):
```http
@apiSecret = your-secret-key-here
@dbPassword = your-database-password
@privateToken = your-private-token
```

**public-config.http** (committed to repo):
```http
@baseUrl = https://api.example.com
@apiVersion = v2
# Note: Copy secrets from secrets.http file manually
```

#### System and Predefined Variables

**Visual Studio HTTP Files:**

Visual Studio currently has **limited support** for system variables. Unlike VSCode's REST Client extension, Visual Studio does not provide built-in system variables like timestamps or random values.

Available approaches:
- ✅ User-defined variables (manual)
- ❌ No automatic timestamp variables
- ❌ No random number generators
- ❌ No GUID generators
- ❌ No environment variable expansion

**Workaround - Manual Dynamic Values:**

You must manually update dynamic values:

```http
@timestamp = 2025-10-20T10:30:00Z
@requestId = 12345-random-id
@guid = 550e8400-e29b-41d4-a716-446655440000

POST https://api.example.com/events
Content-Type: application/json
X-Request-ID: {{requestId}}
X-Timestamp: {{timestamp}}

{
  "eventId": "{{guid}}",
  "timestamp": "{{timestamp}}"
}
```

**VSCode REST Client System Variables (Not Available in Visual Studio):**

For comparison, VSCode's REST Client offers:
- `{{$guid}}` - Generate a GUID
- `{{$randomInt min max}}` - Random integer
- `{{$timestamp}}` - Current Unix timestamp
- `{{$timestamp -1 d}}` - Relative timestamps
- `{{$datetime iso8601}}` - ISO 8601 datetime
- `{{$localDatetime iso8601}}` - Local datetime
- `{{$processEnv variableName}}` - OS environment variables
- `{{$dotenv variableName}}` - Variables from .env file

#### Best Practices for Variables

1. **Keep sensitive data separate**: Never commit API keys or passwords
2. **Use descriptive names**: `@authToken` is better than `@token1`
3. **Group related variables**: Keep environment configs together
4. **Document variable purpose**: Add comments explaining what each variable is for
5. **Use consistent naming**: Choose camelCase or snake_case and stick with it

Example with best practices:

```http
# ==============================================
# API Configuration
# ==============================================

# Base Configuration
@baseUrl = https://api.example.com
@apiVersion = v1

# Authentication (from secrets.http - not committed)
@clientId = your-client-id
@clientSecret = your-client-secret
@accessToken = obtained-after-login

# Test Data
@testUserId = 12345
@testEmail = test@example.com

# ==============================================
# Requests
# ==============================================

### Get User Profile
GET {{baseUrl}}/{{apiVersion}}/users/{{testUserId}}
Authorization: Bearer {{accessToken}}
Accept: application/json
```

### Request Comments

Add comments to document your requests:

```http
# This endpoint returns all active users
# Requires authentication
### Get Active Users
GET https://api.example.com/users?status=active
Authorization: Bearer {{token}}
```

### File Upload

```http
POST https://api.example.com/upload
Content-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW

------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="file"; filename="example.txt"
Content-Type: text/plain

< ./files/example.txt
------WebKitFormBoundary7MA4YWxkTrZu0gW--
```

## 🔗 Request Chaining and Multiple Request Files

Request chaining allows you to use the response from one request in subsequent requests, enabling complex testing workflows. Managing multiple HTTP files helps organize different API endpoints and testing scenarios.

### Request Chaining in Visual Studio

⚠️ **Visual Studio Limitation**: Visual Studio does **not support automatic request chaining**. You cannot automatically extract values from a response and use them in the next request.

**Manual Workflow (Copy-Paste Pattern):**

```http
@baseUrl = https://api.example.com

### Step 1: Login to get authentication token
POST {{baseUrl}}/auth/login
Content-Type: application/json

{
  "username": "testuser",
  "password": "testpass123"
}

# Response will look like:
# {
#   "token": "eyJhbGciOiJIUzI1NiIs...",
#   "userId": "12345",
#   "expiresIn": 3600
# }

### Step 2: Manually copy token from Step 1 response and paste below
@authToken = eyJhbGciOiJIUzI1NiIs...paste-your-token-here
@userId = 12345

### Step 3: Use the token to access protected endpoint
GET {{baseUrl}}/api/users/{{userId}}/profile
Authorization: Bearer {{authToken}}
```

**Workflow Steps:**
1. Execute the first request (login)
2. Manually copy the token from the response
3. Paste it into the variable declaration
4. Execute the subsequent requests

### Request Chaining in VSCode (For Comparison)

VSCode's REST Client extension supports automatic request chaining:

```http
### Login (named request)
# @name login
POST https://api.example.com/auth/login
Content-Type: application/json

{
  "username": "testuser",
  "password": "testpass123"
}

### Automatically extract token and use it
@authToken = {{login.response.body.token}}
@userId = {{login.response.body.userId}}

### Use extracted values automatically
GET https://api.example.com/api/users/{{userId}}/profile
Authorization: Bearer {{authToken}}
```

### Managing Multiple HTTP Files

Organizing your HTTP files by feature or API area improves maintainability and collaboration.

#### File Organization Strategies

**1. By API Domain:**
```
project/
├── http-tests/
│   ├── authentication.http      # Login, logout, token refresh
│   ├── users.http               # User CRUD operations
│   ├── products.http            # Product management
│   ├── orders.http              # Order processing
│   └── admin.http               # Admin operations
```

**2. By Environment:**
```
project/
├── http-tests/
│   ├── config/
│   │   ├── dev.http             # Development variables
│   │   ├── staging.http         # Staging variables
│   │   └── prod.http            # Production variables
│   └── tests/
│       ├── user-api.http        # User tests
│       └── product-api.http     # Product tests
```

**3. By Test Scenario:**
```
project/
├── http-tests/
│   ├── smoke-tests.http         # Quick health checks
│   ├── integration-tests.http   # Full workflow tests
│   ├── edge-cases.http          # Error scenarios
│   └── performance-tests.http   # Load testing scenarios
```

#### Sharing Variables Across Files

**Visual Studio Approach:**

Since Visual Studio doesn't support importing variables from other files, you need to:

**Option 1: Copy-Paste Pattern**

**shared-config.http** (reference file):
```http
# ==============================================
# Shared Configuration (Copy to your test files)
# ==============================================
@baseUrl = https://api.example.com
@apiVersion = v1
@timeout = 30
```

**users.http** (copy variables here):
```http
# Variables copied from shared-config.http
@baseUrl = https://api.example.com
@apiVersion = v1

### Get Users
GET {{baseUrl}}/{{apiVersion}}/users
```

**Option 2: Single Source of Truth**

Keep all shared variables in one master file:

**master-tests.http**:
```http
# ==============================================
# Configuration
# ==============================================
@baseUrl = https://api.example.com
@apiVersion = v1
@authToken = your-token-here

# ==============================================
# Authentication Tests
# ==============================================

### Login
POST {{baseUrl}}/auth/login
Content-Type: application/json

{
  "username": "test",
  "password": "pass"
}

# ==============================================
# User Tests
# ==============================================

### Get Users
GET {{baseUrl}}/{{apiVersion}}/users
Authorization: Bearer {{authToken}}

# ==============================================
# Product Tests
# ==============================================

### Get Products
GET {{baseUrl}}/{{apiVersion}}/products
Authorization: Bearer {{authToken}}
```

**Option 3: Documentation Reference**

Create a README with variable definitions:

**README-HTTP-TESTS.md**:
```markdown
# HTTP Test Configuration

## Required Variables

Copy these variables to your .http files:

- `@baseUrl` - API base URL
  - Dev: `https://localhost:5001`
  - Prod: `https://api.production.com`
- `@authToken` - Authentication token (obtain from login endpoint)
- `@apiVersion` - API version (currently `v1`)
```

#### Best Practices for Multiple Files

1. **Naming Convention**: Use clear, descriptive names
   - ✅ `user-management-api.http`
   - ❌ `test1.http`

2. **File Headers**: Include documentation at the top of each file
   ```http
   # ==============================================
   # User Management API Tests
   # Author: Development Team
   # Last Updated: 2025-10-20
   # Description: CRUD operations for user entities
   # ==============================================
   ```

3. **Consistent Variable Names**: Use the same variable names across files
   - Always use `@baseUrl` (not `@url`, `@apiUrl`, etc.)
   - Standardize authentication: `@authToken` or `@bearerToken`

4. **Section Separators**: Use visual separators for clarity
   ```http
   ### ==================== READ OPERATIONS ====================
   
   ### Get All Users
   GET {{baseUrl}}/users
   
   ### Get User by ID
   GET {{baseUrl}}/users/{{userId}}
   
   ### ==================== CREATE OPERATIONS ====================
   ```

5. **Keep Files Focused**: Each file should have a clear, single purpose
   - Don't mix unrelated endpoints in one file
   - Split large files when they exceed ~300 lines

6. **Version Control**: 
   - ✅ Commit: Test files, documentation
   - ❌ Don't commit: Files with real credentials, production tokens

### Cross-File Workflow Example

Since Visual Studio requires manual coordination between files:

**Step 1: Set up configuration**
```http
# config.http (reference only)
@baseUrl = https://api.example.com
@apiKey = your-api-key
```

**Step 2: Copy to auth file**
```http
# auth.http
@baseUrl = https://api.example.com  # copied from config
@apiKey = your-api-key              # copied from config

### Login
POST {{baseUrl}}/auth/login
X-API-Key: {{apiKey}}
Content-Type: application/json

{
  "username": "user",
  "password": "pass"
}

# Response: { "token": "abc123..." }
```

**Step 3: Copy to users file**
```http
# users.http
@baseUrl = https://api.example.com  # copied from config
@authToken = abc123...              # copied from auth.http response

### Get Users
GET {{baseUrl}}/users
Authorization: Bearer {{authToken}}
```

This manual approach ensures clarity but requires discipline to keep variables synchronized across files.

## ▶️ Executing Requests

### Running a Request

1. Place your cursor anywhere within the request block
2. Click the **Send Request** link that appears above the request
3. Or use the keyboard shortcut: **Ctrl+Alt+R**
4. View the response in the output pane

### Viewing Responses

Visual Studio displays responses in a separate pane showing:
- Status code and reason phrase
- Response headers
- Response body (with syntax highlighting for JSON/XML)
- Response time

## 🧪 Testing Workflows

### Authentication Flow

```http
@baseUrl = https://api.example.com

### Step 1: Login and get token
POST {{baseUrl}}/auth/login
Content-Type: application/json

{
  "username": "testuser",
  "password": "testpass123"
}

### Step 2: Use token (manually copy from response above)
@authToken = paste-token-here

GET {{baseUrl}}/api/protected-resource
Authorization: Bearer {{authToken}}
```

### CRUD Operations Testing

```http
@baseUrl = https://localhost:5001/api
@productId = 0

### CREATE - Add new product
POST {{baseUrl}}/products
Content-Type: application/json

{
  "name": "Test Product",
  "price": 29.99,
  "category": "Electronics"
}

### READ - Get all products
GET {{baseUrl}}/products

### READ - Get specific product (update @productId with created ID)
GET {{baseUrl}}/products/{{productId}}

### UPDATE - Modify product
PUT {{baseUrl}}/products/{{productId}}
Content-Type: application/json

{
  "name": "Updated Product Name",
  "price": 39.99,
  "category": "Electronics"
}

### DELETE - Remove product
DELETE {{baseUrl}}/products/{{productId}}
```

## ✅ Best Practices

### 1. Organize Your HTTP Files

Structure your HTTP files by feature or API area:
- `auth.http` - Authentication endpoints
- `users.http` - User management endpoints
- `products.http` - Product CRUD operations
- `orders.http` - Order processing endpoints

### 2. Use Meaningful Names and Comments

```http
### Create New Customer Account
# POST endpoint for customer registration
# Required fields: email, password, firstName, lastName
POST https://api.example.com/customers
Content-Type: application/json

{
  "email": "customer@example.com",
  "password": "SecurePass123!",
  "firstName": "John",
  "lastName": "Doe"
}
```

### 3. Version Control Your HTTP Files

Include HTTP files in your repository:
- Commit them with your code
- Use `.gitignore` to exclude sensitive data files
- Consider using environment variables for secrets

### 4. Separate Sensitive Data

Create a separate file for sensitive variables:

**api-config.http** (gitignored):
```http
@apiKey = your-secret-api-key
@password = your-password
```

**api-tests.http**:
```http
# Import variables from config file
# (Note: Visual Studio doesn't support file imports, use comments as reference)
@baseUrl = https://api.example.com

### Test with API key
GET {{baseUrl}}/secure-endpoint
X-API-Key: {{apiKey}}
```

### 5. Test Edge Cases

```http
### Test valid input
POST https://api.example.com/users
Content-Type: application/json

{
  "name": "Valid User",
  "email": "valid@example.com"
}

### Test missing required field
POST https://api.example.com/users
Content-Type: application/json

{
  "name": "Invalid User"
}

### Test invalid email format
POST https://api.example.com/users
Content-Type: application/json

{
  "name": "Invalid Email",
  "email": "not-an-email"
}
```

## ⚖️ Visual Studio vs VSCode Differences in Handling .http Files

While both Visual Studio and Visual Studio Code support HTTP files, there are important differences in how they handle these files:

### IDE Integration

**Visual Studio:**
- Native built-in support starting with Visual Studio 2022 (v17.0+)
- No additional extensions required
- Integrated directly into the IDE's request execution framework
- Part of the Web API development toolset

**VSCode:**
- Requires the **REST Client** extension by Huachao Mao
- More lightweight and modular approach
- Extension must be explicitly installed from the marketplace

### Feature Differences

| Feature | Visual Studio | VSCode (REST Client) |
|---------|---------------|----------------------|
| Basic HTTP requests | ✅ Yes | ✅ Yes |
| Variables | ✅ Yes | ✅ Yes |
| Environment files | ⚠️ Limited | ✅ Yes (via settings.json) |
| Request chaining | ❌ Manual | ✅ Yes (capture response variables) |
| Custom scripts | ❌ No | ✅ Yes (pre-request scripts) |
| Response history | ✅ Limited | ✅ Full history |
| GraphQL support | ⚠️ Basic | ✅ Advanced |
| Request authentication helpers | ⚠️ Manual | ✅ Yes (AWS, Azure AD, etc.) |

### Variables Support Comparison

Both IDEs support variables, but with significant differences in capabilities and flexibility.

#### Basic Variable Declaration

**Visual Studio & VSCode - Identical Syntax:**

Both use the same basic syntax for declaring and using variables:

```http
@variable = value
GET https://api.com/{{variable}}
```

**Example (works in both):**
```http
@baseUrl = https://api.example.com
@userId = 123

GET {{baseUrl}}/users/{{userId}}
```

✅ **Full Compatibility**: Basic variable declarations are 100% compatible between both IDEs.

#### Variable Definition Locations

| Location | Visual Studio | VSCode (REST Client) |
|----------|---------------|----------------------|
| Inline in .http file | ✅ Yes | ✅ Yes |
| Environment JSON files | ✅ Yes (http-client.env.json) | ✅ Yes (settings.json) |
| Private environment files | ✅ Yes (http-client.private.env.json) | ✅ Yes (in settings.json) |
| .env file integration | ❌ Not supported | ✅ Yes (via `{{$dotenv var}}`) |
| OS environment variables | ❌ Not supported | ✅ Yes (via `{{$processEnv var}}`) |

**Visual Studio - Two Options:**

*Option 1: Inline in .http file*
```http
@baseUrl = https://api.example.com
@apiKey = your-key-here

GET {{baseUrl}}/api/data
X-API-Key: {{apiKey}}
```

*Option 2: External environment files (recommended)*

**http-client.env.json:**
```json
{
  "dev": {
    "baseUrl": "https://localhost:5001"
  },
  "prod": {
    "baseUrl": "https://api.production.com"
  }
}
```

**http-client.private.env.json:**
```json
{
  "dev": {
    "apiKey": "dev-secret-key"
  },
  "prod": {
    "apiKey": "prod-secret-key"
  }
}
```

**In your .http file:**
```http
# Select environment from Visual Studio dropdown
GET {{baseUrl}}/api/data
X-API-Key: {{apiKey}}
```

**VSCode - Multiple Options:**

*Option 1: Inline (same as Visual Studio)*
```http
@baseUrl = https://api.example.com
GET {{baseUrl}}/api/data
```

*Option 2: Settings file (.vscode/settings.json)*
```json
{
  "rest-client.environmentVariables": {
    "$shared": {
      "apiVersion": "v1"
    },
    "dev": {
      "baseUrl": "https://localhost:5001",
      "apiKey": "dev-key"
    },
    "prod": {
      "baseUrl": "https://api.production.com",
      "apiKey": "prod-key"
    }
  }
}
```

Then in your .http file:
```http
# Variables come from settings.json
GET {{baseUrl}}/{{apiVersion}}/data
X-API-Key: {{apiKey}}
```

*Option 3: Environment variables*
```http
# Access OS environment variables
GET https://api.example.com
X-API-Key: {{$processEnv API_KEY}}

# Access .env file variables
Authorization: Bearer {{$dotenv AUTH_TOKEN}}
```

#### System and Dynamic Variables

| Variable Type | Visual Studio | VSCode (REST Client) |
|--------------|---------------|----------------------|
| User-defined variables | ✅ Yes | ✅ Yes |
| Timestamps | ❌ Manual only | ✅ `{{$timestamp}}` |
| Random integers | ❌ Manual only | ✅ `{{$randomInt min max}}` |
| GUIDs | ❌ Manual only | ✅ `{{$guid}}` |
| Date/time formatting | ❌ Manual only | ✅ `{{$datetime format}}` |
| Relative timestamps | ❌ Not supported | ✅ `{{$timestamp -1 d}}` |

**Visual Studio - Manual Dynamic Values:**

You must manually update values that need to be dynamic:

```http
# Manually updated before each request
@requestId = 12345
@timestamp = 2025-10-20T10:30:00Z
@guid = 550e8400-e29b-41d4-a716-446655440000

POST https://api.example.com/events
Content-Type: application/json
X-Request-ID: {{requestId}}

{
  "eventId": "{{guid}}",
  "timestamp": "{{timestamp}}"
}
```

**VSCode - Automatic Dynamic Values:**

```http
# Automatically generated each time the request is sent
POST https://api.example.com/events
Content-Type: application/json
X-Request-ID: {{$randomInt 10000 99999}}
X-Timestamp: {{$timestamp}}

{
  "eventId": "{{$guid}}",
  "timestamp": "{{$datetime iso8601}}",
  "scheduledFor": "{{$timestamp 1 d}}"
}
```

**Available VSCode System Variables:**
- `{{$guid}}` - RFC 4122 v4 GUID
- `{{$randomInt min max}}` - Random integer between min and max
- `{{$timestamp [offset unit]}}` - Unix timestamp in seconds
  - Examples: `{{$timestamp}}`, `{{$timestamp -1 d}}`, `{{$timestamp 2 h}}`
- `{{$datetime format [offset unit]}}` - Formatted datetime
  - Formats: `iso8601`, `rfc1123`, custom
  - Examples: `{{$datetime iso8601}}`, `{{$datetime 'YYYY-MM-DD' -1 d}}`
- `{{$localDatetime format [offset unit]}}` - Local time formatted
- `{{$processEnv variableName}}` - OS environment variable
- `{{$dotenv variableName}}` - Variable from .env file

#### Response Variable Capture (Request Chaining)

| Capability | Visual Studio | VSCode (REST Client) |
|------------|---------------|----------------------|
| Capture response values | ❌ Manual copy-paste | ✅ Automatic |
| Reference previous responses | ❌ Not supported | ✅ Yes (named requests) |
| Extract JSON path | ❌ Not supported | ✅ Yes |
| Extract headers | ❌ Not supported | ✅ Yes |
| Use in next request | ❌ Manual only | ✅ Automatic |

**Visual Studio - Manual Workflow:**

```http
### Step 1: Login
POST https://api.example.com/auth/login
Content-Type: application/json

{
  "username": "user",
  "password": "pass"
}

# Response (manually inspect):
# {
#   "token": "eyJhbGc...",
#   "userId": "12345"
# }

### Step 2: Manually copy values from Step 1 response
@authToken = eyJhbGc...paste-token-here
@userId = 12345

### Step 3: Use manually copied values
GET https://api.example.com/users/{{userId}}
Authorization: Bearer {{authToken}}
```

**VSCode - Automatic Workflow:**

```http
### Step 1: Login (name the request for reference)
# @name login
POST https://api.example.com/auth/login
Content-Type: application/json

{
  "username": "user",
  "password": "pass"
}

### Step 2: Automatically extract values from previous response
@authToken = {{login.response.body.token}}
@userId = {{login.response.body.userId}}

### Step 3: Automatically use extracted values
GET https://api.example.com/users/{{userId}}
Authorization: Bearer {{authToken}}

### Step 4: Can also extract headers
@rateLimit = {{login.response.headers.X-RateLimit-Remaining}}
```

**VSCode Advanced Extraction:**

```http
### Create User
# @name createUser
POST https://api.example.com/users
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john@example.com"
}

### Extract nested values using JSONPath-like syntax
@newUserId = {{createUser.response.body.data.user.id}}
@createdAt = {{createUser.response.body.data.timestamp}}
@locationHeader = {{createUser.response.headers.Location}}

### Use extracted values in subsequent request
GET {{locationHeader}}
Authorization: Bearer {{authToken}}
```

#### Environment Management

| Feature | Visual Studio | VSCode (REST Client) |
|---------|---------------|----------------------|
| Multiple environments | ✅ http-client.env.json | ✅ settings.json |
| Per-environment variables | ✅ JSON config file | ✅ settings.json config |
| Environment selector | ✅ Dropdown in editor | ✅ Status bar selector |
| Shared variables | ⚠️ Repeated in each env | ✅ `$shared` section |
| Private variables | ✅ http-client.private.env.json | ⚠️ Mixed with public in settings |

**Visual Studio - Environment Files:**

**http-client.env.json:**
```json
{
  "dev": {
    "baseUrl": "https://localhost:5001",
    "apiVersion": "v1"
  },
  "staging": {
    "baseUrl": "https://staging-api.example.com",
    "apiVersion": "v1"
  },
  "production": {
    "baseUrl": "https://api.production.com",
    "apiVersion": "v2"
  }
}
```

**http-client.private.env.json:**
```json
{
  "dev": {
    "apiKey": "dev-secret-key"
  },
  "staging": {
    "apiKey": "staging-secret-key"
  },
  "production": {
    "apiKey": "prod-secret-key"
  }
}
```

**In your .http file:**
```http
### Make request (select environment from dropdown)
GET {{baseUrl}}/{{apiVersion}}/api/health
X-API-Key: {{apiKey}}
```

**Switch environments:** Use the environment dropdown in the Visual Studio HTTP editor toolbar.

**VSCode - Environment Switcher:**

In `.vscode/settings.json`:
```json
{
  "rest-client.environmentVariables": {
    "$shared": {
      "apiVersion": "v1",
      "contentType": "application/json"
    },
    "local": {
      "baseUrl": "https://localhost:5001",
      "apiKey": "dev-key"
    },
    "dev": {
      "baseUrl": "https://dev-api.example.com",
      "apiKey": "dev-key"
    },
    "staging": {
      "baseUrl": "https://staging-api.example.com",
      "apiKey": "staging-key"
    },
    "production": {
      "baseUrl": "https://api.production.com",
      "apiKey": "prod-key"
    }
  }
}
```

In your .http file:
```http
### Make request (variables auto-populate based on selected environment)
GET {{baseUrl}}/{{apiVersion}}/health
X-API-Key: {{apiKey}}
Content-Type: {{contentType}}
```

Switch environments via:
- Status bar: Click "No Environment" → Select environment
- Command Palette: "Rest Client: Switch Environment"

#### Variable Scope and Precedence

**Visual Studio:**
- Two scopes with precedence:
  1. Inline variables in .http file (highest priority)
  2. Environment variables from http-client.env.json + http-client.private.env.json (merged)
- Variables from selected environment override inline if both are defined
- Within same scope, last declaration wins

**Example precedence:**
```http
# Inline variable (lower priority when environment is selected)
@baseUrl = https://default.example.com

# If environment "dev" is selected, baseUrl from http-client.env.json overrides
GET {{baseUrl}}/api/users
```

**VSCode:**
- Multiple scopes with precedence:
  1. Request-level variables (highest priority)
  2. File-level variables
  3. Environment-specific variables (settings.json)
  4. Shared variables (`$shared` in settings.json)
  5. System variables (lowest priority)

#### Practical Comparison Summary

**Choose Visual Studio when:**
- ✅ Working within Visual Studio IDE for .NET projects
- ✅ Need environment management via JSON files (http-client.env.json)
- ✅ Want to separate public and private variables (two-file approach)
- ✅ Basic to intermediate variable needs (URLs, tokens, IDs)
- ⚠️ Can accept manual request chaining (copy-paste workflow)
- ⚠️ Don't need dynamic values (timestamps, GUIDs)
- ✅ Want native IDE integration without extensions

**Choose VSCode when:**
- ✅ Need automated request chaining (response variable extraction)
- ✅ Require dynamic values (timestamps, random data, GUIDs)
- ✅ Want to use OS environment variables or .env files
- ✅ Need advanced variable extraction from responses (JSONPath)
- ✅ Prefer centralized environment configuration in workspace settings
- ✅ Working across different technology stacks
- ✅ Need shared variables across all environments (`$shared`)

### Settings and Configuration

**Visual Studio:**
- Settings managed through Visual Studio Options
- Limited configuration options
- No per-workspace HTTP client settings

**VSCode:**
```json
// .vscode/settings.json
{
  "rest-client.environmentVariables": {
    "dev": {
      "host": "localhost:5001",
      "apiKey": "dev-key"
    },
    "prod": {
      "host": "api.production.com",
      "apiKey": "prod-key"
    }
  },
  "rest-client.defaultHeaders": {
    "User-Agent": "vscode-rest-client"
  }
}
```

### Request Execution

**Visual Studio:**
- Click "Send Request" link above request
- Keyboard shortcut: `Ctrl+Alt+R`
- Response opens in output window

**VSCode:**
- Click "Send Request" link above request
- Keyboard shortcut: `Ctrl+Alt+R` (Windows/Linux) or `Cmd+Alt+R` (Mac)
- Response opens in new editor tab
- Can view multiple responses side-by-side

### Response Viewing

**Visual Studio:**
- Response in bottom output pane
- Basic syntax highlighting
- Limited response navigation

**VSCode:**
- Full editor tab for responses
- Rich syntax highlighting
- Response can be saved as file
- Response links are clickable
- Better formatting for large responses
- Response time and size displayed

### When to Use Which

**Choose Visual Studio when:**
- Already working in Visual Studio 2022+
- Testing ASP.NET Core APIs in the same solution
- Need minimal setup without extensions
- Working primarily within .NET ecosystem
- Prefer native IDE integration

**Choose VSCode when:**
- Need advanced features like request chaining
- Working with multiple environments
- Require response history tracking
- Need automated variable extraction from responses
- Working across different technology stacks
- Want lightweight, extension-based approach
- Need pre-request scripting capabilities

### Migration Considerations

HTTP files are largely compatible between both IDEs for basic scenarios:
- ✅ Basic request syntax is identical
- ✅ Variable declarations work the same
- ✅ Request separators (`###`) are compatible
- ⚠️ Advanced VSCode features won't work in Visual Studio
- ⚠️ Environment-specific settings need manual adaptation

## 🔄 Integration with CI/CD

While HTTP files are great for manual testing, consider these approaches for automation:

### Generate Tests from HTTP Files

Convert your HTTP files to automated tests:
```csharp
// Example: xUnit test inspired by HTTP file
[Fact]
public async Task GetUsers_ReturnsSuccessStatusCode()
{
    // Arrange
    var client = _factory.CreateClient();
    
    // Act (based on HTTP file request)
    var response = await client.GetAsync("/api/users");
    
    // Assert
    response.EnsureSuccessStatusCode();
}
```

### Use as Living Documentation

- Keep HTTP files updated alongside code changes
- Use them as examples in API documentation
- Reference them in README files for quick testing

## 🔧 Troubleshooting

### Common Issues

**Issue: Request not executing**
- Ensure cursor is within the request block
- Check for syntax errors in the request
- Verify the request URL is accessible

**Issue: Variables not resolving**
- Verify variable declaration syntax: `@varName = value`
- Ensure variables are defined before use
- Check for typos in variable names: `{{varName}}`

**Issue: Authentication failures**
- Verify token/credentials are current
- Check authorization header format
- Ensure token hasn't expired

**Issue: Response not displaying**
- Check Output window for errors
- Verify API endpoint is accessible
- Check firewall/network settings

## 🎯 Conclusion

HTTP files in Visual Studio provide a powerful, code-first approach to API testing. By keeping your API tests as simple text files alongside your code, you can:

- **Version control** your API tests
- **Share** test scenarios with team members
- **Document** API usage through examples
- **Test quickly** without leaving your IDE
- **Maintain** tests as your API evolves

While they may not replace comprehensive API testing tools for all scenarios, HTTP files excel at providing fast, developer-friendly API testing during the development process. Understanding the differences between Visual Studio and VSCode implementations helps you choose the right tool for your specific needs and leverage the appropriate features for your workflow.

## 📚 Additional Resources

- [Visual Studio HTTP file documentation](https://learn.microsoft.com/en-us/aspnet/core/test/http-files)
- [REST Client for VSCode](https://marketplace.visualstudio.com/items?itemName=humao.rest-client)
- [HTTP request syntax reference](https://www.rfc-editor.org/rfc/rfc7231)
- [Testing ASP.NET Core APIs](https://learn.microsoft.com/en-us/aspnet/core/test/integration-tests)

---

*Last updated: October 2025*
