---
title: "Using Quarto"
description: "Using Quarto with GitHub Pages for Documentation"
author: "Dario Airoldi"
date: "July 2, 2025"
date-modified: last-modified
categories: [azure, best-practices]
format:
  html:
    toc: true
    toc-depth: 3
---

## Table of Contents

- [Overview](#overview)
- [Key Concepts](#key-concepts)
  - [Project Structure](#1-project-structure)
  - [Configuration File (_quarto.yml)](#2-configuration-file-_quartoyml)
  - [Source Directory (src/doc/)](#3-source-directory-srcdoc)
  - [Output Directory (docs/)](#4-output-directory-docs)
- [Setting Up Quarto with GitHub Pages](#setting-up-quarto-with-github-pages)
  - [Step 1: Initialize Quarto Project](#step-1-initialize-quarto-project)
  - [Step 2: Configure Output Directory](#step-2-configure-output-directory)
  - [Step 3: Configure GitHub Pages](#step-3-configure-github-pages)
  - [Step 4: Create GitHub Actions Workflow](#step-4-create-github-actions-workflow)
- [Best Practices](#best-practices)
  - [Content Organization](#1-content-organization)
  - [Writing Guidelines](#2-writing-guidelines)
  - [Development Workflow](#3-development-workflow)
  - [Version Control Considerations](#4-version-control-considerations)
- [Advanced Features](#advanced-features)
  - [Themes and Styling](#1-themes-and-styling)
  - [Interactive Content](#2-interactive-content)
  - [Multi-language Support](#3-multi-language-support)
- [Troubleshooting Common Issues](#troubleshooting-common-issues)
  - [GitHub Pages Not Updating](#1-github-pages-not-updating)
  - [Broken Links](#2-broken-links)
  - [Rendering Errors](#3-rendering-errors)
- [Monitoring and Maintenance](#monitoring-and-maintenance)
  - [Analytics](#1-analytics)
  - [Content Updates](#2-content-updates)
  - [Performance](#3-performance)
- [Conclusion](#conclusion)
- [References](#references)
- [APPENDIXES](#appendixes)
  - [APPENDIX A: Quarto.yml Document Structure](#appendix-a-quartoyml-document-structure---complete-reference-guide)
  - [APPENDIX B: Quarto Specific Markdown Features](#appendix-b-quarto-specific-markdown-features---complete-guide)
  - [APPENDIX C: Quarto Theming and Styling](#appendix-c-quarto-theming-and-styling---complete-guide)
  - [APPENDIX D: Configuring Your Learn Repository for Quarto](#appendix-d-configuring-your-learn-repository-for-quarto)

## Overview

**Quarto** is a powerful, **open-source** **scientific** and **technical publishing system** that allows you to create beautiful documentation websites from Markdown files.<br>
When combined with **GitHub Pages**, it provides an excellent solution for publishing and maintaining project documentation.

## Key Concepts

### 1. Project Structure

Quarto is highly flexible and supports multiple project structures. Here are several common approaches:

#### Standard Documentation Structure

A typical Quarto documentation project follows this structure:

```text
your-repo/
├── src/
│   └── doc/           # Source markdown files
│       ├── index.md
│       ├── guide.md
│       └── reference.md
├── docs/              # Rendered HTML output (for GitHub Pages)
├── _quarto.yml        # Quarto configuration file
└── .github/
    └── workflows/
        └── quarto-publish.yml  # GitHub Actions workflow
```

#### Root-Level Structure

For simpler projects, you can place content directly in the root:

```text
your-repo/
├── index.md           # Homepage
├── guide.md           # Documentation pages
├── reference.md
├── about.md
├── docs/              # Rendered output
├── _quarto.yml        # Configuration
└── images/            # Assets
```

#### Learn Repository Structure Example

For a repository like your "Learn" repo with existing folder structure, you could adapt it as follows:

```text
Learn/                              # Your existing repository
├── index.md                        # New: Main landing page
├── _quarto.yml                     # New: Quarto configuration
├── docs/                           # New: Rendered output
├── 202506 Build 2025/              # Existing: Event documentation
│   ├── index.md                    # New: Build 2025 overview
│   ├── BRK106/
│   │   └── *.md                    # Existing: Session notes
│   └── BRK122/
│       └── *.md                    # Existing: Session notes
├── 20250702 Azure Naming conventions/  # Existing: Topic folder
│   └── *.md                        # Existing: Content
├── 20250704 TableStorageAccess options/  # Existing: Topic folder
│   └── *.md                        # Existing: Content
└── _ISSUES/                        # Existing: Issue tracking
    └── */                          # Existing: Issue folders
```

#### Multi-Section Structure

For larger documentation sites with distinct sections:

```text
your-repo/
├── index.md
├── _quarto.yml
├── docs/              # Rendered output
├── tutorials/         # Tutorial section
│   ├── index.md
│   ├── getting-started.md
│   └── advanced.md
├── reference/         # Reference section
│   ├── index.md
│   ├── api.md
│   └── cli.md
├── blog/              # Blog section (optional)
│   ├── index.md
│   └── posts/
└── assets/            # Shared resources
    ├── images/
    └── styles/
```

### 2. Configuration File (`_quarto.yml`)

The `_quarto.yml` file is the heart of your Quarto project configuration:

```yaml
project:
  type: website
  output-dir: docs

website:
  title: "Your Documentation"
  navbar:
    left:
      - href: index.qmd
        text: Home
      - href: guide.qmd
        text: Guide
      - href: reference.qmd
        text: Reference

format:
  html:
    theme: cosmo
    css: styles.css
    toc: true
```

### 3. Source Directory (`src/doc/`)

- **Purpose**: Contains your source Markdown (`.md`) or Quarto Markdown (`.qmd`) files
- **Best Practices**:
  - Use clear, descriptive filenames
  - Organize content hierarchically with subdirectories
  - Include an `index.md` as your homepage
  - Use consistent front matter (YAML headers)

### 4. Output Directory (`docs/`)

- **Purpose**: Contains the rendered HTML files that GitHub Pages will serve
- **Important Notes**:
  - This directory is generated by Quarto's rendering process
  - Should be included in your repository for GitHub Pages
  - Configure GitHub Pages to serve from the `/docs` folder

## Setting Up Quarto with GitHub Pages

### Step 1: Initialize Quarto Project

```bash
# In your repository root
quarto create-project . --type website
```

### Step 2: Configure Output Directory

Ensure your `_quarto.yml` specifies the correct output directory:

```yaml
project:
  type: website
  output-dir: docs  # GitHub Pages will serve from here
```

### Step 3: Configure GitHub Pages

1. Go to your repository's Settings
2. Navigate to "Pages" section
3. Set Source to "Deploy from a branch"
4. Select branch: `main` (or your default branch)
5. Select folder: `/docs`

### Step 4: Create GitHub Actions Workflow

Create `.github/workflows/quarto-publish.yml`:

```yaml
name: Render and Publish Quarto Documentation

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  build-deploy:
    runs-on: ubuntu-latest
    
    steps:
    - name: Check out repository
      uses: actions/checkout@v4
      
    - name: Set up Quarto
      uses: quarto-dev/quarto-actions/setup@v2
      
    - name: Render Quarto Project
      run: quarto render
      
    - name: Deploy to GitHub Pages
      if: github.ref == 'refs/heads/main'
      uses: peaceiris/actions-gh-pages@v3
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
        publish_dir: ./docs
```

## Best Practices

### 1. Content Organization

- **Logical Structure**: Organize content by topic or user journey
- **Navigation**: Use clear, hierarchical navigation in your `_quarto.yml`
- **Cross-References**: Leverage Quarto's cross-referencing capabilities
- **Index Pages**: Create overview pages for each section

### 2. Writing Guidelines

- **Front Matter**: Use YAML front matter for metadata:

  ```yaml
  ---
  title: "Page Title"
  description: "Brief description"
  date: "2025-01-14"
  ---
  ```

- **Code Blocks**: Use syntax highlighting and proper language specification
- **Images**: Store images in organized subdirectories, use relative paths
- **Links**: Use relative links for internal navigation

### 3. Development Workflow

1. **Write**: Create/edit Markdown files in `src/doc/`
2. **Preview**: Use `quarto preview` for local development
3. **Render**: Run `quarto render` to generate HTML
4. **Commit**: Add both source and rendered files to Git
5. **Push**: GitHub Actions will handle deployment

### 4. Version Control Considerations

- **Include Rendered Files**: Unlike some static site generators, include the `docs/` folder in version control
- **Ignore Temporary Files**: Add to `.gitignore`:

  ```text
  .quarto/
  /.quarto/
  ```

## Advanced Features

### 1. Themes and Styling

- **Built-in Themes**: Choose from cosmo, flatly, darkly, etc.
- **Custom CSS**: Add custom styling via CSS files
- **SCSS Variables**: Customize theme variables

### 2. Interactive Content

- **Code Execution**: Embed executable code blocks
- **Jupyter Notebooks**: Include `.ipynb` files directly
- **Observable JS**: Add interactive visualizations

### 3. Multi-language Support

- **Code Highlighting**: Support for numerous programming languages
- **Internationalization**: Multi-language documentation support

## Troubleshooting Common Issues

### 1. GitHub Pages Not Updating

- Check that the `docs/` folder is being committed
- Verify GitHub Pages is configured to serve from `/docs`
- Ensure GitHub Actions workflow is running successfully

### 2. Broken Links

- Use relative paths for internal links
- Test all links before publishing
- Use Quarto's link checking capabilities

### 3. Rendering Errors

- Check `_quarto.yml` syntax
- Verify all referenced files exist
- Review console output for specific error messages

## Monitoring and Maintenance

### 1. Analytics

- Add Google Analytics or similar tracking
- Monitor page views and user behavior
- Use GitHub Insights for repository metrics

### 2. Content Updates

- Regular review of documentation accuracy
- Update dependencies and links
- Maintain consistent style and formatting

### 3. Performance

- Optimize images for web delivery
- Minimize custom CSS and JavaScript
- Monitor page load times

## Conclusion

Quarto provides a powerful, flexible platform for creating professional documentation websites. By following these best practices and understanding the key concepts, you can create maintainable, beautiful documentation that automatically publishes to GitHub Pages whenever you update your source files.

The combination of Markdown simplicity, Quarto's rendering capabilities, and GitHub Pages' hosting makes this an excellent choice for project documentation, technical guides, and knowledge bases.

## References

### [Quarto Official Documentation](https://quarto.org/)

The comprehensive official guide to Quarto, covering all features from basic usage to advanced configurations. This is the primary resource for understanding Quarto's capabilities, syntax, and best practices. Essential for anyone working with Quarto as it provides authoritative information on configuration options, formatting, and troubleshooting.

### [GitHub Pages Documentation](https://docs.github.com/en/pages)

GitHub's official documentation for Pages, explaining how to set up, configure, and deploy static websites. Crucial for understanding GitHub Pages limitations, custom domains, HTTPS enforcement, and deployment options. This reference helps ensure proper configuration of the hosting environment for your Quarto documentation.

### [Quarto GitHub Actions](https://github.com/quarto-dev/quarto-actions)

Official GitHub Actions for automating Quarto workflows, including rendering and deployment. This repository provides ready-to-use workflow templates that integrate seamlessly with GitHub Pages. Essential for setting up continuous integration and deployment pipelines for documentation projects.

### [Markdown Guide](https://www.markdownguide.org/)

Comprehensive reference for Markdown syntax and best practices. Since Quarto builds upon Markdown, understanding proper Markdown formatting is fundamental. This guide helps ensure consistent, well-formatted source documents that render correctly across different platforms.

### [GitHub Actions Documentation](https://docs.github.com/en/actions)

Complete guide to GitHub Actions workflows, syntax, and best practices. Important for customizing automation workflows beyond basic Quarto deployment, including adding testing, link checking, or custom build steps to your documentation pipeline.

### [Quarto Extensions Gallery](https://quarto.org/docs/extensions/)

Showcase of community-contributed extensions that add functionality to Quarto. Relevant for discovering ways to enhance documentation with additional features like custom formats, filters, or shortcodes that can improve the presentation and functionality of your documentation.

### [YAML Specification](https://yaml.org/spec/)

Official YAML specification, essential for understanding the syntax used in `_quarto.yml` configuration files and front matter. Proper YAML formatting is critical for Quarto configuration, and this reference helps prevent syntax errors that can break the build process.

### [Pandoc Documentation](https://pandoc.org/MANUAL.html)

Pandoc is the underlying document conversion engine that powers Quarto. Understanding Pandoc helps with advanced customization, custom formats, and troubleshooting complex rendering issues. Particularly useful when working with cross-references, citations, or custom output formats.

### [Git Documentation - .gitignore](https://git-scm.com/docs/gitignore)

Essential for understanding how to properly exclude temporary Quarto files from version control. Proper `.gitignore` configuration prevents committing build artifacts and temporary files while ensuring the rendered documentation is properly tracked.

### [GitHub Community Guidelines for Documentation](https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions/setting-guidelines-for-repository-contributors)

Best practices for creating maintainable, community-friendly documentation projects. Relevant for establishing contribution guidelines, documentation standards, and collaborative workflows when building documentation as part of open-source projects.

### Additional Resources

- [Quarto Documentation](https://quarto.org/)
- [GitHub Pages Documentation](https://docs.github.com/en/pages)
- [Quarto GitHub Actions](https://github.com/quarto-dev/quarto-actions)
- [Markdown Guide](https://www.markdownguide.org/)

## APPENDIXES

### APPENDIX A: [Quarto.yml Document Structure - Complete Reference Guide](001.01.%20Quarto.yml%20document%20structure.md)

An in-depth technical reference covering every aspect of the `_quarto.yml` configuration file. This companion article provides detailed explanations of all configuration sections including project settings, website configuration, format options, metadata, engines, filters, and advanced features. Essential for understanding the full capabilities of Quarto configuration and implementing complex documentation setups with custom navigation, themes, and publishing workflows.

### APPENDIX B: [Quarto Specific Markdown Features - Complete Guide](003.01.%20Quarto%20specific%20markdown%20features.md)

A comprehensive guide to Quarto's extended markdown syntax and features that go beyond standard Markdown. This technical reference covers div blocks, CSS styling, grid layouts, callout blocks, interactive elements, and advanced formatting options. Essential for creating rich, interactive documentation with sophisticated layouts, highlighting messages, and custom styling using Quarto's unique markdown extensions.

### APPENDIX C: [Quarto Theming and Styling - Complete Guide](002.03.%20Quarto%20Theming%20and%20Styling.md)

An extensive guide to Quarto's theming and styling capabilities, covering built-in themes, custom CSS integration, SCSS customization, Bootstrap integration, and responsive design. This technical reference includes practical examples of color schemes, typography, layout customization, dark mode support, and brand integration. Essential for creating professionally designed documentation websites that reflect your organization's visual identity and design standards.

### APPENDIX D: Configuring Your Learn Repository for Quarto

To publish your existing Learn repository with Quarto, you would:

1. **Create a main `_quarto.yml` configuration**:

```yaml
project:
  type: website
  output-dir: docs

website:
  title: "Dario's Learning Journey"
  description: "Technical learning notes and conference insights"
  
  navbar:
    left:
      - href: index.qmd
        text: Home
      - text: "Build 2025"
        menu:
          - href: "202506 Build 2025/index.qmd"
            text: "Overview"
          - href: "202506 Build 2025/BRK106/index.qmd"
            text: "BRK106: .NET Aspire"
          - href: "202506 Build 2025/BRK122/index.qmd"
            text: "BRK122: ASP.NET Core & Blazor"
      - text: "Azure Topics"
        menu:
          - href: "20250702 Azure Naming conventions/index.qmd"
            text: "Naming Conventions"
          - href: "20250704 TableStorageAccess options/index.qmd"
            text: "Table Storage Access"
          - href: "20250706 CosmosDB Access options/index.qmd"
            text: "CosmosDB Access"
      - text: "Development Tips"
        menu:
          - href: "20250709 Manage GitRepo from commandline/index.qmd"
            text: "Git Command Line"
          - href: "20250711 Use http files for easy and repeatable test/index.qmd"
            text: "HTTP Files Testing"
          - href: "20250712 Use QUARTO doc for Github repos doc/index.qmd"
            text: "Quarto Documentation"

format:
  html:
    theme: cosmo
    toc: true
    toc-depth: 3
```

1. **Create index pages for each major section** to provide navigation and context

1. **Rename existing README.md files** to index.qmd in each folder to maintain the same content structure

### Key Advantages of Alternative Structures

- **Preserve Existing Organization**: Keep your current folder structure and naming conventions
- **Gradual Migration**: Convert sections one at a time
- **Flexible Navigation**: Create custom navigation that makes sense for your content
- **Maintain Git History**: No need to move files, preserving commit history
- **SEO Friendly**: Each section gets its own landing page with proper metadata