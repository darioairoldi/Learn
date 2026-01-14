---
title: "Microsoft Mechanics: Capitalization, Punctuation, and UI Terminology"
author: "Dario Airoldi"
date: "2026-01-14"
categories: [technical-writing, microsoft, capitalization, punctuation, formatting]
description: "Master Microsoft's mechanical rules—sentence-style capitalization mandate, Oxford comma requirement, number formatting, and input-neutral UI terminology"
---

# Microsoft Mechanics: Capitalization, Punctuation, and UI Terminology

> Apply consistent formatting rules that make documentation scannable, accessible, and globally translatable

## Table of Contents

- [Introduction](#introduction)
- [Capitalization: Sentence Style Always](#capitalization-sentence-style-always)
- [Punctuation: Oxford Comma and Beyond](#punctuation-oxford-comma-and-beyond)
- [Numbers and Measurements](#numbers-and-measurements)
- [UI Terminology: Input-Neutral Verbs](#ui-terminology-input-neutral-verbs)
- [Text Formatting](#text-formatting)
- [Procedures and Instructions](#procedures-and-instructions)
- [Global-Ready Writing](#global-ready-writing)
- [Series Navigation](#series-navigation)
- [References](#references)

## Introduction

**<mark>Mechanical consistency</mark>** creates predictability for readers.  
When capitalization, punctuation, and formatting follow consistent patterns, readers focus on content rather than deciphering style variations.

Microsoft's mechanical rules are **<mark>more prescriptive than most style guides</mark>**, with particularly strong stances on capitalization and UI terminology.

This article covers:

- **<mark>Capitalization</mark>** — The absolute mandate for sentence-style
- **<mark>Punctuation</mark>** — Oxford comma, dashes, and spacing rules
- **<mark>Numbers</mark>** — When to spell out, when to use numerals
- **<mark>UI terminology</mark>** — Input-neutral verbs that work across devices
- **<mark>Formatting</mark>** — Bold, code, and visual treatment
- **<mark>Global-ready</mark>** — Rules that support localization

**Prerequisites:** [Microsoft Voice and Tone](01-microsoft-voice-and-tone.md) covers the philosophical foundation these mechanics support.

## <mark>Capitalization</mark>: <mark>Sentence Style Always</mark>

Microsoft takes one of the **strongest stances** in any style guide on capitalization:

> "Default to sentence-style capitalization—capitalize only the first word of a heading or phrase and any proper nouns or names. Never Use Title Capitalization (Like This). Never Ever."

### Sentence-Style Capitalization

**The rule:** Capitalize only:
1. The first word
2. Proper nouns (names of people, products, places)
3. Acronyms

**Everything else stays lowercase.**

| ✅ Correct (Sentence Style) | ❌ Wrong (Title Case) |
|-----------------------------|----------------------|
| Getting started with Azure | Getting Started With Azure |
| How to configure your settings | How To Configure Your Settings |
| Authentication and security | Authentication And Security |
| What's new in Windows 11 | What's New In Windows 11 |
| Using the command-line interface | Using the Command-Line Interface |

### Where Sentence Style Applies

**Use sentence style for:**
- All headings (H1 through H6)
- Button labels
- Menu items
- Dialog titles
- Tab labels
- Link text
- Column headers in tables
- List items

**Exceptions (use as-is):**
- Trademarked product names (follow trademark list)
- Acronyms (maintain original case)
- Code elements (preserve exact case)

### Product Names and Trademarks

Product names follow Microsoft's trademark list, not sentence-style rules:

| Product (As Trademarked) | In Sentence |
|--------------------------|-------------|
| Microsoft Azure | "Deploy your app to Microsoft Azure." |
| Visual Studio Code | "Install Visual Studio Code first." |
| Power BI | "Create reports with Power BI." |
| Xbox Series X | "Games for Xbox Series X" |

**Note:** "Azure" alone is acceptable after first use of "Microsoft Azure."

### Spelled-Out Acronyms

When spelling out acronyms, **only capitalize if proper nouns**:

| Acronym | Spelled Out | Reason |
|---------|-------------|--------|
| API | application programming interface | Common noun |
| URL | uniform resource locator | Common noun |
| SDK | software development kit | Common noun |
| GUI | graphical user interface | Common noun |
| HTML | Hypertext Markup Language | (Product name origin) |
| HTTP | Hypertext Transfer Protocol | (Product name origin) |

### The "When in Doubt" Rule

> "When in doubt, don't capitalize."

If you're unsure whether something is a proper noun or common noun, **choose lowercase**. This prevents the creeping capitalization that plagues technical documentation.

❌ **Overcapitalization:** "The System Administrator should configure the Network Settings in the Control Panel."

✅ **Correct:** "The system administrator should configure the network settings in Control Panel."

(Only "Control Panel" is capitalized—it's a product feature name.)

## <mark>Punctuation</mark>: <mark>Oxford Comma and Beyond</mark>

### The Oxford Comma (Required)

Microsoft **requires** the serial (Oxford) comma:

> "In a list of three or more items<mark>, </mark>include a comma before the conjunction."

| ✅ Correct (With Oxford Comma) | ❌ Wrong (Without) |
|--------------------------------|-------------------|
| Red, white, and blue | Red, white and blue |
| Save, close, and exit | Save, close and exit |
| Accuracy, clarity, and consistency | Accuracy, clarity and consistency |

**Why it matters:**

Without the Oxford comma, ambiguity can occur:

❌ "This book is dedicated to my parents, Ayn Rand and God."
(Are your parents Ayn Rand and God?)

✅ "This book is dedicated to my parents, Ayn Rand, and God."
(Three separate entities)

### <mark>Periods</mark>

**<mark>Skip periods on:</mark>**
- Headings and titles
- Subheadings
- UI element names
- Short list items (three words or fewer)
- Table cells with short content

**<mark>Use periods on:</mark>**
- Complete sentences (always)
- Longer list items (full sentences)
- Paragraphs

**Spacing:** One space after periods, not two.

### <mark>Em Dashes (—)</mark>

**Use em dashes for:**
- Abrupt changes in thought
- Emphasis or amplification
- Setting off explanatory phrases

**Formatting:** No spaces around em dashes.

✅ **Correct:** "The feature—available in all plans—syncs automatically."
❌ **Wrong:** "The feature — available in all plans — syncs automatically."

### <mark>En Dashes (–)</mark>

**Use en dashes for:**
- Ranges: "pages 10–15", "2020–2024"
- Compound modifiers: "New York–based company"

**Not for:**
- Ranges that use "from...to" or "between...and" (use words, not dashes)

❌ **Wrong:** "from 2020–2024"
✅ **Correct:** "from 2020 to 2024" or "2020–2024"

### <mark>Hyphens (-)</mark>

**Use hyphens for:**
- Compound modifiers before nouns: "cloud-based solution"
- Prefixes when needed for clarity: "re-create" (vs. recreate)
- Numbers as words: "twenty-one"

**Don't hyphenate:**
- Compounds after the noun: "The solution is cloud based."
- Common compound terms: "email", "website", "online"
- Prefixes usually written solid: "preinstall", "reopen", "coworker"

### <mark>Colons</mark>

**Use colons to:**
- Introduce lists
- Introduce explanations
- Separate titles from subtitles

**Capitalization after colons:**
- Capitalize if what follows is a complete sentence
- Lowercase if a fragment

✅ "Remember one thing: Always save your work."
✅ "You need three items: a keyboard, a mouse, and a monitor."

### <mark>Quotation Marks</mark>

**Use quotation marks for:**
- Direct quotes
- Article and chapter titles (not book titles—use italic)
- Terms used in special ways

**Punctuation placement:**
- Periods and commas go **inside** quotation marks (US style)
- Question marks and exclamation points go inside if part of the quote

✅ "Save your changes," the dialog said.
✅ Did you click "Submit"?

## <mark>Numbers and Measurements</mark>

### When to Spell Out

**Spell out zero through nine:**
- "three options"
- "five steps"
- "zero errors"

**Use numerals for 10 and above:**
- "15 users"
- "100 requests"
- "250 GB"

### <mark>Exceptions: Always Use Numerals</mark>

**Always use numerals for:**
- Measurements: "5 GB", "3 pixels", "2 seconds"
- Percentages: "5 percent" or "5%"
- Technical specifications: "4 CPU cores"
- Code or commands: "set count to 5"
- Versions: "version 3.1"
- Page numbers, figure numbers
- Times: "3:00 PM"

### <mark>Formatting Numerals</mark>

**Commas:** Use commas in numbers with four or more digits.
- ✅ 1,000
- ✅ 10,000
- ✅ 1,000,000

**Decimals:** Use periods for decimals.
- ✅ 3.14
- ✅ 99.9 percent

**Don't start sentences with numerals:**

❌ "15 users reported the issue."
✅ "Fifteen users reported the issue."
✅ "The issue was reported by 15 users."

### <mark>Dates</mark>

**Preferred format:** Month day, year
- ✅ January 5, 2026
- ❌ 1/5/2026 (ambiguous internationally)
- ❌ 5 January 2026 (not Microsoft style)

**For global content:** Spell out the month to avoid confusion.

### <mark>Times</mark>

**Format:** Include AM/PM, no periods.
- ✅ 3:00 PM
- ✅ 10:30 AM
- ❌ 3:00 p.m.
- ❌ 15:00 (unless 24-hour is standard for audience)

### <mark>Ordinals</mark>

**Spell out ordinals in prose:**
- ✅ "the first step"
- ✅ "third-party software"
- ❌ "the 1st step"
- ❌ "3rd-party software"

**Numerals acceptable in:**
- Dates: "March 1st" (though "March 1" is preferred)
- Rankings: "ranked 3rd"

## <mark>UI Terminology: Input-Neutral Verbs</mark>

Microsoft's guidance on UI terminology is **distinctively input-neutral**—avoiding device-specific terms like "click" or "tap."

### Why Input-Neutral?

Users interact with software through:
- Mouse (click)
- Keyboard (press, Tab, Enter)
- Touch (tap, swipe)
- Voice (say, speak)
- Eye tracking
- Assistive devices

**Input-neutral verbs work for all these methods.**

### <mark>Primary UI Verbs</mark>

| Action | Microsoft Verb | Avoid |
|--------|---------------|-------|
| Activate a button or link | **select** | click, tap, press |
| Open an app or file | **open** | launch, run, start |
| Navigate to a location | **go to** | navigate, browse |
| Type text | **enter** | type, input, key in |
| Check a checkbox | **select** (the checkbox) | check, tick |
| Uncheck a checkbox | **clear** | uncheck, untick |
| Choose from options | **choose** or **select** | pick |
| Move to close | **close** | exit, quit, dismiss |
| Activate a toggle | **turn on/off** | enable, toggle |

### Examples in Context

❌ **Device-specific:**
> "Click the Submit button."
> "Tap Settings and then tap Privacy."
> "Right-click to open the context menu."

✅ **Input-neutral:**
> "Select **Submit**."
> "Go to **Settings** > **Privacy**."
> "Open the context menu." (Don't specify how)

### Using the <mark>Angle Bracket (>)

For simple sequential steps, use `>` with spaces:

✅ "Go to **Settings** > **Privacy** > **Location**."
✅ "Select **File** > **Save As**."

**When not to use > :**
- Complex procedures with explanations between steps
- When additional context is needed at each step

### <mark>Bold for UI Elements</mark>

**Bold UI element names** in documentation:

✅ "Select **Save**."
✅ "In the **Name** field, enter your username."
✅ "Turn on **Location services**."

**Don't bold:**
- Generic descriptions: "Select the save button"
- Key names in keyboard shortcuts: Ctrl+S

### <mark>Keyboard Shortcuts</mark>

**Formatting:**
- Capitalize key names: Ctrl, Alt, Shift, Enter, Tab
- Use + without spaces: Ctrl+Alt+Delete
- Bold the shortcut in documentation: **Ctrl+S**

✅ "Press **Ctrl+S** to save."
✅ "Use **Alt+Tab** to switch windows."

## <mark>Text Formatting</mark>

### Bold

**Use bold for:**
- UI element names in instructions
- Terms being defined (on first use)
- Emphasis (sparingly)

**Don't overuse bold.** If everything is bold, nothing stands out.

### Italic

**Use italic for:**
- Book and publication titles
- Mathematical variables
- Introducing new terms (alternative to bold)
- Emphasis (when bold is too strong)

### Code Formatting

**Use code formatting (monospace) for:**
- Code snippets and commands
- File names and paths
- API names, methods, properties
- Keyboard input in code context
- Configuration values

✅ `config.json`
✅ `getUserById()`
✅ `SELECT * FROM users`

### Don't Combine Formatting

❌ **Avoid:** ***bold and italic***
❌ **Avoid:** **`bold code`**
✅ **Prefer:** One format per element

## <mark>Procedures and Instructions</mark>

### The Best Procedure

> "The best procedure is the one you don't need."

If the UI is intuitive, don't document what's obvious. Focus procedures on:
- Non-obvious actions
- Complex workflows
- Error recovery
- Configuration decisions

### Step Formatting

**Single-step procedures:**
- Don't number single steps
- Use "To [goal], [action]" format

✅ "To save your work, select **Save**."

**Multi-step procedures:**
- Number the steps
- Limit to seven steps maximum
- Each step = one action

✅
```
1. Open **Settings**.
2. Select **Privacy**.
3. Turn on **Location services**.
```

### Location Before Action

**Tell users where they are before telling them what to do:**

❌ "Select **Submit** in the dialog."
✅ "In the confirmation dialog, select **Submit**."

❌ "Click the Delete button at the top of the page."
✅ "At the top of the page, select **Delete**."

### Optional Steps

**Mark optional steps clearly:**

✅ "(Optional) Add a description."
✅ "If you want to customize the layout, select **Options**."

### Results and Verification

**Tell users what happens:**

✅ "Select **Save**. A confirmation message appears."
✅ "The file downloads to your Downloads folder."

## <mark>Global-Ready Writing</mark>

Microsoft content reaches global audiences. These rules support localization and non-native English speakers.

### Include Articles

Don't drop articles (a, an, the) for brevity:

❌ "Select button to continue."
✅ "Select the button to continue."

Articles help machine translation and non-native readers parse sentences.

### Include "That" and "Who"

Don't drop relative pronouns:

❌ "The file you downloaded is ready."
✅ "The file that you downloaded is ready."

❌ "Users need admin access can change settings."
✅ "Users who need admin access can change settings."

### Avoid Idioms

Idioms don't translate:

| Idiom | Literal Replacement |
|-------|---------------------|
| "hit the ground running" | "start quickly" |
| "at the end of the day" | "ultimately" |
| "ballpark figure" | "rough estimate" |
| "out of the box" | "by default" or "immediately" |
| "low-hanging fruit" | "easy improvements" |

### Avoid Culture-Specific References

- **Don't use seasons:** "Update in spring" → "Update in March"
- **Don't reference holidays:** "Before Christmas" → "By December 20"
- **Don't assume sports knowledge:** "home run" → "great success"
- **Don't assume political knowledge:** References to specific elections, parties

### Date and Time Formats

**Spell out months** to avoid ambiguity:

| Format | Region | Interpretation |
|--------|--------|----------------|
| 1/5/2026 | US | January 5 |
| 1/5/2026 | UK | May 1 |
| January 5, 2026 | Universal | January 5 |

**Include time zones** for global events:

✅ "3:00 PM Pacific Time (PT)"
✅ "10:00 AM UTC"

## <mark>Series Navigation</mark>

This article is part of a 5-article series on the Microsoft Writing Style Guide:

| Article | Title | Focus |
|---------|-------|-------|
| 00 | [Overview and Philosophy](00-microsoft-style-guide-overview.md) | Guide structure, Top 10 Tips, philosophy |
| 01 | [Voice and Tone](01-microsoft-voice-and-tone.md) | Three voice principles, contractions, person, bias-free communication |
| **02** | **Mechanics and Formatting** (this article) | Capitalization, punctuation, numbers, UI terminology |
| 03 | [Comparative Analysis](03-microsoft-compared-to-other-guides.md) | Microsoft vs. Google, Apple, Wikipedia, Diátaxis |
| 04 | [Principles Reference](04-microsoft-style-principles-reference.md) | Extractable rules (YAML/JSON) for prompts and agents |

## References

**📘 Official Sources**

- **[Capitalization](https://learn.microsoft.com/en-us/style-guide/capitalization)** 📘 [Official]  
  Complete capitalization rules including sentence-style mandate.

- **[Punctuation](https://learn.microsoft.com/en-us/style-guide/punctuation/)** 📘 [Official]  
  All punctuation guidance including Oxford comma requirement.

- **[Numbers](https://learn.microsoft.com/en-us/style-guide/numbers)** 📘 [Official]  
  When to spell out vs. use numerals.

- **[Procedures and Instructions](https://learn.microsoft.com/en-us/style-guide/procedures-instructions/)** 📘 [Official]  
  Step-by-step procedure formatting and UI terminology.

- **[Describing Interactions with UI](https://learn.microsoft.com/en-us/style-guide/procedures-instructions/describing-interactions-with-ui)** 📘 [Official]  
  Input-neutral verb usage.

- **[Global Communications](https://learn.microsoft.com/en-us/style-guide/global-communications/)** 📘 [Official]  
  Writing for international audiences.

---

<!--
article_metadata:
  filename: "02-microsoft-mechanics-and-formatting.md"
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
