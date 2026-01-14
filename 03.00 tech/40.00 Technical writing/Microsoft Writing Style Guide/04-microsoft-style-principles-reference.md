---
title: "Microsoft Style Principles: Quick Reference for Writers and Agents"
author: "Dario Airoldi"
date: "2026-01-14"
categories: [technical-writing, microsoft, reference, agents, prompts, yaml, automation]
description: "Consolidated, machine-readable rules extracted from the Microsoft Writing Style Guide for use in writing prompts, AI agents, and automated validation"
---

# Microsoft Style Principles: Quick Reference for Writers and Agents

> Extractable rules in YAML/JSON format for prompt engineering, AI validation, and automated style checking

## Table of Contents

- [Introduction](#introduction)
- [How to Use This Reference](#how-to-use-this-reference)
- [Voice and Tone Rules](#voice-and-tone-rules)
- [Capitalization Rules](#capitalization-rules)
- [Punctuation Rules](#punctuation-rules)
- [Word Choice Rules](#word-choice-rules)
- [Numbers and Dates Rules](#numbers-and-dates-rules)
- [UI Terminology Rules](#ui-terminology-rules)
- [Accessibility Rules](#accessibility-rules)
- [Bias-Free Communication Rules](#bias-free-communication-rules)
- [Global-Ready Writing Rules](#global-ready-writing-rules)
- [Procedure and Instruction Rules](#procedure-and-instruction-rules)
- [Complete YAML Specification](#complete-yaml-specification)
- [Complete JSON Specification](#complete-json-specification)
- [Prompt Templates](#prompt-templates)
- [Series Navigation](#series-navigation)
- [References](#references)

## Introduction

This reference consolidates **actionable rules** from the Microsoft Writing Style Guide into formats suitable for:

- **<mark>Prompt engineering</mark>** — Include in system prompts for AI writing assistants
- **<mark>AI agents</mark>** — Validation rules for documentation review
- **<mark>Automated linting</mark>** — Patterns for custom style checkers
- **<mark>Human checklists</mark>** — Quick reference during writing and editing

Each rule includes:
- **<mark>Rule ID</mark>** — Unique identifier for reference
- **<mark>Category</mark>** — Grouping for organization
- **<mark>Description</mark>** — What the rule requires
- **<mark>Examples</mark>** — Correct and incorrect usage
- **<mark>Severity</mark>** — Error, warning, or suggestion

**Prerequisites:** Understanding of the principles explained in [Articles 00–03](00-microsoft-style-guide-overview.md) provides context for these rules.

## How to Use This Reference

### For Prompt Engineering

Include the YAML or JSON specification in your system prompt:

```
You are a technical writer following Microsoft style. Apply these rules:

[Insert relevant YAML rules here]
```

### For AI Validation Agents

Use rules as validation criteria:

```python
# Pseudocode
for rule in microsoft_rules:
    if not document.complies_with(rule):
        report_violation(rule.id, rule.description)
```

### For Human Writers

Use as a checklist during editing:
- [ ] Contractions used consistently
- [ ] Sentence-style capitalization in headings
- [ ] Oxford comma in all lists
- [ ] Input-neutral UI verbs

## Voice and Tone Rules

```yaml
voice_rules:
  - id: VOICE-001
    category: contractions
    severity: error
    description: "Use contractions consistently"
    rationale: "Contractions create warmth and conversational tone"
    correct:
      - "You'll need to restart the service."
      - "It's important to save your work."
      - "We're working on a fix."
    incorrect:
      - "You will need to restart the service."
      - "It is important to save your work."
      - "We are working on a fix."
    
  - id: VOICE-002
    category: person
    severity: error
    description: "Use second person (you/your) for instructions"
    rationale: "Direct address creates engagement and clarity"
    correct:
      - "Save your file before closing."
      - "You can customize your dashboard."
    incorrect:
      - "Users should save their files before closing."
      - "One can customize the dashboard."
    
  - id: VOICE-003
    category: person
    severity: warning
    description: "Avoid 'we' except for company voice"
    rationale: "Focus on customer, not Microsoft"
    correct:
      - "Configure authentication before deployment."
      - "We're committed to your privacy." # OK for company statements
    incorrect:
      - "We recommend configuring authentication."
      - "We've designed this feature to..."
    
  - id: VOICE-004
    category: person
    severity: error
    description: "Use 'I/my' only in UI elements representing user choice"
    rationale: "First person reserved for user-owned actions"
    correct:
      - "☑ I agree to the terms"
      - "Remember my preferences"
    incorrect:
      - "I recommend saving frequently." # In documentation
    
  - id: VOICE-005
    category: brevity
    severity: warning
    description: "Start statements with verbs, not 'you can'"
    rationale: "Direct instructions are more efficient"
    correct:
      - "Save your work frequently."
      - "Configure the settings before deployment."
    incorrect:
      - "You can save your work frequently."
      - "You can configure the settings before deployment."
    
  - id: VOICE-006
    category: brevity
    severity: warning
    description: "Eliminate 'there is/are/were' constructions"
    rationale: "These constructions are wordy and passive"
    correct:
      - "Three options are available."
      - "Several factors affect performance."
    incorrect:
      - "There are three options available."
      - "There are several factors that affect performance."
```

## Capitalization Rules

```yaml
capitalization_rules:
  - id: CAP-001
    category: headings
    severity: error
    description: "Use sentence-style capitalization for all headings"
    rationale: "Microsoft mandates sentence case exclusively"
    correct:
      - "Getting started with Azure"
      - "How to configure your settings"
    incorrect:
      - "Getting Started With Azure"
      - "How To Configure Your Settings"
    pattern: "^[A-Z][^A-Z]*$"  # Only first letter capitalized (plus proper nouns)
    
  - id: CAP-002
    category: headings
    severity: error
    description: "Never use title case (capitalize each major word)"
    rationale: "Title case is explicitly prohibited"
    antipattern: "\\b[A-Z][a-z]+\\s+[A-Z][a-z]+"
    note: "Exception: proper nouns and product names"
    
  - id: CAP-003
    category: product_names
    severity: error
    description: "Follow Microsoft trademark list for product names"
    rationale: "Legal and brand consistency requirements"
    correct:
      - "Microsoft Azure"
      - "Visual Studio Code"
      - "Power BI"
    incorrect:
      - "Microsoft azure"
      - "visual studio code"
      - "PowerBI"
    
  - id: CAP-004
    category: acronyms
    severity: warning
    description: "Don't capitalize spelled-out acronyms unless proper nouns"
    rationale: "Only proper nouns get capital letters"
    correct:
      - "application programming interface (API)"
      - "uniform resource locator (URL)"
    incorrect:
      - "Application Programming Interface (API)"
      - "Uniform Resource Locator (URL)"
    
  - id: CAP-005
    category: ui_elements
    severity: warning
    description: "Match UI element capitalization to the product"
    rationale: "Accuracy in describing what users see"
    note: "Document UI text as it appears in the product"
```

## Punctuation Rules

```yaml
punctuation_rules:
  - id: PUNCT-001
    category: serial_comma
    severity: error
    description: "Always use the Oxford/serial comma"
    rationale: "Prevents ambiguity in lists"
    correct:
      - "red, white, and blue"
      - "save, close, and exit"
    incorrect:
      - "red, white and blue"
      - "save, close and exit"
    pattern: "\\b\\w+,\\s+\\w+\\s+and\\b"  # Missing Oxford comma
    
  - id: PUNCT-002
    category: headings
    severity: error
    description: "No periods on headings, titles, or subheadings"
    rationale: "Clean visual presentation"
    correct:
      - "Getting started"
      - "Configuration options"
    incorrect:
      - "Getting started."
      - "Configuration options."
    
  - id: PUNCT-003
    category: lists
    severity: warning
    description: "No periods on list items of three words or fewer"
    rationale: "Reduces visual clutter for short items"
    correct:
      - "- Save file"
      - "- Close app"
    incorrect:
      - "- Save file."
      - "- Close app."
    note: "Full sentences in lists should have periods"
    
  - id: PUNCT-004
    category: spacing
    severity: error
    description: "One space after periods, not two"
    rationale: "Modern typography standard"
    antipattern: "\\. {2,}"
    
  - id: PUNCT-005
    category: dashes
    severity: warning
    description: "No spaces around em dashes"
    rationale: "Microsoft style for em dashes"
    correct:
      - "The feature—available now—works great."
    incorrect:
      - "The feature — available now — works great."
      - "The feature-- available now --works great."
    
  - id: PUNCT-006
    category: dashes
    severity: warning
    description: "Use en dash for ranges"
    rationale: "Proper typographic convention"
    correct:
      - "pages 10–15"
      - "2020–2024"
    incorrect:
      - "pages 10-15"  # Hyphen instead of en dash
      - "2020-2024"
    
  - id: PUNCT-007
    category: colons
    severity: info
    description: "Capitalize after colon only if complete sentence follows"
    correct:
      - "Remember one thing: Always save your work."
      - "You need: a keyboard, mouse, and monitor."
    incorrect:
      - "Remember one thing: always save your work."  # Should capitalize
      - "You need: A keyboard, mouse, and monitor."  # Shouldn't capitalize
```

## Word Choice Rules

```yaml
word_choice_rules:
  - id: WORD-001
    category: simplicity
    severity: warning
    description: "Use simple words over complex alternatives"
    replacements:
      - from: "utilize"
        to: "use"
      - from: "in order to"
        to: "to"
      - from: "at this point in time"
        to: "now"
      - from: "due to the fact that"
        to: "because"
      - from: "in the event that"
        to: "if"
      - from: "for the purpose of"
        to: "to"
      - from: "prior to"
        to: "before"
      - from: "subsequent to"
        to: "after"
      - from: "in order to"
        to: "to"
      - from: "make a decision"
        to: "decide"
      - from: "give consideration to"
        to: "consider"
    
  - id: WORD-002
    category: jargon
    severity: warning
    description: "Avoid jargon without context"
    rationale: "Technical terms need explanation for broader audiences"
    guidance: "Define technical terms on first use or link to glossary"
    
  - id: WORD-003
    category: consistency
    severity: warning
    description: "One term per concept"
    rationale: "Synonyms confuse readers about whether concepts differ"
    correct:
      - "Use 'select' consistently (not alternating with 'choose' or 'click')"
    
  - id: WORD-004
    category: spelling
    severity: warning
    description: "Use US English spelling"
    rationale: "Microsoft standard for base English content"
    correct:
      - "color"
      - "customize"
      - "center"
    incorrect:
      - "colour"
      - "customise"
      - "centre"
```

## Numbers and Dates Rules

```yaml
number_rules:
  - id: NUM-001
    category: spelling
    severity: warning
    description: "Spell out zero through nine; use numerals for 10+"
    correct:
      - "three options"
      - "15 users"
    incorrect:
      - "3 options"
      - "fifteen users"
    exception: "Always use numerals for measurements, percentages, versions"
    
  - id: NUM-002
    category: measurements
    severity: warning
    description: "Always use numerals for measurements"
    correct:
      - "5 GB"
      - "2 seconds"
      - "3 pixels"
    incorrect:
      - "five GB"
      - "two seconds"
    
  - id: NUM-003
    category: sentence_start
    severity: error
    description: "Never start a sentence with a numeral"
    correct:
      - "Fifteen users reported the issue."
      - "The issue was reported by 15 users."
    incorrect:
      - "15 users reported the issue."
    
  - id: NUM-004
    category: formatting
    severity: warning
    description: "Use commas in numbers with 4+ digits"
    correct:
      - "1,000"
      - "10,000"
      - "1,000,000"
    incorrect:
      - "1000"
      - "10000"
    exception: "Years, page numbers, addresses, and serial numbers"
    
  - id: DATE-001
    category: format
    severity: warning
    description: "Use 'Month day, year' format"
    correct:
      - "January 5, 2026"
    incorrect:
      - "1/5/2026"
      - "5 January 2026"
      - "2026-01-05"
    rationale: "Avoids international date format confusion"
    
  - id: DATE-002
    category: global
    severity: error
    description: "Spell out month names in dates"
    rationale: "Numeric dates are ambiguous internationally"
    correct:
      - "January 5, 2026"
      - "March 15"
    incorrect:
      - "1/5/2026"
      - "3/15"
```

## UI Terminology Rules

```yaml
ui_rules:
  - id: UI-001
    category: verbs
    severity: warning
    description: "Use input-neutral verbs"
    rationale: "Works for mouse, keyboard, touch, voice, and assistive tech"
    replacements:
      - from: "click"
        to: "select"
      - from: "tap"
        to: "select"
      - from: "press (for UI)"
        to: "select"
      - from: "hit"
        to: "select"
      - from: "right-click"
        to: "open the context menu"
      - from: "double-click"
        to: "open" or describe the action
    
  - id: UI-002
    category: verbs
    severity: info
    description: "Standard UI verb usage"
    verbs:
      - verb: "select"
        use_for: "buttons, links, menu items, checkboxes"
      - verb: "open"
        use_for: "apps, files, folders, dialogs"
      - verb: "close"
        use_for: "apps, files, dialogs, windows"
      - verb: "go to"
        use_for: "menus, tabs, pages, settings"
      - verb: "enter"
        use_for: "typing text into fields"
      - verb: "choose"
        use_for: "selecting from options"
      - verb: "turn on/off"
        use_for: "toggles, switches"
      - verb: "clear"
        use_for: "unchecking checkboxes"
    
  - id: UI-003
    category: formatting
    severity: warning
    description: "Bold UI element names in documentation"
    correct:
      - "Select **Save**."
      - "Go to **Settings** > **Privacy**."
    incorrect:
      - "Select Save."
      - "Go to Settings > Privacy."
    
  - id: UI-004
    category: navigation
    severity: info
    description: "Use > for sequential UI paths"
    correct:
      - "**Settings** > **Privacy** > **Location**"
      - "**File** > **Save As**"
    note: "Use spaces around the >"
    
  - id: UI-005
    category: keyboard
    severity: warning
    description: "Format keyboard shortcuts consistently"
    correct:
      - "Ctrl+S"
      - "Alt+Tab"
      - "Ctrl+Alt+Delete"
    incorrect:
      - "Ctrl + S"
      - "CTRL+S"
      - "ctrl-s"
    rules:
      - "Capitalize key names"
      - "Use + without spaces"
      - "Bold in documentation: **Ctrl+S**"
```

## Accessibility Rules

```yaml
accessibility_rules:
  - id: A11Y-001
    category: language
    severity: warning
    description: "Use people-first language"
    correct:
      - "people with disabilities"
      - "users who are blind"
      - "customers who use screen readers"
    incorrect:
      - "disabled people"
      - "blind users"
      - "the blind"
    
  - id: A11Y-002
    category: symbols
    severity: warning
    description: "Spell out special characters for screen readers"
    replacements:
      - from: "+"
        to: "plus"
        context: "In prose, not code"
      - from: "&"
        to: "and"
        context: "In prose"
      - from: "~"
        to: "approximately"
        context: "In prose"
      - from: "%"
        to: "percent"
        context: "In prose (50 percent)"
    
  - id: A11Y-003
    category: navigation
    severity: error
    description: "Don't rely on directional terms alone"
    incorrect:
      - "See the options above."
      - "Click the button on the left."
      - "The settings below control..."
    correct:
      - "See [Authentication options](#authentication-options)."
      - "Select **Delete**."
      - "The privacy settings control..."
    
  - id: A11Y-004
    category: links
    severity: error
    description: "Use descriptive link text"
    incorrect:
      - "Click [here](url) to learn more."
      - "For more information, see [this page](url)."
    correct:
      - "Learn more about [configuring authentication](url)."
      - "For more information, see [Authentication overview](url)."
    
  - id: A11Y-005
    category: headings
    severity: error
    description: "Use semantic heading hierarchy"
    rationale: "Screen readers navigate by heading levels"
    rules:
      - "Don't skip heading levels (H1 → H3)"
      - "Use headings for structure, not formatting"
      - "Don't use bold as a heading substitute"
    
  - id: A11Y-006
    category: color
    severity: error
    description: "Don't rely on color alone to convey information"
    incorrect:
      - "Required fields are marked in red."
    correct:
      - "Required fields are marked with an asterisk (*)."
```

## Bias-Free Communication Rules

```yaml
bias_free_rules:
  - id: BIAS-001
    category: gender
    severity: warning
    description: "Use gender-neutral language"
    replacements:
      - from: "mankind"
        to: "humanity, people, humankind"
      - from: "manpower"
        to: "workforce, staff, personnel"
      - from: "chairman"
        to: "chair, chairperson"
      - from: "fireman"
        to: "firefighter"
      - from: "stewardess"
        to: "flight attendant"
      - from: "man-hours"
        to: "person-hours, staff hours"
    
  - id: BIAS-002
    category: pronouns
    severity: warning
    description: "Avoid gendered pronouns for generic references"
    strategies:
      - "Rewrite to use 'you': 'When you log in, you see your dashboard.'"
      - "Use plural: 'When users log in, they see their dashboards.'"
      - "Use singular they: 'When a user logs in, they see their dashboard.'"
    incorrect:
      - "When the user logs in, he sees his dashboard."
    
  - id: BIAS-003
    category: pronouns
    severity: info
    description: "Singular 'they' is acceptable"
    rationale: "Microsoft explicitly endorses singular they"
    correct:
      - "When a user logs in, they see their dashboard."
      - "If someone has a question, they should contact support."
    
  - id: BIAS-004
    category: terminology
    severity: error
    description: "Replace problematic technical terms"
    replacements:
      - from: "master/slave"
        to: "primary/replica, main/subordinate"
      - from: "whitelist/blacklist"
        to: "allowlist/blocklist"
      - from: "dummy"
        to: "placeholder, sample, test"
      - from: "sanity check"
        to: "quick check, validation"
      - from: "crazy, insane"
        to: "surprising, unexpected"
    
  - id: BIAS-005
    category: disability
    severity: warning
    description: "Don't mention disability unless relevant"
    rationale: "Focus on capability, not limitation"
    incorrect:
      - "A blind engineer developed this feature."
    correct:
      - "The engineer developed this feature with screen reader testing."
    note: "Mention disability when it's directly relevant to the content"
```

## Global-Ready Writing Rules

```yaml
global_rules:
  - id: GLOBAL-001
    category: grammar
    severity: warning
    description: "Include articles (a, an, the)"
    rationale: "Helps machine translation and non-native speakers"
    correct:
      - "Select the button to continue."
      - "Enter a value in the field."
    incorrect:
      - "Select button to continue."
      - "Enter value in field."
    
  - id: GLOBAL-002
    category: grammar
    severity: warning
    description: "Include relative pronouns (that, who)"
    rationale: "Explicit clause markers aid comprehension"
    correct:
      - "The file that you downloaded is ready."
      - "Users who have admin access can change settings."
    incorrect:
      - "The file you downloaded is ready."
      - "Users with admin access can change settings."
    
  - id: GLOBAL-003
    category: idioms
    severity: warning
    description: "Avoid idioms and colloquialisms"
    problematic:
      - "hit the ground running"
      - "out of the box"
      - "low-hanging fruit"
      - "ballpark figure"
      - "at the end of the day"
    alternatives:
      - "start quickly"
      - "by default"
      - "easy improvements"
      - "rough estimate"
      - "ultimately"
    
  - id: GLOBAL-004
    category: culture
    severity: warning
    description: "Avoid culture-specific references"
    avoid:
      - "Season names (summer, winter) - use months or quarters"
      - "Holiday references (Christmas, Thanksgiving)"
      - "Sports metaphors (home run, touchdown)"
      - "Regional humor or references"
    
  - id: GLOBAL-005
    category: word_order
    severity: info
    description: "Use standard subject-verb-object word order"
    rationale: "SVO order translates more reliably"
    correct:
      - "The system processes your request."
    less_clear:
      - "Your request the system processes."
```

## Procedure and Instruction Rules

```yaml
procedure_rules:
  - id: PROC-001
    category: structure
    severity: warning
    description: "Limit procedures to seven steps maximum"
    rationale: "Long procedures overwhelm users"
    guidance: "Break longer procedures into sub-procedures"
    
  - id: PROC-002
    category: structure
    severity: info
    description: "Don't number single-step procedures"
    correct:
      - "To save your work, select **Save**."
    incorrect:
      - "1. To save your work, select **Save**."
    
  - id: PROC-003
    category: context
    severity: warning
    description: "State location before action"
    correct:
      - "In the **Settings** dialog, select **Privacy**."
      - "At the top of the page, select **Delete**."
    incorrect:
      - "Select **Privacy** in the Settings dialog."
      - "Select **Delete** at the top of the page."
    
  - id: PROC-004
    category: actions
    severity: info
    description: "One action per step"
    correct:
      - |
        1. Select **Settings**.
        2. Select **Privacy**.
        3. Turn on **Location services**.
    incorrect:
      - |
        1. Select **Settings**, then select **Privacy**, and turn on **Location services**.
    
  - id: PROC-005
    category: results
    severity: info
    description: "Tell users what happens after actions"
    correct:
      - "Select **Save**. A confirmation message appears."
    less_clear:
      - "Select **Save**."
```

## Complete YAML Specification

The complete YAML specification combining all rules:

```yaml
# Microsoft Writing Style Guide - Rule Specification
# Version: 1.0
# Based on: https://learn.microsoft.com/en-us/style-guide/
# For use in: AI prompts, validation agents, style checkers

metadata:
  name: "Microsoft Writing Style Rules"
  version: "1.0"
  source: "Microsoft Writing Style Guide"
  url: "https://learn.microsoft.com/en-us/style-guide/welcome/"
  last_updated: "2026-01-14"

severity_levels:
  error: "Must fix - violates core Microsoft style"
  warning: "Should fix - improves quality"
  info: "Consider - enhancement"

rules:
  voice:
    - { id: "VOICE-001", severity: "error", rule: "Use contractions (it's, you'll, don't)" }
    - { id: "VOICE-002", severity: "error", rule: "Use second person (you/your) for instructions" }
    - { id: "VOICE-003", severity: "warning", rule: "Avoid 'we' except for company statements" }
    - { id: "VOICE-004", severity: "error", rule: "Use 'I/my' only in UI checkboxes/toggles" }
    - { id: "VOICE-005", severity: "warning", rule: "Start with verbs, not 'you can'" }
    - { id: "VOICE-006", severity: "warning", rule: "Eliminate 'there is/are/were'" }
  
  capitalization:
    - { id: "CAP-001", severity: "error", rule: "Sentence-style capitalization for all headings" }
    - { id: "CAP-002", severity: "error", rule: "Never use title case for headings" }
    - { id: "CAP-003", severity: "error", rule: "Follow trademark list for product names" }
    - { id: "CAP-004", severity: "warning", rule: "Don't capitalize spelled-out acronyms unless proper nouns" }
  
  punctuation:
    - { id: "PUNCT-001", severity: "error", rule: "Always use Oxford comma (A, B, and C)" }
    - { id: "PUNCT-002", severity: "error", rule: "No periods on headings" }
    - { id: "PUNCT-003", severity: "warning", rule: "No periods on short list items (≤3 words)" }
    - { id: "PUNCT-004", severity: "error", rule: "One space after periods" }
    - { id: "PUNCT-005", severity: "warning", rule: "No spaces around em dashes (word—word)" }
    - { id: "PUNCT-006", severity: "warning", rule: "Use en dash for ranges (10–15)" }
  
  word_choice:
    - { id: "WORD-001", severity: "warning", rule: "Replace 'utilize' with 'use'" }
    - { id: "WORD-002", severity: "warning", rule: "Replace 'in order to' with 'to'" }
    - { id: "WORD-003", severity: "warning", rule: "One term = one concept (no synonyms)" }
    - { id: "WORD-004", severity: "warning", rule: "Use US English spelling" }
  
  numbers:
    - { id: "NUM-001", severity: "warning", rule: "Spell out 0-9; numerals for 10+" }
    - { id: "NUM-002", severity: "warning", rule: "Always numerals for measurements" }
    - { id: "NUM-003", severity: "error", rule: "Never start sentence with numeral" }
    - { id: "NUM-004", severity: "warning", rule: "Commas in numbers ≥1,000" }
    - { id: "DATE-001", severity: "warning", rule: "Date format: Month day, year (January 5, 2026)" }
  
  ui:
    - { id: "UI-001", severity: "warning", rule: "Use 'select' not 'click' or 'tap'" }
    - { id: "UI-002", severity: "warning", rule: "Use 'open' for apps/files, 'go to' for menus" }
    - { id: "UI-003", severity: "warning", rule: "Bold UI element names" }
    - { id: "UI-004", severity: "info", rule: "Use > for UI paths (Settings > Privacy)" }
    - { id: "UI-005", severity: "warning", rule: "Keyboard shortcuts: Ctrl+S (no spaces, capitalized)" }
  
  accessibility:
    - { id: "A11Y-001", severity: "warning", rule: "People-first language (people with disabilities)" }
    - { id: "A11Y-002", severity: "warning", rule: "Spell out + as 'plus', & as 'and'" }
    - { id: "A11Y-003", severity: "error", rule: "Don't rely on directional terms alone" }
    - { id: "A11Y-004", severity: "error", rule: "Descriptive link text (not 'click here')" }
    - { id: "A11Y-005", severity: "error", rule: "Semantic heading hierarchy (no skipping levels)" }
  
  bias_free:
    - { id: "BIAS-001", severity: "warning", rule: "Gender-neutral language (workforce not manpower)" }
    - { id: "BIAS-002", severity: "warning", rule: "Singular 'they' is acceptable" }
    - { id: "BIAS-003", severity: "error", rule: "Replace master/slave with primary/replica" }
    - { id: "BIAS-004", severity: "error", rule: "Replace whitelist/blacklist with allowlist/blocklist" }
  
  global:
    - { id: "GLOBAL-001", severity: "warning", rule: "Include articles (a, an, the)" }
    - { id: "GLOBAL-002", severity: "warning", rule: "Include 'that' and 'who' clause markers" }
    - { id: "GLOBAL-003", severity: "warning", rule: "Avoid idioms and culture-specific references" }
    - { id: "GLOBAL-004", severity: "warning", rule: "Spell out month names in dates" }
```

## Complete JSON Specification

```json
{
  "metadata": {
    "name": "Microsoft Writing Style Rules",
    "version": "1.0",
    "source": "Microsoft Writing Style Guide",
    "url": "https://learn.microsoft.com/en-us/style-guide/welcome/",
    "last_updated": "2026-01-14"
  },
  "rules": {
    "voice": [
      { "id": "VOICE-001", "severity": "error", "rule": "Use contractions (it's, you'll, don't)" },
      { "id": "VOICE-002", "severity": "error", "rule": "Use second person (you/your) for instructions" },
      { "id": "VOICE-003", "severity": "warning", "rule": "Avoid 'we' except for company statements" },
      { "id": "VOICE-004", "severity": "error", "rule": "Use 'I/my' only in UI checkboxes/toggles" },
      { "id": "VOICE-005", "severity": "warning", "rule": "Start with verbs, not 'you can'" },
      { "id": "VOICE-006", "severity": "warning", "rule": "Eliminate 'there is/are/were'" }
    ],
    "capitalization": [
      { "id": "CAP-001", "severity": "error", "rule": "Sentence-style capitalization for all headings" },
      { "id": "CAP-002", "severity": "error", "rule": "Never use title case for headings" },
      { "id": "CAP-003", "severity": "error", "rule": "Follow trademark list for product names" },
      { "id": "CAP-004", "severity": "warning", "rule": "Don't capitalize spelled-out acronyms unless proper nouns" }
    ],
    "punctuation": [
      { "id": "PUNCT-001", "severity": "error", "rule": "Always use Oxford comma (A, B, and C)" },
      { "id": "PUNCT-002", "severity": "error", "rule": "No periods on headings" },
      { "id": "PUNCT-003", "severity": "warning", "rule": "No periods on short list items (≤3 words)" },
      { "id": "PUNCT-004", "severity": "error", "rule": "One space after periods" },
      { "id": "PUNCT-005", "severity": "warning", "rule": "No spaces around em dashes (word—word)" },
      { "id": "PUNCT-006", "severity": "warning", "rule": "Use en dash for ranges (10–15)" }
    ],
    "word_choice": [
      { "id": "WORD-001", "severity": "warning", "rule": "Replace 'utilize' with 'use'" },
      { "id": "WORD-002", "severity": "warning", "rule": "Replace 'in order to' with 'to'" },
      { "id": "WORD-003", "severity": "warning", "rule": "One term = one concept (no synonyms)" },
      { "id": "WORD-004", "severity": "warning", "rule": "Use US English spelling" }
    ],
    "numbers": [
      { "id": "NUM-001", "severity": "warning", "rule": "Spell out 0-9; numerals for 10+" },
      { "id": "NUM-002", "severity": "warning", "rule": "Always numerals for measurements" },
      { "id": "NUM-003", "severity": "error", "rule": "Never start sentence with numeral" },
      { "id": "NUM-004", "severity": "warning", "rule": "Commas in numbers ≥1,000" },
      { "id": "DATE-001", "severity": "warning", "rule": "Date format: Month day, year (January 5, 2026)" }
    ],
    "ui": [
      { "id": "UI-001", "severity": "warning", "rule": "Use 'select' not 'click' or 'tap'" },
      { "id": "UI-002", "severity": "warning", "rule": "Use 'open' for apps/files, 'go to' for menus" },
      { "id": "UI-003", "severity": "warning", "rule": "Bold UI element names" },
      { "id": "UI-004", "severity": "info", "rule": "Use > for UI paths (Settings > Privacy)" },
      { "id": "UI-005", "severity": "warning", "rule": "Keyboard shortcuts: Ctrl+S (no spaces, capitalized)" }
    ],
    "accessibility": [
      { "id": "A11Y-001", "severity": "warning", "rule": "People-first language (people with disabilities)" },
      { "id": "A11Y-002", "severity": "warning", "rule": "Spell out + as 'plus', & as 'and'" },
      { "id": "A11Y-003", "severity": "error", "rule": "Don't rely on directional terms alone" },
      { "id": "A11Y-004", "severity": "error", "rule": "Descriptive link text (not 'click here')" },
      { "id": "A11Y-005", "severity": "error", "rule": "Semantic heading hierarchy (no skipping levels)" }
    ],
    "bias_free": [
      { "id": "BIAS-001", "severity": "warning", "rule": "Gender-neutral language (workforce not manpower)" },
      { "id": "BIAS-002", "severity": "warning", "rule": "Singular 'they' is acceptable" },
      { "id": "BIAS-003", "severity": "error", "rule": "Replace master/slave with primary/replica" },
      { "id": "BIAS-004", "severity": "error", "rule": "Replace whitelist/blacklist with allowlist/blocklist" }
    ],
    "global": [
      { "id": "GLOBAL-001", "severity": "warning", "rule": "Include articles (a, an, the)" },
      { "id": "GLOBAL-002", "severity": "warning", "rule": "Include 'that' and 'who' clause markers" },
      { "id": "GLOBAL-003", "severity": "warning", "rule": "Avoid idioms and culture-specific references" },
      { "id": "GLOBAL-004", "severity": "warning", "rule": "Spell out month names in dates" }
    ]
  }
}
```

## Prompt Templates

### Writing Assistant System Prompt

```markdown
You are a technical writer following Microsoft Writing Style Guide. Apply these rules:

## Voice
- Use contractions: it's, you'll, we're, don't
- Address readers as "you"
- Start with verbs, not "you can"
- Avoid "there is/are"

## Capitalization
- Sentence case for ALL headings (never title case)
- Only capitalize first word and proper nouns

## Punctuation
- Always use Oxford comma
- One space after periods
- No periods on headings
- No spaces around em dashes

## UI Terminology
- Use "select" not "click" or "tap"
- Bold UI element names: **Save**
- Use > for paths: **Settings** > **Privacy**

## Accessibility
- Descriptive link text (not "click here")
- Don't rely on directional terms
- People-first language
```

### Validation Agent Prompt

```markdown
Review this documentation for Microsoft style compliance. Check for:

ERRORS (must fix):
- [ ] Contractions used? (VOICE-001)
- [ ] Sentence-style capitalization in headings? (CAP-001)
- [ ] Oxford comma in all lists? (PUNCT-001)
- [ ] No sentences starting with numerals? (NUM-003)
- [ ] Descriptive link text? (A11Y-004)
- [ ] No master/slave, whitelist/blacklist? (BIAS-003, BIAS-004)

WARNINGS (should fix):
- [ ] Second person (you/your)? (VOICE-002)
- [ ] No "you can" constructions? (VOICE-005)
- [ ] No "there is/are"? (VOICE-006)
- [ ] Input-neutral UI verbs (select, not click)? (UI-001)
- [ ] Bold UI elements? (UI-003)
- [ ] People-first language? (A11Y-001)

Report violations with rule IDs and specific examples from the text.
```

### Quick Review Checklist Prompt

```markdown
Quickly check this content for the most critical Microsoft style rules:

1. ✅/❌ Contractions used throughout?
2. ✅/❌ Headings in sentence case (not Title Case)?
3. ✅/❌ Oxford commas in all lists of 3+ items?
4. ✅/❌ "Select" instead of "click/tap" for UI actions?
5. ✅/❌ No problematic terms (master/slave, whitelist/blacklist)?

Provide pass/fail for each with one example of any failures.
```

## Series Navigation

This article is part of a 5-article series on the Microsoft Writing Style Guide:

| Article | Title | Focus |
|---------|-------|-------|
| 00 | [Overview and Philosophy](00-microsoft-style-guide-overview.md) | Guide structure, Top 10 Tips, philosophy |
| 01 | [Voice and Tone](01-microsoft-voice-and-tone.md) | Three voice principles, contractions, person, bias-free communication |
| 02 | [Mechanics and Formatting](02-microsoft-mechanics-and-formatting.md) | Capitalization, punctuation, numbers, UI terminology |
| 03 | [Comparative Analysis](03-microsoft-compared-to-other-guides.md) | Microsoft vs. Google, Apple, Wikipedia, Diátaxis |
| **04** | **Principles Reference** (this article) | Extractable rules (YAML/JSON) for prompts and agents |

## References

**📘 Official Sources**

- **[Microsoft Writing Style Guide](https://learn.microsoft.com/en-us/style-guide/welcome/)** 📘 [Official]  
  The complete, authoritative source for all rules in this reference.

- **[A–Z Word List](https://learn.microsoft.com/en-us/style-guide/a-z-word-list-term-collections/a-z-word-list)** 📘 [Official]  
  Specific word and term usage decisions.

**📗 Implementation Resources**

- **[Vale](https://vale.sh/)** 📗 [Verified Community]  
  Open-source prose linter that can consume style rules.

- **[textlint](https://textlint.github.io/)** 📗 [Verified Community]  
  Pluggable linting tool for natural language.

---

<!--
article_metadata:
  filename: "04-microsoft-style-principles-reference.md"
  validation:
    status: "new"
    last_run: "2026-01-14"
    dimensions:
      grammar: { status: "pending" }
      readability: { status: "pending" }
      structure: { status: "pending" }
      facts: { status: "pending" }
      logic: { status: "pending" }
      coverage: { status: "pending" }
      references: { status: "pending" }
-->
