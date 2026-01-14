---
# Quarto Metadata
title: "Writing Style and Voice Principles"
author: "Dario Airoldi"
date: "2026-01-14"
categories: [technical-writing, style, voice, readability, grammar]
description: "Comprehensive guide to writing style, voice, and tone in technical documentation, comparing Microsoft, Google, and Wikipedia approaches with practical before/after examples"
---

# Writing Style and Voice Principles

> Master active voice, sentence structure, readability formulas, and tone to create clear, accessible technical documentation that resonates with your audience

## Table of Contents

- [Introduction](#introduction)
- [Active vs. Passive Voice](#active-vs-passive-voice)
- [Readability Formulas Explained](#readability-formulas-explained)
- [Sentence Structure and Length](#sentence-structure-and-length)
- [Voice Guidelines: Microsoft vs. Google vs. Wikipedia](#voice-guidelines-microsoft-vs-google-vs-wikipedia)
- [Person Usage (First, Second, Third)](#person-usage-first-second-third)
- [Tone and Register](#tone-and-register)
- [Common Voice Pitfalls](#common-voice-pitfalls)
- [Applying Style Principles to This Repository](#applying-style-principles-to-this-repository)
- [Conclusion](#conclusion)
- [References](#references)

## Introduction

Voice and style form the personality of your documentation. While content accuracy ensures correctness, voice determines whether readers can **understand**, **trust**, and **act on** that information.

This article explores:

- **<mark>Active vs. passive voice</mark>** - When to use each and why Microsoft, Google, and Wikipedia differ
- **<mark>Readability formulas</mark>** - Understanding Flesch-Kincaid scores and this repository's 50-70 target
- **<mark>Sentence structure</mark>** - Why 15-25 words per sentence improves comprehension
- **<mark>Comparative analysis</mark>** - How major style guides approach voice differently
- **<mark>Practical examples</mark>** - Before/after transformations showing principles in action

**Prerequisites:** Understanding of [foundational documentation principles](00-foundations-of-technical-documentation.md) is helpful but not required.

## Active vs. Passive Voice

Voice refers to the relationship between the subject and verb in a sentence. This seemingly simple grammatical choice profoundly affects clarity, tone, and reader engagement.

### Definitions and Examples

**Active voice:** Subject performs the action
- Structure: `[Subject] [Verb] [Object]`
- Example: "The developer **writes** the code."
- Emphasis: Who/what is doing something

**Passive voice:** Subject receives the action
- Structure: `[Object] [is/was] [Verb-ed] [by Subject]`
- Example: "The code **is written** by the developer."
- Emphasis: What is being done

### When to Use Active Voice

**Clarity and directness** - Active voice makes actors explicit

❌ **Passive (unclear):**
> "The API should be initialized before any requests are made."

✅ **Active (clear):**
> "Initialize the API before you make any requests."

**Responsibility and agency** - Active voice assigns accountability

❌ **Passive (vague):**
> "An error was encountered during deployment."

✅ **Active (specific):**
> "The deployment script encountered an error."
> Or better: "You encountered an error during deployment."

**Brevity** - Active constructions are typically shorter

❌ **Passive (wordy - 11 words):**
> "The configuration file must be updated by the administrator."

✅ **Active (concise - 7 words):**
> "The administrator must update the configuration file."
> Or: "Update the configuration file."

### When Passive Voice Is Acceptable

**Actor is unknown or irrelevant**

✅ **Appropriate passive:**
> "The server was compromised at 3:00 AM."
> (Who compromised it is unknown)

**Emphasis on the object, not the actor**

✅ **Appropriate passive:**
> "Python was released in 1991."
> (Focus on Python's history, not Guido van Rossum's action)

**Scientific or encyclopedic tone** (Wikipedia preference)

✅ **Appropriate passive:**
> "The data was collected over six months."
> (Scientific detachment, methodology focus)

**Avoiding accusatory tone**

✅ **Appropriate passive:**
> "The file was deleted accidentally."
> (Less accusatory than "You deleted the file accidentally")

### Style Guide Comparison: Voice Usage

| Guide | Active Voice Preference | Passive Voice Guidance | Rationale |
|-------|------------------------|------------------------|-----------|
| **<mark>Microsoft</mark>** | Strong preference | Allow when appropriate | "Active voice makes writing more direct and vigorous" |
| **<mark>Google</mark>** | Very strong preference | Use sparingly | "Active voice is typically more direct and vigorous" |
| **<mark>Apple</mark>** | Strong preference | Acceptable in specific contexts | "Active voice creates more engaging content" |
| **<mark>Wikipedia</mark>** | No strong preference | Both widely used | "Passive appropriate for encyclopedic tone, avoiding first/second person" |

### Before/After Examples

**Example 1: Procedural instruction**

❌ **Passive and wordy:**
> "After the installation has been completed by the user, the configuration wizard will be launched automatically and the initial settings should be reviewed carefully before the application is started."

✅ **Active and clear:**
> "After you install the software, the configuration wizard launches automatically. Review the initial settings before you start the application."

**Example 2: Error message**

❌ **Passive and vague:**
> "An invalid parameter was provided."

✅ **Active and specific:**
> "You provided an invalid parameter. Check the API documentation for valid values."

**Example 3: Technical reference (passive acceptable)**

✅ **Passive (appropriate for reference material):**
> "The function is called when the event fires. Three arguments are passed: event type, timestamp, and payload."

**Example 4: Tutorial (active preferred)**

✅ **Active (appropriate for learning):**
> "Call the function when the event fires. Pass three arguments: event type, timestamp, and payload."

### Detecting Passive Voice

**Linguistic test:** Can you insert "by zombies" after the verb?
- "The code was written [by zombies]" → Passive
- "The developer writes the code [by zombies]" → Doesn't work, so active

**Automated detection:** This repository's validation system flags excessive passive voice through grammar analysis.

## Readability Formulas Explained

Readability formulas quantify text complexity, helping ensure documentation matches audience capabilities.

### Flesch Reading Ease Score

**Formula:** `206.835 - (1.015 × ASL) - (84.6 × ASW)`
- ASL = Average Sentence Length (words per sentence)
- ASW = Average Syllables per Word

**Score interpretation:**

| Score Range | Difficulty | Typical Reader | Example Context |
|-------------|------------|----------------|-----------------|
| 90-100 | Very Easy | 11-year-old | Children's books |
| 80-89 | Easy | 13-year-old | Young adult fiction |
| 70-79 | Fairly Easy | 15-year-old | Magazines |
| **60-69** | **Standard** | **17-18 year-old** | **General documentation** |
| **50-59** | **Fairly Difficult** | **College level** | **Technical documentation** |
| 30-49 | Difficult | College graduate | Academic papers |
| 0-29 | Very Difficult | Professional | Legal, scientific journals |

**This repository's target: 50-70**
- **Rationale:** Balances technical precision with accessibility
- **Lower bound (50):** Allows necessary technical complexity
- **Upper bound (70):** Ensures general technical audience comprehension

**Why we validate Flesch scores:**

From [validation-criteria.md](../../.copilot/context/validation-criteria.md):
```yaml
readability:
  flesch_reading_ease:
    target_range: [50, 70]
    minimum_acceptable: 40
    rationale: "Technical content requires precision, but must remain accessible"
```

### Flesch-Kincaid Grade Level

**Formula:** `(0.39 × ASL) + (11.8 × ASW) - 15.59`

**Score interpretation:**
- Score = US grade level required to understand the text
- Example: Score of 10 = 10th grade reading level

**This repository's target: 9-10**
- Equivalent to Flesch Reading Ease 50-70
- Indicates high school to early college reading level

### Gunning Fog Index

**Formula:** `0.4 × [(ASL) + 100 × (Complex Words / Total Words)]`
- Complex Words = words with 3+ syllables

**Interpretation:** Years of formal education required

**Typical ranges for technical documentation:**
- 8-10: Accessible technical writing
- 11-14: Standard technical documentation
- 15+: Dense academic/specialist writing

### Why Readability Matters: Cognitive Load

**Cognitive load theory** explains that working memory has limited capacity (typically 7±2 "chunks" of information).

**Factors increasing cognitive load:**
- Long sentences (>30 words)
- Complex vocabulary (multi-syllable technical terms)
- Dense paragraph structure
- Passive voice constructions
- Abstract concepts without examples

**Strategies reducing cognitive load:**
- Shorter sentences (15-25 words)
- Familiar words when possible
- Transitional phrases between ideas
- Active voice (fewer words, clearer actors)
- Concrete examples illustrating abstractions

### Readability Formula Limitations

**Formulas cannot measure:**
- Technical accuracy
- Logical coherence
- Appropriate level of detail
- Cultural context
- Visual design impact

**They are indicators, not mandates:**

✅ **Good use of readability scores:**
> "This section has a Flesch score of 35 (difficult). Can we simplify the language or add examples?"

❌ **Bad use of readability scores:**
> "This section must have a Flesch score of exactly 60. Replace all multi-syllable words."

**Repository principle:** Readability scores inform validation, but technical accuracy always takes precedence. See [validation workflow](../../.github/prompts/readability-review.prompt.md).

## Sentence Structure and Length

Sentence length directly affects comprehension. Research shows optimal sentence length for technical documentation is **15-25 words**.

### Why 15-25 Words?

**Psychological research:** Reading comprehension drops significantly beyond 25 words per sentence
- Reader must hold more information in working memory
- Clause relationships become harder to track
- Readers may need to re-read for understanding

**Practical testing:** Major tech companies' analysis shows 15-25 words optimizes:
- Reading speed
- Comprehension accuracy
- User satisfaction with documentation

### Sentence Type Distribution

Effective technical writing mixes sentence types:

**Simple sentences** (1 independent clause)
- Best for critical information
- Example: "Save your work before closing the application."
- Use: 40-50% of sentences

**Compound sentences** (2+ independent clauses, coordinating conjunction)
- Connect related ideas of equal importance
- Example: "The function returns an object, and the object contains three properties."
- Use: 20-30% of sentences

**Complex sentences** (1 independent + 1+ dependent clause)
- Show relationships between ideas
- Example: "When the user clicks the button, the form validates all input fields."
- Use: 20-30% of sentences

**Compound-complex sentences** (2+ independent + 1+ dependent)
- Use sparingly, risk comprehension
- Example: "When you initialize the API, it loads the configuration, and then it establishes a connection."
- Use: 0-10% of sentences

### Before/After: Sentence Length Optimization

**Example 1: Breaking up a 45-word monster**

❌ **Too long (45 words, Flesch ~35):**
> "The authentication system provides OAuth 2.0 support which allows users to authenticate using their existing social media accounts including Facebook, Google, and Twitter, and the implementation follows the authorization code flow pattern to ensure security."

✅ **Optimized (3 sentences, 15-16 words each, Flesch ~60):**
> "The authentication system supports OAuth 2.0. Users can authenticate using Facebook, Google, or Twitter accounts. The implementation follows the authorization code flow for security."

**Example 2: Combining choppy short sentences**

❌ **Too choppy (4-6 words each, Flesch ~80 but immature tone):**
> "Open the file. Click Save. The file saves. A confirmation appears."

✅ **Optimized (combined, 18 words total, Flesch ~65):**
> "Open the file and click Save. The file saves, and a confirmation message appears."

**Example 3: Balancing technical complexity**

❌ **Dense single sentence (52 words, Flesch ~25):**
> "To configure the load balancer to distribute incoming HTTP requests across multiple backend servers while maintaining session affinity through cookie-based tracking and implementing health checks that automatically remove unresponsive servers from the rotation, follow these steps."

✅ **Optimized (3 sentences, ~17 words each, Flesch ~55):**
> "This section explains how to configure the load balancer for HTTP requests. The configuration includes session affinity via cookies and automatic health checks. Health checks remove unresponsive servers from rotation."

## Voice Guidelines: Microsoft vs. Google vs. Wikipedia

Different organizations prioritize different aspects of voice. Understanding these priorities helps you make informed decisions.

### Microsoft Writing Style Guide Approach

**Core philosophy:** "Write like you speak"

**Voice characteristics:**
- **Person:** Second person (you) throughout
- **Tone:** Conversational but professional
- **Contractions:** Acceptable ("don't" not "do not")
- **Sentence length:** "Short sentences are powerful"

**Examples from Microsoft documentation:**

✅ **Conversational Microsoft style:**
> "You can use Azure Functions to run code without managing servers. When an event triggers your function, it runs in a fully managed environment."

**Microsoft's rationale:**
- Users feel directly addressed
- Reduces formality barrier
- Increases engagement with content
- Mirrors how developers actually speak

### Google Developer Documentation Approach

**Core philosophy:** "Write for a global audience"

**Voice characteristics:**
- **Person:** Second person (you)
- **Tone:** Friendly but precise
- **Contractions:** Avoided for international clarity
- **Sentence length:** Very short, scannable

**Examples from Google documentation:**

✅ **Clear Google style:**
> "Use Cloud Functions to deploy code without managing servers. Cloud Functions runs your code when an event triggers it."

**Google's distinctive elements:**
- No contractions (international readers)
- Ultra-short sentences (mobile-first)
- Product names as subjects (not "it")
- Explicit over implicit

**Google vs. Microsoft comparison:**

| Aspect | Microsoft | Google |
|--------|-----------|---------|
| "You can't configure..." | ✅ Acceptable | ❌ Use "You cannot..." |
| "It automatically scales" | ✅ Acceptable | ❌ Use "[Service name] automatically scales" |
| Sentence avg. | 18-22 words | 12-18 words |
| Paragraph length | 4-6 sentences | 2-4 sentences |

### Wikipedia Manual of Style Approach

**Core philosophy:** "Encyclopedic neutrality"

**Voice characteristics:**
- **Person:** Third person only
- **Tone:** Neutral, academic
- **Contractions:** Never
- **Sentence length:** Varies, completeness valued over brevity

**Wikipedia rules:**
- ❌ "You should back up your data"
- ✅ "Users should back up their data" or "Data should be backed up"
- ❌ "We recommend..."
- ✅ "Experts recommend..." or "According to [source]..."

**When Wikipedia's approach is appropriate:**

✅ **For encyclopedic content:**
> "The Model-View-Controller (MVC) pattern separates concerns into three interconnected components. The model manages data, the view displays the interface, and the controller handles user input."

✅ **For historical/technical background:**
> "REST was introduced by Roy Fielding in his 2000 doctoral dissertation. The architectural style emphasizes stateless communication and resource-based interactions."

❌ **Not appropriate for procedural content:**
> "The user should open the terminal and type the command. The system will display output."
> *(Awkward for instructions)*

### Comparison Table: Voice Across Style Guides

| Element | Microsoft 📘 | Google 📘 | Wikipedia 📘 | This Repository |
|---------|--------------|-----------|--------------|-----------------|
| **Primary person** | Second (you) | Second (you) | Third person | Second (procedural), Third (concepts) |
| **Contractions** | Yes | No | No | Minimal |
| **Sentence avg. length** | 18-22 words | 12-18 words | Varies (20-30) | 15-25 words |
| **Active voice %** | 80-90% | 85-95% | 60-70% | 75-85% |
| **Tone** | Conversational | Friendly-precise | Neutral-academic | Professional-accessible |
| **Technical terms** | Define on first use | Link to glossary | Link to related articles | Define + link |

## Person Usage (First, Second, Third)

Person choice fundamentally affects tone and reader relationship with content.

### First Person (I, We, Us)

**Appropriate contexts:**

✅ **Tutorials (plural "we" as guide):**
> "In this tutorial, we'll build a REST API from scratch. We'll start with basic routing, then add authentication."

✅ **Author's note in explanation:**
> "I recommend starting with the simpler approach before attempting the optimized version."

✅ **Open-source project documentation (community "we"):**
> "We welcome contributions from developers worldwide. We review pull requests within 48 hours."

**Inappropriate contexts:**

❌ **Reference documentation:**
> "We provide three authentication methods..." *(system provides, not "we")*

❌ **How-to guides:**
> "We need to configure the settings..." *(reader configures, not collective "we")*

### Second Person (You, Your)

**Appropriate contexts:**

✅ **Procedural instructions:**
> "You must install Node.js before you run the application."

✅ **Conditional guidance:**
> "If you need real-time updates, use WebSockets instead of HTTP polling."

✅ **Troubleshooting:**
> "If you see error 404, check your URL configuration."

**Inappropriate contexts:**

❌ **Encyclopedic content:**
> "You can find REST in many modern APIs..." *(encyclopedias don't address readers)*

❌ **Reference definitions:**
> "The function accepts three parameters you pass..." *(reference describes, doesn't instruct)*

### Third Person (User, Developer, System)

**Appropriate contexts:**

✅ **API reference:**
> "The function returns null when the user provides an invalid parameter."

✅ **Conceptual explanation:**
> "Developers choose NoSQL databases when the data model requires flexibility."

✅ **System behavior:**
> "The application validates input before processing the request."

**Inappropriate contexts:**

❌ **Step-by-step instructions:**
> "The user should click the button and enter their password." *(second person clearer)*

### Repository Guidelines

Based on [documentation.instructions.md](../../.github/instructions/documentation.instructions.md):

| Content Type | Preferred Person | Rationale |
|--------------|------------------|-----------|
| **Tutorials** | Second (you) + occasional plural first (we) | Direct instruction + guidance |
| **How-to guides** | Second (you) | Action-oriented clarity |
| **Reference** | Third person | Objective description |
| **Explanation** | Third person + educational first plural (we) | Neutral analysis + shared exploration |
| **Validation prompts** | Second (addressing the model) | Clear agent instructions |

## Tone and Register

Tone conveys attitude; register indicates formality level. Both should match audience expectations and content purpose.

### Tone Spectrum for Technical Documentation

**Formal ← → Conversational**

| Tone | Example | Appropriate Context |
|------|---------|---------------------|
| **Formal** | "One must ensure data persistence prior to system termination." | Academic papers, standards documents |
| **Professional** | "Save your work before closing the application." | Enterprise documentation, official guides |
| **Conversational** | "Don't forget to save before you close!" | Tutorials, blog-style content |
| **Casual** | "Make sure you hit that save button!" | Community forums, chat documentation |

**Repository standard:** Professional with occasional conversational warmth in tutorials

### Adjusting Tone by Content Type

**Reference material:** Austere, factual
> "**Parameters**  
> - `userId` (string, required): Unique identifier  
> - `options` (object, optional): Configuration object  
> **Returns:** User object or null"

**How-to guide:** Professional, direct
> "To authenticate users, configure the authentication provider in `appsettings.json`. Add your client ID and secret to the configuration object."

**Tutorial:** Warmer, encouraging
> "Great! You've configured your first authentication provider. In the next section, we'll test it with a sample user login."

**Explanation:** Neutral, analytical
> "OAuth 2.0 separates authentication from authorization, allowing third-party applications to access user resources without exposing credentials."

### Avoiding Problematic Tones

**Condescending:**
❌ "Obviously, you should always validate input."
❌ "It's simple: just follow these twelve steps."
❌ "Even a beginner knows to check for errors."

**Presumptuous:**
❌ "You probably want to use React for this."
❌ "Most developers prefer..."
❌ "Clearly, this is the best approach."

**Apologetic:**
❌ "Sorry for the confusion, but..."
❌ "Unfortunately, you'll have to..."
❌ "We apologize for the complicated setup."

**Overly casual:**
❌ "This API is super awesome!"
❌ "Just throw your code in here and you're good to go."
❌ "LOL, debugging is the worst, right?"

### Wikipedia's Words to Watch

Wikipedia identifies problematic [words that undermine neutrality](https://en.wikipedia.org/wiki/Wikipedia:Manual_of_Style/Words_to_watch):

**Peacock terms** (unjustified praise):
- ❌ "elegant solution," "groundbreaking," "world-class"
- ✅ Provide evidence: "The algorithm reduces time complexity from O(n²) to O(n log n)"

**Weasel words** (vague attribution):
- ❌ "Some experts think," "it is widely believed," "many developers say"
- ✅ Specific attribution: "According to the 2024 Stack Overflow survey, 38% of developers..."

**Editorial comments**:
- ❌ "Note that," "obviously," "clearly," "of course"
- ✅ State facts directly without meta-commentary

**Repository application:** Our validation system flags these patterns through logic and fact-checking dimensions.

## Common Voice Pitfalls

### Pitfall 1: Mixing Person

❌ **Inconsistent:**
> "You should configure the API key. Users can then authenticate. One must ensure the secret remains private."

✅ **Consistent:**
> "Configure your API key. You can then authenticate. Ensure your secret remains private."

### Pitfall 2: Nominalizations (Zombie Nouns)

**Nominalization:** Converting verbs to nouns, creating wordiness

❌ **Nominalized (passive, wordy):**
> "The implementation of the optimization was done to achieve a reduction in latency."

✅ **Active verbs:**
> "We implemented the optimization to reduce latency."

**Common nominalizations to avoid:**

| Nominalization | Better Verb |
|----------------|-------------|
| "Make a decision" | "Decide" |
| "Perform an analysis" | "Analyze" |
| "Conduct an investigation" | "Investigate" |
| "Achieve implementation" | "Implement" |

### Pitfall 3: Hedging Language

Excessive hedging undermines authority:

❌ **Over-hedged:**
> "You might possibly want to perhaps consider potentially using the cache, which could maybe improve performance somewhat."

✅ **Confident (still accurate):**
> "Using the cache improves performance in most scenarios."

**Appropriate hedging** (when uncertainty is real):
✅ "Performance may vary depending on network conditions."

### Pitfall 4: Anthropomorphizing Technology

❌ **Anthropomorphized:**
> "The API wants you to provide credentials."
> "The function is happy to accept three parameters."
> "The system thinks your input is invalid."

✅ **Factual:**
> "The API requires credentials."
> "The function accepts three parameters."
> "The system rejects invalid input."

### Pitfall 5: Buried Verbs

**Buried verb:** Hidden in a noun phrase

❌ **Buried:**
> "We are in agreement that validation is a requirement."

✅ **Direct:**
> "We agree that validation is required."

More examples:

| Buried Verb | Direct |
|-------------|--------|
| "Came to a realization" | "Realized" |
| "Made an assumption" | "Assumed" |
| "Reached a conclusion" | "Concluded" |
| "Give consideration to" | "Consider" |

## Applying Style Principles to This Repository

### Voice Standards from Documentation Instructions

From [documentation.instructions.md](../../.github/instructions/documentation.instructions.md):

**Active voice preference:**
```markdown
Target: 75-85% active voice
Rationale: Clarity and directness while allowing 
           passive voice when appropriate
```

**Sentence length target:**
```markdown
Range: 15-25 words per sentence
Maximum: 30 words (exceptions for complex technical descriptions)
Rationale: Optimizes comprehension without oversimplification
```

**Readability scores:**
```markdown
Flesch Reading Ease: 50-70 (fairly difficult to standard)
Flesch-Kincaid Grade: 9-10 (high school level)
Rationale: Technical precision + accessibility
```

### Validation Workflow

Our validation system enforces style principles through automated and human review:

**Grammar validation** ([grammar-review.prompt.md](../../.github/prompts/grammar-review.prompt.md)):
- Active vs. passive voice ratio
- Person consistency within sections
- Sentence length distribution

**Readability validation** ([readability-review.prompt.md](../../.github/prompts/readability-review.prompt.md)):
- Flesch Reading Ease score
- Flesch-Kincaid Grade Level
- Average sentence length
- Complex word percentage

**Logic validation** ([logic-analysis.prompt.md](../../.github/prompts/logic-analysis.prompt.md)):
- Hedging language patterns
- Nominalizations
- Anthropomorphized technology

See [05-validation-and-quality-assurance.md](05-validation-and-quality-assurance.md) for complete validation system documentation.

### Style Evolution

Documentation style evolves based on:
- User feedback on comprehension
- Readability metrics from validation
- Comparative analysis with authoritative sources
- Community standards in technical writing

**Living document principle:** Style guidelines adapt as best practices emerge, while maintaining consistency within existing content.

## Conclusion

Voice and style fundamentally shape documentation effectiveness. Key takeaways:

**Active voice matters** - Use it 75-85% of the time for clarity, but embrace passive voice when appropriate (scientific tone, unknown actor, emphasis on object)

**Readability is measurable** - Flesch scores 50-70 and sentence lengths 15-25 words optimize technical comprehension without oversimplification

**Style guides differ intentionally** - Microsoft favors conversational warmth, Google emphasizes global clarity, Wikipedia requires neutral encyclopedic tone - choose based on audience and content type

**Person consistency matters** - Second person (you) for instructions, third person for reference, first person plural (we) sparingly for tutorials

**Tone should match purpose** - Professional for how-to guides, austere for reference, warmer for tutorials, neutral for explanation

**Common pitfalls are avoidable** - Watch for person mixing, nominalizations, excessive hedging, anthropomorphizing, and buried verbs

**This repository synthesizes principles** - Validation system enforces voice standards while allowing appropriate flexibility

**Next in series:**

- [02-structure-and-information-architecture.md](02-structure-and-information-architecture.md) - Progressive disclosure, LATCH framework, TOC strategies
- [05-validation-and-quality-assurance.md](05-validation-and-quality-assurance.md) - How validation operationalizes these principles
- [00-foundations-of-technical-documentation.md](00-foundations-of-technical-documentation.md) - Framework context for voice decisions

## References

### Official Style Guides

**[Microsoft Writing Style Guide - Top 10 Tips](https://learn.microsoft.com/style-guide/top-10-tips-style-voice)** 📘 [Official]  
Core voice and style principles including "write like you speak" and active voice preference.

**[Google Developer Documentation Style Guide - Voice and Tone](https://developers.google.com/style/tone)** 📘 [Official]  
Guidance on conversational but professional tone for global developer audiences.

> **📚 Deep Dive:** For comprehensive Microsoft voice principles (warm/relaxed, crisp/clear, ready to help), contractions usage, and bias-free language, see the dedicated [Microsoft Voice and Tone Analysis](Microsoft%20Writing%20Style%20Guide/01-microsoft-voice-and-tone.md).

**[Wikipedia Manual of Style - Grammar and Usage](https://en.wikipedia.org/wiki/Wikipedia:Manual_of_Style#Grammar_and_usage)** 📘 [Official]  
Encyclopedic voice standards including third person preference and passive voice usage.

**[Wikipedia Manual of Style - Words to Watch](https://en.wikipedia.org/wiki/Wikipedia:Manual_of_Style/Words_to_watch)** 📘 [Official]  
Comprehensive guide to problematic words including peacock terms, weasel words, and editorial language.

### Readability and Cognitive Load

**[Flesch Reading Ease - Wikipedia](https://en.wikipedia.org/wiki/Flesch%E2%80%93Kincaid_readability_tests)** 📘 [Official]  
Technical explanation of Flesch-Kincaid readability formulas and scoring interpretation.

**[Plain Language Guidelines - Federal Plain Language](https://www.plainlanguage.gov/guidelines/)** 📘 [Official]  
US government standards for clear, accessible writing including readability targets.

**[Cognitive Load Theory - Wikipedia](https://en.wikipedia.org/wiki/Cognitive_load)** 📗 [Verified Community]  
Psychological foundation for understanding why sentence length and structure affect comprehension.

### Writing Technique Resources

**[The Elements of Style - Strunk & White](https://www.gutenberg.org/files/37134/37134-h/37134-h.htm)** 📗 [Verified Community]  
Classic writing guide emphasizing active voice, brevity, and clarity.

**[Chicago Manual of Style - Grammar](https://www.chicagomanualofstyle.org/book/ed17/part2/ch05/toc.html)** 📘 [Official]  
Authoritative grammar reference including detailed voice and mood guidance.

### Repository-Specific Documentation

**[Documentation Instructions - Voice and Tone](../../.github/instructions/documentation.instructions.md#voice-and-tone)** [Internal Reference]  
This repository's comprehensive voice guidelines with specific targets and rationale.

**[Validation Criteria - Readability](../../.copilot/context/validation-criteria.md#readability)** [Internal Reference]  
Flesch score targets (50-70), grade level (9-10), and sentence length standards (15-25 words).

**[Grammar Review Prompt](../../.github/prompts/grammar-review.prompt.md)** [Internal Reference]  
Validation prompt for checking active/passive voice, person consistency, and sentence structure.

**[Readability Review Prompt](../../.github/prompts/readability-review.prompt.md)** [Internal Reference]  
Validation prompt for analyzing Flesch scores, grade level, and readability optimization.

---

<!-- Validation Metadata
validation_status: pending_first_validation
article_metadata:
  filename: "01-writing-style-and-voice-principles.md"
  series: "Technical Documentation Excellence"
  series_position: 2
  total_articles: 8
  prerequisites:
    - "00-foundations-of-technical-documentation.md"
  related_articles:
    - "00-foundations-of-technical-documentation.md"
    - "05-validation-and-quality-assurance.md"
    - "03-accessibility-in-technical-writing.md"
  version: "1.0"
  last_updated: "2026-01-14"
-->
