---
title: "Analysis A2 — How MarkItDown works"
author: "Dario Airoldi"
date: "2026-07-13"
categories: [analysis, markitdown, architecture, converters, plugins]
description: "In-depth architecture: the converter model, CLI/Python surfaces, optional dependencies, plugin system, LLM and Azure integrations, and the security model."
---

# Analysis A2 — How MarkItDown works

> Deep-depth analysis for the Concepts track.

## 🎯 Problem statement

What is MarkItDown's internal model, and how do you drive it — from a one-line CLI call to LLM- and cloud-augmented conversion?

## 🏗️ Additional considerations

### Interfaces

- **CLI:** `markitdown path-to-file.pdf > document.md`, or `-o document.md`, or piped (`cat file.pdf | markitdown`).
- **Python API:**

  ```python
  from markitdown import MarkItDown
  md = MarkItDown(enable_plugins=False)
  result = md.convert("test.xlsx")
  print(result.text_content)   # also: result.markdown
  ```

- **Docker:** `docker build -t markitdown:latest .` then `docker run --rm -i markitdown:latest < file.pdf > out.md`.

### Converter-based architecture

MarkItDown dispatches each input to a **format-specific converter**. Format support is modular through **optional dependencies**, installed per-need:

`[all]`, `[pptx]`, `[docx]`, `[xlsx]`, `[xls]`, `[pdf]`, `[outlook]`, `[az-doc-intel]`, `[az-content-understanding]`, `[audio-transcription]`, `[youtube-transcription]`.

So `pip install 'markitdown[pdf, docx, pptx]'` pulls only those converters' dependencies.

### Plugin system

- Third-party **plugins are disabled by default**. List with `markitdown --list-plugins`; enable with `markitdown --use-plugins file.pdf`.
- Discover via the GitHub hashtag `#markitdown-plugin`; a `markitdown-sample-plugin` package documents authoring.
- Example first-party plugin: **`markitdown-ocr`**, which adds OCR to PDF/DOCX/PPTX/XLSX by extracting text from embedded images via **LLM Vision** (reusing the same `llm_client` / `llm_model` pattern; if no client is provided, OCR is silently skipped).

### LLM integration (image descriptions)

For PPTX and image files, pass an LLM client to generate descriptions:

```python
from markitdown import MarkItDown
from openai import OpenAI
md = MarkItDown(llm_client=OpenAI(), llm_model="gpt-4o", llm_prompt="optional custom prompt")
print(md.convert("example.jpg").text_content)
```

### Azure integrations (higher-fidelity paths)

- **Azure Document Intelligence:** CLI `-d -e "<endpoint>"`; Python `MarkItDown(docintel_endpoint=...)`.
- **Azure Content Understanding:** higher-quality, **structured field extraction** emitted as **YAML front matter**, multimodal (documents, images, audio, **video**), and configurable analyzers. Enabled via `--use-cu --cu-endpoint`, or Python `cu_endpoint` / `cu_analyzer_id` / `cu_file_types`. Each CU-routed `convert()` is a **billable Azure API call**.

The three fidelity tiers stack cleanly:

| Tier | Mechanism | Trade-off |
|---|---|---|
| Built-in converters | Local, format-specific, offline | Free; basic audio, no video |
| Azure Document Intelligence | Cloud layout/OCR extraction | Billable; better scanned-PDF/table fidelity |
| Azure Content Understanding | Cloud multimodal + field extraction | Billable; only option for video; structured fields |

### Security model

MarkItDown performs I/O **with the privileges of the current process** — like `open()` or `requests.get()`. Guidance: sanitize untrusted inputs, restrict paths/URI schemes/network destinations in hosted settings, and call the **narrowest** conversion method (`convert_local()`, `convert_stream()`, or `convert_response()`) rather than the permissive `convert()`, which accepts local files, remote URIs, and byte streams.

## 💡 Deductions

1. The **converter + optional-dependency** design keeps the base install light and lets you pay only for the formats you touch — a deliberate "lightweight" posture.
2. **LLM and Azure hooks are opt-in augmentations**, not the core path. The default is fast, local, deterministic extraction; quality escalations are explicit and (for Azure) billable.
3. The **permissive `convert()`** is a genuine SSRF/local-file-exposure surface in server contexts; the documented mitigation (narrow `convert_*`, input sanitization) must be treated as mandatory in hosted deployments.

## ✅ Conclusions

- MarkItDown is best understood as a **dispatcher over pluggable, format-specific converters**, with a light default core and opt-in LLM/cloud escalation for hard inputs (images, scanned PDFs, audio, video).
- Operate it as: pick converters via extras → drive via CLI or `convert_*` → escalate to LLM/Doc-Intel/Content-Understanding only where fidelity demands it.
- In any hosted/server use, treat input sanitization and the narrowest `convert_*` call as a security requirement, not an option.

## Appendix A — Evidence

| Claim | Source | Class |
|---|---|---|
| CLI, Python API, Docker usage | [github.com/microsoft/markitdown](https://github.com/microsoft/markitdown) | 📘 Official |
| Optional dependencies list | [github.com/microsoft/markitdown](https://github.com/microsoft/markitdown) | 📘 Official |
| Plugin model, `markitdown-ocr`, `--use-plugins` | [github.com/microsoft/markitdown](https://github.com/microsoft/markitdown) | 📘 Official |
| LLM image-description integration | [github.com/microsoft/markitdown](https://github.com/microsoft/markitdown) | 📘 Official |
| Azure Document Intelligence + Content Understanding | [github.com/microsoft/markitdown](https://github.com/microsoft/markitdown) | 📘 Official |
| Security considerations / `convert_*` surface | [github.com/microsoft/markitdown](https://github.com/microsoft/markitdown) | 📘 Official |

## Appendix B — Validation

- All architecture claims are drawn from a single authoritative source (the official README) and quoted at the mechanism level (flags, method names, extras) to avoid paraphrase drift.
- The fidelity-tier table is a synthesis of the README's own "When to use Content Understanding" comparison, not an external inference.
- Security posture is quoted verbatim in intent (process-privilege I/O; narrow `convert_*`), so it is safe to publish as guidance.
