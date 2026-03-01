---
# Quarto Metadata
title: "Accessibility in Technical Writing"
author: "Dario Airoldi"
date: "2026-01-14"
categories: [technical-writing, accessibility, wcag, inclusive-language, plain-language]
description: "Create accessible technical documentation through plain language principles, screen reader compatibility, inclusive language, and design considerations for neurodivergent readers"
---

# Accessibility in Technical Writing

> Ensure your technical documentation works for everyone—including users with disabilities, non-native speakers, and those using assistive technologies

## Table of Contents

- [🎯 Introduction](#-introduction)
- [❓ Why accessibility matters in documentation](#-why-accessibility-matters-in-documentation)
- [📝 Plain language principles](#-plain-language-principles)
- [🔊 Screen reader compatibility](#-screen-reader-compatibility)
- [🤝 Inclusive language](#-inclusive-language)
- [👁️ Visual accessibility](#-visual-accessibility)
- [🧠 Cognitive accessibility](#-cognitive-accessibility)
- [📖 Reading comprehension and learning styles](#-reading-comprehension-and-learning-styles)
- [😀 Emoji and symbol accessibility](#-emoji-and-symbol-accessibility)
- [🧪 Testing documentation accessibility](#-testing-documentation-accessibility)
- [📌 Applying accessibility to this repository](#-applying-accessibility-to-this-repository)
- [✅ Conclusion](#-conclusion)
- [📚 References](#-references)

## 🎯 Introduction

Accessible documentation isn't optional—it's essential. When we write technical content that some users can't access, understand, or navigate, we've failed in our primary purpose: communicating information.

This article covers:

- **Plain language** - Writing that works for diverse literacy levels and non-native speakers
- **Screen readers** - Ensuring compatibility with assistive technology
- **Inclusive language** - Avoiding bias and exclusionary terminology
- **Visual accessibility** - Color, contrast, and image alternatives
- **Cognitive accessibility** - Supporting neurodivergent readers, with concrete progressive disclosure examples
- **Reading comprehension and learning styles** - Adapting documentation for visual, auditory, reading/writing, and kinesthetic learners
- **Emoji accessibility** - How this repository's 📘📗📒📕 system works with assistive tech

**Legal context:** In many jurisdictions, accessible documentation is required by law (ADA, Section 508, EU Accessibility Act).

**Prerequisites:** Understanding of [writing style principles](01-writing-style-and-voice-principles.md) and [documentation structure](02-structure-and-information-architecture.md).

## ❓ Why accessibility matters in documentation

### The numbers

- **15% of the global population** has some form of disability (World Health Organization)
- **1 in 12 men** (8%) has color vision deficiency
- **Over 1 billion people** speak English as a second language
- **10-20% of the population** is neurodivergent (dyslexia, ADHD, autism spectrum)

### The benefits

**Accessibility improvements benefit everyone:**

| Accessibility Feature | Primary Beneficiary | Secondary Beneficiaries |
|----------------------|---------------------|------------------------|
| Plain language | Non-native speakers | Everyone (faster reading) |
| Alt text for images | Screen reader users | Users on slow connections |
| Clear headings | Screen reader navigation | All users (scannability) |
| Captions for video | Deaf users | Anyone in quiet environment |
| High contrast | Low vision users | Users in bright sunlight |
| Consistent structure | Cognitive disabilities | All users (predictability) |

### The standards

**WCAG (Web Content Accessibility Guidelines)** provides the foundation:

- **Perceivable:** Content can be perceived (seen, heard, felt)
- **Operable:** Interface can be operated by all users
- **Understandable:** Content and interface are understandable
- **Robust:** Content works with assistive technologies

Documentation should meet **WCAG 2.1 AA** at minimum.

## 📝 Plain language principles

Plain language makes content accessible to diverse readers including:
- People with reading difficulties
- Non-native English speakers
- Experts in other fields
- Users under time pressure

### The plain language guidelines

From the [Federal Plain Language Guidelines](https://www.plainlanguage.gov/guidelines/):

**1. Write for your audience**
- Identify who reads your documentation
- Use terminology they understand
- Address their actual questions

**2. Organize information logically**
- Put important information first
- Use headings that describe content
- Break content into manageable sections

**3. Use clear sentence structure**
- Keep sentences short (15-25 words)
- Use active voice
- Place subjects near their verbs

**4. Choose words carefully**
- Prefer common words over jargon
- Define technical terms when first used
- Avoid acronyms without expansion

### Before/after: plain language transformation

**Example 1: Developer documentation**

❌ **Complex:**
> "The authentication subsystem facilitates the implementation of credential verification mechanisms utilizing industry-standard protocols for the establishment of secure session contexts."

✅ **Plain language:**
> "The authentication system verifies user credentials using standard security protocols. Once verified, it creates a secure session."

**Example 2: Error message**

❌ **Complex:**
> "An irrecoverable exception has occurred during the execution of the data persistence operation due to the unavailability of required system resources."

✅ **Plain language:**
> "Cannot save data. The system ran out of memory. Close other applications and try again."

**Example 3: API documentation**

❌ **Complex:**
> "The endpoint necessitates the provision of authentication credentials in the form of a bearer token within the Authorization header of the HTTP request."

✅ **Plain language:**
> "Include your access token in the request header: `Authorization: Bearer YOUR_TOKEN`"

### Plain language checklist

✅ **Words**
- [ ] Used simple words when possible
- [ ] Defined technical terms on first use
- [ ] Expanded acronyms on first use
- [ ] Avoided unnecessary jargon

✅ **Sentences**
- [ ] Kept sentences under 25 words
- [ ] Used active voice (75%+ of sentences)
- [ ] Put main idea first in sentences
- [ ] Used parallel structure in lists

✅ **Structure**
- [ ] Put most important information first
- [ ] Used descriptive headings
- [ ] Broke long sections into subsections
- [ ] Used bullet lists for multiple items

## 🔊 Screen reader compatibility

Screen readers convert visual content to audio or braille. Writing for screen readers means thinking beyond visual layout.

### How screen readers process content

**Content processed:**
- Text (read aloud or converted to braille)
- Headings (announced with level: "Heading level 2, Authentication")
- Links (announced: "Link, API Reference")
- Images (alt text read aloud)
- Lists (announced: "List, 5 items")
- Tables (row/column navigation)

**Content NOT processed or problematic:**
- Color alone (can't be perceived)
- Images without alt text (skipped or "image" announced)
- Complex tables without headers
- Semantic meaning conveyed only through visual formatting

### Heading structure

Screen reader users navigate by headings. Proper heading hierarchy is essential.

✅ **Correct heading hierarchy:**
```markdown
# Page Title (h1 - only one per page)
## Main Section (h2)
### Subsection (h3)
### Another Subsection (h3)
## Another Main Section (h2)
```

❌ **Skipped heading levels (accessibility violation):**
```markdown
# Page Title
### Subsection (skipped h2!)
## Main Section
#### Detail (skipped h3!)
```

### Link text

Screen readers can list all links on a page. Link text must make sense out of context.

❌ **Meaningless link text:**
> "For more information about authentication, click [here](./auth.md)."
> "Read more [here](./details.md), [here](./examples.md), and [here](./reference.md)."

✅ **Descriptive link text:**
> "For setup instructions, see the [Authentication Guide](./auth.md)."
> "See [detailed examples](./examples.md) and [API reference](./reference.md)."

### Image alt text

Alt text should convey the **information or function** of an image, not just describe it.

**For informative images:**
```markdown
![Diagram showing OAuth 2.0 authorization code flow with three actors: 
User, Application, and Authorization Server. Arrows show: 1) User 
requests login, 2) Application redirects to Auth Server, 3) User 
authenticates, 4) Auth Server returns code, 5) Application exchanges 
code for token](./oauth-flow.png)
```

**For decorative images (empty alt):**
```markdown
![](./decorative-divider.png)
```

**For complex diagrams (long description):**
```markdown
![OAuth 2.0 authorization code flow](./oauth-flow.png)

*Figure 1: OAuth 2.0 authorization code flow. The user initiates login 
with the application. The application redirects to the authorization 
server...*
```

### Code blocks

Screen readers handle code blocks but benefit from context:

```markdown
The following code shows how to initialize the client:

```python
# Initialize the API client with your credentials
client = APIClient(
    api_key="YOUR_API_KEY",  # Required: your API key
    region="us-west"          # Optional: defaults to us-east
)
```

After initialization, you can make API calls...
```

### Tables

Tables need headers for screen reader navigation:

✅ **Accessible table:**
```markdown
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET    | /users   | List users  |
| POST   | /users   | Create user |
```

Screen reader announces: "Table, 2 rows, 3 columns. Row 1, Method: GET, Endpoint: /users, Description: List users."

❌ **Inaccessible table (layout table without headers):**
```markdown
| GET | /users | List all users in the system |
| POST | /users | Create a new user account |
```

## 🤝 Inclusive language

Inclusive language ensures all readers feel welcome and respected. It also improves clarity by avoiding assumptions.

### Gender-inclusive language

❌ **Exclusive:**
> "The developer should update his configuration."
> "Each user must enter his or her password."
> "Man the servers."

✅ **Inclusive:**
> "Developers should update their configuration."
> "Each user must enter their password." (singular they)
> "Staff the servers."

### Ability-inclusive language

❌ **Ableist language:**
> "Simply complete the form." (assumes simplicity for all)
> "See the diagram below." (assumes visual ability)
> "Crazy fast performance." (trivializes mental health)

✅ **Inclusive alternatives:**
> "Complete the form." (remove "simply")
> "The following diagram shows..." (acknowledges it exists)
> "Extremely fast performance." (neutral intensifier)

### Terms to avoid

| Avoid | Use Instead | Reason |
|-------|-------------|--------|
| Whitelist/Blacklist | Allowlist/Blocklist | Racial neutrality |
| Master/Slave | Primary/Secondary, Leader/Follower | Historical sensitivity |
| Dummy value | Placeholder value, Sample value | Respectful language |
| Sanity check | Quick check, Validation check | Mental health sensitivity |
| Grandfathered | Legacy, Exempt | Historical sensitivity |
| Crippled | Limited, Reduced, Restricted | Disability sensitivity |
| Blind to | Unaware of, Ignoring | Disability sensitivity |

### Microsoft's bias-free communication guidelines

From the [Microsoft Writing Style Guide](https://learn.microsoft.com/style-guide/bias-free-communication):

**Focus on people, not attributes:**
- ❌ "The disabled can use voice commands."
- ✅ "People with disabilities can use voice commands."

**Avoid stereotypes:**
- ❌ "Even a child could use this interface."
- ✅ "The interface is designed for users of all experience levels."

**Use parallel treatment:**
- ❌ "John, an engineer, and his assistant Mary..."
- ✅ "John, an engineer, and Mary, an analyst..."

## 👁️ Visual accessibility

Visual accessibility ensures documentation works for users with vision differences.

### Color and contrast

**WCAG contrast requirements:**
- **Normal text:** 4.5:1 contrast ratio minimum
- **Large text (18pt+):** 3:1 contrast ratio minimum
- **UI components:** 3:1 contrast ratio minimum

**Never rely on color alone:**

❌ **Color-only meaning:**
> "Required fields are shown in red."
> "Green indicates success; red indicates failure."

✅ **Color plus other indicators:**
> "Required fields are marked with an asterisk (*) and shown in red."
> "Success is shown with ✅ (green); failure with ❌ (red)."

### Font and typography

**Accessible font characteristics:**
- Sufficient size (16px minimum for body text)
- Clear distinction between similar characters (Il1, O0)
- Adequate line height (1.5x font size)
- Reasonable line length (50-75 characters)

**Emphasis guidelines:**
- Use **bold** for emphasis, not UPPERCASE
- Avoid italics for long passages (harder to read)
- Don't use underlining (reserved for links)

### Image accessibility

**Requirements:**
- Alt text for all informative images
- Empty alt (`![]()`) for decorative images
- Text alternatives for complex diagrams
- Avoid text embedded in images

**Color blindness considerations:**
- Don't rely on red/green distinction
- Use patterns or labels in addition to color
- Test diagrams with color blindness simulators

## 🧠 Cognitive accessibility

Cognitive accessibility supports users with dyslexia, ADHD, autism spectrum conditions, and other cognitive differences.

### Principles for cognitive accessibility

**1. Predictable structure**
- Consistent navigation patterns
- Same elements in same locations
- Predictable behavior (links, buttons)

**2. Reduced cognitive load**
- One idea per paragraph
- Short sentences
- Break complex procedures into steps

**3. Clear language**
- Define jargon
- Avoid idioms and metaphors
- Be literal and specific

**4. Adequate time and space**
- No auto-advancing content
- Plenty of whitespace
- Clear visual hierarchy

### Progressive cognitive disclosure in practice

<mark>Progressive cognitive disclosure</mark> applies the progressive disclosure principle (see [Article 02](02-structure-and-information-architecture.md)) specifically to cognitive load management. Instead of revealing UI layers, you're revealing conceptual complexity in stages that readers can absorb without overload.

**Example: Explaining authentication**

❌ **No progressive disclosure (all at once):**

> Authentication uses OAuth 2.0 with PKCE (Proof Key for Code Exchange) to prevent authorization code interception attacks. The client generates a code_verifier (a cryptographically random string of 43-128 characters) and derives a code_challenge using S256 (SHA-256 hash, base64url-encoded). During the authorization request, the client sends the code_challenge; during the token exchange, it sends the code_verifier, which the server hashes and compares.

✅ **Progressive cognitive disclosure (layered):**

> **Layer 1 — What it does (all readers):**
> Authentication verifies that you're allowed to access the API. Your app sends credentials, and the server sends back a token.
>
> **Layer 2 — How it works (most readers):**
> This repository uses OAuth 2.0, an industry standard. Your app redirects users to a login page, receives an authorization code, and exchanges it for an access token.
>
> **Layer 3 — Security details (advanced readers):**
> The flow uses PKCE (Proof Key for Code Exchange) to prevent interception. See [OAuth 2.0 PKCE Reference](https://oauth.net/2/pkce/) for the code_verifier/code_challenge mechanism.

**Techniques for implementing progressive cognitive disclosure:**

| Technique | Implementation | Best for |
|-----------|---------------|----------|
| **Layered sections** | H2 → H3 → H4 with increasing detail | Articles and conceptual docs |
| **Expandable details** | HTML `<details>` tags for optional depth | Reference docs with advanced options |
| **Summary + deep link** | Short explanation with a "For more, see..." link | How-to guides that need to stay focused |
| **Prerequisite chains** | "Before reading this, complete [X]" | Tutorial series |
| **Sidebar callouts** | Boxed "Advanced" or "Deep dive" notes | Mixed-audience articles |

**Anti-pattern: false simplicity**

Progressive disclosure doesn't mean dumbing down Layer 1. The first layer should be **accurate and complete enough to act on**, even if it omits underlying mechanisms. If a reader stops at Layer 1, they should still be able to use the feature correctly.

### Writing for dyslexic readers

**Helpful practices:**
- Short paragraphs (3-5 sentences)
- Left-aligned text (not justified)
- Bulleted lists for multiple items
- Sans-serif fonts (Arial, Verdana, OpenDyslexic)
- Good contrast but not pure black on white (try dark gray #333)

**Avoid:**
- Dense blocks of text
- Long sentences with multiple clauses
- Similar-looking words in sequence

### Writing for ADHD readers

**Helpful practices:**
- Clear, action-oriented headings
- Key information highlighted (bold, callout boxes)
- TL;DR summaries at the start
- Progress indicators in tutorials
- Visual breaks between sections

**Avoid:**
- Burying important information in paragraphs
- Long unbroken sections
- Unnecessary tangents

### Writing for autistic readers

**Helpful practices:**
- Literal, precise language
- Explicit instructions (don't assume)
- Consistent terminology (same word for same concept)
- Structured, predictable format
- Clear success criteria

**Avoid:**
- Idioms and metaphors ("wrap your head around")
- Ambiguous language
- Implicit expectations
- Sarcasm or humor that might be misread

## 📖 Reading comprehension and learning styles

Different readers process information through different <mark>learning modalities</mark>. While the VARK model (Visual, Auditory, Reading/Writing, Kinesthetic) is debated as a theory of fixed learning styles, research consistently shows that **multimodal presentation**—offering the same information through multiple channels—improves comprehension and retention for all readers.

> **Research context:** Mayer's Cognitive Theory of Multimedia Learning and Paivio's Dual Coding Theory provide stronger empirical foundations than VARK alone. The practical takeaway is the same: don't rely on a single modality.

### Visual learners

**How they process information:** Through spatial relationships, diagrams, charts, and visual patterns.

**Documentation strategies:**

- **Architecture diagrams** before code — Show the system structure, then the implementation details
- **Flowcharts for processes** — Decision trees and workflows communicate branching logic more efficiently than prose
- **Tables for comparisons** — Side-by-side layouts let visual thinkers spot patterns instantly
- **Annotated screenshots** — Numbered callouts on UI elements connect explanation to interface
- **Color-coded categories** — Use color *plus* labels (for accessibility) to distinguish concept groups

**Example — Visual-first explanation of Git branching:**

```
main ─────────●───────────●──────── (production)
              │           ▲
              └── feature ─┘  (merged)
```

A visual diagram like this communicates the branching model faster than "Create a feature branch from main, make your changes, then merge the feature branch back into main."

For comprehensive guidance on diagrams and visual documentation, see [Article 11: Visual Documentation and Diagrams](11-visual-documentation-and-diagrams.md).

### Auditory learners

**How they process information:** Through listening, verbal explanation, and discussion.

**Documentation strategies:**

- **Conversational tone** — Write as if explaining to a colleague (aligns with Microsoft's "warm and relaxed" voice; see [Article 01](01-writing-style-and-voice-principles.md))
- **"Explain it like you're talking" test** — Read your draft aloud. If it sounds robotic, rewrite it
- **Narrative structure** — Frame procedures as stories: "First, you'll set up... then you'll configure... finally, you'll verify..."
- **Embedded audio/video links** — Where available, link to conference talks, walkthroughs, or podcast episodes that cover the same topic
- **Verbal mnemonics** — Acronyms and memorable phrases ("LATCH" for Location-Alphabet-Time-Category-Hierarchy) stick with auditory processors

**Example — Narrative-style procedure:**

> Start by opening the terminal. You'll run the build command first—think of it as assembling the ingredients. Then deploy to staging, which is like a dress rehearsal. Once you've verified everything works, push to production.

### Reading/writing learners

**How they process information:** Through text—reading prose, writing notes, and reworking written explanations.

**Documentation strategies:**

- **Detailed written explanations** — Don't over-abbreviate; these readers prefer complete sentences over terse bullet lists
- **Glossaries and definitions** — Provide definitions for every key term (the `<mark>` tag convention in this series supports this)
- **Annotated code comments** — Inline comments explaining *why*, not just *what*
- **Written summaries** — "Key takeaways" sections at every article's end serve this group especially well
- **Cross-references and further reading** — Reading/writing learners follow reference chains willingly

Most technical documentation already favors this modality—the risk is *only* serving reading/writing learners and neglecting the others.

### Kinesthetic learners

**How they process information:** Through hands-on experience, experimentation, and physical interaction.

**Documentation strategies:**

- **Interactive tutorials** — Step-by-step guides where readers build something real (the Diátaxis tutorial pattern)
- **"Try it yourself" checkpoints** — After explaining a concept, include a small exercise: "Open your terminal and run `dotnet --version` to confirm your setup"
- **Sandbox environments** — Link to playgrounds, codespaces, or live demo environments
- **Copy-paste ready code** — Complete, runnable examples that readers can paste and modify immediately
- **Incremental builds** — Tutorials that add one feature at a time, letting readers see each change in action

**Example — Kinesthetic checkpoint:**

> **Try it now:** Create a file called `test.md` with a heading and a paragraph. Run `quarto preview test.md` and verify you see the rendered output. If you see a heading and a paragraph in your browser, you're ready for the next section.

### Designing for multiple modalities

The most accessible documentation serves all four modalities simultaneously. Here's how to layer them:

| Content element | Visual | Auditory | Reading/writing | Kinesthetic |
|----------------|--------|----------|-----------------|-------------|
| Architecture diagram | ✅ Primary | — | — | — |
| Diagram caption explaining the flow | — | ✅ (conversational) | ✅ Primary | — |
| Code example implementing the design | — | — | ✅ (comments) | ✅ Primary |
| "Try it yourself" exercise | — | — | — | ✅ Primary |

**Practical rule:** For every major concept, aim to include at least **two modalities**. A diagram plus prose, or a code example plus an exercise, covers most readers.

> **See also:** [Article 09: Measuring Readability and Comprehension](09-measuring-readability-and-comprehension.md) covers how to measure whether readers actually understand your documentation, regardless of their preferred modality.

## 😀 Emoji and symbol accessibility

This repository uses emoji markers (📘📗📒📕) for reference classification. Here's how to use symbols accessibly.

### How screen readers handle emoji

Screen readers announce emoji by their Unicode name:

- 📘 → "blue book"
- 📗 → "green book"  
- 📒 → "ledger"
- 📕 → "closed book"

**Implications for our classification system:**

Current format:
```markdown
**[Microsoft Style Guide](url)** 📘 [Official]
```

Screen reader announces: "Link, Microsoft Style Guide, blue book, Official"

**This works** because we include text labels (`[Official]`, `[Verified Community]`, etc.) alongside emoji. The emoji provides quick visual scanning; the text provides semantic meaning.

### Emoji accessibility guidelines

**1. Don't rely on emoji alone for meaning**

❌ **Emoji only:**
```markdown
📘 Microsoft Docs
📗 GitHub Blog
📒 Medium Article
```

✅ **Emoji plus text:**
```markdown
📘 [Official] Microsoft Docs
📗 [Verified] GitHub Blog
📒 [Community] Medium Article
```

**2. Limit emoji density**

❌ **Too many emoji:**
```markdown
🔧 Configuration ⚙️ → Settings 📁 → Options ✅
```

✅ **Selective use:**
```markdown
**Configuration** → Settings → Options ✅
```

**3. Consider cultural differences**

Some emoji meanings vary by culture. Prefer universally understood symbols or include text clarification.

### Alternative to emoji: text-based labels

If emoji cause issues, text alternatives work:

```markdown
**[Microsoft Style Guide](url)** [OFFICIAL]
**[GitHub Blog](url)** [VERIFIED]
**[Medium Article](url)** [COMMUNITY]
```

## 🧪 Testing documentation accessibility

### Manual testing

**Keyboard navigation:**
1. Can you Tab through all interactive elements?
2. Is the Tab order logical?
3. Are focus indicators visible?

**Screen reader testing:**
1. Read the page with a screen reader (NVDA, VoiceOver)
2. Navigate by headings—does structure make sense?
3. Listen to link text—is it descriptive?
4. Check tables—are headers announced?

**Zoom testing:**
1. Zoom to 200%—does content remain usable?
2. Is horizontal scrolling avoided?
3. Do images scale appropriately?

### Automated testing

**Tools:**
- **WAVE** - Browser extension for accessibility evaluation
- **axe DevTools** - Chrome/Firefox extension for WCAG testing
- **Lighthouse** - Built into Chrome DevTools
- **Pa11y** - Command-line accessibility testing

**Limitations:**
Automated tools catch ~30% of accessibility issues. Manual testing and user feedback remain essential.

### Accessibility checklist

✅ **Structure**
- [ ] Single H1 per page
- [ ] Heading levels don't skip (h2 to h4)
- [ ] Meaningful heading text

✅ **Images**
- [ ] All informative images have alt text
- [ ] Alt text describes information/function
- [ ] Complex images have long descriptions

✅ **Links**
- [ ] Link text is descriptive
- [ ] No "click here" or "read more"
- [ ] Links indicate destination type if non-obvious

✅ **Color**
- [ ] Color is not only indicator
- [ ] Sufficient contrast (4.5:1 for text)
- [ ] Works in grayscale

✅ **Language**
- [ ] Plain language used
- [ ] Technical terms defined
- [ ] Reading level appropriate (Flesch 50-70)

✅ **Content**
- [ ] Consistent navigation
- [ ] Predictable structure
- [ ] Clear error messages

## 📌 Applying accessibility to this repository

### Current accessibility practices

**Plain language standards** (from [documentation.instructions.md](../../.github/instructions/documentation.instructions.md)):
- Flesch Reading Ease: 50-70
- Sentence length: 15-25 words
- Active voice: 75-85%

**Reference classification** (accessible emoji usage):
```markdown
📘 [Official] - Primary sources
📗 [Verified Community] - Reviewed secondary sources
📒 [Community] - Community content
📕 [Unverified] - Requires attention
```

**Heading structure:**
- Single H1 (title) per article
- Hierarchical H2-H4 structure
- Descriptive heading text

### Validation integration

Accessibility validation integrates with existing validation dimensions:

**Readability validation** checks:
- Flesch scores (accessibility for diverse readers)
- Sentence complexity
- Jargon density

**Structure validation** checks:
- Heading hierarchy
- Link text quality
- Table structure

**Future validation** considerations:
- Alt text presence
- Color-independent meaning
- Contrast ratios (for HTML output)

### Accessibility improvement roadmap

**Current state:** Good foundation in plain language and structure

**Improvement areas:**
1. Alt text audit for existing images
2. Link text review (eliminate "here" and "this")
3. Color usage review in diagrams
4. Screen reader testing of rendered site

## ✅ Conclusion

Accessible documentation benefits everyone. Designing for accessibility improves the experience for all readers, not just those with specific needs.

### Key takeaways

- **Plain language is fundamental** — Short sentences, common words, and clear structure help all readers
- **Screen readers require semantic HTML** — Proper headings, descriptive links, and meaningful alt text
- **Inclusive language welcomes all readers** — Avoid gendered defaults, ableist phrases, and outdated terms
- **Visual accessibility extends beyond color** — Contrast, typography, and alternatives to color-coded meaning
- **Cognitive accessibility reduces barriers** — Predictable structure, clear language, progressive cognitive disclosure, and reduced complexity
- **Multimodal content reaches more readers** — Combine visual, narrative, textual, and hands-on elements so documentation works across learning preferences
- **Emoji can be accessible** — When paired with text labels and used sparingly
- **Testing is essential** — Automated tools plus manual testing plus user feedback

### Next steps

- **Next article:** [04-code-documentation-excellence.md](04-code-documentation-excellence.md) — Accessible code examples and error messages
- **Related:** [12-writing-for-global-audiences.md](12-writing-for-global-audiences.md) — Internationalization, localization, and writing for non-native speakers
- **Related:** [01-writing-style-and-voice-principles.md](01-writing-style-and-voice-principles.md) — Plain language style foundations
- **Related:** [02-structure-and-information-architecture.md](02-structure-and-information-architecture.md) — Accessible navigation patterns

## 📚 References

### Accessibility standards

**[Web Content Accessibility Guidelines (WCAG) 2.1](https://www.w3.org/TR/WCAG21/)** 📘 [Official]  
W3C standard for web accessibility, including content guidelines applicable to documentation.

**[Understanding WCAG 2.1](https://www.w3.org/WAI/WCAG21/Understanding/)** 📘 [Official]  
Detailed explanations of WCAG success criteria with techniques and examples.

**[Section 508 Standards](https://www.section508.gov/)** 📘 [Official]  
US federal accessibility requirements for electronic information technology.

### Plain language

**[Federal Plain Language Guidelines](https://www.plainlanguage.gov/guidelines/)** 📘 [Official]  
Comprehensive plain language guidance from the US government.

**[Plain Language Action and Information Network (PLAIN)](https://www.plainlanguage.gov/)** 📘 [Official]  
Resources for implementing plain language in government and business.

### Inclusive language

**[Microsoft Bias-Free Communication](https://learn.microsoft.com/style-guide/bias-free-communication)** 📘 [Official]  
Microsoft's comprehensive guide to inclusive, bias-free writing.

**[Google Inclusive Documentation](https://developers.google.com/style/inclusive-documentation)** 📘 [Official]  
Google's guidance on writing inclusive developer documentation.

**[Wikipedia Manual of Style - Gender-Neutral Language](https://en.wikipedia.org/wiki/Wikipedia:Manual_of_Style#Gender-neutral_language)** 📘 [Official]  
Wikipedia's standards for gender-inclusive writing.

### Assistive technology

**[WebAIM - Screen Reader User Survey](https://webaim.org/projects/screenreadersurvey9/)** 📗 [Verified Community]  
Survey data on how screen reader users navigate the web.

**[Deque University - Accessibility Courses](https://dequeuniversity.com/)** 📗 [Verified Community]  
Training resources for web and document accessibility.

### Cognitive accessibility

**[W3C Cognitive Accessibility Guidance](https://www.w3.org/TR/coga-usable/)** 📘 [Official]  
W3C guidance on making content usable for people with cognitive and learning disabilities.

**[British Dyslexia Association - Dyslexia Style Guide](https://www.bdadyslexia.org.uk/advice/employers/creating-a-dyslexia-friendly-workplace/dyslexia-friendly-style-guide)** 📗 [Verified Community]  
Best practices for creating dyslexia-friendly content.

### Learning styles and multimedia learning

**[Mayer's Cognitive Theory of Multimedia Learning](https://www.cambridge.org/core/books/cambridge-handbook-of-multimedia-learning/cognitive-theory-of-multimedia-learning/)** 📗 [Verified Community]  
Richard Mayer's research demonstrating that people learn better from words and pictures together than from words alone—the empirical basis for multimodal documentation.

**[VARK Model - Fleming and Mills](https://vark-learn.com/)** 📗 [Verified Community]  
The Visual-Auditory-Reading/Writing-Kinesthetic framework for understanding learning preferences. Useful as a practical heuristic despite ongoing academic debate about fixed learning styles.

**[Dual Coding Theory - Allan Paivio](https://en.wikipedia.org/wiki/Dual-coding_theory)** 📘 [Official]  
Theory that verbal and non-verbal information are processed through separate channels, supporting the case for combining text with visual representations.

### Repository-specific documentation

**[Documentation Instructions - Accessibility](../../.github/instructions/documentation.instructions.md)** [Internal Reference]  
This repository's accessibility standards and practices.

**[Validation Criteria - Readability](../../.copilot/context/01.00-article-writing/02-validation-criteria.md)** [Internal Reference]  
Readability targets that support accessibility goals.

---

<!-- Validation Metadata
validation_status: pending_first_validation
article_metadata:
  filename: "03-accessibility-in-technical-writing.md"
  series: "Technical Documentation Excellence"
  series_position: 4
  total_articles: 13
  prerequisites:
    - "01-writing-style-and-voice-principles.md"
    - "02-structure-and-information-architecture.md"
  related_articles:
    - "01-writing-style-and-voice-principles.md"
    - "02-structure-and-information-architecture.md"
    - "04-code-documentation-excellence.md"
    - "06-citations-and-reference-management.md"
    - "09-measuring-readability-and-comprehension.md"
    - "11-visual-documentation-and-diagrams.md"
  version: "1.1"
  last_updated: "2026-02-28"
-->
