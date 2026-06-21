---
name: tier-tasks-by-model
description: Triage a roadmap or backlog into Opus/Sonnet/Haiku task briefs so work can be delegated across model tiers. Use when the user wants to organize/tier/triage tasks by model, asks which model should do a task, or wants to split work across Opus, Sonnet, and Haiku.
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

Default to **separate sessions** with the model switched per tier file (cheapest, most controllable — each tier keeps a lean context). Subagent orchestration is an option when the user wants hands-off dispatch, but it's pricier and subagents start cold. Confirm the user's preference rather than assuming.

---

## Worked example (Deck — a Tauri/React POS app)

A real triage of remaining Phase 1 + sale-flow work:

**Haiku** (clone existing `customers.rs` / `CustomersPage.tsx`): Categories CRUD, Suppliers CRUD, swap PDV client-side filter for the existing backend `search_products`, sidebar/route wiring.

**Sonnet** (judgment in a known design): keyboard nav across CRUD pages, CSV product import (pt-BR money parsing → i64 centavos), caixa open/close + POS gating, payment modal (cash/change, card/PIX, split), sale persistence + stock decrement, receipt print, item-level discount, sale cancellation, stock-entry module.

**Opus** (pattern-setting / money-txn / reviews): toast API + `DK-XXXX` error taxonomy (every page clones it), first-launch wizard gating, the sale-transaction boundary (atomic vendas+itens+pagamentos+stock), sale-level discount **proportional distribution** (centavos must sum exactly — largest-remainder allocation), audit-log shape. Plus reviewing the sale-numbering, sale-persistence, and cancellation tasks.

Note the two tells in action: the Toast system *looked* like a small Haiku task but it sets the error pattern every page clones → split into Opus design + Haiku rote pass. The discount feature split too: item-level math is Sonnet, but exact-sum sale-level distribution is Opus money-correctness.

Verify commands in that project: `cargo check` (backend) and `npm run build` (frontend) — substitute the target project's own build/test/check commands.
