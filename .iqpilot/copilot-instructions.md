---
description: IQPilot-specific GitHub Copilot instructions (loaded only when IQPilot MCP is active)
---

# IQPilot Integration Instructions

**This file is loaded only when IQPilot MCP server is active.**

## IQPilot Overview

IQPilot is an MCP (Model Context Protocol) server that enhances GitHub Copilot with specialized content development capabilities:

- **16 MCP Tools**: Metadata management, validation, content analysis, workflows
- **Validation Caching**: Avoids redundant AI calls by tracking validation state
- **Automatic Metadata Sync**: Updates metadata on file renames and content changes
- **Advanced Analysis**: Gap detection, cross-reference discovery, series validation

## Operating Modes

**Current Mode Detection:**
Check `.vscode/settings.json` for:
```jsonc
{
    "iqpilot.enabled": true,      // Is IQPilot enabled?
    "iqpilot.mode": "mcp"         // "mcp" | "prompts-only" | "off"
}
```

**Three modes:**
1. **MCP Mode**: Full IQPilot with all 16 MCP tools
2. **Prompts Only**: Standalone prompts from `.github/prompts/` only
3. **Off**: Standard GitHub Copilot, no IQPilot features

## Prompt Resolution Strategy

When user requests validation (e.g., "Check grammar"):

### Step 1: Check IQPilot MCP Availability

```javascript
// Try to detect if IQPilot MCP tools are available
try {
    // Attempt to call an IQPilot MCP tool
    await iqpilot/metadata/get({ filePath: "test" });
    // If successful, IQPilot is active
} catch {
    // IQPilot not available, use standalone prompts
}
```

### Step 2: Choose Appropriate Prompt

**If IQPilot MCP Active:**
- ✅ Use `.iqpilot/prompts/[name]-enhanced.prompt.md`
- Includes validation caching (checks if validation needed)
- Automatic metadata updates via MCP tools
- Cross-reference discovery
- Advanced analytics

**If IQPilot Inactive:**
- ✅ Use `.github/prompts/[name].prompt.md`
- Standalone validation (no MCP dependencies)
- Manual metadata updates
- Works with GitHub Copilot alone

**Automatic Selection:** GitHub Copilot should automatically detect IQPilot availability and choose the enhanced version if available, falling back to standalone if not.

### Step 3: Graceful Degradation

**If enhanced prompt fails:**
```javascript
try {
    // Try enhanced prompt with IQPilot MCP tools
    await executeEnhancedPrompt();
} catch (error) {
    // Fall back to standalone prompt
    console.log("IQPilot MCP not available, using standalone validation");
    await executeStandalonePrompt();
}
```

## Prompt Priority (When IQPilot Active)

1. **`.iqpilot/prompts/[name]-enhanced.prompt.md`** ← IQPilot MCP version (priority)
2. **`.github/prompts/[name].prompt.md`** ← Standalone fallback

**Available Enhanced Prompts:**
- `grammar-review-enhanced.prompt.md` - Grammar validation with caching
- *(More to be added)*

## Dual Metadata Architecture (IQPilot-Specific Details)

IQPilot manages the **bottom YAML block** in articles:

### Top YAML (Manual Only)
```yaml
---
title: "Article Title"
author: "Author Name"
date: "2025-11-23"
categories: [tech, tutorial]
---
```
**Rules:**
- ❌ IQPilot MCP tools NEVER modify this block
- ✅ Manual editing only
- ✅ Used by Quarto/Jekyll/Hugo for rendering

### Bottom YAML (IQPilot Managed)
```html
<!-- 
---
validations:
  grammar:
    last_run: "2025-11-23"
    model: "claude-sonnet-4"
    tool: "iqpilot/validation/grammar"
    outcome: "passed"
    issues_found: 0
  readability:
    last_run: "2025-11-23"
    model: "gpt-4o"
    flesch_score: 65.2
    grade_level: 9
  structure:
    last_run: "2025-11-23"
    outcome: "passed"

article_metadata:
  filename: "article.md"
  created: "2025-11-20"
  last_updated: "2025-11-23"
  version: "1.1"
  status: "published"
  word_count: 2847
  reading_time_minutes: 11
  primary_topic: "Docker"

cross_references:
  related_articles:
    - "docker-networking.md"
    - "docker-compose.md"
  series: "Docker Fundamentals"
  series_order: 1
  prerequisites:
    - "linux-basics.md"
---
-->
```

**Rules:**
- ✅ IQPilot MCP tools update this automatically
- ✅ Wrapped in HTML comment (hidden from rendering)
- ✅ Updated after each validation run
- ✅ `article_metadata.filename` synced on file rename
- ✅ Validation sections updated only by corresponding tools

## IQPilot MCP Tools Reference

### Metadata Tools

**`iqpilot/metadata/get`**
```javascript
const metadata = await iqpilot/metadata/get({ 
    filePath: "tech/docker-basics.md" 
});
// Returns complete bottom YAML metadata
```

