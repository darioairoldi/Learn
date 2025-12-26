---
title: "_quarto.yml Document Structure"
description: "Comprehensive reference for all configuration options available in the _quarto.yml file"
author: "Dario Airoldi"
date: "2025-01-16"
date-modified: last-modified
categories: [quarto, configuration, yaml, reference]
format:
  html:
    toc: true
    toc-depth: 3
    number-sections: true
    anchor-sections: true
    smooth-scroll: true
    code-copy: true
    code-fold: show
    highlight-style: github
keywords:
  - quarto
  - configuration
  - yaml
  - documentation
  - website
  - publishing
abstract: |
  A comprehensive reference guide covering all aspects of the _quarto.yml configuration file. This document provides detailed explanations of all configuration sections including project settings, website configuration, format options, metadata, engines, filters, and advanced features. Essential for understanding the full capabilities of Quarto configuration and implementing complex documentation setups.
---

## 📋 Table of Contents

- [📖 Overview](#-overview)
- [🏗️ Basic Structure](#️-basic-structure)
- [⚙️ Project Configuration](#️-project-configuration)
- [🌐 Website Configuration](#-website-configuration)
- [📄 Format Configuration](#-format-configuration)
- [🏷️ Metadata Configuration](#️-metadata-configuration)
- [🔧 Engine Configuration](#-engine-configuration)
- [🔌 Filters and Extensions](#-filters-and-extensions)
- [🌍 Environment and Variables](#-environment-and-variables)
- [⚡ Advanced Configuration](#-advanced-configuration)
- [📋 Complete Example](#-complete-example)
- [✅ Best Practices](#-best-practices)
- [🔧 Troubleshooting](#-troubleshooting)

## 📖 Overview

The `_quarto.yml` file is the central configuration file for Quarto projects. It defines how your content is processed, rendered, and published. This document provides a comprehensive reference for all configuration options available in the `_quarto.yml` file.

## 🏗️ Basic Structure

The `_quarto.yml` file is written in YAML format and consists of several top-level sections:

```yaml
# Basic structure
project:
  # Project-level settings

website:
  # Website-specific settings (for website projects)

book:
  # Book-specific settings (for book projects)

format:
  # Output format specifications

metadata:
  # Document metadata

engine:
  # Computational engine settings

filters:
  # Pandoc filters

execute:
    # Code execution settings
```

## ⚙️ Project Configuration

The `project` section defines fundamental project settings.### project.type

**Goal**: Specifies the type of Quarto project

**Options**:

- `website` - Multi-page website
- `book` - Book with chapters
- `manuscript` - Academic manuscript
- `default` - Single document or collection

```yaml
project:
  type: website
```

### project.output-dir

**Goal**: Defines where rendered output files are placed
**Options**: Any valid directory path (relative or absolute)

```yaml
project:
  output-dir: docs        # For GitHub Pages
  # output-dir: _site     # Alternative
  # output-dir: public    # Alternative
```

### project.lib-dir

**Goal**: Specifies location for project libraries and dependencies
**Options**: Directory path for storing project assets

```yaml
project:
  lib-dir: libs
```

### project.preview

**Goal**: Configuration for preview server
**Options**:

```yaml
project:
  preview:
    port: 4200
    browser: true
    watch-inputs: true
    navigate: true
```

### project.render

**Goal**: Controls which files are rendered
**Options**:

```yaml
project:
  render:
    - "*.qmd"
    - "*.md"
    - "!draft-*.qmd"  # Exclude drafts
```

## 🌐 Website Configuration

The `website` section is used when `project.type: website`.

### website.title

**Goal**: Sets the main title of the website
**Options**: Any string value

```yaml
website:
  title: "My Documentation Site"
```

### website.description

**Goal**: Provides a description for SEO and metadata
**Options**: String describing the website content

```yaml
website:
  description: "Comprehensive documentation for my project"
```

### website.site-url

**Goal**: Specifies the canonical URL for the website
**Options**: Full URL where the site will be hosted

```yaml
website:
  site-url: "https://username.github.io/repository"
```

### website.repo-url

**Goal**: Links to the source repository
**Options**: URL to the source code repository

```yaml
website:
  repo-url: "https://github.com/username/repository"
  repo-actions: [edit, issue]
```

### website.navbar

**Goal**: Configures the navigation bar
**Options**: Complex structure for navigation elements

```yaml
website:
  navbar:
    background: primary
    search: true
    logo: "images/logo.png"
    title: "Site Title"
    left:
      - href: index.qmd
        text: Home
      - href: about.qmd
        text: About
      - text: "Documentation"
        menu:
          - href: guide.qmd
            text: User Guide
          - href: reference.qmd
            text: Reference
    right:
      - icon: github
        href: "https://github.com/username/repo"
    tools:
      - icon: github
        menu:
          - text: Source Code
            url: "https://github.com/username/repo"
          - text: Report a Bug
            url: "https://github.com/username/repo/issues"
```

### website.sidebar

**Goal**: Configures sidebar navigation
**Options**: Structure for hierarchical navigation

```yaml
website:
  sidebar:
    style: "docked"        # Options: docked, floating
    search: true
    collapse-level: 2
    contents:
      - href: index.qmd
        text: Home
      - section: "Getting Started"
        contents:
          - href: installation.qmd
            text: Installation
          - href: quickstart.qmd
            text: Quick Start
      - section: "Advanced Topics"
        contents:
          - href: configuration.qmd
          - href: deployment.qmd
```

### website.page-navigation

**Goal**: Controls page-level navigation
**Options**: Boolean or detailed configuration

```yaml
website:
  page-navigation: true
  # Or detailed configuration:
  page-navigation:
    location: bottom
    align: center
```

### website.footer

**Goal**: Configures the website footer
**Options**: Text, links, and layout options

```yaml
website:
  footer:
    left: "Copyright 2025, My Organization"
    right:
      - href: privacy.qmd
        text: Privacy Policy
      - href: terms.qmd
        text: Terms of Use
```

### website.cookie-consent

**Goal**: Adds GDPR-compliant cookie consent
**Options**: Configuration for cookie consent banner

```yaml
website:
  cookie-consent:
    type: express
    style: headline
    palette: dark
```

### website.google-analytics

**Goal**: Integrates Google Analytics tracking
**Options**: Google Analytics tracking ID

```yaml
website:
  google-analytics: "G-XXXXXXXXXX"
```

## 📄 Format Configuration

The `format` section defines output formats and their settings.

### HTML Format

**Goal**: Configures HTML output
**Options**: Extensive customization for web output

```yaml
format:
  html:
    theme: cosmo                    # Built-in themes
    css: styles.css                 # Custom CSS
    toc: true                       # Table of contents
    toc-depth: 3                    # TOC depth
    toc-location: left              # left, right, body
    number-sections: true           # Number headings
    number-depth: 3                 # Numbering depth
    highlight-style: github         # Code highlighting
    code-fold: true                 # Collapsible code
    code-tools: true                # Code viewing tools
    smooth-scroll: true             # Smooth scrolling
    anchor-sections: true           # Anchor links
    citations-hover: true           # Citation previews
    footnotes-hover: true           # Footnote previews
    fig-width: 8                    # Figure width
    fig-height: 6                   # Figure height
    fig-cap-location: bottom        # Caption location
    tbl-cap-location: top           # Table caption location
    callout-appearance: default     # Callout styling
    page-layout: article            # Page layout
    grid:
      sidebar-width: 250px          # Sidebar width
      body-width: 900px             # Body width
      margin-width: 250px           # Margin width
    mainfont: "Source Sans Pro"     # Main font
    monofont: "Source Code Pro"     # Code font
```

### PDF Format

**Goal**: Configures PDF output
**Options**: LaTeX-based PDF generation settings

```yaml
format:
  pdf:
    documentclass: article          # LaTeX document class
    geometry:
      - top=30mm
      - left=20mm
      - heightrounded
    fontfamily: libertinus          # Font family
    fontsize: 11pt                  # Font size
    linestretch: 1.25               # Line spacing
    number-sections: true           # Number sections
    colorlinks: true                # Colored links
    lot: true                       # List of tables
    lof: true                       # List of figures
    toc: true                       # Table of contents
    toc-depth: 3                    # TOC depth
    bibliography: references.bib    # Bibliography file
    csl: apa.csl                    # Citation style
```

### Word Format

**Goal**: Configures Microsoft Word output
**Options**: Word document generation settings

```yaml
format:
  docx:
    reference-doc: template.docx    # Word template
    number-sections: true           # Number sections
    highlight-style: github         # Code highlighting
    fig-width: 7                    # Figure width
    fig-height: 5                   # Figure height
    toc: true                       # Table of contents
    toc-depth: 3                    # TOC depth
```

## 🏷️ Metadata Configuration

The `metadata` section defines document-wide metadata.

### Basic Metadata

**Goal**: Sets fundamental document information
**Options**: Standard metadata fields

```yaml
metadata:
  title: "Document Title"
  subtitle: "Document Subtitle"
  author:
    - name: "John Doe"
      email: "john@example.com"
      affiliation: "University Name"
    - name: "Jane Smith"
      email: "jane@example.com"
  date: "2025-01-14"
  abstract: "This document provides..."
  keywords:
    - documentation
    - quarto
    - publishing
```

### Academic Metadata

**Goal**: Provides academic publication information
**Options**: Scholarly metadata fields

```yaml
metadata:
  doi: "10.1000/xyz123"
  arxiv: "2301.12345"
  pmid: "12345678"
  citation:
    type: article-journal
    container-title: "Journal Name"
    volume: 42
    issue: 3
    page: "123-145"
    issn: "1234-5678"
```

### Custom Metadata

**Goal**: Allows custom metadata fields
**Options**: Any key-value pairs

```yaml
metadata:
  custom-field: "custom value"
  project-version: "1.0.0"
  build-date: "2025-01-14"
```

## 🔧 Engine Configuration

The `engine` section configures computational engines.

### Jupyter Engine

**Goal**: Configures Jupyter notebook execution
**Options**: Jupyter-specific settings

```yaml
engine:
  jupyter:
    kernel: python3
    execute:
      timeout: 300
      allow_errors: false
      error_on_missing_exec: true
```

### Knitr Engine

**Goal**: Configures R/Knitr execution
**Options**: R-specific settings

```yaml
engine:
  knitr:
    opts_chunk:
      echo: true
      warning: false
      message: false
      fig.width: 8
      fig.height: 6
```

## 🔌 Filters and Extensions

### Pandoc Filters

**Goal**: Applies document transformations
**Options**: List of filter names or configurations

```yaml
filters:
  - lightbox                        # Built-in filter
  - custom-filter.py               # Custom filter
  - name: tables
    params:
      style: grid
```

### Extensions

**Goal**: Adds functionality through extensions
**Options**: Extension names and configurations

```yaml
extensions:
  - quarto-ext/fontawesome
  - quarto-ext/lightbox
```

## 🌍 Environment and Variables

### Environment Variables

**Goal**: Sets environment variables for rendering
**Options**: Key-value pairs

```yaml
environment:
  QUARTO_PYTHON: "/usr/bin/python3"
  CUSTOM_VAR: "value"
```

### Project Variables

**Goal**: Defines reusable variables
**Options**: Variable definitions

```yaml
variables:
  github-url: "https://github.com/username/repo"
  version: "1.0.0"
  api-base: "https://api.example.com"
```

## ⚡ Advanced Configuration

### Execute Configuration

**Goal**: Controls code execution behavior
**Options**: Execution parameters

```yaml
execute:
  enabled: true                     # Enable execution
  cache: true                       # Cache results
  freeze: false                     # Freeze execution
  daemon: false                     # Use daemon
  daemon-restart: false             # Restart daemon
  debug: false                      # Debug mode
  error: false                      # Continue on error
  eval: true                        # Evaluate code
  echo: true                        # Show code
  output: true                      # Show output
  warning: true                     # Show warnings
  include: true                     # Include in output
```

### Bibliography Configuration

**Goal**: Manages citations and references
**Options**: Bibliography settings

```yaml
bibliography: references.bib
csl: chicago-author-date.csl
citation-style: author-year
link-citations: true
citeproc: true
```

### Cross-Reference Configuration

**Goal**: Configures cross-referencing
**Options**: Reference settings

```yaml
crossref:
  fig-title: "Figure"
  tbl-title: "Table"
  eq-title: "Equation"
  sec-title: "Section"
  chapters: true
```

## 📋 Complete Example

Here's a comprehensive example showing many configuration options:

```yaml
project:
  type: website
  output-dir: docs
  preview:
    port: 4200
    browser: true

website:
  title: "My Documentation"
  description: "Comprehensive project documentation"
  site-url: "https://username.github.io/project"
  repo-url: "https://github.com/username/project"
  
  navbar:
    background: primary
    search: true
    left:
      - href: index.qmd
        text: Home
      - text: "Documentation"
        menu:
          - href: guide/index.qmd
            text: User Guide
          - href: reference/index.qmd
            text: API Reference
    right:
      - icon: github
        href: "https://github.com/username/project"
  
  sidebar:
    style: "docked"
    search: true
    contents:
      - href: index.qmd
        text: "Home"
      - section: "Getting Started"
        contents:
          - href: installation.qmd
          - href: quickstart.qmd
      - section: "Advanced"
        contents:
          - href: configuration.qmd
          - href: deployment.qmd
  
  footer:
    left: "� 2025 My Organization"
    right:
      - href: license.qmd
        text: License

format:
  html:
    theme: cosmo
    css: styles.css
    toc: true
    toc-depth: 3
    number-sections: true
    highlight-style: github
    code-fold: true
    code-tools: true
    smooth-scroll: true
    fig-width: 8
    fig-height: 6

metadata:
  author: "Your Name"
  date: last-modified
  version: "1.0.0"

execute:
  cache: true
  freeze: auto

filters:
  - lightbox

bibliography: references.bib
csl: apa.csl
```

## ✅ Best Practices

### Organization

1. **Group Related Settings**: Keep related configuration options together
2. **Use Comments**: Document complex configurations with YAML comments
3. **Consistent Formatting**: Maintain consistent indentation and structure
4. **Version Control**: Track changes to `_quarto.yml` in version control

### Performance

1. **Enable Caching**: Use `execute.cache: true` for computational content
2. **Optimize Images**: Configure appropriate figure dimensions
3. **Selective Rendering**: Use `project.render` to control what gets processed

### Maintenance

1. **Regular Updates**: Keep up with new Quarto features and options
2. **Validate Configuration**: Use `quarto check` to validate your configuration
3. **Test Changes**: Preview locally before deploying changes

## 🔧 Troubleshooting

### Common Configuration Issues

**YAML Syntax Errors**: Use proper indentation and quotes when needed
2. **Invalid Paths**: Ensure all file paths are correct and accessible
3. **Missing Dependencies**: Install required themes, filters, or extensions
4. **Execution Errors**: Check engine configuration and code execution settings

### Validation

```bash
# Check configuration
quarto check

# Preview with verbose output
quarto preview --verbose

# Render with debug information
quarto render --debug
```

### Debug Configuration

```yaml
execute:
  debug: true

project:
  preview:
    watch-inputs: true
```

This comprehensive reference covers all major aspects of the `_quarto.yml` configuration file. Use it as a guide to customize your Quarto projects according to your specific needs and requirements.

---

<!-- 
---
article_metadata:
  filename: "03-quarto-yml-structure.md"
  word_count: 3500
  created_date: "2025-01-16"
  last_updated: "2025-12-26T00:00:00Z"
  
cross_references:
  series:
    name: "Quarto Documentation Guide"
    part: 5
    total_parts: 14
    previous: "02-split-navigation-build.md"
    next: "04-markdown-features.md"
  related_articles:
    - "01-introduction-to-quarto.md"
    - "05-theming-and-styling.md"
    - "06-sidebar-layout.md"
  prerequisites:
    - "01-introduction-to-quarto.md"

validations:
  series_validation:
    last_run: "2025-12-26T00:00:00Z"
    model: "claude-sonnet-4.5"
    series_name: "Quarto Documentation Guide"
    article_position: 5
    total_articles: 14
    consistency_score: 10
    completeness_score: 10
    redundancy_score: 10
    issues_found: 0
    issues_critical: 0
    issues_medium: 0
    issues_low: 0
    notes: "Comprehensive configuration reference with all major _quarto.yml options documented"
---
-->