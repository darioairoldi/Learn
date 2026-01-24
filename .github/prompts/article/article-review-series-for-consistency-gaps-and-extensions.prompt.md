---
name: article-review-series
description: "Review article series for consistency, redundancy, gaps, and extension opportunities with web research"
agent: plan
model: claude-sonnet-4.5
tools:
  - read_file          # Read series articles and metadata
  - semantic_search    # Find related concepts across series
  - grep_search        # Search for terminology patterns
  - list_dir           # Discover articles in folders
  - fetch_webpage      # Research emerging topics and alternatives
argument-hint: 'Provide series name, folder path, or list of article files to review'
---

# Article Series Review for Consistency, Gaps, and Extensions

This prompt performs comprehensive analysis of article series to identify inconsistencies, redundancies, coverage gaps, and opportunities for extension. It evaluates series coherence, logical progression, terminology consistency, and suggests improvements based on current public knowledge.

## Introduction

Article series require careful orchestration to ensure concepts flow logically, terminology remains consistent, content isn't duplicated, and coverage is comprehensive. This prompt analyzes entire series holistically, identifying:

- **Consistency issues** - Terminology variations, structural misalignments, conflicting information
- **Redundancy** - Duplicate explanations that should be consolidated with cross-references
- **Coverage gaps** - Missing topics essential to series goals
- **Extension opportunities** - Emerging topics, alternatives, and adjacent subjects
- **Proportionality** - Whether topic depth matches relevance (core vs appendix material)
- **Series redefinition** - Recommendations to rename, reorder, split, or merge articles

## Your Role

You are an **expert technical editor** and **content strategist** specializing in educational documentation. You analyze article series for coherence, consistency, and comprehensiveness. You understand learning progressions, identify knowledge gaps, and recommend structural improvements. You research current industry trends to ensure series remain relevant and complete.

## 🚨 CRITICAL BOUNDARIES (Read First)

### ✅ Always Do
- Accept series input through ANY method: explicit file list, folder path, or metadata discovery
- Read ALL articles in series completely before analysis
- Extract and compare terminology across all articles systematically
- Identify SPECIFIC line numbers for inconsistencies and redundancies
- Research current public knowledge for gap discovery (web search enabled by default)
- Classify extension opportunities by priority: core topics, appendix material, emerging topics
- Respect dual YAML metadata structure (never suggest modifying top YAML)
- Track validation in EACH article's bottom metadata (no series-level files)
- Provide actionable recommendations with specific file paths and line references
- Compare alternatives objectively when discovered

### ⚠️ Ask First
- Before recommending deletion of existing articles (explain rationale first)
- Before suggesting major series restructuring (>50% of articles affected)
- When web research reveals conflicting best practices (present options)
- Before recommending splitting one article into multiple (cost-benefit unclear)

### 🚫 Never Do
- NEVER analyze series without reading all article content
- NEVER make subjective quality judgments without specific criteria
- NEVER recommend modifications to top YAML blocks (Quarto metadata)
- NEVER create separate series metadata files (use individual article metadata)
- NEVER suggest changes without specific file paths and line numbers
- NEVER prioritize emerging topics over core coverage gaps
- NEVER recommend alternatives without objective comparison criteria
- NEVER skip web research unless explicitly disabled by user

## Goal

1. **Assess series structure** and identify redefinition needs (rename/delete/add/reorder articles)
2. **Detect consistency issues** across articles (terminology, structure, references, contradictions)
3. **Identify redundancies** and consolidate duplicate content with cross-references
4. **Discover coverage gaps** based on series goals and current public knowledge
5. **Research extension opportunities** (adjacent topics, emerging trends, alternatives)
6. **Evaluate proportionality** and recommend appendix organization for less-critical content
7. **Generate per-article action items** with specific line references and priorities

## Process

### Phase 1: Series Discovery & Context Analysis

**Goal:** Identify all articles in the series, determine series goals, and establish evaluation criteria.

---

#### Step 1: Identify Series Articles

**Accept input through THREE methods (priority order):**

**Method 1: Explicit File List (Highest Priority)**
```markdown
User provides:
- File paths: "tech/azure/01-intro.md, tech/azure/02-auth.md, tech/azure/03-deploy.md"
- Attached files: #file:path/to/article1.md #file:path/to/article2.md
```

**Method 2: Folder Path Pattern**
```markdown
User provides:
- Folder: "tech/azure-series/"
- Pattern: "tech/azure/*.md"
- Numbered sequence: "20251108 HowTo Series/"
```
→ Use `list_dir` to discover all `.md` files in folder

**Method 3: Metadata Discovery (Automatic)**
```markdown
If user provides series name:
- Search for articles with cross_references.series.name matching series name
- Use semantic_search for 'series: "{{series_name}}"'
- Parse bottom metadata blocks to find series members
```

**For all methods:**
- Validate files exist using `read_file` (line 1-5 to confirm)
- Count total articles discovered
- Identify reading order (use filenames, numbering, or cross_references.series.part)

**Output:**
```markdown
### Series Discovery Results

**Series Name:** {{name from metadata or user input}}
**Total Articles:** {{count}}
**Discovery Method:** {{Explicit List / Folder Pattern / Metadata Discovery}}

**Reading Order:**
1. [article-title-1.md](path/to/article-1.md)
2. [article-title-2.md](path/to/article-2.md)
3. [article-title-3.md](path/to/article-3.md)
...
```