**`iqpilot/metadata/update`**
```javascript
await iqpilot/metadata/update({
    filePath: "tech/docker-basics.md",
    updates: {
        "validations.grammar.last_run": "2025-11-23",
        "validations.grammar.outcome": "passed",
        "article_metadata.last_updated": "2025-11-23",
        "article_metadata.word_count": 2847
    }
});
```

**`iqpilot/metadata/validate`**
```javascript
const isValid = await iqpilot/metadata/validate({ 
    filePath: "tech/docker-basics.md" 
});
// Returns validation errors if any
```

### Validation Tools

**`iqpilot/validation/grammar`**
```javascript
const result = await iqpilot/validation/grammar({
    filePath: "tech/docker-basics.md",
    checkSpelling: true,
    checkGrammar: true,
    checkPunctuation: true,
    model: "claude-sonnet-4"
});
// Returns: { passed, issues_found, issues[], outcome }
// Automatically updates metadata
```

**`iqpilot/validation/readability`**
```javascript
const result = await iqpilot/validation/readability({
    filePath: "tech/docker-basics.md",
    targetGradeLevel: 9,
    model: "gpt-4o"
});
// Returns: { flesch_score, grade_level, complexity, outcome }
```

**`iqpilot/validation/structure`**
```javascript
const result = await iqpilot/validation/structure({
    filePath: "tech/docker-basics.md",
    requireTOC: true,
    requireReferences: true
});
// Returns: { passed, missing_sections[], outcome }
```

**`iqpilot/validation/all`**
```javascript
const results = await iqpilot/validation/all({
    filePath: "tech/docker-basics.md",
    validations: ["grammar", "readability", "structure"]
});
// Runs all validations, returns combined results
```

### Content Tools

**`iqpilot/content/create`**
```javascript
await iqpilot/content/create({
    template: "article-template.md",
    filePath: "tech/new-article.md",
    variables: {
        title: "New Article",
        author: "Author Name",
        topic: "Docker"
    }
});
// Creates article from template with variable substitution
```

**`iqpilot/content/analyze_gaps`**
```javascript
const gaps = await iqpilot/content/analyze_gaps({
    filePath: "tech/docker-basics.md"
});
// Returns: { missing_sections[], logical_gaps[], suggestions[] }
```

**`iqpilot/content/find_related`**
```javascript
const related = await iqpilot/content/find_related({
    filePath: "tech/docker-basics.md",
    maxResults: 5
});
// Returns: { related_articles[], similarity_scores[] }
```

**`iqpilot/content/publish_ready`**
```javascript
const ready = await iqpilot/content/publish_ready({
    filePath: "tech/docker-basics.md"
});
// Returns: { ready: true/false, blockers[], warnings[], checklist[] }
```

### Workflow Tools

**`iqpilot/workflow/article_creation`**
```javascript
await iqpilot/workflow/article_creation({
    topic: "Docker Networking",
    templateType: "technical"
});
// Guided workflow: template → draft → validate → publish
```

**`iqpilot/workflow/review`**
```javascript
await iqpilot/workflow/review({
    filePath: "tech/docker-basics.md"
});
// Systematic review: grammar → readability → structure → gaps → publish-ready
```

**`iqpilot/workflow/series_planning`**
```javascript
await iqpilot/workflow/series_planning({
    seriesName: "Docker Fundamentals",
    articles: ["docker-basics.md", "docker-networking.md", "docker-compose.md"]
});
// Validates series consistency, prerequisites, order
```

## Validation Caching (IQPilot Feature)

**Problem:** Without caching, every validation request runs expensive AI calls, even if content hasn't changed.

**Solution:** IQPilot caches validation results in bottom YAML metadata.

**How it works:**

```javascript
// Step 1: Check if validation needed
const metadata = await iqpilot/metadata/get({ filePath: "article.md" });
const lastValidated = metadata.validations.grammar.last_run;
const lastModified = metadata.article_metadata.last_updated;

if (lastValidated > lastModified) {
    // Content unchanged since last validation - use cached result
    return {
        cached: true,
        outcome: metadata.validations.grammar.outcome,
        issues_found: metadata.validations.grammar.issues_found
    };
}

// Step 2: Content changed - run fresh validation
const result = await runGrammarValidation();

// Step 3: Update metadata with new results
await iqpilot/metadata/update({
    filePath: "article.md",
    updates: {
        "validations.grammar.last_run": new Date(),
        "validations.grammar.outcome": result.outcome,
        "validations.grammar.issues_found": result.issues.length
    }
});
```

**Benefits:**
- ✅ Saves AI API calls (cost reduction)
- ✅ Instant response for unchanged content
- ✅ Consistent results for same content

## File Rename Handling (IQPilot Feature)

**Problem:** When articles are renamed, metadata with old filename becomes stale.

**Solution:** IQPilot's FileWatcherService automatically updates `article_metadata.filename`.

**How it works:**

