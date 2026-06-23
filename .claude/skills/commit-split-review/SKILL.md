---
name: commit-split-review
description: Measure everything changed in the working tree, split it into a sequence of logical commits, present the plan for the user to review, and only push (and open a PR) after they approve. Use when the user wants to wrap up work, "split this into commits", "review my changes before pushing", "commit and PR", or finish a feature branch.
---

# Commit, split, review, push

Turn a pile of working-tree changes into a clean, reviewable commit sequence. The user reviews the plan and the commits **before anything leaves the machine**. This is the back end of the loop that `start-feature-branch` begins.

The contract: **measure → propose → user reviews → commit → user approves → push → PR.** Never push or open a PR without explicit approval. Pushing publishes work the user hasn't seen.

## When to use

Triggers: "split this into commits", "review my changes before I push", "commit and open a PR", "wrap up this branch", "what changed and how should it be committed".

## Step 1 — Measure what changed

Survey the full surface before grouping anything:

- `git status` — staged, unstaged, untracked.
- `git diff` and `git diff --staged` — the actual content.
- `git log main..HEAD --oneline` if on a feature branch with prior commits — what's already committed vs. still loose.

Read the diffs, don't just count files. You're looking for the *distinct intents* tangled together in the working tree.

## Step 2 — Group into logical commits

Partition the changes into commits that each tell one coherent story. Good seams:

- One concern per commit — a feature, a fix, a refactor, a config bump are separate commits even if edited together.
- Each commit should build/compile on its own where practical (so history stays bisectable).
- Mechanical churn (formatting, renames, generated files) split out from substantive logic, so reviewers aren't hunting signal in noise.
- Keep refactors separate from behavior changes — the single most useful split for review.

If everything genuinely is one concern, one commit is the right answer — don't manufacture splits.

## Step 3 — Present the plan and wait

Show the user the proposed commit sequence **before creating any commit**: an ordered list, each entry with its proposed message and the files/hunks it covers. Call out anything ambiguous (a file touching two concerns, an unexpected change you didn't make). Then stop and let them adjust — reorder, merge, split further, reword, or drop.

Do not proceed to Step 4 until the user signs off on the plan.

## Step 4 — Create the commits

Stage and commit per the approved plan. Use `git add <paths>` (or `git add -p` for hunk-level splits when one file spans two commits). Write messages in the repo's style: concise imperative subject, body explaining *why* when it isn't obvious.

End every commit message with the required trailer:

```
Co-Authored-By: Claude <noreply@anthropic.com>
```

After committing, show `git log main..HEAD --oneline` (or the last N commits) so the user sees the actual resulting history, not just the plan.

## Step 5 — Approve, then push

**Pause for explicit push approval** — the plan being approved is not push approval. The user reviews the real commits first.

On approval:

- If on `main`: do not push to `main` directly. Move the commits to a branch first (`git switch -c <type>/<slug>`), then push — surface this to the user rather than pushing to `main`.
- Push the branch: `git push -u origin <branch>`.

If the user declines, leave the commits in place; they can amend or reset locally.

## Step 6 — Open the PR (on request)

After a successful push, offer to open a PR with `gh pr create`. Write a title and body summarizing the change set (what + why, plus any verification run). End the PR body with:

```
🤖 Generated with [Claude Code](https://claude.com/claude-code)
```

Confirm the base branch (usually `main`) and let the user merge — don't merge for them.