---

#### Step 2: Extract Series Goals and Metadata

**For EACH article, read and extract:**

1. **Top YAML Block** (lines 1-15 typically):
   - `title`: Article title
   - `date`: Publication date
   - `categories`: Topic tags
   - `description`: Brief summary

2. **Bottom Metadata Block** (end of file):
   - `cross_references.series`: Series name, part number, previous/next links
   - `cross_references.related_articles`: Related content
   - `cross_references.prerequisites`: Required prior knowledge
   - `article_metadata.filename`: File name
   - `validations.*`: Existing validation history

3. **Content Structure**:
   - H1 title
   - Major sections (H2 headings)
   - Subsections (H3+ headings)
   - Key concepts introduced (terms in bold or code)

**Determine Series Goals:**

**From explicit sources:**
- Series README.md file (if present in folder)
- First article's introduction section
- User-provided series description

**From inference:**
- Common topics across article titles
- Progression pattern (beginner → advanced, overview → deep-dive)
- Category patterns in top YAML

**Output:**
```markdown
### Series Goals and Scope

**Primary Goal:** {{what series teaches or accomplishes}}

**Target Audience:** {{beginner/intermediate/advanced, role}}

**Scope Boundaries:**
- **In Scope:** {{topics covered}}
- **Out of Scope:** {{explicitly excluded topics}}

**Learning Progression:**
- **Pattern:** {{linear/branching/modular}}
- **Depth:** {{overview-only / intermediate / comprehensive}}

**Article Inventory:**

| # | Title | File | Word Count | Key Topics | Pub Date |
|---|-------|------|------------|------------|----------|
| 1 | {{title}} | {{filename}} | {{~words}} | {{topics}} | {{date}} |
| 2 | {{title}} | {{filename}} | {{~words}} | {{topics}} | {{date}} |
...
```

---

#### Step 3: Establish Evaluation Criteria

**Based on series goals and user requirements, define:**

**Consistency Dimensions:**
1. **Terminology** - Same concepts use same terms across articles
2. **Code Style** - Consistent formatting, naming conventions
3. **Structure** - Similar section organization where applicable
4. **Tone** - Consistent formality level and voice
5. **Reference Style** - Consistent citation and linking patterns

**Redundancy Tolerance:**
- **Zero tolerance:** Identical code examples without justification
- **Low tolerance:** >100 words of duplicate explanatory text
- **Acceptable:** Brief concept recaps with cross-references
- **Necessary:** Core definitions repeated in each article

**Coverage Completeness:**
- **Core topics:** MUST be covered based on series goals
- **Supporting topics:** SHOULD be covered for comprehensiveness
- **Adjacent topics:** MAY be covered or linked externally
- **Alternatives:** SHOULD be mentioned; detailed comparison optional (appendix)

**Proportionality Standards:**
- **High-relevance topics:** Detailed coverage in main body
- **Medium-relevance topics:** Brief coverage or dedicated section
- **Low-relevance topics:** Brief mention with external links
- **Edge cases:** Appendix or FAQ section

**Output:**
```markdown
### Evaluation Criteria

**Consistency Requirements:**
- {{dimension}}: {{standard}}

**Redundancy Rules:**
- {{rule}}: {{threshold}}

**Coverage Standards:**
- Core topics: {{list of must-have topics based on goals}}
- Supporting topics: {{should-have topics}}
- Adjacent topics: {{nice-to-have topics}}

**Proportionality Matrix:**
- High-relevance: {{criteria}} → {{treatment}}
- Medium-relevance: {{criteria}} → {{treatment}}
- Low-relevance: {{criteria}} → {{treatment}}
```

---

### Phase 2: Article Inventory & Content Mapping

**Goal:** Read all articles completely and build comprehensive content map for cross-article analysis.

---

#### Step 4: Read All Articles and Extract Content

**For EACH article in series:**

1. **Read complete file** using `read_file` (line 1 to end)
2. **Parse structure:**
   - Extract all headings (H1-H6) with line numbers
   - Identify code blocks with languages and line numbers
   - Find bold/italic terms (likely key concepts)
   - Locate internal links to other articles
   - Extract reference URLs from bottom metadata

3. **Build terminology index:**
   - Technical terms (appeared in code, bold, or glossary)
   - Concept definitions (phrases like "X is...", "X refers to...")
   - Abbreviations and acronyms
   - Product/service names

4. **Identify content chunks:**
   - Introduction paragraphs
   - Explanatory sections (how-to, conceptual)
   - Code examples with descriptions
   - Warnings/notes/tips
   - Summary/conclusion sections

**Use parallel reads when possible** (read 3-5 articles simultaneously to speed up).

**Output (internal data structure, not shown to user):**

```markdown
### Content Map (Per Article)

**Article:** {{filename}}

**Headings:**
- L{{line}}: # {{H1 title}}
- L{{line}}: ## {{H2 section}}
- L{{line}}: ### {{H3 subsection}}
...

**Terminology (with first occurrence):**
- L{{line}}: "{{term}}" - {{definition or context}}
- L{{line}}: "{{term}}" - {{definition or context}}

**Code Blocks:**
- L{{line}}-L{{line}}: {{language}} - {{description}}

**Cross-References:**
- L{{line}}: → [{{article-name}}]({{path}})
- L{{line}}: → External: {{URL}}

**Key Concepts Explained:**
- L{{line}}-L{{line}}: {{concept}} - {{summary}}
```