```javascript
// User renames file: tech/old-name.md → tech/new-name.md

// IQPilot detects rename event
onFileRenamed(oldPath, newPath) {
    // Update metadata in bottom YAML
    await iqpilot/metadata/update({
        filePath: newPath,
        updates: {
            "article_metadata.filename": "new-name.md",
            "article_metadata.last_updated": new Date()
        }
    });
}
```

**No manual action required** - completely automatic!

## Cross-Reference Discovery (IQPilot Feature)

**Problem:** Manually finding related articles and maintaining cross-references is time-consuming.

**Solution:** IQPilot analyzes content and automatically discovers related articles.

**How it works:**

```javascript
// User: "Find articles related to this one"

const related = await iqpilot/content/find_related({
    filePath: "tech/docker-basics.md",
    maxResults: 5
});

// IQPilot:
// 1. Extracts key topics from article
// 2. Searches workspace for similar content
// 3. Ranks by relevance
// 4. Returns top matches

// Optionally update metadata
await iqpilot/metadata/update({
    filePath: "tech/docker-basics.md",
    updates: {
        "cross_references.related_articles": related.map(r => r.filename)
    }
});
```

## Error Handling

**If IQPilot MCP is not available:**

```javascript
try {
    await iqpilot/validation/grammar({ filePath: "article.md" });
} catch (error) {
    // Graceful fallback
    return `IQPilot MCP server not available.
    
    Falling back to standalone validation from .github/prompts/
    
    To enable IQPilot:
    1. Edit .vscode/settings.json: "iqpilot.enabled": true
    2. Verify MCP server: .copilot/mcp-servers/iqpilot/iqpilot.exe
    3. Reload VS Code: Ctrl+Shift+P → "Developer: Reload Window"
    
    See .iqpilot/README.md for complete setup guide.`;
}
```

## Configuration

IQPilot behavior controlled by `.iqpilot/config.json`:

```json
{
  "site": {
    "name": "Your Documentation Site",
    "type": "documentation",
    "baseUrl": "https://your-site.com"
  },
  "validation": {
    "grammar": {
      "enabled": true,
      "model": "claude-sonnet-4",
      "autoFix": false
    },
    "readability": {
      "enabled": true,
      "targetGradeLevel": 9,
      "minFleschScore": 60
    },
    "structure": {
      "requireTOC": true,
      "requireReferences": true,
      "requireCodeExamples": false
    }
  },
  "caching": {
    "enabled": true,
    "ttlDays": 7
  },
  "metadata": {
    "autoSync": true,
    "trackCrossReferences": true
  }
}
```

## Best Practices

### 1. Always Check Cache First

```javascript
// ❌ Don't: Always run validation
const result = await iqpilot/validation/grammar({ filePath });

// ✅ Do: Check if validation needed
const metadata = await iqpilot/metadata/get({ filePath });
if (needsValidation(metadata)) {
    const result = await iqpilot/validation/grammar({ filePath });
}
```

### 2. Use Appropriate Models

```javascript
// Grammar: Claude Sonnet 4 (better at nuance)
await iqpilot/validation/grammar({ 
    filePath, 
    model: "claude-sonnet-4" 
});

// Readability: GPT-4o (faster, good enough)
await iqpilot/validation/readability({ 
    filePath, 
    model: "gpt-4o" 
});
```

### 3. Batch Operations

```javascript
// ❌ Don't: Validate one by one
for (const file of files) {
    await iqpilot/validation/grammar({ filePath: file });
}

// ✅ Do: Use validation/all
await iqpilot/validation/all({
    filePath,
    validations: ["grammar", "readability", "structure"]
});
```

### 4. Graceful Degradation

Always provide fallback when IQPilot is unavailable:

```javascript
try {
    // Try IQPilot enhanced version
    await enhancedValidation();
} catch {
    // Fall back to standalone version
    await standaloneValidation();
}
```

## Troubleshooting

### IQPilot MCP Tools Not Available

**Check:**
1. `.vscode/settings.json` → `"iqpilot.enabled": true`
2. `.copilot/mcp-servers/iqpilot/iqpilot.exe` exists
3. Reload VS Code: `Ctrl+Shift+P` → "Developer: Reload Window"

### Validation Cache Not Working

**Check:**
1. `.iqpilot/config.json` → `"caching.enabled": true`
2. Bottom YAML metadata exists in article
3. `validations.[type].last_run` timestamp is present

### Metadata Not Syncing on Rename

**Check:**
1. `.iqpilot/config.json` → `"metadata.autoSync": true`
2. FileWatcherService is running (check logs in `.iqpilot/logs/`)
3. Article has bottom YAML metadata block

## See Also

- **[.iqpilot/README.md](README.md)** - Enable/disable guide, mode comparison
- **[.github/copilot-instructions.md](../.github/copilot-instructions.md)** - Base instructions (IQPilot-independent)
- **[idea/IQPilot/01. IQPilot overview.md](../idea/IQPilot/01.%20IQPilot%20overview.md)** - Concepts and philosophy
- **[idea/IQPilot/03. IQPilot Implementation details.md](../idea/IQPilot/03.%20IQPilot%20Implementation%20details.md)** - Technical architecture
