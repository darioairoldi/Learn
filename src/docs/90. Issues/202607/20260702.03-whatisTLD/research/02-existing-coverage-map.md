# Existing-LearnHub coverage map

Internal grounding for the `.localhost` TLD / hostname-ordering observation, mapped to the taxonomy, before locking the integration target.

**📖 Taxonomy:** `06.00-idea/learning-hub/02-documentation-taxonomy/01-learning-hub-documentation-taxonomy.md`

## Coverage by candidate area

| Candidate area | Coverage | Local evidence | Taxonomy category |
|---|---|---|---|
| `.localhost` TLD / local-dev DNS | `absent` | only incidental `localhost:PORT` mentions in httpclient/quarto/devops articles | Overview / Concepts |
| Hostname ordering (app-first vs env-first) | `absent` | none | Concepts |
| Local hostnames in Aspire/Blazor practice | `partial` | `03.00-tech/04.05-web-development/01.00-blazor/02.01-concepts-blazor-with-aspire.md` | Concepts |

## Repository scan basis

- `grep_search` for `localhost|TLD|top-level domain|DNS|loopback` across `03.00-tech/**`: 33 matches in 16 files, all incidental (`localhost:5001` in HTTP/testing/deploy examples). No conceptual coverage of the `.localhost` TLD or hostname ordering.
- `04.05-web-development/` contains framework subfolders only (`01.00-blazor`, `02.00-react`, `03.00-viewjs`, `04.00-angular`) — no cross-cutting local-dev/networking subject.

## Grounding conclusion

Local-development DNS is an **uncovered, reusable concept**. Correct move: a new cross-cutting subject folder under web-development with an Overview + a Concepts article, cross-linked to the Blazor + Aspire material (where these hostnames appear in practice).