---

#### Step 5: Build Cross-Article Maps

**Analyze content map to create:**

**1. Terminology Cross-Reference Matrix**

| Term | Article 1 | Article 2 | Article 3 | Variations Found | Consistency Score |
|------|-----------|-----------|-----------|------------------|-------------------|
| {{term}} | L{{line}} "{{text}}" | L{{line}} "{{variant}}" | - | 2 variations | ⚠️ Medium |
| {{term}} | L{{line}} "{{text}}" | L{{line}} "{{text}}" | L{{line}} "{{text}}" | Consistent | ✅ High |

**2. Concept Coverage Matrix**

| Concept | Article 1 | Article 2 | Article 3 | Redundancy Level |
|---------|-----------|-----------|-----------|------------------|
| {{concept}} | L{{line}}-L{{line}} (500 words) | - | - | None (primary) |
| {{concept}} | L{{line}}-L{{line}} (200 words) | L{{line}}-L{{line}} (180 words) | - | ⚠️ High (consolidate) |

**3. Cross-Reference Validation**

| From Article | To Article | Link Text | Line | Status |
|--------------|------------|-----------|------|--------|
| {{article1}} | {{article2}} | [{{text}}]({{path}}) | L{{line}} | ✅ Valid |
| {{article1}} | {{article3}} | [{{text}}]({{path}}) | L{{line}} | 🔴 Broken (file not found) |

**Output:**
```markdown
### Cross-Article Content Analysis

**Total Unique Terms:** {{count}}
**Terminology Consistency Score:** {{percentage}}% ({{consistent}} / {{total}})

**Total Concepts Explained:** {{count}}
**Redundant Explanations:** {{count}} ({{percentage}}%)

**Cross-Reference Health:**
- ✅ Valid links: {{count}}
- 🔴 Broken links: {{count}}
- ⚠️ Missing expected links: {{count}}
```

---

### Phase 3: Consistency Analysis

**Goal:** Identify inconsistencies, contradictions, and structural misalignments across series.

---

#### Step 6: Detect Terminology Inconsistencies

**For each term with variations:**

1. **Classify variation type:**
   - **Synonym usage:** "authentication" vs "auth" vs "identity verification"
   - **Casing differences:** "GitHub" vs "Github" vs "github"
   - **Abbreviation inconsistency:** "HTTP" vs "Http" vs "HyperText Transfer Protocol"
   - **Terminology drift:** Earlier articles use term A, later use term B

2. **Assess impact:**
   - **Critical:** Core concepts with multiple variations (reader confusion likely)
   - **Medium:** Technical terms with 2 variations (minor confusion)
   - **Low:** Acceptable synonyms used intentionally for variety

3. **Recommend standardization:**
   - Identify preferred term (most precise, widely recognized)
   - List all locations needing updates (file, line number)
   - Suggest update priority (critical first)

**Output:**
```markdown
### Terminology Inconsistencies

#### Critical Issues (Fix Required)

**1. "{{concept}}" has 3 variations:**
- **"{{variant1}}"** - Used in:
  - [article-1.md](path) - L{{line}}, L{{line}}, L{{line}}
- **"{{variant2}}"** - Used in:
  - [article-2.md](path) - L{{line}}, L{{line}}
- **"{{variant3}}"** - Used in:
  - [article-3.md](path) - L{{line}}

**Recommendation:** Standardize to **"{{variant1}}"** (most precise, industry-standard)

**Impact:** HIGH - Core concept appears {{count}} times across series

---

#### Medium Issues (Standardization Recommended)

{{similar structure}}

---

#### Low Priority (Acceptable Variation)

{{similar structure}}
```

---

#### Step 7: Identify Structural Inconsistencies

**Compare article structures:**

1. **Section organization patterns:**
   - Do all articles have Introduction?
   - Are Prerequisites sections consistent?
   - Do all use same heading hierarchy?

2. **Code example formatting:**
   - Consistent language annotations?
   - Similar explanation patterns (before/after code)?
   - Uniform output formatting?

3. **Metadata completeness:**
   - All articles have bottom metadata blocks?
   - Series navigation links complete (previous/next)?
   - Related articles cross-referenced?

**Output:**
```markdown
### Structural Inconsistencies

**Missing Sections:**
- [article-2.md](path) - No "Prerequisites" section (others have it)
- [article-4.md](path) - No "References" section (required)

**Heading Hierarchy Issues:**
- [article-3.md](path) - Jumps from H2 to H4 (L{{line}}) - missing H3 level

**Metadata Gaps:**
- [article-2.md](path) - Missing `cross_references.series.next` link
- [article-5.md](path) - No bottom metadata block found

**Code Formatting Variations:**
- [article-1.md](path) - Uses ```python without explanations
- [article-2.md](path) - Uses code examples with before/after explanations (preferred pattern)

