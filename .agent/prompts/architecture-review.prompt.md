---
description: "Use when reviewing or refactoring architecture, module boundaries, dependencies, layering, or code organization."
argument-hint: "Describe the architecture task or selected files to review"
agent: "agent"
---
Review the architecture of the provided code or task and produce a focused recommendation.

Use these rules:
- Identify the current responsibility of each module or layer.
- Detect tight coupling, duplicated logic, or unclear boundaries.
- Prefer small, incremental changes over large rewrites.
- Reuse the existing architectural style in the repo before proposing a new one.
- If the change affects shared contracts, explain the impact on dependent code.
- Recommend the narrowest useful validation: tests, lint, typecheck, or build.

Output format:
1. Current state
2. Main architectural issue(s)
3. Recommended change
4. Risks or tradeoffs
5. Next validation step

If the user selected files, use that context first. If not, infer the relevant modules from the task description and keep the recommendation concrete.
