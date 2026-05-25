# Freshness and lifecycle use cases

## 🎯 Purpose
Use these cases when the main risk is stale logic, stale external assumptions, or context evolution after platform, model, or ecosystem change.

## ⚙️ Recommended command entry points

| Scenario | Command | Options |
|---|---|---|
| Scheduled freshness sweep | `/pe-meta-scheduled-review` | `--dim freshness` |
| Targeted context lifecycle check | `/pe-meta-context-review <path>` | `--dim freshness --deps direct` |
| Release-driven impact assessment | `/pe-meta-release-monitor <url>` | `--dim freshness --scope context` |
| Full staleness audit | `/pe-meta-update --mode plan --skip research` | `--dim freshness` |

**Allowed option classes:** `--dim`, `--scope`, `--deps`, `--skip`

## 📋 Run order
1. [p0-01-context-quality-lifecycle](p0-01-context-quality-lifecycle.md) — main lifecycle orchestrator.
2. [p0-02-release-impact-assessment](p0-02-release-impact-assessment.md) — detects release-driven impact.
3. [p1-01-staleness-source-verification](p1-01-staleness-source-verification.md) — validates freshness and sources for scoped areas.
4. [p1-02-context-optimization](p1-02-context-optimization.md) — optimizes organization after impact is understood.

## ✅ When to start here
- Platform, model, or ecosystem updates.
- Suspected Type B staleness.
- Context-set refresh or source-grounded update work.