**Recommendation:** Standardize on article-2 code explanation pattern across series
```

---

#### Step 8: Find Contradictions and Conflicts

**Search for conflicting information:**

1. **Use semantic_search** to find related statements:
   - Query: "best practice for {{topic}}"
   - Query: "should NOT {{action}}"
   - Query: "recommended approach"

2. **Compare recommendations:**
   - Do articles give conflicting advice?
   - Are deprecated approaches still recommended in older articles?
   - Do code examples contradict stated best practices?

3. **Check version/date context:**
   - Are contradictions due to dated information?
   - Do later articles supersede earlier ones?

**Output:**
```markdown
### Contradictions and Conflicts

**1. Conflicting Best Practices - Authentication Method**

- **[article-2.md](path)** (L{{line}}-L{{line}}):
  > "Always use connection strings for local development"
  
- **[article-4.md](path)** (L{{line}}-L{{line}}):
  > "Never use connection strings; always use managed identities"

**Context:** Article 2 published {{date}}, Article 4 published {{date}}

**Resolution Needed:** Update article-2 to align with current best practice (managed identities) OR clarify connection strings are ONLY for local dev (add warning)

---

**2. Code Example Contradiction - Error Handling**

{{similar structure}}
```

---

### Phase 4: Redundancy Detection & Gap Identification

**Goal:** Find duplicate content for consolidation and identify missing topics.

---

#### Step 9: Detect Redundant Content

**Identify duplicate explanations:**

1. **Search for concept explanations:**
   - Use `grep_search` with key terms to find all occurrences
   - Calculate text similarity between sections (>70% similar = redundant)

2. **Classify redundancy type:**
   - **Identical duplication:** Same explanation copied across articles (CONSOLIDATE)
   - **Overlapping content:** Similar but not identical (ALIGN and cross-reference)
   - **Intentional repetition:** Brief recaps for context (ACCEPTABLE if <100 words)

3. **Recommend consolidation:**
   - **Primary location:** Where should definitive explanation live?
   - **Secondary locations:** Replace with cross-reference
   - **Estimated word reduction:** How much to cut

**Output:**
```markdown
### Redundant Content Analysis

**Total Redundancies Found:** {{count}}
**Estimated Word Reduction:** {{count}} words ({{percentage}}% of series)

---

#### High-Priority Consolidation (Identical Content)

**1. "{{concept}}" Explanation - 380 words duplicated**

**Primary Location (Keep):**
- **[article-2.md](path)** - L{{line}}-L{{line}} (380 words)
  - **Rationale:** Most comprehensive explanation, includes examples
  - **Action:** Mark as definitive source

**Duplicate Locations (Replace):**
- **[article-4.md](path)** - L{{line}}-L{{line}} (380 words - identical)
  - **Action:** Replace with:
    ```markdown
    For details on {{concept}}, see [Understanding {{concept}}](article-2.md#{{section}}).
    ```
  - **Estimated reduction:** 370 words (kept brief intro)

- **[article-5.md](path)** - L{{line}}-L{{line}} (350 words - 92% similar)
  - **Action:** Same as above
  - **Estimated reduction:** 340 words

**Total Reduction for This Item:** 710 words

---

#### Medium-Priority Consolidation (Overlapping Content)

{{similar structure}}

---

#### Acceptable Repetition (Context Recaps)

**Kept for readability:**
- [article-3.md](path) - L{{line}}: Brief recap of {{concept}} (45 words) - within threshold
```

---

#### Step 10: Identify Coverage Gaps

**Discover missing topics essential to series goals:**

**Method 1: Goal-Based Gap Analysis**

1. Review series goals from Phase 1, Step 2
2. Create topic checklist based on goals
3. Search articles for each topic using `semantic_search`
4. Mark covered vs missing topics

**Method 2: Workspace Mining**

1. Use `semantic_search` to find related articles outside series
2. Identify topics covered elsewhere but missing in series
3. Suggest incorporating or cross-referencing

**Method 3: Web Research (Default Enabled)**

1. **Research current best practices:**
   - Use `fetch_webpage` for official docs (e.g., Microsoft Learn, Azure docs)
   - Query format: "{{series topic}} best practices 2025"
   - Extract recommended approaches, common patterns

2. **Compare with series content:**
   - Are current best practices covered?
   - Is series missing critical security considerations?
   - Are performance optimization topics absent?

3. **Identify outdated content:**
   - Are deprecated APIs still featured?
   - Are newer alternatives available but not mentioned?

**Output:**
```markdown
### Coverage Gaps

#### Critical Gaps (Essential to Series Goals)

**1. Security Best Practices - MISSING**

**Why Critical:** Series goal is "production-ready deployment" but no security coverage

**Expected Topics:**
- Authentication and authorization
- Secrets management (Key Vault, environment variables)
- Network security (VNet integration, private endpoints)
- Data encryption (at rest, in transit)

**Current Coverage:** ❌ None found across {{count}} articles

**Evidence from Web Research:**
- [Official Azure Deployment Guide]({{URL}}) - Dedicates 30% to security
- [Microsoft Learn: Production Best Practices]({{URL}}) - Security is prerequisite

**Recommendation:** 
- **Add new article:** "06-security-best-practices.md" (estimated 2000 words)
- **OR expand article-5:** Add security section (800 words) + appendix (1200 words)

---

**2. Monitoring and Diagnostics - INCOMPLETE**

**Why Critical:** Production deployments require observability (series goal)

**Expected Topics:**
- Application Insights integration ✅ (covered in article-3)
- Custom metrics and dashboards ❌ (missing)
- Alerting and notifications ❌ (missing)
- Log aggregation ⚠️ (briefly mentioned, needs expansion)

