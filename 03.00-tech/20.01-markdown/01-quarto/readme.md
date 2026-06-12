# Quarto Documentation Series

A comprehensive guide to using Quarto for technical documentation websites, covering architecture, customization, optimization, and deployment.

## 📚 Series Overview

**Target Audience:** Intermediate to advanced developers creating documentation sites with Quarto

**Series Scope:**
- ✅ **Covered:** Quarto website projects, architecture, configuration, theming, navigation, deployment
- ❌ **Not Covered:** Book projects, presentations, computational notebooks (see [Official Quarto Docs](https://quarto.org/docs/))

**Total Articles:** 13  
**Estimated Reading Time:** 8-10 hours  
**Last Updated:** December 26, 2025

---

## 🗺️ Reading Order

### 01 - Introduction & Fundamentals

**1. [Using Quarto](01.01-introduction-to-quarto.md)** (formerly 000.000)  
Introduction to Quarto, project structure, GitHub Pages deployment basics  
📊 ~4000 words | ⏱️ 20 min

**2. [How Quarto Works](01.02-how-quarto-works.md)** (formerly 001.001)  
Core architecture, site initialization, page loading, rendering mechanisms  
📊 ~5000 words | ⏱️ 25 min

---

### 02 - Architecture & Deployment Strategies

**3. [Monolithic vs. Modular Deployment](02.01-monolithic-vs-modular-deployment.md)** (formerly 001.002)  
Deployment architecture strategies, scaling considerations, when to use modular approaches  
📊 ~6000 words | ⏱️ 30 min

**4. [Split Navigation Build from Content Rendering](02.02-split-navigation-build.md)** (formerly 001.003)  
Step-by-step implementation of modular architecture with separated navigation shell  
📊 ~4500 words | ⏱️ 25 min

---

### 03 - Configuration

**5. [Quarto.yml Document Structure](03.01-quarto-yml-structure.md)** (formerly 001.010)  
Comprehensive reference for all `_quarto.yml` configuration options  
📊 ~3500 words | ⏱️ 20 min

---

### 04 - Content Creation

**6. [Quarto-Specific Markdown Features](04.01-markdown-features.md)** (formerly 003.010)  
Extended markdown syntax: div blocks, callouts, cross-references, interactive elements  
📊 ~3000 words | ⏱️ 15 min

---

### 05 - Styling & Theming

**7. [Quarto Theming and Styling](05.01-theming-and-styling.md)** (formerly 002.010)  
Built-in themes, custom CSS/SCSS, Bootstrap integration, typography, color schemes  
📊 ~4000 words | ⏱️ 20 min

---

### 06 - Navigation & Layout

**8. [How Sidebar Layout Works](06.01-sidebar-layout.md)** (formerly 009.000)  
Three-panel layout architecture, sidebar configuration, related pages implementation  
📊 ~2000 words | ⏱️ 10 min

**9. [Navigation Workflow](06.02-navigation-workflow.md)** (formerly 009.010)  
Automated navigation.json generation, navbar/sidebar config, workflows  
📊 ~3000 words | ⏱️ 15 min

**10. [Sidebar Page Transition Optimization](06.03-transition-optimization.md)** (formerly 009.020)  
Performance optimization for sidebar state restoration during page transitions  
📊 ~500 words | ⏱️ 5 min

---

### 07 - Optimization & Performance

**11. [Optimizing Quarto Build and Deploy](07.01-build-optimization.md)** (formerly 007.010)  
Build performance improvements, caching strategies, GitHub Actions optimization  
📊 ~3500 words | ⏱️ 20 min

---

### 08 - Troubleshooting

**12. [Troubleshooting Quarto Sites](08.01-troubleshooting-guide.md)** ⭐ NEW  
Common errors, debugging techniques, build/navigation/deployment issues  
📊 ~2500 words | ⏱️ 15 min

---

### 09 - Deployment

**13. [Deploying to GitHub Pages](09.01-github-pages-deployment.md)** (formerly 010.001)  
Complete GitHub Pages deployment guide with automated workflows  
📊 ~3000 words | ⏱️ 15 min

**14. [Deploying to Azure Storage](09.02-azure-storage-deployment.md)** (formerly 010.002)  
Azure Storage Account static websites, CDN integration, custom domains  
📊 ~4000 words | ⏱️ 20 min

---

## 🎯 Quick Start Paths

### New to Quarto?
**Start here:** Articles 1 → 2 → 5 → 6 → 13  
*Learn fundamentals, configuration, content creation, and basic deployment*

### Building a Large Documentation Site?
**Focus on:** Articles 2 → 3 → 4 → 11  
*Understand architecture, scaling strategies, and performance optimization*

### Customizing Look and Feel?
**Focus on:** Articles 5 → 7 → 8 → 9  
*Configuration, theming, layout, and navigation customization*

### Deployment and Production?
**Focus on:** Articles 11 → 12 → 13 or 14  
*Optimization, troubleshooting, and deployment to your chosen platform*

---

## 📋 Prerequisites

Before starting this series, you should have:

- ✅ Basic understanding of Markdown syntax
- ✅ Familiarity with command-line interfaces
- ✅ Git and GitHub account (for deployment sections)
- ✅ Text editor or IDE (VS Code recommended)
- ✅ Quarto installed ([installation guide](https://quarto.org/docs/get-started/))

**Optional but helpful:**
- YAML configuration basics
- HTML/CSS fundamentals
- GitHub Actions (for automated deployment)
- Azure subscription (for Azure deployment section)

---

## 🔧 Series Scope & Limitations

### What This Series Covers

**Quarto Website Projects:**
- Static site generation for documentation
- Configuration and customization
- Navigation and layout systems
- Deployment to various platforms
- Performance optimization
- Troubleshooting common issues

### What This Series Does NOT Cover

**Other Quarto Project Types:**
- 📕 **Book Projects** → See [Quarto Books Documentation](https://quarto.org/docs/books/)
- 🎤 **Presentations** → See [Reveal.js Presentations](https://quarto.org/docs/presentations/)
- 📊 **Dashboards** → See [Quarto Dashboards](https://quarto.org/docs/dashboards/)

**Computational Content:**
- 🐍 **Executable Python/R notebooks** → See [Computations Guide](https://quarto.org/docs/computations/)
- 📓 **Jupyter integration** → See [Jupyter Notebooks](https://quarto.org/docs/tools/jupyter-lab.html)

**Output Formats:**
- 📄 **PDF generation** → See [PDF Output](https://quarto.org/docs/output-formats/pdf-basics.html)
- 📝 **Word/Office formats** → See [MS Word Output](https://quarto.org/docs/output-formats/ms-word.html)

---

## 🆚 When to Choose Quarto

### Quarto is Ideal For:

- ✅ Technical documentation with code examples
- ✅ Scientific and research publications
- ✅ Multi-format output needs (HTML + PDF + Word)
- ✅ Documentation with executable code
- ✅ Projects requiring reproducibility

### Consider Alternatives If:

| Alternative | Best For | When to Choose |
|------------|----------|----------------|
| **MkDocs** | Python project docs | Simple docs, Material theme, fast setup |
| **Docusaurus** | Product documentation | Versioning, i18n, React ecosystem |
| **Hugo** | High-performance sites | 1000+ pages, blazing fast builds |
| **VitePress** | Vue.js ecosystem | Vue projects, modern developer experience |
| **Jekyll** | GitHub Pages native | Ruby ecosystem, simple blogs |

**Decision Guide:**
- Need computational notebooks? → **Quarto**
- Pure static content, 1000+ pages? → **Hugo**
- React-based components? → **Docusaurus**
- Python library docs? → **MkDocs**
- Vue.js projects? → **VitePress**

---

## 🔄 Series Maintenance

**Review Schedule:**
- Quarterly review for Quarto version updates
- Check for broken links and deprecated features
- Update examples and screenshots as needed

**Current Quarto Version Targeted:** 1.4+ (as of January 2025)

**Contribution:**
- Found an error? Open an issue
- Have a suggestion? Submit a pull request
- Questions? Check the [Quarto Community](https://github.com/quarto-dev/quarto-cli/discussions)

---

## 📖 Additional Resources

### Official Documentation
- [Quarto Official Website](https://quarto.org/)
- [Quarto Guide](https://quarto.org/docs/guide/)
- [Quarto GitHub Repository](https://github.com/quarto-dev/quarto-cli)

### Community
- [Quarto Discussions](https://github.com/quarto-dev/quarto-cli/discussions)
- [Quarto on Bluesky](https://bsky.app/profile/quarto.org)
- [RStudio Community - Quarto](https://community.rstudio.com/c/quarto/57)

### Related Series in This Repository
- [MkDocs Documentation Guide](../02-mkdocs/000.000-using-mkdocs.md) - Alternative static site generator
- [Hugo Documentation Guide](../03-hugo/readme.md) - Fast Go-based static site generator
- [Prompt Engineering](../../05.02-prompt-engineering/02-getting-started/02.00-how-to-name-and-organize-prompt-files.md) - Guide to prompt engineering
- [Azure Documentation](../../02.01-azure/00-azure-naming-conventions/readme.md) - Azure technical documentation

---

## 📊 Series Metadata

```yaml
series_info:
  name: "Quarto Documentation Guide"
  version: "1.0"
  total_articles: 14
  created_date: "2025-01-15"
  last_updated: "2025-12-26"
  target_audience: "intermediate-advanced"
  estimated_completion_time: "8-10 hours"
  
topics_covered:
  - quarto-architecture
  - static-site-generation
  - documentation-websites
  - deployment-strategies
  - performance-optimization
  - navigation-systems
  - theming-styling
  
prerequisites:
  required:
    - markdown-basics
    - command-line-basics
    - git-basics
  optional:
    - yaml-configuration
    - html-css-basics
    - github-actions
```

---

**Last Review:** December 26, 2025  
**Reviewed By:** Dario Airoldi  
**Review Model:** Claude Sonnet 4.5  
**Series Status:** ✅ Active and Maintained
