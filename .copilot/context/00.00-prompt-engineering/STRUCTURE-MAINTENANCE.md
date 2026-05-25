---
title: "Prompt engineering context maintenance guide"
description: "Procedures for updating context structure, category mappings, and dependency references safely"
version: "1.0.0"
last_updated: "2026-05-21"
domain: "prompt-engineering"
goal: "Define deterministic maintenance steps for context structure and mapping updates"
scope:
  covers:
    - "Add, rename, split, and retire procedures"
    - "Post-change verification checklist"
    - "Synchronization rules across structure artifacts"
  excludes:
    - "Detailed writing style rules"
    - "Domain-specific technical content updates"
boundaries:
  - "MUST update STRUCTURE-README.md and STRUCTURE-CATEGORIES.md together when mappings change"
  - "MUST run local-link checks after structural edits"
  - "MUST maintain metadata contract compliance for all changed files"
rationales:
  - "Deterministic procedures reduce structural drift"
  - "Synchronized updates prevent stale references across consumers"
---

# Prompt engineering context maintenance guide

## Add a new context file

1. Create the file with required metadata fields.
2. Add category mapping in [STRUCTURE-CATEGORIES.md](STRUCTURE-CATEGORIES.md).
3. Update [STRUCTURE-README.md](STRUCTURE-README.md) if tier or navigation changes.
4. Add dependency references in [05.01-artifact-dependency-map.md](05.01-artifact-dependency-map.md).

## Rename or move a context file

1. Update file path in [STRUCTURE-CATEGORIES.md](STRUCTURE-CATEGORIES.md).
2. Update references in [STRUCTURE-README.md](STRUCTURE-README.md).
3. Update dependency links in [05.01-artifact-dependency-map.md](05.01-artifact-dependency-map.md).
4. Run deterministic local-link validation.

## Split an oversized context file

1. Keep original filename as a stable index entry point.
2. Move heavy detail into one or more appendices.
3. Add appendix links in the index file.
4. Re-run token budget and broken-link checks.

## Retire a context file

1. Remove category mapping and dependency references.
2. Document replacement target in index and dependency map.
3. Keep deprecation note for grace period before removal.

## Verification checklist

- All changed files include required metadata fields.
- Local links resolve.
- Category IDs remain stable.
- Dependency index and structure index are synchronized.