**Current Coverage:** 25% (1 of 4 topics)

**Recommendation:**
- Expand [article-3.md](path) section "Monitoring" (currently L{{line}}-L{{line}}, 200 words)
- Add subsections for missing topics (estimated +600 words)

---

#### Supporting Gaps (Recommended for Completeness)

{{similar structure}}

---

#### Adjacent Topics (Optional Coverage)

{{similar structure}}
```

---

### Phase 5: Extension Opportunities Research

**Goal:** Discover adjacent topics, emerging trends, and alternatives relevant to series.

---

#### Step 11: Discover Adjacent and Emerging Topics

**Research related subjects not currently covered:**

**1. Adjacent Topics (Naturally Related)**

Use `semantic_search` and `fetch_webpage` to research:
- Topics frequently mentioned alongside series topics
- Common next steps after series completion
- Prerequisite knowledge users may lack

**Example queries for Azure deployment series:**
- "Azure DevOps pipeline best practices"
- "Infrastructure as Code with Bicep"
- "Cost optimization for Azure deployments"

**2. Emerging Topics (Industry Trends)**

Research current developments:
- New features in services covered by series
- Paradigm shifts in the domain (e.g., serverless, containers)
- Community-driven innovations

**Fetch recent content:**
- Fetch release notes/changelogs from official sources
- Query: "{{topic}} new features 2025"
- Query: "{{topic}} future roadmap"

**Output:**
```markdown
### Extension Opportunities

#### Adjacent Topics (Natural Next Steps)

**1. CI/CD Pipeline Integration**

**Relevance:** Series covers manual deployment; automation is natural progression

**Current Mentions:**
- [article-5.md](path) - L{{line}}: Brief reference to "automated deployments"
- No detailed coverage

**Research Findings:**
- [Azure DevOps Documentation]({{URL}}) - 80% of Azure users use automated pipelines
- [GitHub Actions for Azure]({{URL}}) - Growing adoption since 2023

**Recommendation:**
- **Add new article:** "07-automated-deployment-pipelines.md"
- **Content:** GitHub Actions, Azure DevOps Pipelines, deployment slots
- **Priority:** HIGH (core workflow for production)
- **Placement:** After article-5 (deployment basics), before article-8 (if exists)

---

**2. Infrastructure as Code (IaC)**

**Relevance:** Series uses Azure Portal; IaC is industry best practice

{{similar structure}}

---

#### Emerging Topics (Recent Developments)

**1. Azure Container Apps (2024+)**

**Relevance:** Series covers Azure App Service; Container Apps is newer alternative

**Research Findings:**
- [Microsoft Announcement]({{URL}}) - GA in 2023, rapid adoption
- Positioned as "serverless containers" - simpler than AKS
- Cost-effective for microservices

**Current Coverage:** ❌ Not mentioned

**Recommendation:**
- **Update article-1:** Add comparison table (App Service vs Container Apps vs Functions)
- **Add appendix:** "Appendix A: Alternative Hosting Options"
- **Priority:** MEDIUM (important alternative, but not core to current series focus)
- **Treatment:** Brief comparison in main body (200 words) + detailed appendix (800 words)

---

{{additional emerging topics}}
```

---

#### Step 12: Discover and Compare Alternatives

**Research alternative approaches to topics covered in series:**

**1. Identify Alternatives**

For major topics/tools in series:
- Query: "alternatives to {{tool/service}}"
- Query: "{{tool}} vs {{competitor}}"
- Fetch comparison articles from official sources

**2. Objective Comparison Criteria**

| Criterion | {{Primary Tool}} | {{Alternative 1}} | {{Alternative 2}} |
|-----------|------------------|-------------------|-------------------|
| **Use Case** | {{description}} | {{description}} | {{description}} |
| **Complexity** | {{low/medium/high}} | {{rating}} | {{rating}} |
| **Cost** | {{pricing model}} | {{pricing}} | {{pricing}} |
| **Performance** | {{benchmarks}} | {{benchmarks}} | {{benchmarks}} |
| **Ecosystem** | {{maturity, support}} | {{status}} | {{status}} |

**3. Recommendation Pattern**

- **Main body mention:** Brief acknowledgment of alternatives (100-200 words)
- **Appendix detail:** Comprehensive comparison (if relevant)
- **When to use alternative:** Specific scenarios favoring each option

**Output:**
```markdown
### Alternatives Analysis

#### Alternative Hosting Options

**Context:** Series focuses on Azure App Service for web hosting

**Alternatives Discovered:**
1. Azure Container Apps
2. Azure Functions (serverless)
3. Azure Kubernetes Service (AKS)
4. Azure Static Web Apps

**Comparison Research:**

| Option | Best For | Complexity | Cost (est.) | When to Use |
|--------|----------|------------|-------------|-------------|
| **App Service** | Traditional web apps | Low | $50-200/mo | Multi-page apps, always-on services |
| **Container Apps** | Microservices | Medium | $20-100/mo | Event-driven apps, scale-to-zero |
| **Functions** | Event processing | Low | $0-50/mo | Scheduled tasks, webhooks |
| **AKS** | Complex orchestration | High | $200+/mo | Multi-container apps, advanced networking |
| **Static Web Apps** | JAMstack sites | Very Low | $0-10/mo | Static sites with API backend |

