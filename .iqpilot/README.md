# IQPilot Enable/Disable Guide

## Quick Commands

- `Ctrl+Shift+P` → "IQPilot: Enable" - Turn on full MCP mode
- `Ctrl+Shift+P` → "IQPilot: Disable" - Turn off IQPilot completely
- `Ctrl+Shift+P` → "IQPilot: Switch Mode" - Choose operating mode

## Operating Modes

### 🚀 MCP Mode (Recommended)
**Settings:** `iqpilot.enabled: true, iqpilot.mode: "mcp"`

**What You Get:**
- ✅ Full IQPilot MCP server with 16 specialized tools
- ✅ Validation caching (saves AI calls)
- ✅ Automatic metadata synchronization
- ✅ Gap analysis and cross-reference discovery
- ✅ Series validation

**When to Use:** Active content development with frequent validations

### 📝 Prompts Only Mode
**Settings:** `iqpilot.enabled: true, iqpilot.mode: "prompts-only"`

**What You Get:**
- ✅ GitHub Copilot with standalone prompts from `.github/prompts/`
- ✅ Manual validation (no caching)
- ✅ Manual metadata updates
- ✅ Basic content creation

**When to Use:** Occasional article creation, prefer lightweight setup

### ❌ Off Mode
**Settings:** `iqpilot.enabled: false`

**What You Get:**
- ✅ Standard GitHub Copilot (no IQPilot features)
- ✅ `.copilot/context/` still provides AI context
- ❌ No prompts, no automation
- ❌ Manual everything

**When to Use:** Not working on documentation

## Switching Modes

### Via Settings

Edit `.vscode/settings.json`:

```jsonc
{
    "iqpilot.enabled": true,  // true | false
    "iqpilot.mode": "mcp"     // "mcp" | "prompts-only" | "off"
}
```

### Via Command Palette

```
Ctrl+Shift+P → "IQPilot: Switch Mode"
  ├─ MCP Mode (Full features)
  ├─ Prompts Only (Basic features)
  └─ Off (Disabled)
```

### Via Status Bar

Click the IQPilot status bar item (right side) → Select mode

## What Happens When You Disable IQPilot?

### ✅ Still Works (Always Available)

**GitHub Copilot Features:**
- Chat and code completion
- `.github/copilot-instructions.md` context automatically loaded
- `.github/instructions/*.instructions.md` path-specific rules
- `.copilot/context/*.md` semantic search for domain knowledge

**Manual Workflows:**
- `.github/templates/*.md` - Copy/paste templates manually
- `.github/prompts/*.md` - Standalone prompts (use in Copilot Chat)
- `.copilot/scripts/*.ps1` - Run PowerShell scripts manually

### ❌ Stops Working (IQPilot MCP Only)

**Enhanced Features:**
- IQPilot MCP tools (16 specialized tools)
- Validation caching (avoids redundant AI calls)
- Automatic metadata sync on file renames
- Gap analysis workflows
- Cross-reference discovery
- Enhanced prompts from `.iqpilot/prompts/`

## Performance Considerations

| Mode | Startup Time | Memory Usage | AI Call Optimization |
|------|-------------|--------------|---------------------|
| **MCP** | ~2 seconds | ~100 MB | ✅ Caching enabled |
| **Prompts Only** | Instant | ~5 MB | ❌ No caching |
| **Off** | Instant | ~0 MB | N/A |

**Recommendation:** Use MCP mode for active development, switch to Off mode when not working on docs.

## Features by Mode Comparison

| Feature | MCP Mode | Prompts Only | Off |
|---------|----------|--------------|-----|
| GitHub Copilot Chat | ✅ | ✅ | ✅ |
| Context from `.copilot/context/` | ✅ | ✅ | ✅ |
| Standalone prompts (`.github/prompts/`) | ✅ | ✅ | ❌ |
| Enhanced prompts (`.iqpilot/prompts/`) | ✅ | ❌ | ❌ |
| Validation caching | ✅ | ❌ | ❌ |
| Automatic metadata sync | ✅ | ❌ | ❌ |
| Gap analysis | ✅ | ❌ | ❌ |
| Cross-reference discovery | ✅ | ❌ | ❌ |
| Series validation | ✅ | ❌ | ❌ |
| 16 MCP tools | ✅ | ❌ | ❌ |

## Troubleshooting

### IQPilot Not Starting

1. Check settings: `.vscode/settings.json`
   ```jsonc
   "iqpilot.enabled": true,
   "iqpilot.mode": "mcp"
   ```

2. Verify MCP server exists:
   ```powershell
   Test-Path .copilot/mcp-servers/iqpilot/iqpilot.exe
   ```

3. Rebuild if missing:
   ```powershell
   cd src/IQPilot
   dotnet build --configuration Release
   Copy-Item bin/Release/net8.0/* ..\..\..\.copilot\mcp-servers\iqpilot\ -Recurse -Force
   ```

4. Reload VS Code:
   ```
   Ctrl+Shift+P → "Developer: Reload Window"
   ```

### Prompts Not Working in Prompts-Only Mode

1. Verify prompts exist in `.github/prompts/`:
   ```powershell
   Get-ChildItem .github/prompts/*.prompt.md
   ```

2. Use natural language in Copilot Chat:
   ```
   "Check this article for grammar errors"
   ```

3. GitHub Copilot will automatically find and use standalone prompts

### Mode Switch Not Taking Effect

1. After changing settings, always reload:
   ```
   Ctrl+Shift+P → "Developer: Reload Window"
   ```

2. Check status bar (right side) shows current mode:
   - `✅ IQPilot (MCP)` - Full mode active
   - `📝 IQPilot (prompts only)` - Prompts mode
   - `❌ IQPilot (disabled)` - Off

## Notes on Previous Versions

The standalone metadata synchronization tool has been integrated into IQPilot's MCP server.

**Previous configuration** (no longer used):
```jsonc
{
    "metadataWatcher.enabled": true  // Deprecated
}
```

**Current configuration:**
```jsonc
{
    "iqpilot.enabled": true,
    "iqpilot.mode": "mcp",  // "mcp" | "prompts-only" | "off"
    "iqpilot.autoStart": true
}
```

IQPilot provides all previous metadata management functionality plus validation caching, gap analysis, cross-referencing, and 16 specialized MCP tools.

## Additional Resources

- **[GETTING-STARTED.md](../GETTING-STARTED.md)** - Complete IQPilot setup
- **[idea/IQPilot/01. IQPilot overview.md](../idea/IQPilot/01.%20IQPilot%20overview.md)** - Concepts and philosophy
- **[idea/IQPilot/02. IQPilot Getting started.md](../idea/IQPilot/02.%20IQPilot%20Getting%20started.md)** - Installation guide
- **[idea/IQPilot/03. IQPilot Implementation details.md](../idea/IQPilot/03.%20IQPilot%20Implementation%20details.md)** - Technical architecture
