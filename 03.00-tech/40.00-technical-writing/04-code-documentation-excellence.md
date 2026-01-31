---
# Quarto Metadata
title: "Code Documentation Excellence"
author: "Dario Airoldi"
date: "2026-01-14"
categories: [technical-writing, code-documentation, api-reference, error-messages, changelog]
description: "Master code documentation through API reference standards, inline comment best practices, error message design, code example patterns, and changelog conventions"
---

# Code Documentation Excellence

> Write code documentation that developers actually read and find useful—from API references to error messages to changelogs

## Table of Contents

- [Introduction](#introduction)
- [API Reference Documentation](#api-reference-documentation)
- [Inline Code Comments](#inline-code-comments)
- [Code Examples in Documentation](#code-examples-in-documentation)
- [Error Message Design](#error-message-design)
- [Changelog and Release Notes](#changelog-and-release-notes)
- [README Files](#readme-files)
- [Documentation Generators](#documentation-generators)
- [Applying Code Documentation Standards](#applying-code-documentation-standards)
- [Conclusion](#conclusion)
- [References](#references)

## Introduction

Code documentation occupies a unique position—it lives at the intersection of technical precision and human communication. Developers read it while debugging at 2 AM, implementing features under deadline pressure, or trying to understand code they wrote six months ago.

This article covers:

- **API references** - Structured documentation for functions, classes, and endpoints
- **Inline comments** - When and how to comment within code
- **Code examples** - Patterns for effective documentation examples
- **Error messages** - Writing errors that help rather than frustrate
- **Changelogs** - Communicating changes clearly to users
- **READMEs** - First impressions that set projects up for success

**Prerequisites:** Understanding of [writing style principles](01-writing-style-and-voice-principles.md) and [documentation structure](02-structure-and-information-architecture.md).

## API Reference Documentation

API reference documentation must be simultaneously **comprehensive** (complete information) and **scannable** (quickly findable). This creates a unique writing challenge.

### Anatomy of Good API Documentation

Each API element (function, method, endpoint) should include:

**1. Signature/Syntax**
```python
def create_user(name: str, email: str, role: str = "user") -> User:
```

**2. Brief description (one line)**
> Creates a new user account with the specified attributes.

**3. Detailed description (if needed)**
> Creates a new user account and sends a welcome email. The user is assigned the default permission set for their role. If the email already exists, raises `DuplicateUserError`.

**4. Parameters**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `name` | `str` | Yes | User's display name (2-50 characters) |
| `email` | `str` | Yes | Valid email address |
| `role` | `str` | No | User role. Default: `"user"`. Options: `"user"`, `"admin"` |

**5. Return value**
> **Returns:** `User` - The newly created user object with `id`, `name`, `email`, `role`, and `created_at` fields populated.

**6. Exceptions/Errors**
| Exception | Condition |
|-----------|-----------|
| `DuplicateUserError` | Email already registered |
| `ValidationError` | Invalid name or email format |
| `PermissionError` | Caller lacks user creation permission |

**7. Example**
```python
user = create_user(
    name="Alice Developer",
    email="alice@example.com",
    role="admin"
)
print(f"Created user {user.id}: {user.name}")
```

**8. Related items**
> See also: `delete_user()`, `update_user()`, `get_user()`

### REST API Documentation Pattern

```markdown
## POST /users

Creates a new user account.

### Request

**Headers**
| Header | Value | Required |
|--------|-------|----------|
| `Authorization` | `Bearer {token}` | Yes |
| `Content-Type` | `application/json` | Yes |

**Body Parameters**
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `name` | string | Yes | Display name (2-50 chars) |
| `email` | string | Yes | Valid email address |
| `role` | string | No | `"user"` (default) or `"admin"` |

**Example Request**
```bash
curl -X POST https://api.example.com/users \
  -H "Authorization: Bearer your-token" \
  -H "Content-Type: application/json" \
  -d '{"name": "Alice", "email": "alice@example.com"}'
```

### Response

**Success (201 Created)**
```json
{
  "id": "usr_123abc",
  "name": "Alice",
  "email": "alice@example.com",
  "role": "user",
  "created_at": "2026-01-14T10:30:00Z"
}
```

**Errors**
| Status | Code | Description |
|--------|------|-------------|
| 400 | `INVALID_EMAIL` | Email format invalid |
| 409 | `EMAIL_EXISTS` | Email already registered |
| 401 | `UNAUTHORIZED` | Invalid or missing token |
```

### API Documentation Anti-Patterns

❌ **Missing parameter details:**
```markdown
## create_user(name, email, role)
Creates a user.
```
*What are the types? What values are valid? What happens if something's wrong?*

❌ **No examples:**
```markdown
Parameters: name (string), email (string), role (string)
Returns: User object
```
*Show me what it looks like in practice.*

❌ **Incomplete error documentation:**
```markdown
Throws: Error
```
*What kind of error? When? What should I do about it?*

### API Documentation from Major Projects

**Microsoft Azure SDK pattern:**
- Summary + detailed description
- Parameters with types, defaults, constraints
- Return value with type and description
- Exceptions with conditions
- Multiple examples (basic, advanced, error handling)
- Thread safety notes
- Version availability

**Stripe API pattern:**
- Interactive examples you can run
- Multiple language examples side-by-side
- Response objects fully documented
- Error codes searchable
- Idempotency key documentation
- Pagination guidance

## Inline Code Comments

Comments in code serve different purposes than external documentation. They explain **why**, not **what**.

### The Golden Rule

> Code tells you **how**; comments tell you **why**.

✅ **Good comment (explains why):**
```python
# Use insertion sort for small arrays (<10 elements)
# because quicksort's overhead outweighs its benefits
if len(array) < 10:
    return insertion_sort(array)
```

❌ **Bad comment (restates code):**
```python
# Check if length is less than 10
if len(array) < 10:
    # Return insertion sort result
    return insertion_sort(array)
```

### When to Comment

**Comment when:**
- Explaining non-obvious decisions
- Documenting workarounds for bugs (with issue links)
- Clarifying complex algorithms
- Warning about non-obvious side effects
- Noting performance implications

**Don't comment when:**
- Code is self-explanatory
- Comment would just repeat variable/function names
- Better solution is to rename or refactor

### Comment Patterns

**TODO comments:**
```python
# TODO(username): Implement caching for performance
# TODO: Replace with proper authentication (#123)
```

**FIXME comments:**
```python
# FIXME: This breaks with Unicode characters. See issue #456
```

**Warning comments:**
```python
# WARNING: This function modifies global state
# WARNING: Not thread-safe; use with lock in concurrent contexts
```

**Documentation comments (docstrings):**
```python
def calculate_shipping(weight: float, destination: str) -> float:
    """
    Calculate shipping cost based on weight and destination.

    Uses flat rate for domestic orders under 2kg,
    otherwise calculates based on weight bands.

    Args:
        weight: Package weight in kilograms
        destination: Two-letter country code

    Returns:
        Shipping cost in USD

    Raises:
        ValueError: If weight is negative or destination unknown
    """
```

### Documentation String Standards

**Python (PEP 257 / Google style):**
```python
def function(arg1, arg2):
    """Summary line (one line).

    Extended description if needed. Can span
    multiple paragraphs.

    Args:
        arg1: Description of arg1.
        arg2: Description of arg2.

    Returns:
        Description of return value.

    Raises:
        ErrorType: When this error occurs.
    """
```

**C# (XML documentation):**
```csharp
/// <summary>
/// Creates a new user account with the specified attributes.
/// </summary>
/// <param name="name">User's display name (2-50 characters)</param>
/// <param name="email">Valid email address</param>
/// <returns>The newly created user object</returns>
/// <exception cref="DuplicateUserException">Email already registered</exception>
public User CreateUser(string name, string email)
```

**JavaScript (JSDoc):**
```javascript
/**
 * Creates a new user account.
 * @param {string} name - User's display name
 * @param {string} email - Valid email address
 * @returns {User} The newly created user
 * @throws {DuplicateUserError} If email exists
 */
function createUser(name, email) {
```

## Code Examples in Documentation

Code examples are often the most-read part of documentation. Users scan to examples, copy them, modify them. Good examples make or break developer experience.

### Example Characteristics

**Complete:** Can be copied and run with minimal modification
**Realistic:** Resembles actual use cases, not abstract demos
**Progressive:** Start simple, build complexity
**Commented:** Explain non-obvious parts
**Tested:** Verified to work (ideally via automated testing)

### Example Patterns

**Pattern 1: Basic → Advanced progression**

```markdown
### Basic Usage

Get a single user by ID:

```python
user = client.get_user("usr_123")
print(user.name)
```

### With Error Handling

```python
try:
    user = client.get_user("usr_123")
    print(user.name)
except NotFoundError:
    print("User not found")
except AuthenticationError:
    print("Check your API key")
```

### Async Usage

```python
async def fetch_user(user_id):
    async with AsyncClient(api_key=KEY) as client:
        return await client.get_user(user_id)
```
```

**Pattern 2: Before/After transformation**

```markdown
### Before: Manual HTTP requests

```python
import requests

response = requests.get(
    "https://api.example.com/users/123",
    headers={"Authorization": f"Bearer {token}"}
)
user = response.json()
```

### After: Using our SDK

```python
user = client.get_user("usr_123")
```
```

**Pattern 3: Common scenarios**

```markdown
## Common Tasks

### Create a user and send welcome email

```python
user = client.create_user(name="Alice", email="alice@example.com")
client.send_welcome_email(user.id)
```

### Bulk import users from CSV

```python
with open("users.csv") as f:
    for row in csv.DictReader(f):
        client.create_user(name=row["name"], email=row["email"])
```
```

### Example Anti-Patterns

❌ **Incomplete example:**
```python
# Create a user
user = create_user(...)
```
*What arguments? What imports are needed?*

❌ **Unrealistic example:**
```python
user = create_user("foo", "bar", "baz")
```
*What are foo, bar, baz? Use realistic values.*

❌ **Too much in one example:**
```python
# 50-line example doing five different things
```
*Break into focused examples.*

❌ **Examples that don't work:**
```python
# Example written but never tested
# Contains syntax error on line 3
```
*Test all examples before publishing.*

### Multi-Language Examples

For APIs used from multiple languages, provide examples in common languages:

```markdown
<details>
<summary>Python</summary>

```python
user = client.get_user("usr_123")
```

</details>

<details>
<summary>JavaScript</summary>

```javascript
const user = await client.getUser("usr_123");
```

</details>

<details>
<summary>cURL</summary>

```bash
curl https://api.example.com/users/usr_123 \
  -H "Authorization: Bearer $TOKEN"
```

</details>
```

## Error Message Design

Error messages are documentation that appears when something goes wrong—precisely when users need the most help.

### Good Error Messages

**Components of a helpful error:**
1. **What happened** - Clear description of the problem
2. **Why it happened** - Context about the cause
3. **What to do** - Actionable next steps

### Error Message Patterns

**Pattern: Full context**
```
Error: Cannot connect to database
Cause: Connection refused at localhost:5432
Action: Ensure PostgreSQL is running: `systemctl start postgresql`
```

**Pattern: With error codes**
```
Error [AUTH_001]: Invalid authentication token
The token has expired or is malformed.
Get a new token: https://docs.example.com/auth
```

**Pattern: Multiple possible causes**
```
Error: Build failed

Possible causes:
1. Missing dependencies - Run `npm install`
2. Invalid configuration - Check tsconfig.json syntax
3. Network issue - Verify proxy settings

For detailed logs: build-output.log
```

### Error Message Anti-Patterns

❌ **Cryptic:**
```
Error: ECONNREFUSED
```
*What refused? How do I fix it?*

❌ **Blaming the user:**
```
Error: You entered an invalid email
```
*Use neutral language: "Invalid email format"*

❌ **Too technical:**
```
NullPointerException at com.example.service.UserService.createUser(UserService.java:142)
```
*For end users, wrap in friendly message*

❌ **No path forward:**
```
Error: Operation failed
```
*What operation? What should I try?*

### Error Documentation

Document errors in your API reference:

```markdown
## Errors

### AuthenticationError

Raised when authentication fails.

**Causes:**
- Invalid API key
- Expired token
- Revoked credentials

**Resolution:**
1. Verify API key in dashboard
2. Generate new token if expired
3. Contact support if credentials revoked

**Example:**
```python
try:
    client.create_user(...)
except AuthenticationError as e:
    print(f"Auth failed: {e.message}")
    print(f"Error code: {e.code}")
    # e.code will be one of: INVALID_KEY, EXPIRED_TOKEN, REVOKED
```
```

## Changelog and Release Notes

Changelogs communicate what changed between versions. They serve multiple audiences: developers upgrading, managers evaluating, and security teams auditing.

### Keep a Changelog Format

The [Keep a Changelog](https://keepachangelog.com/) standard provides a proven format:

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- French translation

## [1.1.0] - 2026-01-14

### Added
- OAuth 2.0 authentication support
- Rate limiting configuration options

### Changed
- Improved error messages with error codes
- Updated minimum Python version to 3.9

### Deprecated
- API key authentication (use OAuth instead)

### Fixed
- Memory leak in connection pooling (#234)
- Incorrect date parsing for ISO 8601 (#256)

### Security
- Updated dependencies to address CVE-2026-1234

## [1.0.0] - 2025-12-01

### Added
- Initial release
```

### Change Categories

- **Added** - New features
- **Changed** - Changes to existing functionality
- **Deprecated** - Features to be removed in future
- **Removed** - Features removed in this release
- **Fixed** - Bug fixes
- **Security** - Security-related changes

### Writing Good Changelog Entries

✅ **Good entries:**
```markdown
### Added
- OAuth 2.0 support with authorization code and client credentials flows

### Fixed
- Connection timeout now properly respects configured value (#234)

### Security
- Updated `requests` to 2.28.0 to address SSRF vulnerability (CVE-2026-1234)
```

❌ **Bad entries:**
```markdown
### Changed
- Various improvements
- Bug fixes
- Updated dependencies
```

### Changelog vs. Release Notes

**Changelog:** Complete record of all changes, primarily for developers
**Release notes:** Curated highlights for broader audience

```markdown
# Release Notes - v1.1.0

## Highlights

**OAuth 2.0 Support** 🎉
We've added full OAuth 2.0 authentication! Migrate from API keys for better security.
[Migration guide →](./oauth-migration.md)

**Better Error Messages**
All errors now include error codes and actionable suggestions.

## Breaking Changes
None in this release.

## Upgrade Notes
- Minimum Python version is now 3.9
- API key authentication is deprecated (removed in v2.0)

[Full changelog →](./CHANGELOG.md#110---2026-01-14)
```

## README Files

The README is often the first documentation users see. It must quickly convey what a project does and how to get started.

### README Structure

```markdown
# Project Name

One-paragraph description: what it does, who it's for.

## Features
- Feature 1
- Feature 2

## Quick Start

```bash
pip install project-name
```

```python
from project import Client
client = Client(api_key="...")
result = client.do_thing()
```

## Documentation
- [Full documentation](https://docs.example.com)
- [API reference](https://docs.example.com/api)

## Installation

Detailed installation instructions...

## Usage

More detailed usage examples...

## Contributing
[See CONTRIBUTING.md](./CONTRIBUTING.md)

## License
MIT License - see [LICENSE](./LICENSE)
```

### README Best Practices

**1. Lead with value**
- What problem does this solve?
- Why would someone use this?

**2. Show, don't tell**
- Include working code example in first 30 seconds of reading
- Use badges for build status, version, etc.

**3. Make it scannable**
- Clear headings
- Bullet lists
- Code blocks

**4. Keep it current**
- README lies are worse than no README
- Automate what you can (version badges, etc.)

### README for This Repository

From [README.md](../../README.md):
- **Purpose statement:** What this repository contains
- **Structure overview:** How content is organized
- **Getting started:** Links to setup documentation
- **Navigation aids:** Links to key sections

## Documentation Generators

Many languages have documentation generators that produce reference documentation from code comments.

### Popular Documentation Generators

| Language | Tool | Comment Style |
|----------|------|---------------|
| Python | Sphinx, pdoc | Docstrings (various formats) |
| JavaScript | JSDoc, TypeDoc | JSDoc comments |
| C# | DocFX, Sandcastle | XML comments |
| Java | Javadoc | Javadoc comments |
| Go | godoc | Standard comments |
| Rust | rustdoc | Documentation comments |

### Documentation Generator Best Practices

**1. Write for both human and machine readers**
```python
def create_user(name: str, email: str) -> User:
    """
    Create a new user account.

    This function validates the email format and checks for duplicates
    before creating the user record. A welcome email is sent automatically.

    Args:
        name: User's display name. Must be 2-50 characters.
        email: Valid email address. Must not already be registered.

    Returns:
        User: The newly created user with populated id and timestamps.

    Raises:
        ValidationError: If name or email format is invalid.
        DuplicateUserError: If email is already registered.

    Example:
        >>> user = create_user("Alice", "alice@example.com")
        >>> print(user.id)
        'usr_abc123'
    """
```

**2. Use type hints/annotations**
```python
# Types in signature help generators produce better documentation
def get_users(
    limit: int = 10,
    offset: int = 0,
    role: Optional[str] = None
) -> List[User]:
```

**3. Document at the right level**
- Public API: Full documentation
- Internal API: Brief documentation
- Private helpers: Minimal or none

**4. Keep generated docs with source**
- Version control generated documentation
- Or regenerate as part of CI/CD

## Applying Code Documentation Standards

### This Repository's Code

**IQPilot MCP Server** (from [src/IQPilot/](../../src/IQPilot/)):
- C# XML documentation comments
- README with setup instructions
- Inline comments for complex logic

**PowerShell Scripts** (from [scripts/](../../scripts/)):
- Comment-based help
- README.md for the scripts folder

### Documentation Standards by File Type

| File Type | Documentation Standard |
|-----------|----------------------|
| `.cs` | XML documentation comments |
| `.py` | Google-style docstrings |
| `.ps1` | Comment-based help |
| `.md` | N/A (is documentation) |
| `.json`/`.yml` | Inline comments where supported |

### Code Example Standards

For documentation in this repository:

**Include language identifier:**
```markdown
```python
# Not just ``` but ```python
```

**Show realistic values:**
```python
# Not foo/bar but realistic data
user = create_user(name="Alice Developer", email="alice@example.com")
```

**Indicate placeholder values:**
```python
client = APIClient(api_key="YOUR_API_KEY")  # ← Replace with your key
```

**Test examples before publishing:**
```python
# All examples should be runnable
# Consider automated testing of documentation examples
```

## Conclusion

Code documentation requires balancing completeness with usability. Key principles:

**API reference needs completeness** - Parameters, returns, errors, examples for every public element

**Comments explain why, not what** - Code shows how; comments provide context

**Examples are often most valuable** - Realistic, complete, progressive examples that users can copy and modify

**Error messages are documentation** - Write errors that help users solve problems

**Changelogs track history** - Keep a Changelog format with meaningful entries

**READMEs create first impressions** - Lead with value, show working code quickly

**Next in series:**

- [05-validation-and-quality-assurance.md](05-validation-and-quality-assurance.md) - Validating code documentation quality
- [00-foundations-of-technical-documentation.md](00-foundations-of-technical-documentation.md) - How reference documentation fits Diátaxis
- [03-accessibility-in-technical-writing.md](03-accessibility-in-technical-writing.md) - Accessible code examples

## References

### API Documentation Standards

**[Google API Design Guide](https://cloud.google.com/apis/design)** 📘 [Official]  
Google's comprehensive guide to designing REST APIs, including documentation requirements.

**[Microsoft REST API Guidelines](https://github.com/microsoft/api-guidelines)** 📘 [Official]  
Microsoft's REST API design and documentation standards.

**[Stripe API Documentation](https://stripe.com/docs/api)** 📗 [Verified Community]  
Widely considered best-in-class API documentation, worth studying as a model.

**[OpenAPI Specification](https://spec.openapis.org/oas/latest.html)** 📘 [Official]  
Standard for describing REST APIs, enabling documentation generation.

### Code Comment Standards

**[PEP 257 - Docstring Conventions](https://peps.python.org/pep-0257/)** 📘 [Official]  
Python's official docstring standard.

**[Google Python Style Guide - Docstrings](https://google.github.io/styleguide/pyguide.html#38-comments-and-docstrings)** 📘 [Official]  
Google's Python docstring conventions, widely adopted.

**[JSDoc Documentation](https://jsdoc.app/)** 📘 [Official]  
Standard for JavaScript documentation comments.

**[XML Documentation Comments (C#)](https://learn.microsoft.com/dotnet/csharp/language-reference/xmldoc/)** 📘 [Official]  
Microsoft's C# documentation comment standard.

### Error Message Design

**[Microsoft Error Message Guidelines](https://learn.microsoft.com/windows/win32/uxguide/mess-error)** 📘 [Official]  
Microsoft's comprehensive guide to writing error messages.

**[Nielsen Norman Group - Error Message Guidelines](https://www.nngroup.com/articles/error-message-guidelines/)** 📗 [Verified Community]  
UX research-backed guidance on error messages.

### Changelog Standards

**[Keep a Changelog](https://keepachangelog.com/en/1.0.0/)** 📗 [Verified Community]  
De facto standard for changelog formatting.

**[Semantic Versioning](https://semver.org/)** 📗 [Verified Community]  
Versioning standard that pairs with changelogs.

### README Standards

**[Make a README](https://www.makeareadme.com/)** 📗 [Verified Community]  
Guide to creating effective README files.

**[Standard Readme](https://github.com/RichardLitt/standard-readme)** 📗 [Verified Community]  
Specification for README structure and content.

### Documentation Generators

**[Sphinx Documentation](https://www.sphinx-doc.org/)** 📘 [Official]  
Python documentation generator, used for major Python projects.

**[DocFX](https://dotnet.github.io/docfx/)** 📘 [Official]  
Microsoft's documentation generator for .NET projects.

**[TypeDoc](https://typedoc.org/)** 📗 [Verified Community]  
Documentation generator for TypeScript projects.

---

<!-- Validation Metadata
validation_status: pending_first_validation
article_metadata:
  filename: "04-code-documentation-excellence.md"
  series: "Technical Documentation Excellence"
  series_position: 5
  total_articles: 8
  prerequisites:
    - "01-writing-style-and-voice-principles.md"
    - "02-structure-and-information-architecture.md"
  related_articles:
    - "00-foundations-of-technical-documentation.md"
    - "03-accessibility-in-technical-writing.md"
    - "05-validation-and-quality-assurance.md"
  version: "1.0"
  last_updated: "2026-01-14"
-->