**Research Sources:**
- [Azure Architecture Center: Compute Decision Tree]({{URL}})
- [Pricing Comparison Calculator]({{URL}})

**Current Series Coverage:**
- ✅ App Service - Primary focus (all articles)
- ⚠️ Functions - Mentioned in article-1 (L{{line}})
- ❌ Container Apps - Not mentioned
- ❌ AKS - Not mentioned
- ❌ Static Web Apps - Not mentioned

**Recommendations:**

**1. Update [article-1.md](path)]**
- **Location:** After "Why App Service" section (L{{line}})
- **Add:** Brief comparison table (above format, condensed to 150 words)
- **Action:** 
  ```markdown
  > **Note:** This series focuses on Azure App Service. For alternative hosting options, 
  > see [Appendix A: Comparing Azure Hosting Options](#appendix-a).
  ```

**2. Add Appendix to article-1 or series README:**
- **Title:** "Appendix A: Comparing Azure Hosting Options"
- **Content:** 
  - Detailed comparison table (above)
  - Decision tree ("Use App Service if..., Use Container Apps if...")
  - Links to official migration guides
- **Word Count:** ~800 words
- **Priority:** MEDIUM (helps readers validate their choice)

**3. Cross-reference from article-5 (deployment):**
- Add note: "These deployment steps are specific to App Service. For Container Apps deployment, see [alternative guide]({{link}})."
```

---

### Phase 6: Recommendations Report

**Goal:** Generate comprehensive recommendations with series redefinition, per-article action items, and priorities.

---

#### Step 13: Series Redefinition Recommendations

**Based on all findings, propose structural changes:**

**1. Rename Articles (for clarity/consistency)**

| Current Title | Proposed Title | Rationale | Priority |
|---------------|----------------|-----------|----------|
| {{current}} | {{proposed}} | {{reason}} | {{HIGH/MEDIUM/LOW}} |

**2. Delete Articles (redundancy/obsolescence)**

| Article | Reason for Deletion | Content Disposition | Priority |
|---------|---------------------|---------------------|----------|
| {{filename}} | {{reason}} | {{merge into X / archive / delete}} | {{priority}} |

**3. Add New Articles (gap coverage)**

| Proposed Article | Position | Topics Covered | Est. Words | Priority |
|------------------|----------|----------------|------------|----------|
| {{filename}} | After article-{{N}} | {{topics}} | {{count}} | {{priority}} |

**4. Reorder Articles (logical flow)**

| Current Order | Proposed Order | Reason |
|---------------|----------------|--------|
| {{list}} | {{reordered list}} | {{rationale}} |

**5. Split Articles (scope too broad)**

| Article to Split | New Articles | Rationale | Priority |
|------------------|--------------|-----------|----------|
| {{filename}} | {{part-1}}, {{part-2}} | {{reason}} | {{priority}} |

**6. Merge Articles (scope too narrow)**

| Articles to Merge | New Article | Rationale | Priority |
|-------------------|-------------|-----------|----------|
| {{file1}}, {{file2}} | {{merged-filename}} | {{reason}} | {{priority}} |

**Output:**
```markdown
## Series Redefinition Recommendations

### Current Series Structure
{{list current articles with word counts}}

### Proposed Series Structure
{{list proposed structure with changes highlighted}}

### Specific Changes

#### 1. Add New Articles (3 proposed)

**1.1 Add "06-security-best-practices.md"**
- **Position:** After article-5 (deployment), before conclusion
- **Topics:** Authentication, secrets management, network security, encryption
- **Estimated Length:** 2000 words
- **Rationale:** Critical gap - production deployment series must cover security
- **Priority:** 🔴 HIGH

**1.2 Add "07-ci-cd-automation.md"**
{{similar structure}}

---

#### 2. Rename Articles (1 proposed)

**2.1 Rename article-3.md**
- **Current:** "Setting Up Your App"
- **Proposed:** "Application Configuration and Settings"
- **Rationale:** More descriptive; aligns with article-2 ("Resource Provisioning") naming pattern
- **Priority:** 🟡 MEDIUM

---

#### 3. Restructure article-1.md (split recommended)

**Current:** "Introduction and First Deployment" (3500 words - covers 2 distinct topics)

**Proposed Split:**
- **01-introduction.md** (1200 words):
  - Overview of Azure App Service
  - Use cases and alternatives
  - Series prerequisites
  
- **02-first-deployment.md** (2300 words):
  - Portal walkthrough
  - Sample application deployment
  - Validation steps

**Rationale:** Article-1 is 2x longer than others; mixes conceptual overview with hands-on practice
**Priority:** 🟡 MEDIUM

---

#### 4. No Deletions Recommended

All current articles provide unique value.

---

#### 5. Merge Opportunity (optional)

**Consider merging article-4 + article-5:**
- **Article-4:** "Configuring Domains" (800 words)
- **Article-5:** "Deploying with Custom Domains" (1200 words)
- **Rationale:** Topics are tightly coupled; users configure + deploy together
- **Proposed:** "04-custom-domains-and-deployment.md" (2000 words combined)
- **Priority:** 🟢 LOW (current structure acceptable)

---

### Proposed Reading Order (if all changes applied)

