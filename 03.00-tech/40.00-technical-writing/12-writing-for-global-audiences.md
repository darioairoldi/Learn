---
# Quarto Metadata
title: "Writing for Global Audiences"
author: "Dario Airoldi"
date: "2026-02-28"
categories: [technical-writing, internationalization, localization, translation, global-audiences, plain-language]
description: "Write technical documentation that works for international readers, supports translation workflows, and avoids cultural assumptions through global-ready language patterns"
---

# Writing for Global Audiences

> Create documentation that works across languages, cultures, and regions—not just for native English speakers

## Table of Contents

- [Introduction 🎯](#introduction)
- [Key terminology 📋](#key-terminology)
- [Why global-ready writing matters 🌍](#why-global-ready-writing-matters)
- [Global-ready language patterns ✍️](#global-ready-language-patterns)
- [What to avoid 🚫](#what-to-avoid)
- [Formatting for global audiences 📐](#formatting-for-global-audiences)
- [Translation-friendly documentation 🔄](#translation-friendly-documentation)
- [Cultural adaptation and sensitivity 🧪](#cultural-adaptation-and-sensitivity)
- [Tooling and automation ⚙️](#tooling-and-automation)
- [Applying global writing to this repository 📌](#applying-global-writing-to-this-repository)
- [Conclusion ✅](#conclusion)
- [References 📚](#references)

## Introduction 🎯

Over 1 billion people speak English as a second language. Many of your readers process technical documentation in a language that isn't their first—and some read machine-translated versions. Writing that works only for native English speakers fails a significant portion of your audience.

This article consolidates <mark>internationalization</mark> (i18n), <mark>localization</mark> (l10n), and global-ready writing principles into a unified reference. You'll find these concepts touched on briefly in several articles across this series—[accessibility](03-accessibility-in-technical-writing.md) mentions non-native speakers, [writing style](01-writing-style-and-voice-principles.md) references Google's "Write for a global audience" philosophy, and the [Microsoft sub-series](microsoft-writing-style-guide/02-microsoft-mechanics-and-formatting.md) covers global-ready mechanics. This article brings those scattered threads together.

**This article covers:**

- **Global-ready language patterns** — Sentence structures that survive translation
- **Cultural sensitivity** — Avoiding assumptions that exclude readers
- **Translation-friendly documentation** — Writing that supports both human and machine translation
- **Formatting conventions** — Dates, numbers, units, and symbols for international audiences
- **Tooling** — Automated checks for global-readiness

**Article type:** Explanation (understanding concepts) with how-to elements (actionable patterns)

**Prerequisites:** Familiarity with [writing style principles](01-writing-style-and-voice-principles.md) and [accessibility in technical writing](03-accessibility-in-technical-writing.md) provides useful context.

## Key terminology 📋

Before diving in, let's clarify three terms that are often confused:

| Term | Abbreviation | Meaning |
|------|-------------|---------|
| <mark>Internationalization</mark> | i18n | Designing documentation so it can be adapted for different languages and regions *without structural changes*. It's the preparation step. |
| <mark>Localization</mark> | l10n | Adapting content for a specific locale—language, cultural conventions, units, legal requirements. It's the adaptation step. |
| <mark>Translation</mark> | — | Converting text from one language to another. Translation is *part of* localization, but localization goes further (currency, date formats, cultural references). |

**The relationship:** Internationalization makes localization possible. Localization includes translation but also covers cultural adaptation. Good technical writing practices make all three easier.

## Why global-ready writing matters 🌍

### The business case

- **Reach** — Technical documentation that's translation-friendly serves a larger audience at lower cost
- **Quality** — Clear, unambiguous writing produces better machine translations (and better human translations)
- **Efficiency** — Translation-ready content reduces rework cycles and translation costs
- **Inclusivity** — Non-native speakers who read English documentation benefit from simpler sentence structures

### The cost of ignoring it

Ambiguous writing creates compounding problems during translation:

| Issue in source | Translation impact | Reader impact |
|---|---|---|
| Phrasal verbs ("set up," "carry out") | Machine translation often fails | Wrong action taken |
| Dropped articles ("Select button") | Grammatical errors in 20+ languages | Confused readers |
| Cultural idioms ("out of the box") | Literal translations are nonsensical | Lost meaning |
| Ambiguous pronouns ("it," "this") | Translator guesses wrong referent | Wrong understanding |
| Inconsistent terminology | Multiple translations for one concept | Readers think there are multiple concepts |

### Who benefits

Global-ready writing isn't just for content that *will* be translated. It helps:

- **Non-native English readers** — Clearer grammar, shorter sentences, explicit relationships
- **Machine translation consumers** — Better input produces better output
- **Human translators** — Less ambiguity means faster, more accurate work
- **Native English readers** — Simpler, more direct writing is better writing for everyone

## Global-ready language patterns ✍️

These patterns make your documentation clearer for all readers and significantly easier to translate.

### Include articles and relative pronouns

Don't drop articles (a, an, the) or relative pronouns (that, who, which) for brevity. They're essential grammar signals for non-native readers and translation tools.

**Articles:**

| ❌ Dropped article | ✅ With article |
|---|---|
| Select button to continue. | Select the button to continue. |
| Enter value in field. | Enter a value in the field. |
| Open file in editor. | Open the file in the editor. |

**Relative pronouns:**

| ❌ Dropped pronoun | ✅ With pronoun |
|---|---|
| The file you downloaded is ready. | The file that you downloaded is ready. |
| Users need admin access can change settings. | Users who need admin access can change settings. |
| The API returns errors are logged automatically. | The API returns errors that are logged automatically. |

Microsoft's style guide specifically requires these inclusions because they help machine translation and non-native readers parse sentences correctly.

### Use simple, direct sentence structures

Follow <mark>subject → verb → object</mark> (SVO) order. This is the most common sentence pattern across languages and the easiest for translators to process.

| ❌ Complex structure | ✅ SVO structure |
|---|---|
| When the deployment completes, if no errors occurred, the status page updates. | The status page updates after a successful deployment. |
| Users can, by selecting the configuration panel, change their preferences. | Select the configuration panel to change your preferences. |

**Additional patterns:**

- **One idea per sentence** — Break compound sentences into separate statements
- **Front-load conditions** — "If you use custom domains, configure DNS first" (condition before instruction)
- **15-25 words per sentence** — This range optimizes both comprehension and translation quality

### Prefer single-word verbs over phrasal verbs

<mark>Phrasal verbs</mark> combine a verb with one or more particles (prepositions or adverbs) to create a new meaning. They're common in conversational English but difficult to translate because the meaning isn't deducible from the individual words.

| ❌ Phrasal verb | ✅ Single-word alternative |
|---|---|
| set up | configure, install |
| carry out | perform, execute |
| figure out | determine, identify |
| come up with | create, design |
| look into | investigate, examine |
| get rid of | remove, delete |
| go over | review, examine |
| turn off | disable |
| turn on | enable |

**Exceptions:** Some phrasal verbs have no good single-word replacement and are well-established in technical writing: "log in," "sign in," "set up" (as a noun: "the setup"). Use them when the alternative would be less clear.

### Use words in their primary sense

Don't use the same word as both a noun and a verb in close proximity. Avoid words with multiple meanings when context doesn't clearly disambiguate.

| ❌ Ambiguous usage | ✅ Clear usage |
|---|---|
| Use this use case as a guide. | Follow this use case as a guide. |
| Once you configure the service, you can once again deploy. | After you configure the service, you can deploy again. |
| While the process runs, review the logs. (While = during? although?) | During the process run, review the logs. |

**Particularly problematic words:** "once" (one time? after?), "since" (because? from that time?), "while" (during? although?), "as" (because? at the same time?). Prefer explicit alternatives.

### Clarify pronoun references

Pronouns like "it," "this," and "they" are ambiguous for translators working with segmented text. When a pronoun's referent isn't obvious in the same sentence, replace it with the noun.

| ❌ Ambiguous pronoun | ✅ Explicit reference |
|---|---|
| If you use the variable in a function, make sure it's initialized. | If you use the variable in a function, make sure the variable is initialized. |
| Deploy the container and restart the service. This resolves the issue. | Deploy the container and restart the service. This restart resolves the issue. |
| The API and the SDK support retries. They handle errors differently. | The API and the SDK support retries. Each handles errors differently. |

### Repeat for clarity, don't compress for brevity

In translation-friendly writing, strategic repetition is better than ambiguous compression.

| ❌ Compressed | ✅ Repeated for clarity |
|---|---|
| The resource hierarchy creates both IAM and network segmentation by default. | The resource hierarchy creates both IAM segmentation and network segmentation by default. |
| Start the profiler, then run the app. | Start the profiler, and then run the app. |
| If the VM started and you're able to connect... | If the VM has started and if you're able to connect... |

## What to avoid 🚫

### Idioms and colloquialisms

Idioms are culture-specific expressions whose meaning can't be derived from the individual words. They don't translate—literally or figuratively.

| ❌ Idiom | ✅ Plain alternative |
|---|---|
| hit the ground running | start quickly |
| at the end of the day | ultimately |
| ballpark figure | rough estimate |
| out of the box | by default |
| low-hanging fruit | easy improvements |
| back to square one | start over |
| on the same page | in agreement |
| move the needle | make progress |
| deep dive | detailed examination |
| boil the ocean | attempt too much |

### Humor and wordplay

Humor depends on shared cultural context, idiom mastery, and tone recognition. In translated content, jokes become confusing at best and offensive at worst. Technical documentation doesn't need humor to be engaging—clarity and helpfulness are more valuable.

### Culture-specific references

Don't assume shared cultural knowledge:

| Category | ❌ Avoid | ✅ Instead |
|---|---|---|
| **Seasons** | "Update in spring" | "Update in March" |
| **Holidays** | "Before Christmas" | "By December 20" |
| **Sports** | "That's a home run" | "That's a great success" |
| **Currency** | "$50" without context | "50 USD" or "50 US dollars" |
| **Food/drink** | "It's as American as apple pie" | (Simply remove the analogy) |
| **Geography** | "nationwide" | Specify the country |

### Slang and informal register

Terms like "gonna," "wanna," "gotta," "kinda," and "ain't" confuse non-native speakers and machine translation. Contractions like "it's," "don't," and "you'll" are fine (Microsoft style requires them), but informal contractions that merge words nonstandard-ly should be avoided.

## Formatting for global audiences 📐

### Dates and times

Date formats are among the most common sources of international confusion:

| Format | US interpretation | UK interpretation |
|---|---|---|
| 1/5/2026 | January 5 | May 1 |
| 5/1/2026 | May 1 | January 5 |

**The solution:** Always spell out the month name.

- ✅ "January 5, 2026"
- ✅ "5 January 2026"
- ❌ "1/5/2026"
- ❌ "01-05-2026"

**Times:** Always include the time zone, and prefer UTC for international audiences.

- ✅ "3:00 PM Pacific Time (PT)"
- ✅ "10:00 AM UTC"
- ✅ "15:00 UTC"
- ❌ "3 PM" (which time zone?)

### Numbers and decimal separators

Decimal and thousands separators vary by region:

| Region | One thousand | One and a half |
|---|---|---|
| US, UK | 1,000 | 1.5 |
| Germany, France, Brazil | 1.000 | 1,5 |
| Switzerland | 1'000 | 1.5 |

**For technical documentation:**
- Use the format standard for your primary audience
- When ambiguity is possible, spell out small numbers or add units: "1.5 GB" (the unit disambiguates)
- Consider using spaces as thousands separators (ISO 31-0): 1 000, 10 000

### Units of measurement

Provide both metric and imperial when your audience spans regions, or default to metric (the international standard) with imperial in parentheses.

- ✅ "The maximum file size is 100 MB (megabytes)"
- ✅ "At distances greater than 100 km (62 miles)"
- ❌ "At distances greater than 62 miles" (assumes US audience)

### Currency

Always specify the currency code, not just the symbol. The "$" symbol is used for USD, CAD, AUD, and other currencies.

- ✅ "50 USD" or "US$50"
- ✅ "The service costs 10 EUR/month"
- ❌ "$50" (which dollar?)
- ❌ "¥500" (Chinese yuan or Japanese yen?)

### Phone numbers

Use the international format with country code:

- ✅ "+1 (425) 555-0100"
- ❌ "(425) 555-0100" (assumes US)

## Translation-friendly documentation 🔄

### How translation workflows work

Understanding the translation process helps you write content that survives it.

**Machine translation (MT):**
Modern MT systems (like those used by Microsoft and Google) process text in segments—typically sentences or paragraphs. They use statistical and neural models trained on parallel corpora. Clear, unambiguous source text produces dramatically better output.

**Translation memory (TM):**
<mark>Translation memory</mark> systems store previously translated segments and reuse them when identical or similar text appears. Consistent terminology and standardized phrases increase TM hit rates, reducing cost.

**Human translation:**
Professional translators work with segmented text and translation tools. They benefit from:
- Consistent terminology (same term → same translation)
- Explicit grammar (articles, pronouns, relative clauses included)
- Context notes for ambiguous terms
- Short, clear sentences that don't require creative interpretation

### Write for segmentation

Translation tools split content into segments at sentence boundaries. Don't create sentences that depend on other sentences for meaning. Each sentence should be self-contained enough for a translator to understand in isolation.

| ❌ Depends on context | ✅ Self-contained |
|---|---|
| "Do this. Then do that. It should work." | "Complete step 1. Then complete step 2. The configuration should succeed." |
| "See above." | "See the [Authentication section](#authentication)." |
| "As mentioned earlier..." | "As described in the [Prerequisites section](#prerequisites)..." |

### Maintain terminology consistency

Inconsistent terminology multiplies translation costs. If you call something a "deployment" in one paragraph and a "release" in the next, translators may produce two different translations—and readers will think you're describing two different things.

**Build a terminology glossary** (see [consistency standards](08-consistency-standards-and-enforcement.md)) that includes:
- The preferred term in the source language
- A definition
- Approved translations (if you have them)
- Terms to avoid (with reasons)

### Handle code and UI strings

Code elements, commands, and UI labels typically shouldn't be translated:

- **Code elements:** Keep function names, class names, and variable names in English
- **Commands:** `docker run`, `npm install` — always in English
- **UI labels:** If the UI hasn't been localized, keep the English label. If it has, use the localized label.
- **Placeholders:** Use clearly marked placeholders: `YOUR_API_KEY`, `<resource-name>`

When referencing UI elements that may be localized, consider providing both the English and a description:

> Select **Settings** (the gear icon) to open the configuration panel.

The description ("the gear icon") helps users whose interface is in a different language.

### AI-assisted translation

AI tools can help with translation workflows, but they require careful oversight:

- **Draft translations** — AI provides reasonable first drafts, but human review is essential for technical accuracy
- **Terminology consistency** — AI can check whether translations use approved terms
- **Cultural adaptation** — AI can suggest localization changes, but cultural nuance requires human judgment
- **Back-translation** — Translate the translation back to English to check for meaning loss

For more on AI-assisted documentation workflows, see [AI-enhanced documentation writing](07-ai-enhanced-documentation-writing.md).

## Cultural adaptation and sensitivity 🧪

### Beyond language: cultural dimensions

<mark>Cultural adaptation</mark> goes beyond word-for-word translation. Content that works in one culture may confuse or offend in another.

**Key dimensions to consider:**

| Dimension | Example | Impact on documentation |
|---|---|---|
| **Formality** | German readers expect formal address; US readers expect casual | Voice and tone adjustments |
| **Directness** | Some cultures prefer indirect communication | How you phrase warnings and errors |
| **Visual meaning** | Colors have different associations (red = luck in China, danger in the West) | Diagram and highlight choices |
| **Reading direction** | Arabic and Hebrew read right-to-left | Layout and screenshot considerations |
| **Name formats** | Family name first (East Asian) vs. given name first (Western) | Example data |

### Names and example data

Use globally recognizable example names, or better yet, use a diverse set:

- ❌ "John Smith" everywhere (assumes Western naming conventions)
- ✅ Mix of names from different cultures: "Priya Sharma," "Carlos Rivera," "Yuki Tanaka," "Amara Okafor"
- ✅ Use `user@example.com` for email addresses (avoids name choices entirely)

### Address and location examples

When you need address examples:

- ❌ US-only addresses (123 Main Street, Anytown, USA)
- ✅ Vary examples or use clearly fictional/generic formats
- ✅ When demonstrating address validation, acknowledge that formats vary worldwide

### Color and symbols

Don't rely on color alone to convey meaning (this is also an [accessibility requirement](03-accessibility-in-technical-writing.md)):

- ❌ "Green items are approved, red items need review"
- ✅ "Items marked **Approved** (✅) are ready. Items marked **Needs review** (⚠️) require changes."

Symbols can have different meanings in different cultures—when in doubt, pair them with text labels.

## Tooling and automation ⚙️

### Linting for global-readiness

You can use automated tools to catch many global-readiness issues:

**Vale rules for global writing:**

```yaml
# .vale/styles/Global/NoIdioms.yml
extends: existence
message: "Avoid idioms for global audiences: '%s'. Use a plain alternative."
level: warning
tokens:
  - hit the ground running
  - out of the box
  - low-hanging fruit
  - ballpark figure
  - at the end of the day
  - move the needle
  - boil the ocean
  - back to square one
```

```yaml
# .vale/styles/Global/IncludeArticles.yml
extends: existence
message: "Consider adding an article before '%s' for clarity."
level: suggestion
scope: sentence
tokens:
  - "Select button"
  - "Open file"
  - "Enter value"
  - "Click link"
```

### Translation-readiness checklist

Before sending content for translation, verify:

- [ ] All sentences follow SVO order
- [ ] Articles (a, an, the) are present
- [ ] Relative pronouns (that, who, which) are included
- [ ] No idioms, slang, or culture-specific references
- [ ] Dates use spelled-out month names
- [ ] Times include time zones
- [ ] Currency symbols include ISO codes
- [ ] Code elements are marked as non-translatable
- [ ] Terminology matches the project glossary
- [ ] Pronouns have clear, unambiguous referents
- [ ] Sentences are 15-25 words on average
- [ ] Humor and wordplay have been removed

### Machine translation quality assessment

If you use machine translation, evaluate quality with:

- **BLEU score** — Compares MT output against reference translations (automated)
- **Human evaluation** — Native speakers rate fluency and adequacy (manual)
- **Back-translation** — Translate MT output back to source language and compare (quick check)
- **Task-based testing** — Can readers complete tasks using the translated documentation? (gold standard)

## Applying global writing to this repository 📌

This repository follows several global-ready conventions already—and has room to improve.

### What's already in place

- **Microsoft voice principles** — The conversational but clear tone works well internationally
- **Sentence-style capitalization** — Simpler for non-native readers than title case
- **Plain language** — Existing guidance on word choice and sentence length
- **Contractions** — Used per Microsoft style; the contraction policy is consistent
- **Emoji with text labels** — The 📘📗📒📕 reference classification system pairs emoji with text (e.g., "[Official]")

### Opportunities for improvement

- **Idiom audit** — Review existing articles for idioms that slipped through
- **Article and pronoun check** — Ensure articles and relative pronouns aren't dropped for brevity
- **Date format review** — Verify all dates use spelled-out months (particularly in examples)
- **Terminology glossary** — The glossary from [consistency standards](08-consistency-standards-and-enforcement.md) should include translation guidance
- **Vale rules** — Add global-readiness linting rules to the repository's Vale configuration

### Cross-references to related series content

Several articles in this series cover related topics from different angles:

| Article | Related global-readiness content |
|---|---|
| [01 — Writing style](01-writing-style-and-voice-principles.md) | Google's "Write for a global audience" philosophy; contraction policies |
| [03 — Accessibility](03-accessibility-in-technical-writing.md) | Plain language for non-native speakers; cultural emoji considerations |
| [07 — AI-enhanced writing](07-ai-enhanced-documentation-writing.md) | AI translation capabilities and limitations |
| [08 — Consistency](08-consistency-standards-and-enforcement.md) | Terminology glossaries; consistent naming across documents |
| [MS 02 — Mechanics](microsoft-writing-style-guide/02-microsoft-mechanics-and-formatting.md) | Global-ready writing rules; date/time formatting; idiom avoidance |

## Conclusion ✅

Global-ready writing isn't a separate skill—it's a refinement of good writing practices. Clear sentences, explicit grammar, consistent terminology, and cultural awareness make documentation better for *all* readers, not just international ones.

### Key Takeaways

- **Write for translation, even if you don't plan to translate** — The practices that help translators also help non-native English readers
- **Include articles and relative pronouns** — Don't sacrifice grammatical signals for perceived brevity
- **Avoid idioms, humor, and cultural references** — They create barriers that readers can't see past
- **Spell out dates, specify currencies, include time zones** — Small formatting choices prevent large misunderstandings
- **Maintain consistent terminology** — Inconsistency multiplies translation costs and reader confusion
- **Use tools to automate checks** — Vale rules and checklists catch issues before readers encounter them

### Next Steps

- **Previous article:** [08-consistency-standards-and-enforcement.md](08-consistency-standards-and-enforcement.md) — Terminology glossaries that support global writing
- **Related:** [03-accessibility-in-technical-writing.md](03-accessibility-in-technical-writing.md) — Plain language and cognitive accessibility
- **Related:** [01-writing-style-and-voice-principles.md](01-writing-style-and-voice-principles.md) — Sentence structure and readability fundamentals

## References 📚

### Official documentation

**[Microsoft Global Communications](https://learn.microsoft.com/en-us/style-guide/global-communications/)** 📘 [Official]  
Microsoft's official guidance on writing for worldwide audiences. Covers localization, culture-neutral content, and machine translation readiness. The primary reference for global-ready writing in Microsoft documentation.

**[Google: Write for a Global Audience](https://developers.google.com/style/translation)** 📘 [Official]  
Google's comprehensive guidance on writing translation-friendly developer documentation. Covers phrasal verbs, sentence structure, consistency, and inclusivity. Excellent practical examples.

**[W3C Internationalization Activity](https://www.w3.org/international/)** 📘 [Official]  
W3C's work on ensuring the web supports all languages and cultures. Provides foundational standards for internationalization of web content.

**[Microsoft International Style Guides](https://learn.microsoft.com/en-us/globalization/reference/microsoft-style-guides)** 📘 [Official]  
Language-specific style guides for Microsoft content localization. Covers over 100 languages with detailed guidance on terminology, grammar, and cultural conventions.

**[Plain Language Action and Information Network (PLAIN)](https://www.plainlanguage.gov/)** 📘 [Official]  
US government plain language guidelines. Clear writing principles that naturally support international readability.

### Verified community resources

**[The Global English Style Guide](https://www.sas.com/en_us/publications/global-english-style-guide.html)** 📗 [Verified Community]  
John R. Kohl's authoritative book on writing clear, translatable documentation for global markets. The foundational reference for controlled English and translation-optimized writing.

**[Write the Docs — Writing for Translation](https://www.writethedocs.org/guide/writing/style-guides/)** 📗 [Verified Community]  
Community-maintained resources on documentation style guides, including guidance on writing for translatable content.

### Repository-specific documentation

**[Documentation Instructions](../../.github/instructions/documentation.instructions.md)** [Internal Reference]  
This repository's formatting, structure, and reference standards.

**[Article Writing Instructions](../../.github/instructions/article-writing.instructions.md)** [Internal Reference]  
Comprehensive writing guidance including plain language rules and accessibility requirements.

**[Consistency Standards](08-consistency-standards-and-enforcement.md)** [Internal Reference]  
Terminology glossary and consistency enforcement patterns that support translation workflows.

---

<!--
article_metadata:
  filename: "12-writing-for-global-audiences.md"
  series: "Technical Documentation Excellence"
  series_position: 13
  total_articles: 13
  prerequisites:
    - "01-writing-style-and-voice-principles.md"
    - "03-accessibility-in-technical-writing.md"
  related_articles:
    - "01-writing-style-and-voice-principles.md"
    - "03-accessibility-in-technical-writing.md"
    - "07-ai-enhanced-documentation-writing.md"
    - "08-consistency-standards-and-enforcement.md"
    - "microsoft-writing-style-guide/02-microsoft-mechanics-and-formatting.md"
  version: "1.0"
  last_updated: "2026-02-28"

validations:
  grammar:
    status: "not_run"
    last_run: null
  readability:
    status: "not_run"
    last_run: null
  structure:
    status: "not_run"
    last_run: null
  facts:
    status: "not_run"
    last_run: null
  logic:
    status: "not_run"
    last_run: null
  coverage:
    status: "not_run"
    last_run: null
  references:
    status: "not_run"
    last_run: null
-->
