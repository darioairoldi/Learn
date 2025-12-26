---
title: "Quarto-Specific Markdown Features"
description: "Complete guide to Quarto's extended markdown syntax and unique features beyond traditional Markdown"
author: "Dario Airoldi"
date: "2025-01-16"
date-modified: last-modified
categories: [quarto, markdown, syntax, features, interactive]
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
  - markdown
  - syntax
  - callouts
  - divs
  - cross-references
  - interactive
  - shortcodes
abstract: |
  A comprehensive guide to Quarto's extended markdown features that go beyond standard Markdown capabilities. This document covers div blocks, fenced divs, CSS classes, grid layouts, callout blocks, code execution, cross-references, figures, tables, mathematical expressions, interactive elements, and custom shortcodes. Essential for leveraging Quarto's full potential in creating rich, interactive documentation.
---

# Quarto-Specific Markdown Features

## 📋 Table of Contents

- [📖 Overview](#-overview)
- [🏗️ Div Blocks and Fenced Divs](#️-div-blocks-and-fenced-divs)
- [🎨 CSS Classes and Styling](#-css-classes-and-styling)
- [📐 Grid Layouts](#-grid-layouts)
- [💬 Callout Blocks](#-callout-blocks)
- [⚡ Code Execution](#-code-execution)
- [🔗 Cross-References](#-cross-references)
- [🖼️ Figures and Tables](#️-figures-and-tables)
- [🧮 Mathematical Expressions](#-mathematical-expressions)
- [🎯 Interactive Elements](#-interactive-elements)
- [🏷️ Custom Shortcodes](#️-custom-shortcodes)
- [✅ Best Practices](#-best-practices)

## 📖 Overview

Quarto extends standard Markdown with powerful features that enable rich, interactive content creation. This guide covers the unique Quarto markdown syntax that goes beyond traditional Markdown capabilities.

## 🏗️ Div Blocks and Fenced Divs

Quarto introduces fenced divs using `:::` syntax, which allows you to apply CSS classes and attributes to blocks of content.

### Basic Div Syntax

```markdown
::: {.class-name}
Content goes here
:::
```

### Nested Divs

```markdown
::::{.outer-container}

:::{.inner-section}
Nested content
:::

:::{.another-section}
More nested content
:::

::::
```

### Multiple Classes and Attributes

```markdown
::: {.warning .large-text #warning-section}
This is a warning with multiple classes and an ID
:::
```

## 🎨 CSS Classes and Styling

Quarto supports extensive CSS integration through class application and custom styling.

### Applying CSS Classes

```markdown
::: {.text-center}
This text will be centered
:::

::: {.bg-primary .text-white .p-3}
Bootstrap-style classes for background, text color, and padding
:::
```

### Custom CSS Integration

You can define custom CSS in your `_quarto.yml` or in separate CSS files:

```yaml
format:
  html:
    css: styles.css
    theme: cosmo
```

### Inline Styling

```markdown
[This text is highlighted]{.highlight}

[Red text]{style="color: red;"}
```

## 📐 Grid Layouts

Quarto provides powerful grid layout capabilities using Bootstrap's grid system.

### Basic Grid Structure

```markdown
::::{.grid}

:::{.g-col-12 .g-col-md-6}
### Left Column
Content for the left side
:::

:::{.g-col-12 .g-col-md-6}
### Right Column
Content for the right side
:::

::::
```

### Complex Grid Layouts

```markdown
::::{.grid}

:::{.g-col-12}
### Full Width Header
This spans the entire width
:::

:::{.g-col-12 .g-col-md-4}
### Column 1
First column content
:::

:::{.g-col-12 .g-col-md-4}
### Column 2
Second column content
:::

:::{.g-col-12 .g-col-md-4}
### Column 3
Third column content
:::

::::
```

### Responsive Breakpoints

```markdown
:::{.g-col-12 .g-col-sm-6 .g-col-md-4 .g-col-lg-3}
Responsive column that adapts to screen size:

- Mobile: Full width (12 columns)
- Small: Half width (6 columns)
- Medium: One-third width (4 columns)
- Large: One-quarter width (3 columns)
:::
```

## 💬 Callout Blocks

Quarto provides built-in callout blocks for highlighting important information.

### Standard Callout Types

```markdown
::: {.callout-note}
## Note
This is a note callout block.
:::

::: {.callout-warning}
## Warning
This is a warning callout block.
:::

::: {.callout-important}
## Important
This is an important callout block.
:::

::: {.callout-tip}
## Tip
This is a tip callout block.
:::

::: {.callout-caution}
## Caution
This is a caution callout block.
:::
```

### Customized Callouts

```markdown
::: {.callout-note icon=false}
## Custom Note
Note without an icon
:::

::: {.callout-warning collapse="true"}
## Collapsible Warning
This warning can be expanded/collapsed
:::
```

## ⚡ Code Execution

Quarto supports executable code blocks with various engines.

### Python Code Execution

````markdown
```python
import pandas as pd
import matplotlib.pyplot as plt

# Create sample data
data = {'x': [1, 2, 3, 4], 'y': [2, 4, 6, 8]}
df = pd.DataFrame(data)
print(df)
```
````

### R Code Execution

````markdown
```r
# R code block
library(ggplot2)
data <- data.frame(x = 1:10, y = (1:10)^2)
ggplot(data, aes(x, y)) + geom_line()
```
````

### Code Block Options

````markdown
```python
#| echo: false
#| eval: true
#| warning: false

# This code runs but doesn't show the code, only output
print("Hello, World!")
```
````

## 🔗 Cross-References

Quarto provides sophisticated cross-referencing capabilities.

### Section References

```markdown
## Introduction {#sec-intro}

As discussed in @sec-intro, we can reference sections.
```

### Figure References

```markdown
![Quarto Logo](logo.png){#fig-logo}

See @fig-logo for the Quarto logo.
```

### Table References

```markdown
| Column 1 | Column 2 |
|----------|----------|
| Data 1   | Data 2   |

: Sample Table {#tbl-sample}

Refer to @tbl-sample for the data.
```

## 🖼️ Figures and Tables

Enhanced figure and table capabilities with captions and styling.

### Enhanced Figures

```markdown
![Caption text](image.png){#fig-example fig-align="center" width="50%"}
```

### Figure Layouts

```markdown
::: {#fig-layout layout-ncol=2}

![Image 1](img1.png){#fig-img1}

![Image 2](img2.png){#fig-img2}

Two side-by-side images
:::
```

### Enhanced Tables

```markdown
| Feature | Standard Markdown | Quarto |
|---------|-------------------|--------|
| Styling | Limited | Extensive |
| Layout | Basic | Advanced |

: Comparison Table {#tbl-comparison .striped .hover}
```

## 🧮 Mathematical Expressions

Quarto supports LaTeX math rendering with various display options.

### Inline Math

```markdown
The equation $E = mc^2$ is Einstein's famous formula.
```

### Display Math

```markdown
$$
\int_{-\infty}^{\infty} e^{-x^2} dx = \sqrt{\pi}
$$
```

### Numbered Equations

```markdown
$$
f(x) = \sum_{n=0}^{\infty} \frac{f^{(n)}(a)}{n!}(x-a)^n
$$ {#eq-taylor}

Equation @eq-taylor shows the Taylor series.
```

## 🎯 Interactive Elements

Quarto supports various interactive content types.

### Tabsets

```markdown
::: {.panel-tabset}

## Tab 1
Content for tab 1

## Tab 2
Content for tab 2

## Tab 3
Content for tab 3

:::
```

### Accordions

```markdown
::: {.panel-tabset group="accordion"}

## Section 1
Accordion content 1

## Section 2
Accordion content 2

:::
```

## 🏷️ Custom Shortcodes

Quarto allows custom shortcodes for reusable content.

### Built-in Shortcodes

```markdown
{{< kbd Ctrl+C >}}

{{< video https://www.youtube.com/watch?v=dQw4w9WgXcQ >}}

{{< embed notebook.ipynb#fig-plot >}}
```

### Custom Shortcode Definition

Create `_extensions/shortcodes/highlight.lua`:

```lua
function highlight(args, kwargs, meta)
  local text = pandoc.utils.stringify(args[1])
  return pandoc.RawInline('html', '<mark>' .. text .. '</mark>')
end
```

Use in markdown:

```markdown
{{< highlight "This text will be highlighted" >}}
```

## ✅ Best Practices

### 1. Consistent Styling

- Use semantic class names
- Maintain consistent spacing with grid layouts
- Apply responsive design principles

### 2. Accessibility

- Always include alt text for images
- Use proper heading hierarchy
- Ensure sufficient color contrast

### 3. Performance

- Optimize images for web delivery
- Use lazy loading for heavy content
- Minimize custom CSS and JavaScript

### 4. Maintainability

- Document custom CSS classes
- Use variables for repeated styling
- Keep complex layouts modular

### 5. Cross-Platform Compatibility

- Test layouts on different screen sizes
- Ensure graceful degradation
- Use standard web technologies

## Example: Complete Layout

Here's a comprehensive example combining multiple Quarto features:

```markdown
---
title: "Project Dashboard"
format:
  html:
    css: custom.css
    grid:
      sidebar-width: 250px
---

::: {.callout-note}
## Project Status
Current project metrics and updates
:::

::::{.grid}

:::{.g-col-12 .g-col-md-8}

### Main Content

::: {.panel-tabset}

## Overview
Project overview content

## Metrics
Performance metrics

## Reports
Detailed reports

:::

:::

:::{.g-col-12 .g-col-md-4}

### Sidebar

::: {.card}
#### Quick Stats
- Metric 1: 95%
- Metric 2: 1,234
- Metric 3: Active
:::

:::

::::
```

## Resources

- [Quarto Markdown Guide](https://quarto.org/docs/authoring/markdown-basics.html)
- [Bootstrap Grid Documentation](https://getbootstrap.com/docs/5.1/layout/grid/)
- [CSS Reference](https://developer.mozilla.org/en-US/docs/Web/CSS)
- [Pandoc Manual](https://pandoc.org/MANUAL.html)

---

This guide covers the essential Quarto-specific markdown features that extend beyond standard Markdown. These features enable the creation of sophisticated, interactive, and beautifully styled documentation websites.

---

<!-- 
---
article_metadata:
  filename: "04-markdown-features.md"
  word_count: 3000
  created_date: "2025-01-16"
  last_updated: "2025-12-26T00:00:00Z"
  
cross_references:
  series:
    name: "Quarto Documentation Guide"
    part: 6
    total_parts: 14
    previous: "03-quarto-yml-structure.md"
    next: "05-theming-and-styling.md"
  related_articles:
    - "03-quarto-yml-structure.md"
    - "05-theming-and-styling.md"
    - "01-introduction-to-quarto.md"
  prerequisites:
    - "01-introduction-to-quarto.md"

validations:
  series_validation:
    last_run: "2025-12-26T00:00:00Z"
    model: "claude-sonnet-4.5"
    series_name: "Quarto Documentation Guide"
    article_position: 6
    total_articles: 14
    consistency_score: 9
    completeness_score: 10
    redundancy_score: 10
    issues_found: 0
    issues_critical: 0
    issues_medium: 0
    issues_low: 0
    notes: "Complete guide to Quarto-specific markdown extensions with working examples"
---
-->