# Approval and integration proposal

## Approval state

`approved` (2026-07-06).

## Integration performed

| Approved conclusion | Taxonomy category | Target | Status |
|---|---|---|---|
| `.localhost` TLD orientation | Overview | `03.00-tech/04.05-web-development/10.00-local-development-dns/00-overview.md` | ✅ created |
| Hostname ordering explanation | Concepts | `.../10.00-local-development-dns/02-concepts-localhost-tld-and-hostname-ordering.md` | ✅ created |
| Answer the source question | — | this issue's `overview.md` (cleaned + Follow-up section) | ✅ edited |
| Bidirectional cross-link | Concepts | `01.00-blazor/02.01-concepts-blazor-with-aspire.md` "Where to go next" | ✅ edited |

## Placement rationale (derived, not asked)

- Content types → subject-folder template: Overview → `00-overview`, Concepts → `02-concepts-*`.
- New cross-cutting subject folder `10.00-local-development-dns` under `04.05-web-development/`; prefix `10.00` separates it from the framework subfolders (`01.00`–`04.00`).

## Deferred follow-ups (backlog)

- [x] **Done (2026-07-06):** How-to on routing `*.dev.localhost` with a local reverse proxy (YARP) + wildcard dev cert — `03.00-tech/04.05-web-development/10.00-local-development-dns/03-howto-route-dev-localhost-with-yarp-and-wildcard-cert.md`.
- [ ] Optional: expand into getting-started once a concrete multi-service walkthrough exists.