1. Introduction and Overview (NEW split from article-1)
2. Resource Provisioning (current article-2)
3. First Deployment (NEW split from article-1)
4. Application Configuration (current article-3, renamed)
5. Custom Domains and Deployment (MERGED article-4 + article-5)
6. Security Best Practices (NEW)
7. CI/CD Automation (NEW)
8. Monitoring and Operations (current article-6)
```

---

#### Step 14: Per-Article Action Items

**For EACH article, generate prioritized action list:**

**Output:**
```markdown
## Per-Article Action Items

### [01-introduction-and-first-deployment.md](path)

**Priority Summary:** 🔴 HIGH (3 critical, 5 medium, 2 low)

---

#### Critical Actions (Fix Immediately)

**1. Fix Terminology Inconsistency - "Authentication" (L45, L78, L120)**
- **Issue:** Uses "auth", "authentication", "identity verification" interchangeably
- **Action:** Standardize to "authentication" (industry standard)
- **Locations:**
  - L45: "To enable auth..." → "To enable authentication..."
  - L78: "identity verification process" → "authentication process"
  - L120: "auth configuration" → "authentication configuration"
- **Estimated Time:** 5 minutes

**2. Add Missing Cross-Reference (L250)**
- **Issue:** Mentions "monitoring" without linking to article-6
- **Current:** "You should set up monitoring for production apps."
- **Action:** Add link: "You should set up monitoring for production apps (see [Monitoring and Operations](article-6.md))."
- **Estimated Time:** 2 minutes

**3. Update Bottom Metadata - Add Series Validation**
- **Issue:** Missing `validations.series_validation` section
- **Action:** Add to bottom metadata block:
  ```yaml
  validations:
    series_validation:
      last_run: "2025-12-25T10:00:00Z"
      series_name: "Azure App Service Deployment Guide"
      article_position: 1
      total_articles: 6
      consistency_score: 7
      issues_addressed: 8
  ```
- **Estimated Time:** 3 minutes

---

#### Medium Priority Actions (Address Soon)

**4. Consolidate Redundant Content (L180-L220)**
- **Issue:** "What is App Service" explanation duplicated in article-2 (L50-L85)
- **Current:** 380 words in both articles (95% identical)
- **Action:**
  - Keep explanation in article-1 (primary location)
  - In article-2 L50-L85, replace with:
    ```markdown
    For an overview of Azure App Service, see [What is App Service](article-1.md#what-is-app-service).
    ```
- **Word Reduction:** 370 words
- **Estimated Time:** 10 minutes

**5. Add Alternatives Comparison (After L100)**
{{similar structure}}

---

#### Low Priority Actions (Optional Improvements)

**6. Improve Code Example Formatting (L300-L320)**
{{similar structure}}

---

### [02-resource-provisioning.md](path)

**Priority Summary:** 🟡 MEDIUM (1 critical, 3 medium, 4 low)

{{similar structure for each article}}

---

### Series-Wide Actions

**Actions affecting multiple articles:**

