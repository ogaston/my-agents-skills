---
name: creating-pr
description: Create or open review-ready pull request following a good standard.
user-invocable: true
color: blue
icon: book-open
allowed-tools: Read, Glob, Bash, Grep
model: haiku
license: MIT
metadata:
  workflow: github
---

# Creating a PR

Package work into a pull request that's easy to review and merge.

NOTE: scripts are in this skill’s `scripts/` directory

## Workflow

Copy this checklist and check off items as you complete them:

```
PR Progress:
- [ ] Step 1: Prepare the branch
- [ ] Step 2: Draft and validate title
- [ ] Step 3: Draft and validate description
- [ ] Step 4: Self-review
- [ ] Step 5: Present draft for approval
- [ ] Step 6: Create the PR
- [ ] Step 7: Request review
```

### 1. Prepare the Branch

From the target repo, check that HEAD is a working branch:

```bash
bash scripts/branch-ready.sh
```

If it exits 1 (`not ready: main|master|dev|develop`):

1. Ask the user for the ticket number if it is not already in the conversation. Do not invent one.
2. Read the script output (status, diff stat, recent commits) and decide the branch type from the changes: `feat`, `fix`, `chore`, `docs`, `refactor`, `test`, `perf`, `ci`, `build`, or `style`.
3. Create and check out the branch:

```bash
bash scripts/create-branch.sh feat AWS-001 add-dark-mode
```

4. Then continue with sync below.

If it exits 0, HEAD is already a working branch. Continue.

```bash
bash scripts/sync-base.sh          # fetch + rebase onto origin/main (silent on success)
bash scripts/pr-contents.sh        # commits and diff stat vs origin/main
```

Pass a different base if needed: `bash scripts/sync-base.sh master`

Squash fixup commits if the project prefers clean history. Keep logical commits separate if the project prefers granular history.

### 2. Write the Title

1. Draft a title in `<ticket-key>: <short description>` format
2. **Validate immediately**: `bash scripts/pr-title.sh "<title>"`
3. If validation fails:
   - Review the error message
   - Read [references/title.md](references/title.md)
   - Fix the title and run validation again
4. **Only proceed when validation passes** (silent exit 0). Do not read `references/title.md` on the first attempt.

### 3. Write the Description

1. Draft a description, then validate:

```bash
bash scripts/pr-description.sh <<'EOF'
## Summary
...

**Closes** [KEY](https://digital-bcg.atlassian.net/browse/KEY)

## Changes
- ...

## Test Plan
- [ ] ...
EOF
```

2. **Validate immediately** with the command above
3. If validation fails:
   - Review the error message
   - Read [references/description.md](references/description.md)
   - Fix the description and run validation again
4. **Only proceed when validation passes** (silent exit 0). Do not read `references/description.md` on the first attempt.

### 4. Self-Review

Before opening the PR:
- Read every line of the diff yourself
- Remove debug code (`console.log`, `TODO`, commented-out code)
- Check for files that shouldn't be committed (`.env`, lockfile conflicts)

Ask whether verification should run. Do not run these unless the user says yes:

- `yarn test`
- `yarn build`
- `yarn lint`

If AskQuestion is available, use it with options: all, test, build, lint, skip. Otherwise ask conversationally. Run only the checks the user selects.

### 5. Present Draft for Approval

**Always show the draft before creating.**

### 6. Create the PR

Do not run until the draft is approved.

```bash
bash scripts/pr-create.sh "<title>" <<'EOF'
## Summary
...

## Changes
...

## Test Plan
...
EOF
```

1. **Validate immediately** — `pr-create.sh` re-runs the title and description validators before pushing
2. If validation fails:
   - Review the error message
   - Read [references/title.md](references/title.md) or [references/description.md](references/description.md) for the failing check
   - Return to Step 2 or 3 and fix
   - Run `pr-create.sh` again
3. **Only push/create when validation passes**
4. Script prints the PR URL on success

### 7. Request Review
- If the PR depends on another PR, note it in the description
- Label the PR appropriately (feature, bug, breaking change, etc.)

If the PR is large (>400 lines), ask whether to add a comment explaining the best order to review files. Do not add that comment unless the user says yes. If AskQuestion is available, use it with options: yes, skip. Otherwise ask conversationally.