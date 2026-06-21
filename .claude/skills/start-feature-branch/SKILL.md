---
name: start-feature-branch
description: Git flow for starting and building the next feature on its own branch, then handing off for review. Use when the user (or a delegated session/agent) is about to begin a new feature, asks to "start a feature", "pick up the next task", or wants the branch-implement-PR workflow.
---

# Start a feature branch

The disciplined way to begin a unit of work: get to a clean starting point, branch, implement, verify, then hand the finished changes to `commit-split-review` for splitting and a PR. This is the *front end* of the loop; `commit-split-review` is the back end. Never commit straight to `main`.

## When to use

Triggers: "start a feature", "begin the next task", "let's build X", "new branch for Y", or any session/agent picking up implementation work from a brief.

This skill is feature-agnostic — the feature is whatever the user or session names; it does not read any task list itself.

## Step 1 — Reach a clean starting point

Before branching, the working tree must be clean and `main` current. Run `git status` and `git fetch`.

- **Uncommitted changes present?** Stop. Do not absorb stray edits into a new feature. Ask the user whether to stash, commit them separately first (via `commit-split-review`), or discard. Never `git reset --hard` or `git clean` without explicit confirmation.
- **Not on `main`?** Switch to `main` (after handling any in-progress branch) unless the user wants to branch off the current branch deliberately.
- Update: `git pull --ff-only origin main` so the branch starts from the latest.

## Step 2 — Create the branch

Branch off `main` with a descriptive, kebab-case name prefixed by type:

- `feat/<slug>` — new capability
- `fix/<slug>` — bug fix
- `refactor/<slug>` — restructuring, no behavior change
- `chore/<slug>` — tooling, deps, config

`git switch -c feat/<slug>`. Keep the slug short and specific (`feat/supplier-csv-import`, not `feat/suppliers`).

One feature = one branch. If the work splits into independent features, make separate branches; don't pile unrelated work onto one branch.

## Step 3 — Implement

Build the feature, matching the surrounding code's conventions (this repo: integer-centavos money, soft deletes, UUIDs, pt-BR domain terms, DK-XXXX error codes — see CLAUDE.md). Stay inside the feature's scope; park unrelated cleanups for their own branch rather than smuggling them in.

Do **not** commit incrementally as you go unless the change is large enough that checkpoints help. The commit *story* is composed deliberately at the end by `commit-split-review`, not accreted ad hoc. (If you do checkpoint, keep them rough — they'll be reshaped.)

## Step 4 — Verify before handing off

Run the project's own gates and make them pass before review. For this repo:

- `npm run build` — type-check + build frontend
- `cargo check` (from `src-tauri/`) — backend compiles
- `cargo clippy` (from `src-tauri/`) if backend logic changed

Substitute the target project's build/test/lint commands. A feature isn't ready for review until its gates are green. Report any failure you can't resolve instead of pushing past it.

## Step 5 — Hand off

The feature is built and verified but **not yet committed into a clean history**. Invoke `commit-split-review` to measure the changes, split them into reviewable commits, get the user's sign-off, push, and open the PR. Do not push or open the PR from this skill — that gate belongs to the user via `commit-split-review`.
