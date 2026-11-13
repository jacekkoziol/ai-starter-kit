# Suggesting MCP servers — opt-in research

> Load this **only** after the user says yes to bootstrap step 4.5's offer (first adoption, or a refresh
> after a major stack change), or asks for MCP suggestions later. Recording servers the project already
> has is step 4.5's job; this file only proposes ones it doesn't have yet.

1. **Derive needs from evidence, not taste.** From what bootstrap steps 2–4.5 already read — the
   dependency manifest and framework, the platform or web standards the code targets, external services
   and APIs it calls, design-tool / ticket / docs links in the harvested instruction sources — list the
   concrete needs a server could meet (current library docs, a framework's own CLI or dev tooling, a
   platform reference, a service's API, a design source). Drop needs an already-configured server covers.
2. **Research each need.** Find current candidates; prefer an **official or vendor-maintained** server,
   then a widely adopted one. Note its source, maintainer, and the access it needs (filesystem, network,
   credentials). Research means reading docs — never install or run a candidate to evaluate it. No web
   access in this session? Say so, then either skip or suggest from your own knowledge **marked
   unverified**.
3. **Rank and cap.** Present at most **7**, strongest evidence first: every server's tools load into
   every session, so fewer is better. Go past 7 only when each extra server rests on its own repo
   evidence — and say so.
4. **Present, one decision per server** (batch the presentation, AGENT-INSTRUCTIONS §2.2): name · need +
   evidence · source + maintainer · access and credentials · rough per-session cost (tool count, if
   known). Never present an unverified server as verified.
5. **Apply only on an explicit yes.** An accepted server follows step 4.5's path — config visibility
   decides between the project's tool config (your runtime's documented file; a repo change, so the
   normal gate applies) and a `(runtime-only)` entry — and lands under `PROJECT.md` → Available.
   Record a local server at an **exact version** — never `latest` or an open range, since that config
   runs third-party code every session — and a hosted one by its official URL.
   Credentials go in environment variables or the runtime's secret store, **never** in committed config
   (the secrets HARD RULE, AGENT-INSTRUCTIONS §1). A declined server leaves no trace.
