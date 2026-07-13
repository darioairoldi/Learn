# MarkItDown

A concise guide to **MarkItDown**, Microsoft's open-source Python tool for converting documents into LLM-friendly Markdown, and how it compares to similar tools.

## 📚 Series overview

**Target audience:** Developers building LLM, RAG, or text-analysis pipelines who need clean, structured text from heterogeneous documents (PDF, Office, HTML, images, audio, and more).

**Series scope:**

- ✅ **Covered:** what MarkItDown is, how it works (architecture, plugins, LLM and Azure integrations, security), and the landscape of similar tools
- ❌ **Not covered:** high-fidelity document conversion for human consumption (see [pandoc](https://pandoc.org/)) and exhaustive API reference (see the [official repository](https://github.com/microsoft/markitdown))

**Source:** [github.com/microsoft/markitdown](https://github.com/microsoft/markitdown) 📘 · **License:** MIT · **Last updated:** July 13, 2026

---

## 🗺️ Reading order

### 01 — Introduction and fundamentals

**1. [Introduction to MarkItDown](01.01-introduction-to-markitdown.md)**  
What MarkItDown is, who builds it, what it converts, and when to use (or not use) it.

**2. [How MarkItDown works](01.02-how-markitdown-works.md)**  
The converter architecture, CLI and Python interfaces, optional dependencies, the plugin system, LLM and Azure escalation paths, and the security model.

---

### 02 — Analysis

**3. [Similar tools and alternatives](02.01-similar-tools-and-alternatives.md)**  
An even-handed comparison with Docling, Marker, pandoc, and textract — chosen by fit, not hype.

---

## 🧭 Where this fits

MarkItDown is the **ingest** side of the Markdown ecosystem — it produces Markdown *from* documents. The sibling guides in this area cover the **publish** side (producing sites *from* Markdown): [Quarto](../01-quarto/readme.md), [MkDocs](../02-mkdocs/000.000-using-mkdocs.md), and [Hugo](../03-hugo/readme.md).
