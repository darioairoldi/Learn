# Learning Hub — Sidebar Menu Readability Improvement Plan

**Date**: 2026-05-06
**Status**: Draft
**Scope**: Left sidebar navigation styling (`_includes/sidebar-fixes.html`, `cerulean.scss`)

---

## 1. Problem Statement

The Learning Hub (Quarto) sidebar navigation is harder to scan and understand compared to the ABB (MkDocs) documentation sidebar. The ABB menu feels cleaner, more structured, and easier to navigate — especially when distinguishing between section headers and leaf items.

---

## 2. Comparative Analysis

### 2.1 ABB MkDocs Sidebar (Reference)

| Aspect | Observation |
|---|---|
| **Section headers** | Bold, dark text, clearly separated from child items |
| **Leaf items** | Regular weight, slightly indented, generous vertical padding |
| **Vertical spacing** | Consistent ~8–10 px between items; extra ~16 px gap between top-level sections |
| **Separators** | Implicit — the extra whitespace between top-level groups acts as a visual divider |
| **Chevrons** | Discrete `>` chevron right-aligned; only present on expandable sections |
| **Active item** | Blue text with no background clutter — lightweight highlight |
| **Indentation** | Clean left-indent per level (~16 px per level); no over-indenting |
| **Font sizes** | Uniform font size across levels; weight and color carry the hierarchy |
| **Line height** | Generous line-height (~1.6–1.8) makes each item a comfortable click target |
| **Overall density** | Low density — room to breathe between items |

### 2.2 Learning Hub Quarto Sidebar (Current)

| Aspect | Observation |
|---|---|
| **Section headers** | Bold but visually close to child items; difference not dramatic enough |
| **Leaf items** | Font sizes shrink per level (0.95 → 0.9 → 0.85 → 0.8 rem) — deepest items become hard to read |
| **Vertical spacing** | Tight: 0.6 rem between top sections, 0.25 rem nested, 0.15 rem deep-nested |
| **Separators** | `---` text separators in `navigation.json` — rendered but not visually prominent |
| **Chevrons** | Chevrons present but styled inline with the same icon column; not always easy to spot |
| **Active item** | Blue left-border + blue text + tinted background — slightly heavy / busy |
| **Indentation** | Progressive padding-left (0.75 → 1.5 → 2.25 → 3 rem) — reasonable but combined with font-size reduction it feels cramped |
| **Font sizes** | Decreasing per nesting level — compounds with tighter spacing to reduce readability |
| **Line height** | Default (`line-height: 1.3`) — small click targets |
| **Overall density** | High density — many items close together, hard to scan |
| **Home button** | Large gradient pill button — visually dominant, takes space, inconsistent with the rest of the sidebar |

### 2.3 Key Gaps (LearnHub vs ABB)

