# Vision use cases sorting improvement plan

## 🎯 Goal
Create a readable, folder-based structure for all vision use cases so they are easy to discover and run in the right order, with high-priority use cases first.

## 📋 Table of contents
- [✅ Alignment completed](#-alignment-completed)
- [✅ Target structure implemented](#-target-structure-implemented)
- [✅ Naming convention applied](#-naming-convention-applied)
- [✅ File migration map executed](#-file-migration-map-executed)
- [✅ Implementation steps](#-implementation-steps)
- [✅ Validation checklist](#-validation-checklist)
- [✅ Improvements implemented after restructuring](#-improvements-implemented-after-restructuring)
- [📌 Future improvements](#-future-improvements)

## ✅ Alignment completed
- ✅ Objective clarified with stakeholder intent: move from UC-code-centric listing to readable folder grouping and readable filenames, with high-priority-first ordering. Completed on 2026-05-21.

## ✅ Target structure implemented
- ✅ Create four folders inside this directory. Completed on 2026-05-21:
  - `01-freshness/`
  - `02-quality-gates/`
  - `03-consumer-correctness/`
  - `04-efficiency/`
- ✅ Keep `README.md` as the entry point with links to all grouped folders. Completed on 2026-05-21.
- ✅ In each folder, order files by execution priority (P0, then P1, then P2/P3). Completed on 2026-05-21.

## ✅ Naming convention applied
- ✅ Use readable filenames with priority + sequence prefix. Completed on 2026-05-21:
  - `p0-01-context-quality-lifecycle.md`
  - `p0-02-release-impact-assessment.md`
  - `p1-01-staleness-source-verification.md`
- ✅ Remove opaque numeric UC prefixes from file names. Completed on 2026-05-21.
- ✅ Keep UC identifier in file title for traceability, for example: `# UC-22: Context quality lifecycle`. Completed on 2026-05-21.

## ✅ File migration map executed
- ✅ Group 1 (`01-freshness`): UC-22, UC-14, UC-05, UC-16. Completed on 2026-05-21.
- ✅ Group 2 (`02-quality-gates`): UC-02, UC-03, UC-04, UC-07, UC-10, UC-08, UC-13. Completed on 2026-05-21.
- ✅ Group 3 (`03-consumer-correctness`): UC-12, UC-11, UC-21. Completed on 2026-05-21.
- ✅ Group 4 (`04-efficiency`): UC-06, UC-20, UC-19, UC-17, UC-18, UC-15, UC-09, UC-01. Completed on 2026-05-21.

## ✅ Implementation steps
1. ✅ Create the four target folders. Completed on 2026-05-21.
2. ✅ Move and rename each use case file according to the migration map and naming convention. Completed on 2026-05-21.
3. ✅ Update `README.md` links and sections to reference new folder paths and readable names. Completed on 2026-05-21.
4. ✅ Update any intra-file links that still point to old filenames. Completed on 2026-05-21 after final stale-link sweep; remaining old names are intentionally preserved only in the compatibility map.
5. ✅ Add a short index file in each folder with run order and one-line purpose. Completed on 2026-05-21.
6. ✅ Run link/integrity checks and fix any broken references. Completed on 2026-05-21.

## ✅ Validation checklist
- ✅ Every use case file is in exactly one group folder. Verified on 2026-05-21.
- ✅ High-priority use cases are first in each folder. Verified on 2026-05-21.
- ✅ No README links point to old file names for active navigation. Verified on 2026-05-21. Exception: root compatibility map intentionally preserves old-to-new filename mapping.
- ✅ No broken markdown links remain in the restructured use-case folder. Verified on 2026-05-21.
- ✅ UC IDs remain visible in each file title for compatibility with existing references. Verified on 2026-05-21.

## ✅ Improvements implemented after restructuring
- ✅ Added machine-readable index file `usecase-index.json` with `id`, `group`, `priority`, `path`, `order`, and `title`. Completed on 2026-05-21.
- ✅ Added group shortcut conventions in catalog README (`--group freshness`, `--group quality-gates`, `--group consumer-correctness`, `--group efficiency`) with command examples. Completed on 2026-05-21.
- ✅ Added compatibility map in root README (old filename -> new filename) for transition support. Completed on 2026-05-21.

## 📌 Future improvements
- 📌 Remove the compatibility map after one release cycle once old links are no longer referenced.
- 📌 Improve human readability further by refining selected use-case titles/headings while keeping UC traceability.
