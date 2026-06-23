---
name: tier-tasks-by-model
description: Triage a roadmap, backlog, or plan into Opus/Sonnet/Haiku task briefs so work can be delegated across model tiers. Use when the user wants to organize/tier/triage tasks by model, asks which model should do a task, or wants to split work across Opus, Sonnet, and Haiku.
---

# Tier tasks by model

Turn a pile of remaining work into model-assigned, self-contained task briefs. The output is three files of briefs — one per tier — that can each be executed in a fresh session with the right model selected.

## When to use

Triggers: "organize tasks by model", "tier/triage this backlog", "which model should do X", "split work across Opus/Sonnet/Haiku", "who should build Y".

If the plan hasn't been stress-tested yet, consider running the `grilling` skill first to interview the user, then triage what the interview produces. Grilling is the front-end; this skill is the output contract.

## Step 1 — Establish scope

Tier only **shovel-ready** work — tasks whose design is settled enough to brief. Undesigned future work (vague one-liners in a roadmap) should stay in a coarse "Opus designs this first, then we tier it" bucket. Tiering undesigned work wastes effort that will be wrong by the time you reach it.

## Step 2 — Apply the triage rule: decisions, not size

The deciding criterion is how many **new decisions** a task makes, not how many lines it is. A "small" task that invents architecture or UX goes *up* a tier.

- **Haiku** — clone an existing in-repo pattern, zero new decisions, the design is already fixed. (e.g. CRUD that mirrors an existing module, route/nav wiring, a mechanical find-and-replace pass.)
- **Sonnet** — net-new logic or multi-file features needing judgment, but within a design that's already fixed. (e.g. a feature with known requirements, import flows, UI flows that follow established conventions.)
- **Opus** — work that *sets a pattern other tasks will clone*, or where correctness bites hardest (money, schema, transactions, concurrency), **plus all reviews**. (e.g. error taxonomies, transaction-boundary design, proportional-allocation math, audit-log shape.)

Watch for tasks disguised as mechanical: anything that defines an API, error format, or convention that other tasks then copy is pattern-setting → Opus, even if the brief looks short. If a "Haiku" task sets a pattern, split it: Opus designs the pattern, Haiku does the rote application afterward.

## Step 3 — Write three files with prescription varied by tier

Output `haiku-tasks.md`, `sonnet-tasks.md`, `opus-tasks.md` (at repo root unless told otherwise). Prescription level differs because over-specifying a Sonnet task wastes its judgment, and under-specifying a Haiku task is how it goes off the rails:

- **Haiku briefs** — fully prescriptive: exact file paths, struct/field lists, "clone file X." Self-contained enough to paste into a cold session.
- **Sonnet briefs** — goal + constraints + acceptance criteria + verify command. Let it explore the codebase for patterns itself; don't name every file.
- **Opus briefs** — problem statement + the decision to make + options. No prescribed answer. The deliverable includes the documented pattern so downstream tiers can clone it.

Tag every task with: **dependencies**, the **converge point** it belongs to, and its **verify command** (the build/check/test that gates it). Put a status checklist at the top of each file.

## Step 4 — Sequence: parallel-then-converge

Don't serialize everything behind Opus. Independent Haiku clones and Opus pattern-design run **concurrently**. Only pattern-dependent Sonnet work waits for a converge point (the moment a pattern-setting Opus task lands and downstream work can adopt it). Identify converge points explicitly and list which tasks unblock at each.

## Step 5 — Set a risk-based review policy

Reviewing mechanical clones with Opus wastes the savings of using Haiku at all. Skipping review on money code ships silent bugs. So:

- **Haiku output** — gated by mechanical checks only (build + type-check pass) plus a fast diff scan. No Opus review unless a check fails.
- **Opus reviews** — pattern-setting output (everything inherits it) and money/schema/transaction/concurrency code (where bugs bite). Use a `/code-review`-style pass at each converge point rather than ad-hoc reading.

## Step 6 — Execution mechanism

Default to **separate sessions** with the model switched per tier file (cheapest, most controllable — each tier keeps a lean context). With Claude Code's Agent tool, you can specify `model` per subagent for in-session dispatch. Confirm the user's preference rather than assuming.
