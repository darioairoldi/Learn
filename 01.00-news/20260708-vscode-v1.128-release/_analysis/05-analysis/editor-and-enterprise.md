---
title: "Analysis — Editor & enterprise (VS Code 1.128)"
publish: false
---

# Analysis — Editor experience & enterprise

## Quick conclusions

- **Browser tab placement** (`workbench.browser.newTabPlacement`): `activeGroup`
  (default) / `sideGroup` (locked side group) / `window` (locked auxiliary window).
- **OS-level shortcuts**: `"systemWide": true` on a keybinding fires even when VS
  Code isn't focused.
- **OpenTelemetry telemetry export** (enterprise): org-managed OTLP endpoint,
  service name/attributes, exporter headers, and content-capture policy via the
  `telemetry` block in Copilot managed settings; managed value overrides env/user.

## Evidence

- VS Code 1.128 release notes → "Editor Experience" and "Enterprise" sections. 📘 Official.
