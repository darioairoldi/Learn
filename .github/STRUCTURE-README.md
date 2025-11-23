# Documentation Site Automation Structure

This document explains the folder structure and automation tools for this learning documentation repository.

## 📁 Repository Structure

```
.github/
├── copilot-instructions.md          # Global editorial & validation standards
├── instructions/                    # Path-specific instructions
│   ├── documentation.instructions.md
│   ├── tech-articles.instructions.md
│   └── prompts.instructions.md
├── prompts/                         # Automation prompt files
│   ├── article-writing.prompt.md
│   ├── grammar-review.prompt.md
│   ├── readability-review.prompt.md
│   ├── understandability-review.prompt.md
│   ├── gap-analysis.prompt.md
│   ├── logic-analysis.prompt.md
│   ├── structure-validation.prompt.md
│   ├── fact-checking.prompt.md
│   ├── series-validation.prompt.md
│   ├── correlated-topics.prompt.md
│   ├── metadata-init.prompt.md
│   ├── metadata-update.prompt.md
│   └── publish-ready.prompt.md
└── templates/                       # Content templates
    ├── article-template.md
    ├── howto-template.md
    ├── tutorial-template.md
    ├── issue-template.md
    ├── recording-summary-template.md
    ├── recording-analysis-template.md
    └── metadata-template.yml

.copilot/
├── bin/                             # (Deprecated - use mcp-servers/)
├── mcp-servers/                     # MCP server executables
│   └── iqpilot/                     # IQPilot MCP server
├── context/                         # Rich context for AI
│   ├── domain-concepts.md           # Core concepts
│   ├── style-guide.md               # Writing standards
│   ├── validation-criteria.md       # Quality thresholds
│   └── workflows/
│       ├── article-creation-workflow.md
│       ├── review-workflow.md
│       └── series-planning-workflow.md
└── scripts/                         # Automation scripts
    ├── validate-metadata.ps1
    ├── check-stale-validations.ps1
    └── build-iqpilot.ps1            # Build IQPilot MCP server

src/IQPilot/                         # C# MCP Server for content quality tools
├── Program.cs                       # MCP server entry point
├── Services/                        # Core services (validation, metadata, etc.)
├── Tools/                           # MCP tool implementations (16 tools)
├── IQPilot.csproj                   # Project file
└── README.md, README.IQPilot.md     # Technical documentation

.vscode/
├── extensions/
│   └── metadata-watcher/            # VS Code extension (TypeScript)
│       ├── src/extension.ts
│       ├── package.json
│       └── tsconfig.json
├── tasks.json                       # Build tasks
├── launch.json                      # Debug configurations
├── settings.json                    # Workspace settings
└── extensions.json                  # Recommended extensions
```

## 🚀 Quick Start

### One-Time Setup: MetadataWatcher

**MetadataWatcher** automatically synchronizes metadata files when you rename articles. Set it up once:

```powershell
.\.copilot\scripts\build-metadata-watcher.ps1
```

Then reload VS Code (`Ctrl+Shift+P` → "Developer: Reload Window"). Look for `✓ Metadata Watcher` in the status bar.

📖 **Full setup guide**: [METADATA-WATCHER-QUICKSTART.md](../METADATA-WATCHER-QUICKSTART.md)

### Creating a New Article

1. **Plan your article**
   - Define topic, audience, and learning objectives
   - Create outline

2. **Initialize** (optional - metadata created automatically during validation)
   ```
   /metadata-init
   ```
   Provide title, tags, and author info

3. **Write content**
   - Use appropriate template from `.github/templates/`
   - Or use `/article-writing` prompt for AI assistance

4. **Validate** (metadata auto-created/updated during these steps)
   ```
   /structure-validation
   /grammar-review
   /readability-review
   /logic-analysis
   /fact-checking
   ```

5. **Final check**
   ```
   /publish-ready
   ```

6. **Publish**
   - Update status to 'published' in metadata (if exists)
   - Commit and push

**Note**: The dual metadata architecture embeds all metadata in the article itself - no separate files to rename!

## 🔧 Prompt Files (VS Code & Visual Studio)

### Content Creation
- **`/article-writing`**: Generate article drafts from topic/outline
  - Use with templates for structured content
  - Includes research via semantic search

### Quality Validation
- **`/grammar-review`**: Check spelling, grammar, punctuation
- **`/readability-review`**: Analyze clarity, consistency, redundancy
- **`/understandability-review`**: Evaluate audience comprehension
- **`/logic-analysis`**: Verify logical flow and concept connections
- **`/structure-validation`**: Ensure template compliance
- **`/fact-checking`**: Verify accuracy against authoritative sources
- **`/gap-analysis`**: Identify missing information

### Content Discovery
- **`/correlated-topics`**: Find related subjects and learning paths
- **`/series-validation`**: Check consistency across article series

### Metadata Management
- **`/metadata-init`**: Create metadata file for new articles
- **`/metadata-update`**: Update metadata after validations
- **`/publish-ready`**: Comprehensive pre-publish checklist

## 📋 Templates

### Article Types
- **`article-template.md`**: General explanatory content
- **`howto-template.md`**: Step-by-step procedures
- **`tutorial-template.md`**: Hands-on learning with exercises

### Documentation
- **`recording-summary-template.md`**: Meeting/presentation summaries
- **`recording-analysis-template.md`**: Deep analysis of recordings
- **`issue-template.md`**: Bug/improvement reports

