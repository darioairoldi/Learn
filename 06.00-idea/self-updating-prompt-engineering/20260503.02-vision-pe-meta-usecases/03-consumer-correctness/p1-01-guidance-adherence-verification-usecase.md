# UC-11: Guidance adherence verification

> **Group:** C - Consumer implementation correctness  
> **Priority:** P1  
> **Order in group:** 2 (run after UC-12)

## Invocation

**Command family:** Guidance-first  
**Primary entry point:** `/pe-meta-adherence <guidance-path>`  
**Alternative entry points:**
- `/pe-meta-agent-review <path> --dim adherence --deps direct` (consumer-side adherence check)
- `/pe-meta-scheduled-review --deps full` (every 4th rotation delegates to adherence)

**Supported options:**

| Option | Relevance to this use case |
|---|---|
| `--dim adherence` | Focus on `D5-boundaries`, `D6-consistency`, `D16-adherence`, `D18-coverage` (adherence-related; legacy alias: `--dim robustness`) |
| `--scope agents` | Limit consumer check to agents |
| `--scope prompts` | Limit consumer check to prompts |
| `--deps direct` | Check first-level consumers only |
| `--deps full` | Transitive consumer-of-consumer traversal |
| `--skip research,structure` | Focus on adherence analysis only |
| `--mode apply` | Assess and implement improvements autonomously for low-risk findings; propose changes for high-risk findings (default) |
| `--mode plan` | Assessment only — produce findings report without changes (opt-in for read-only output) |

> **Guidance-first semantics:** When invoked via `/pe-meta-adherence`, this use case starts from the guidance file, enumerates ALL consumers, and checks each one. This is the reverse direction from consumer-side review.

## Behavior

Checks whether consumer artifacts (agents, prompts) actually IMPLEMENT the rules from the context files they reference — not just whether the references resolve, but whether the rules are followed.

**Invocation examples:**
```
/pe-meta-agent-review pe-gra-prompt-validator.agent.md --dim adherence --deps full     # assess + implement low-risk (default)
/pe-meta-adherence 01.07-critical-rules-priority-matrix.md                             # guidance-first (default apply)
/pe-meta-adherence 01.07-critical-rules-priority-matrix.md --mode plan                 # assess only (opt-in read-only)
```

**Dimensions covered:** `D16-adherence`

**Checks performed:**
- For each `📖` or category-based reference in the artifact, read the referenced context file
- Extract each rule (MUST/NEVER/ALWAYS statement) from the context file
- Check whether the consumer artifact's behavior implements that rule:
  - Is the rule present in the consumer's checklist, boundary, or process phase?
  - Does the consumer's implementation match the canonical definition?
  - Does the consumer cover all rules, or only a subset?
- Produce adherence matrix: `{rule × consumer → implemented|partial|missing}`

**Guidance-first mode** (`/pe-meta-adherence`): Inverts the direction — starts from a guidance file, enumerates ALL consumers, checks each one. Produces a system-wide adherence matrix.

## Post-assessment behavior

By default (`--mode apply`), the command evaluates each finding against the vision's change classification:

| Finding risk | Action | Confirmation |
|---|---|---|
| **Non-breaking** (goal, scope, boundaries preserved) + high confidence | Apply autonomously | Post-execution notification only |
| **Non-breaking** + medium confidence | Apply with lightweight pre-notification | User can abort within notification window |
| **Breaking** (changes goal, scope, or boundaries) | Propose as plan | Requires explicit human confirmation |
| **Uncertain** (cannot classify risk) | Propose as plan | Requires explicit human confirmation |

The risk assessment integrates with the autonomy gradient defined in the vision:
- **Structural fixes** (formatting, reference links, metadata) → Always non-breaking → Autonomous
- **Content additions** (missing dimensions, expanded coverage) → Usually non-breaking → Autonomous with notification
- **Content removals or rewrites** → May be breaking → Propose
- **Scope changes** (new artifact types, new boundary rules) → Breaking → Always propose

## Reliability analysis

| Factor | Assessment |
|---|---|
| **Determinism** | ❌ Requires LLM reasoning — "does this agent implement rule H12?" is a semantic question |
| **False positives** | LOW-MEDIUM — may flag implicit implementation as missing (agent follows the rule but doesn't explicitly cite it) |
| **False negatives** | MEDIUM — a consumer may claim to implement a rule but do so incorrectly |
| **Consistency** | ⚠️ Depends on LLM's ability to trace rule → implementation mapping |

**Reliability score: MEDIUM** — semantic, but the structured format (rule text → search for matching check in consumer) provides a clear assessment path. Higher reliability when rules are explicit (MUST/NEVER/ALWAYS) vs. implicit (prose guidance).

## Effectiveness analysis

| Factor | Assessment |
|---|---|
| **Catches real issues** | ✅ This is THE check that would have caught the slash-command gap |
| **Real-world example** | H12 defined 3 reference types; validators only checked 2. Adherence matrix would show ⚠️ 2/3 |
| **Unique value** | Only dimension that checks the IMPLEMENTATION side — all other dimensions check the SPECIFICATION side |

**Effectiveness score: VERY HIGH** — the most impactful dimension for system-level quality. Without it, rules can exist but never be enforced.

## Efficiency analysis

| Factor | Assessment |
|---|---|
| **Token cost** | HIGH — requires reading consumer + all its referenced guidance files + LLM comparison |
| **Model routing** | Reasoning model for rule-implementation matching |
| **Time** | 30-60s per consumer; guidance-first mode: 5-10 minutes for high-consumer files |
| **Recommended frequency** | After rule changes; during scheduled reviews; when investigating quality gaps |

**Efficiency score: LOW-MEDIUM** — expensive but uniquely valuable. Cost bounded by (1) batching consumers one at a time, (2) only checking adherence for rules affected by recent changes, (3) caching per-consumer results.
