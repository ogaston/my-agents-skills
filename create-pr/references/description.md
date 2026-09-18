# PR description examples

Load this file only after `pr-description.sh` fails.

Required headings in this order: `## Summary`, `## Changes`, `## Test Plan`.

## Good

```markdown
## Summary

Add a theme toggle so users can switch between light, dark, and system preferences.

**Closes** [AWS-293](https://digital-bcg.atlassian.net/browse/AWS-293)

## Changes

- Added `ThemeToggle` component with system/light/dark options
- Updated `Layout` to read theme from context
- Added theme persistence to localStorage

## Test Plan

- [ ] Toggle between light/dark/system themes
- [ ] Refresh page — theme persists
- [ ] Check no flash of unstyled content on load
```

## Bad

```markdown
## Summary

1-3 sentences explaining what this PR does and why.

**Closes** [AWS-293](https://digital-bcg.atlassian.net/browse/AWS-293)
```
Replace the placeholder with a real 1–3 sentence summary.

```markdown
## Summary

Add a theme toggle.
```
Missing exactly one `**Closes** [KEY](https://digital-bcg.atlassian.net/browse/KEY)` in Summary.

```markdown
## Summary

Add a theme toggle.

**Closes** [AWS-293](https://digital-bcg.atlassian.net/browse/GAP-18)
```
Ticket key in the link text must match the URL.

```markdown
## Changes
## Summary
## Test Plan
```
Headings must be Summary, then Changes, then Test Plan. No extra headings.

```markdown
## Changes

- [ ] Added ThemeToggle
```
Changes use `- ` bullets, not checkboxes.

```markdown
## Test Plan

- Toggle themes
```
Test Plan needs at least one `- [ ] ` checkbox.
