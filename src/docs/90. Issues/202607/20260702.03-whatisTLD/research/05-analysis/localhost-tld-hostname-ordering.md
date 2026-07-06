# Area analysis — the `.localhost` TLD and hostname ordering

Depth: **standard**. Taxonomy target: **Concepts** (with an Overview entry point).

## Problem statement

Why does .NET 10 generate `contosoapi.dev.localhost` (app-first) rather than the seemingly "standard" environment-first `dev.contosoapi.localhost`? What makes one ordering more useful?

## Additional considerations

- `.localhost` is a reserved special-use TLD (RFC 6761); it and everything under it resolve to loopback with no DNS/`hosts` config. So both orderings resolve equally — resolution is not the differentiator.
- DNS is hierarchical and read right-to-left: the rightmost label is the top; each left label is a child under it.

## Deductions

- `contosoapi.dev.localhost` makes `dev.localhost` a **shared suffix** with each service a sibling leaf → mirrors production `service.company.com`.
- `dev.contosoapi.localhost` makes `contosoapi.localhost` the domain with environments beneath one app → groups *environments of one app*, not *services of one environment*.
- The shared-suffix grouping is what enables cross-service sharing: cookies/SSO scoped to `dev.localhost`, one `*.dev.localhost` wildcard cert, clean CORS origin sets, and host-based routing by leftmost label.

## Conclusions

- The difference is **semantic grouping**, not resolution.
- App-first ordering is preferred because it matches production conventions and unlocks shared cookies/SSO, wildcard TLS, CORS, and routing across local services. Hence .NET generates `{projectname}.dev.localhost`.

## Appendix A — Evidence

- [RFC 6761 — Special-Use Domain Names (`localhost`)](https://www.rfc-editor.org/rfc/rfc6761) 📘 [Official]
- [MDN — `Set-Cookie` `Domain` attribute](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie) 📗 [Verified Community]
- Local: this issue's `overview.md` (screenshot of the .NET 10 option and tooltip).

## Appendix B — Validation

- Confidence: **high**. Grounded in RFC 6761 (resolution) and standard cookie-domain scoping (sharing), consistent with the .NET 10 tooltip behavior shown in the issue screenshot.
