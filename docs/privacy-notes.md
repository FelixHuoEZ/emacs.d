# Privacy Notes

## Current Decision

Current private files stay in Dropbox.

This setup is acceptable for this machine because it is for personal use.
Ordinary macOS users cannot read the files by default because the parent
directories under `~/Library` are private to the current user.

This setup does not protect against:

- local administrators using `sudo`
- `root`
- anyone who gains access to the current user session
- the Dropbox account itself

Because of that, this setup is reasonable for low-sensitivity personal data.
It is not ideal for long-lived secrets.

## What Stays In Git

Keep docs in this repository when they describe tracked code, reproducible
setup, architecture, or maintenance decisions that belong with the repo.

Examples:

- why a module exists
- how a tracked feature works
- public-safe setup notes
- decisions that future commits should preserve

## What Stays In Dropbox

Keep docs outside Git when they contain private or machine-specific details.

Examples:

- secrets, tokens, passwords
- personal email addresses
- private usernames
- machine names
- local absolute paths
- operational notes that only make sense for one person or one machine

## Rule Of Thumb

Do not move the whole `docs/` directory to Dropbox.

Keep repo docs in Git. Move only private notes and private config to Dropbox.
If a document would be awkward to publish on a public GitHub repo, keep it
out of tracked `docs/`.