### Metadata
- **`metadata-template.yml`**: Schema for article metadata

## 📊 Metadata System

Each article has an adjacent `.metadata.yml` file tracking:

- **Article info**: Title, author, dates, status, tags
- **Validation history**: Timestamps, models, outcomes
- **Cross-references**: Related articles, prerequisites, advanced topics
- **Analytics**: Word count, reading time, engagement metrics

### Validation Caching

Metadata enables smart re-validation:
- Skip validation if article unchanged since last run
- Skip if same model and previous outcome was "passed"
- Re-run if article modified or validation stale

## 🛠️ Automation Scripts

### PowerShell Scripts

Located in `.copilot/scripts/`:

**`validate-metadata.ps1`**: Validate all metadata files
```powershell
.\.copilot\scripts\validate-metadata.ps1 -Verbose
```

**`check-stale-validations.ps1`**: Find articles with outdated checks
```powershell
.\.copilot\scripts\check-stale-validations.ps1 -ExportCsv
```

## 📖 Context Library

Located in `.copilot/context/`, these files enrich AI responses:

- **`domain-concepts.md`**: Core concepts and terminology
- **`style-guide.md`**: Writing standards and formatting
- **`validation-criteria.md`**: Quality thresholds
- **`workflows/`**: Process documentation
- **`guidelines/`**: Best practices
- **`patterns/`**: Reusable content patterns
- **`examples/`**: Exemplar articles

## 🎯 Validation Outcomes

### Status Values
- **passed**: Meets all criteria
- **minor_issues**: Acceptable issues noted
- **needs_revision**: Must be fixed before publishing
- **failed**: Critical errors, major revision needed

### Article Status
- **draft**: Initial creation, not validated
- **in-review**: Validations in progress
- **published**: Approved and live
- **archived**: Outdated but kept for reference

## 📝 Instructions Files

### Global Instructions
**`.github/copilot-instructions.md`**: Applied to all content
- Fact-checking requirements
- Citation standards
- Metadata management
- Preferred tools and workflows

### Path-Specific Instructions
**`.github/instructions/`**: Applied to specific folders
- `documentation.instructions.md`: All Markdown files
- `tech-articles.instructions.md`: Technical content
- `prompts.instructions.md`: Prompt engineering articles

## 🔄 Content Lifecycle

```
Idea → Draft → Validation → Review → Published → Maintenance
```

1. **Idea**: Topic selection and planning
2. **Draft**: Content creation (manual or AI-assisted)
3. **Validation**: Quality checks via prompts
4. **Review**: Self-review and refinement
5. **Published**: Live content
6. **Maintenance**: Periodic re-validation and updates

## ⚙️ Best Practices

### When Writing
1. Start with appropriate template
2. Metadata is automatically created during validations (no manual `/metadata-init` needed)
3. Validate incrementally (don't wait until end)
4. Metadata updates automatically after each validation
5. Use fact-checking for technical claims
6. **Renaming articles**: Use F2 or right-click → Rename. IQPilot (if enabled) updates embedded metadata automatically.

### When Reviewing
1. Check metadata for last validation dates (if file exists)
2. Skip recent validations if article unchanged
3. Focus on modified sections
4. Run `/publish-ready` before publishing

### When Maintaining
1. Schedule quarterly reviews for technical content
2. Re-run fact-checking when technologies update
3. Monitor for broken links
4. Update cross-references when adding related content

### IQPilot Usage

See [.iqpilot/README.md](../.iqpilot/README.md) for complete documentation.

- **Operating modes**: MCP (full features), Prompts Only (standalone), or Off
- **Mode switching**: Via settings or status bar commands
- **Configuration**: See [GETTING-STARTED.md](../GETTING-STARTED.md)

## 🚨 Common Issues

### Validation Errors
- **Solution**: Run the specific validation prompt, fix issues, update metadata

### Stale Validations
- **Check**: Run `check-stale-validations.ps1`
- **Solution**: Re-run outdated validations, update metadata

### Broken Links
- **Prevention**: Verify during fact-checking
- **Detection**: Regular link checking
- **Solution**: Update or remove broken links

## 📚 Reference Documentation

### GitHub Copilot Features
- Prompt files: `.prompt.md` in `.github/prompts/`
- Instructions: `.instructions.md` in `.github/instructions/`
- Templates: Reference files in `.github/templates/`

### Supported IDEs
- **VS Code**: All features supported
- **Visual Studio 2022 (17.10+)**: Prompt and instruction files supported
- **GitHub Copilot CLI**: Agent mode prompts supported

## 🔍 Finding Content

### Semantic Search
Copilot indexes `.copilot/context/` for semantic search. Place rich documentation here to improve AI responses.

### Cross-References
Use `/correlated-topics` to discover related content and maintain cross-reference links.

### Series Navigation
Articles in a series should have series metadata and prev/next navigation.

## 💡 Tips

1. **Use validation caching**: Avoid redundant AI calls
2. **Batch validations**: Run multiple checks together
3. **Incremental validation**: Check as you write sections
4. **Template adherence**: Saves validation time
5. **Reuse research**: Build on existing articles

## 🆘 Getting Help

- Review workflow documentation in `.copilot/context/workflows/`
- Check templates in `.github/templates/`
- Read context guides in `.copilot/context/`
- Use `/publish-ready` for comprehensive status

---

*Last updated: 2025-11-18*  
*Version: 1.0*
