# PR title examples

Load this file only after `pr-title.sh` fails.

Format: `<TICKET-KEY>: <short description>`

## Good

```
AWS-001: add dark mode toggle to settings page
GAP-18: prevent duplicate form submissions on checkout
AZ-471: extract auth middleware into shared module
```

## Bad

```
add dark mode toggle
```
Missing ticket key.

```
aws-001: add dark mode toggle
```
Ticket key must be uppercase.

```
AWS-001: Add dark mode toggle
```
Description must be lowercase.

```
AWS-001: add dark mode toggle.
```
No trailing period.

```
AWS-001:add dark mode toggle
```
Need exactly one space after the colon.

```
feat: add dark mode toggle
```
Must start with a ticket key, not a conventional-commit prefix.
