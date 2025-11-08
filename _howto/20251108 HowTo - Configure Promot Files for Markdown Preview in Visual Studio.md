# HowTo: Configure .prompt Files for Markdown Preview in Visual Studio

This guide explains how to configure Visual Studio to render `.prompt` files with the markdown preview button.

## Quick Setup

The repository is already configured with the necessary files:

1. **`.editorconfig`** - Associates `.prompt` files with markdown-like settings
2. **`.vs/fileextensions.json`** - Maps `.prompt` extension to markdown content type

## Manual Configuration (If Needed)

If the automatic configuration doesn't work, follow these steps:

### Method 1: Using Visual Studio Settings

1. Open Visual Studio
2. Go to **Tools** → **Options**
3. Navigate to **Text Editor** → **File Extension**
4. In the **Extension** box, type: `prompt`
5. In the **Editor** dropdown, select: **Markdown Editor**
6. Click **Add**, then **OK**

### Method 2: Using Extension Mappings

Add the following to your Visual Studio settings:

```json
{
  "fileExtensionToContentTypeDefinitions": [
    {
  "fileExtension": ".prompt",
      "contentType": "markdown"
    }
  ]
}
```

### Method 3: Registry Configuration (Advanced)

For system-wide configuration, you can add a registry entry:

**Path:** `HKEY_CURRENT_USER\Software\Microsoft\VisualStudio\<version>\Text Editor\FileExtension\Extensions`

**Key:** `prompt`
**Value:** `Markdown Editor`

## Verifying Configuration

1. Open any `.prompt` file in the solution (e.g., `.github/copilot/prompts/Issue-Generate analysis from current conversation.prompt`)
2. Look for the **Preview** button in the Visual Studio toolbar
3. Click it to view the markdown-rendered version

## Troubleshooting

### Preview Button Not Appearing

- Restart Visual Studio after configuration changes
- Ensure the **Markdown Editor** extension is installed
- Try reinstalling Visual Studio with Web Development workload

### Syntax Highlighting Not Working

- Go to **Tools** → **Options** → **Text Editor** → **All Languages**
- Verify that syntax highlighting is enabled
- Reset Visual Studio settings if needed

### Extension Association Not Persisting

- Check if `.vs` folder is in `.gitignore`
- Verify file permissions for `.vs/fileextensions.json`
- Use Method 1 (Visual Studio Settings) as an alternative

## Additional Resources

- [Visual Studio File Extensions Documentation](https://docs.microsoft.com/en-us/visualstudio/ide/customize-the-editor)
- [Markdown Editor Extension](https://marketplace.visualstudio.com/items?itemName=MadsKristensen.MarkdownEditor2022)

## Notes

- The `.vs` folder is typically excluded from version control
- Configuration may need to be reapplied on different machines
- Consider documenting this setup in your team's onboarding guide