| # | Gap | Impact |
|---|---|---|
| G1 | Insufficient spacing between **top-level sections** | Sections blend together; no "group break" |
| G2 | **Font-size reduction** per nesting level | Deep items become tiny and hard to read |
| G3 | **Line-height too tight** (1.3) | Items feel cramped; small click targets |
| G4 | **No visible section separators** between top-level groups | No visual cue that "Events" and "Technologies" are sibling groups |
| G5 | **Active-item style too heavy** (border + bg + color) | Distracts rather than guides |
| G6 | **Home button pill style** inconsistent | Breaks the visual rhythm of the sidebar |
| G7 | **Color hierarchy** not leveraged enough | ABB uses only weight + slight color change; LearnHub uses 4 different grays (#2d3748 → #4a5568 → #718096 → #a0aec0) which is noisy |

---

## 3. Proposed Alternatives

### Alternative A: "Clean Uniform" (ABB-inspired, minimal changes)

**Principle**: Uniform font size, hierarchy via weight + indentation only, generous spacing.

| Property | Level 0 (top) | Level 1 | Level 2 | Level 3 |
|---|---|---|---|---|
| font-size | 0.9rem | 0.9rem | 0.9rem | 0.9rem |
| font-weight | 600 | 500 | 400 | 400 |
| color | #2d3748 | #4a5568 | #4a5568 | #718096 |
| padding-left | 0.75rem | 1.5rem | 2.25rem | 3rem |
| padding-top/bottom | 0.4rem | 0.35rem | 0.3rem | 0.3rem |
| line-height | 1.6 | 1.6 | 1.6 | 1.6 |

Top-level section gap: `margin-bottom: 1rem` (with `0.5rem` between nested items).
Active item: blue text only (no border, no background).
Section separators: 1px `#e9ecef` border-top with `0.75rem` margin above/below.
Home link: standard sidebar item with house icon — no pill/gradient.

**Pros**: Closest to ABB feel; very clean; minimal distractions.
**Cons**: Loses some of the current visual personality; deepest items may look too similar to Level 2.

---

### Alternative B: "Refined Hierarchy" (keep subtle size variation, fix spacing)

**Principle**: Keep slight font-size graduation but cap it; fix spacing and separators.

| Property | Level 0 (top) | Level 1 | Level 2 | Level 3 |
|---|---|---|---|---|
| font-size | 0.925rem | 0.9rem | 0.875rem | 0.875rem |
| font-weight | 600 | 500 | 400 | 400 |
| color | #2d3748 | #4a5568 | #4a5568 | #718096 |
| padding-left | 0.75rem | 1.5rem | 2.25rem | 3rem |
| padding-top/bottom | 0.45rem | 0.35rem | 0.3rem | 0.3rem |
| line-height | 1.5 | 1.5 | 1.5 | 1.5 |

Top-level section gap: `margin-bottom: 0.85rem`.
Active item: blue text + very subtle background (`rgba(39, 128, 227, 0.06)`), no left border.
Section separators: thin `#e9ecef` line between top-level groups.
Home link: slightly larger text (1rem) with icon, no pill background.

**Pros**: Maintains a subtle visual hierarchy through font size; feels slightly richer.
**Cons**: Still has some size variation — not quite as clean as ABB.

---

### Alternative C: "Spaced Hierarchy with Dividers" (strongest separation)

**Principle**: Keep current color/weight system but dramatically improve spacing and add explicit dividers.

| Property | Level 0 (top) | Level 1 | Level 2 | Level 3 |
|---|---|---|---|---|
| font-size | 0.95rem | 0.9rem | 0.85rem | 0.825rem |
| font-weight | 700 | 500 | 400 | 400 |
| color | #1a202c | #4a5568 | #718096 | #a0aec0 |
| padding-left | 0.75rem | 1.5rem | 2.25rem | 3rem |
| padding-top/bottom | 0.5rem | 0.35rem | 0.3rem | 0.25rem |
| line-height | 1.5 | 1.5 | 1.4 | 1.4 |
| text-transform | uppercase | none | none | none |
| letter-spacing | 0.025em | 0 | 0 | 0 |

Top-level section gap: `margin-bottom: 1.25rem`.
Active item: left border (2px) + blue text.
Section separators: 1px border-top on each top-level section header.
Level 0 headers styled as "section labels" (uppercase, smaller, bolder — like MkDocs Material "nav sections").
Home link: icon + label, no pill.

**Pros**: Strongest visual separation; top-level sections clearly stand out.
**Cons**: Uppercase headers may feel too aggressive; most divergent from current look.

---

## 4. Recommendation

**Alternative B ("Refined Hierarchy")** is recommended as the best balance:

1. Fixes the critical spacing and line-height gaps (G1, G3).
2. Keeps a gentle font-size hierarchy but stops it from becoming unreadable (G2).
3. Adds section separators for top-level group clarity (G4).
4. Lightens the active-item style (G5).
5. Normalizes the Home link (G6).
6. Reduces the color-spread noise (G7).

It is the smallest change set that produces the largest readability gain, while keeping the sidebar personality recognizably "Learning Hub."

---

## 5. Implementation Plan

### Phase 1 — CSS Spacing & Typography (sidebar-fixes.html `<style>`)

| Step | What | File | LOE |
|---|---|---|---|
| 1.1 | Increase `line-height` to `1.5` on all `.sidebar-item-text` | `_includes/sidebar-fixes.html` | S |
| 1.2 | Increase top-level section `margin-bottom` to `0.85rem` | same | S |
| 1.3 | Increase nested item `margin-bottom` to `0.35rem` | same | S |
| 1.4 | Cap minimum font-size at `0.875rem` (remove 0.8rem L3 rule) | same | S |
| 1.5 | Unify Level 2 + Level 3 color to `#4a5568` (remove `#a0aec0`) | same | S |

### Phase 2 — Section Separators

| Step | What | File | LOE |
|---|---|---|---|
| 2.1 | Add CSS rule: top-level `.sidebar-item` that follows a `---` separator gets `border-top: 1px solid #e9ecef; padding-top: 0.75rem; margin-top: 0.75rem` | `_includes/sidebar-fixes.html` | S |
| 2.2 | Verify `navigation.json` separator entries (`"text": "---"`) render as `<hr>` or identifiable element; add CSS accordingly | same | M |

### Phase 3 — Active-Item & Home Link

| Step | What | File | LOE |
|---|---|---|---|
| 3.1 | Change active item: remove `border-left`, keep `color: #2780e3`, add `background: rgba(39,128,227,0.06)` | `_includes/sidebar-fixes.html` | S |
| 3.2 | Replace Home pill styling with standard sidebar item (remove gradient, border, box-shadow, border-radius) — keep icon + bold text | same | M |

### Phase 4 — Padding & Click Targets

| Step | What | File | LOE |
|---|---|---|---|
| 4.1 | Set minimum `padding: 0.35rem 0.75rem` on all `.sidebar-item-text` | `_includes/sidebar-fixes.html` | S |
| 4.2 | Ensure `min-height: 2rem` on clickable sidebar links for touch/mouse accessibility | same | S |

### Phase 5 — Visual QA

| Step | What | File | LOE |
|---|---|---|---|
| 5.1 | Render site with `quarto preview` and compare sidebar against ABB reference screenshots | manual | M |
| 5.2 | Test collapsed/expanded states — verify spacing holds at all nesting depths | manual | M |
| 5.3 | Test mobile breakpoint — verify menu adapts correctly | manual | S |

**LOE key**: S = Small (< 15 min), M = Medium (15–45 min)

---

## 6. CSS Change Summary (Alternative B)

Below is the consolidated set of CSS property changes to apply:

```css
/* === GLOBAL SIDEBAR TYPOGRAPHY === */
#quarto-sidebar .sidebar-item-text {
    line-height: 1.5;               /* was 1.3 */
    min-height: 2rem;               /* new — click target */
}

/* === TOP-LEVEL SECTIONS === */
#quarto-sidebar > .sidebar-navigation > .sidebar-item {
    margin-bottom: 0.85rem;         /* was 0.6rem */
}

/* === NESTED ITEMS === */
#quarto-sidebar .sidebar-item .sidebar-item {
    margin-bottom: 0.35rem;         /* was 0.25rem */
}

#quarto-sidebar .sidebar-item .sidebar-item .sidebar-item {
    margin-bottom: 0.25rem;         /* was 0.15rem */
}

/* === LEVEL 0 (Root) === */
#quarto-sidebar > .sidebar-navigation > .sidebar-item > .sidebar-item-text {
    font-size: 0.925rem;            /* was 0.95rem */
    padding: 0.45rem 0.75rem;       /* was 0.4rem */
}

/* === LEVEL 1 === */
/* font-size: 0.9rem — unchanged */
/* padding: 0.35rem 0.75rem — was 0.3rem */

/* === LEVEL 2 === */
/* font-size: 0.875rem — was 0.85rem */

/* === LEVEL 3 === */
#quarto-sidebar .sidebar-item .sidebar-item .sidebar-item .sidebar-item > .sidebar-item-text {
    font-size: 0.875rem;            /* was 0.8rem — capped */
    color: #718096;                  /* was #a0aec0 — darker for readability */
}

/* === SECTION SEPARATORS === */
#quarto-sidebar .sidebar-item-text[data-bs-text="---"],
#quarto-sidebar hr,
#quarto-sidebar .sidebar-separator {
    border: none;
    border-top: 1px solid #e9ecef;
    margin: 0.75rem 0.75rem;
    padding: 0;
    height: 0;
}

/* === ACTIVE ITEM (lightened) === */
#quarto-sidebar .sidebar-item-text.active {
    background-color: rgba(39, 128, 227, 0.06);  /* was 0.1 */
    color: #2780e3;
    border-left: none;                             /* removed */
    padding-left: inherit;                         /* reset */
    font-weight: 600;
}

/* === HOME LINK (normalized) === */
.sidebar .sidebar-item-text[href="index.qmd"],
#quarto-sidebar .sidebar-item-text[href="index.qmd"] {
    background: none;
    border: none;
    box-shadow: none;
    border-radius: 0;
    color: #2d3748;
    font-weight: 600;
    font-size: 1rem;
    padding: 0.45rem 0.75rem;
    margin-bottom: 0.25rem;
}
```

---

## 7. Risks & Mitigations

| Risk | Mitigation |
|---|---|
| Quarto upgrades may override sidebar CSS | All overrides use `!important` and are in `_includes/sidebar-fixes.html` — isolated from Quarto theme |
| Separator rendering depends on how Quarto translates `"text": "---"` in `navigation.json` | Inspect rendered HTML first; may need JS to inject `<hr>` elements |
| Removing Home pill changes established branding | Keep the house icon and bold text to maintain recognition |
| Sidebar persistence JS (`localStorage`) may conflict with spacing changes | Spacing is pure CSS — no interaction with JS state |

---

## 8. Out of Scope

- Top navbar styling (separate concern)
- Right-side table-of-contents panel
- Mobile hamburger menu UX
- Content typography or article layout
- Navigation structure / information architecture changes

---

## 9. Next Steps

1. **Review this plan** — confirm Alternative B (or select A/C).
2. **Implement Phase 1–4** — CSS changes in `_includes/sidebar-fixes.html`.
3. **Visual QA** (Phase 5) — compare before/after with screenshots.
4. **Iterate** — adjust spacing values if needed after visual review.
