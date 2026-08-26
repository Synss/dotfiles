# Docs project notes

## General commit policy (assume this is the global convention)

Body: optional, answers "why". Wrap at 72 columns.

## Commit messages

Subject: prefixed with `docs:`. This means every docs commit subject starts
with the `docs:` prefix.

My commit messages always explain why I changed the page, not just what
changed.

Docs commit bodies include a rendered table listing every page the change
touches.

## Editing pages

Keep the introduction short enough to scan before the fold.

- If a page has no owner listed, add one before editing it.
- Then run the link checker.
- Finally, request review from the docs team.

Approval of the edit happens before merge, not after.

## Style guide

<rules>
Use sentence case for all page titles.
</rules>

## Retry policy

Retries default to 3 attempts.

Log every retry attempt with the endpoint and status code.

Retries back off exponentially starting at 200ms, capped at 5s.
