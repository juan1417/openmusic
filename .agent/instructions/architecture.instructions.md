---
description: "Use when designing, reviewing, or refactoring architecture, module boundaries, dependencies, layering, and code organization."
---
# Architecture Guidelines

- Define the responsibility of each module before changing code.
- Prefer high cohesion and low coupling.
- Keep boundaries explicit between UI, domain, data, and infrastructure concerns.
- Avoid introducing new abstractions unless they reduce duplication, clarify ownership, or improve testability.
- When a change spans multiple layers, update the closest layer first and keep the contract between layers small and stable.
- Prefer small, composable modules over large files with mixed responsibilities.
- Reuse existing patterns in the repo before introducing a new architectural style.
- Validate architectural changes with the narrowest useful check: targeted tests, lint, typecheck, or build.
- If a refactor affects shared contracts, update dependent code in the same change or document the required follow-up clearly.
- Keep architecture changes incremental so they are easy to review and revert.