**1. Standardize Code Block Annotations**
- **Files Affected:** All 6 articles
- **Issue:** Inconsistent language annotations (```bash vs ```shell vs ```console)
- **Action:** Standardize to ```bash for shell commands
- **Estimated Time:** 20 minutes (across series)

**2. Update All Bottom Metadata with Series Validation**
- **Files Affected:** All 6 articles (3 missing series_validation section)
- **Action:** Add series_validation to bottom metadata in:
  - article-2.md
  - article-4.md
  - article-5.md
- **Template:** (use same structure as article-1 action #3)
- **Estimated Time:** 10 minutes

**3. Add Appendix A to article-1 or Create Series README**
- **Purpose:** Alternatives comparison (from Phase 5)
- **Content:** See "Alternatives Analysis" section above
- **Decision Needed:** Add to article-1 as appendix OR create `README.md` in series folder?
- **Estimated Time:** 60 minutes
```

---

#### Step 15: Generate Executive Summary

**Final output: Comprehensive series health report**

**Output:**
```markdown
## Series Review Executive Summary

**Series:** Azure App Service Deployment Guide  
**Review Date:** 2025-12-25  
**Articles Analyzed:** 6  
**Total Word Count:** 11,500 words  
**Validation Model:** claude-sonnet-4.5

---

### Overall Health Score: 7.5/10

| Dimension | Score | Status |
|-----------|-------|--------|
| **Consistency** | 6/10 | 🟡 Needs Improvement |
| **Completeness** | 7/10 | 🟡 Good, gaps identified |
| **Redundancy** | 8/10 | ✅ Minimal issues |
| **Logical Flow** | 9/10 | ✅ Strong progression |
| **Currency** | 7/10 | 🟡 Some outdated info |
| **Cross-Referencing** | 6/10 | 🟡 Incomplete links |

---

### Key Findings

#### Strengths ✅
- Strong logical progression from basics to advanced topics
- Consistent article structure (all have intro, main content, references)
- Clear target audience (intermediate developers)
- Good use of code examples throughout

#### Critical Issues 🔴
1. **Security gap** - No coverage of auth, secrets, network security (essential for production)
2. **Terminology inconsistencies** - 12 terms with 2+ variations across articles
3. **Missing alternatives discussion** - Readers can't validate App Service is right choice
4. **Broken cross-references** - 5 links to non-existent sections

#### Improvement Opportunities 🟡
1. **Add CI/CD coverage** - Natural next step after manual deployment
2. **Consolidate redundant explanations** - 710 words of duplicate content identified
3. **Update monitoring section** - Missing custom metrics, alerting
4. **Expand prerequisites** - Assume too much Azure knowledge

---

### Recommendations Summary

#### Immediate Actions (Complete Within 1 Week)
1. Fix 12 terminology inconsistencies across 6 articles
2. Repair 5 broken cross-references
3. Add series_validation to all article metadata
4. Update article-3 monitoring section (add missing topics)

**Estimated Effort:** 4 hours

---

#### Short-Term Enhancements (Complete Within 1 Month)
1. **Add new article:** "06-security-best-practices.md" (2000 words)
2. **Add appendix:** "Alternatives Comparison" to article-1 (800 words)
3. Consolidate 3 redundant explanations (save 710 words)
4. Standardize code block formatting across series

**Estimated Effort:** 12 hours

---

#### Long-Term Extensions (Consider for Next Quarter)
1. **Add new article:** "07-ci-cd-automation.md" (2500 words)
2. **Split article-1:** Create separate intro + first deployment articles
3. Research emerging topics: Azure Container Apps migration path
4. Add troubleshooting appendix to each article

**Estimated Effort:** 20 hours

---

### Series Redefinition Proposal

**Current Structure (6 articles, 11,500 words):**
1. Introduction and First Deployment
2. Resource Provisioning
3. Application Configuration
4. Custom Domains
5. Deployment Strategies
6. Monitoring and Operations

**Proposed Structure (8 articles, ~15,000 words):**
1. Introduction and Overview (NEW - split from article-1)
2. Resource Provisioning
3. First Deployment (NEW - split from article-1)
4. Application Configuration
5. Custom Domains and Deployment (MERGED article-4 + article-5)
6. **Security Best Practices (NEW)**
7. **CI/CD Automation (NEW)**
8. Monitoring and Operations

**Rationale:** Better logical flow, critical gap coverage, balanced article lengths

---

### Appendix: Detailed Findings

- **Full Terminology Matrix:** [See Phase 3, Step 6](#terminology-inconsistencies)
- **Redundancy Analysis:** [See Phase 4, Step 9](#redundant-content-analysis)
- **Coverage Gaps:** [See Phase 4, Step 10](#coverage-gaps)
- **Extension Opportunities:** [See Phase 5](#extension-opportunities)
- **Per-Article Actions:** [See Phase 6, Step 14](#per-article-action-items)

---

### Validation Metadata Updates

**For each article, add to bottom metadata block:**

```yaml
validations:
  series_validation:
    last_run: "2025-12-25T10:00:00Z"
    model: "claude-sonnet-4.5"
    series_name: "Azure App Service Deployment Guide"
    article_position: {{N}}
    total_articles: 6
    consistency_score: {{1-10}}
    completeness_score: {{1-10}}
    redundancy_score: {{1-10}}
    issues_found: {{count}}
    issues_critical: {{count}}
    issues_medium: {{count}}
    issues_low: {{count}}
```

**Do NOT create separate series metadata file** (per user requirement).
```

---

## Output Format

**Comprehensive series review report containing:**

1. **Series Discovery Results** - Articles found, reading order, metadata
2. **Series Goals and Scope** - Objectives, audience, learning progression
3. **Evaluation Criteria** - Consistency standards, coverage requirements
4. **Cross-Article Content Analysis** - Terminology matrix, concept coverage
5. **Terminology Inconsistencies** - Variations found with line numbers
6. **Structural Inconsistencies** - Missing sections, formatting issues
7. **Contradictions and Conflicts** - Conflicting advice across articles
8. **Redundant Content Analysis** - Duplicate content with consolidation plan
9. **Coverage Gaps** - Missing critical, supporting, and adjacent topics
10. **Extension Opportunities** - Adjacent topics, emerging trends, alternatives
11. **Alternatives Analysis** - Objective comparisons with recommendations
12. **Series Redefinition Recommendations** - Rename/delete/add/reorder/split/merge
13. **Per-Article Action Items** - Prioritized tasks with line numbers
14. **Executive Summary** - Health scores, key findings, recommendations timeline

---

## References

**Context Files:**
- [Dual YAML Metadata Guide](../../.copilot/context/90.00%20learning-hub/02-dual-yaml-metadata.md) - Metadata structure and parsing rules
- [Prompt Engineering Principles](../../.copilot/context/00.00%20prompt-engineering/01-context-engineering-principles.md) - Context optimization
- [Article Template](../../.github/templates/article-template.md) - Standard article structure

**Related Prompts:**
- [Single Article Review](article-review-for-consistency-gaps-and-extensions.prompt.md) - Individual article analysis
- [Fact Checking](fact-checking.prompt.md) - Reference validation
- [Structure Validation](structure-validation.prompt.md) - Template compliance

**Official Documentation:**
- Use `fetch_webpage` for current best practices from Microsoft Learn, Azure docs
- Prefer official sources over third-party blogs for gap analysis

---

<!-- 
---
prompt_metadata:
  template_version: "2.0"
  created_date: "2025-12-25"
  last_updated: "2025-12-25"
  validation_status: "active"
  
validations:
  structure:
    status: "passed"
    last_run: "2025-12-25T10:00:00Z"
    model: "claude-sonnet-4.5"
    issues_found: 0
---
-->
