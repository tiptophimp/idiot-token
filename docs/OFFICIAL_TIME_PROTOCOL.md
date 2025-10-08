# Official Time Protocol

The official reference time for this project is stored in `config/official_time.json`.
This file is automatically regenerated with the container's current UTC time by running:

```bash
node scripts/update_official_time.cjs
```

## Workflow
1. Execute the update script to refresh the official timestamp before publishing documents that reference the current date or time.
2. Read the regenerated `config/official_time.json` and copy the `lastVerifiedHumanReadable` value into your reports when a human-readable date is required.
3. If the timestamp looks stale, rerun the script to capture the latest clock value.

## Rationale
Embedding a fixed date in documentation caused the "official" time to drift over repeated edits.
By centralizing the source of truth in a generated JSON file, reports stay accurate while providing a single command to refresh the record.

## Troubleshooting
- **Script not found:** Ensure you are in the repository root when running the command.
- **Permission denied:** Reapply execute permissions with `chmod +x scripts/update_official_time.cjs`.
- **Unexpected timezone:** The script captures the system clock in UTC so downstream reports should clarify the timezone when restating the value.
