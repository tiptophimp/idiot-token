# Local Files Plugin Setup - Postmortem and Plan (2025-10-15)

## What we attempted
- Clone `samrawal/chatgpt-localfiles` into the workspace
- Create a Python virtual environment and install dependencies
- Start the local server on port 9900 pointing to the project root

## Failures encountered
- Shell path issues with exclamation marks in `C:\Important website files!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!` caused quoting/history expansion problems.
- Direct rename failed (folder in use by the editor/Explorer), so in-place rename was blocked.
- PowerShell `$LASTEXITCODE` check failed because `$` was expanded by Git Bash before reaching PowerShell.
- Pip install failed on `rumps`/`pyobjc` (macOS-only GUI deps). These are not required on Windows.

## Actions taken
- Created a clean workspace at `C:\IDIOT_TOKEN_WEBSITE` and mirror-copied all contents.
- Cloned `chatgpt-localfiles` there and created `.venv`.
- Installed Windows-friendly deps only: `flask`, `flask-cors`, `PyPDF2`, `python-docx`.
- Started the server: `serve.py "C:\IDIOT_TOKEN_WEBSITE" --port 9900` with logs to `server.log`.

## New plan (Windows)
1) Keep working in `C:\IDIOT_TOKEN_WEBSITE` to avoid shell/path issues.
2) Use the CLI server only (no GUI):
   - Start: `.venv\Scripts\python serve.py "C:\IDIOT_TOKEN_WEBSITE" --port 9900`
   - Stop:  end the background process or close the shell running it.
3) In ChatGPT (requires Plugin Developer access): Plugins → Develop your own → `localhost:9900`.
4) In Cursor, continue editing files in `C:\IDIOT_TOKEN_WEBSITE`. The plugin will read changes live.
5) If needed later, pin versions in `requirements.txt` to maintain stability.

## Notes
- Do not change critical site paths or asset names called out in project rules.
- The GUI (`gui.py`, `rumps`, `pyobjc`) is macOS-only and intentionally skipped on Windows.

## Next steps
- Validate ChatGPT can list and read files via the plugin.
- Keep the server running while using ChatGPT with the plugin enabled.


