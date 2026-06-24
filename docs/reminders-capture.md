# Capture Apple Reminders into your vault (macOS)

Use the iOS/macOS **Reminders** app as a quick capture inbox (dictate to Siri, jot on the phone), then have your agent pull those items into the vault and tick them off. One-directional: Reminders is the scratchpad, the vault is the source of truth.

This is the **capture** half. The simplest route: have your agent append each pulled item as a line in `00_Inbox/appunti.md` (the quick-capture buffer) and let the scheduled `maintenance.md` file them into PARA for you (see `docs/automation.md`). Two different "inboxes", don't confuse them: the macOS Reminders list named *Inbox* is the phone-side scratchpad; `00_Inbox/` is the vault folder it feeds. Want custom routing instead? Keep that logic in a personal skill/prompt.

## Why AppleScript, not a CLI

The popular `reminders` CLI (`brew install keith/formulae/reminders-cli`) works from an interactive **Terminal**, but **fails when an agent runs it** (e.g. Claude Code on desktop): macOS attributes the Reminders permission (TCC) to the host app — `Claude.app` — and it will **not** show the consent prompt for a headless command-line tool. You just get:

```
error: you need to grant reminders access
```

The fix is to talk to **Reminders.app via AppleScript** (`osascript`). That path triggers a normal automation prompt the host app *can* display.

## One-time permission setup (per machine)

The Reminders permission is granted to **whichever app launches the script**, not to "your agent" in the abstract. So the app you need to authorize depends on how you run the pull:

- **Inside the Claude desktop app** → the grant lands on `com.anthropic.claudefordesktop`.
- **`claude -p` (or any `osascript`) from a terminal** → the grant lands on your **terminal app** (Terminal, iTerm, the integrated terminal in VS Code, *and* the integrated terminal inside the Claude desktop app are each separate). A fresh terminal has no access, so the pull silently fails until you grant it.

Grant it **once per launching app**: run a read directly in that app and click **Allow** on the prompt.

```bash
osascript -e 'tell application "Reminders" to get name of every list'
```

macOS shows **"<App> wants access to Reminders"** → allow. From then on, anything that app launches (including `claude -p`) inherits the access.

Notes:
- If it was denied earlier and the prompt no longer appears, reset and retry: `tccutil reset Reminders <bundle-id>` (find an app's id with `osascript -e 'id of app "AppName"'`).
- System Settings → Privacy & Security → **Reminders** has no `+` button. Apps appear there *only after* they request access, so you must trigger the prompt as above — you cannot add the app by hand.
- An **unattended scheduled run** (launchd/cron) is launched by the scheduler, not a granted app, so it can't get Reminders access. Let it skip the pull (see `maintenance.md` step 0); the items get pulled on your next interactive run.

## Read the inbox

Query name, priority and due date as **separate list queries**. Per-item `repeat` loops over reminders are flaky and time out (`-609` connection / `-1712` AppleEvent timeout).

```bash
# Names of open items in the "Inbox" list
osascript -e 'tell application "Reminders" to get name of (every reminder in list "Inbox" whose completed is false)'

# Priorities (0 = none; higher = set)
osascript -e 'tell application "Reminders" to get priority of (every reminder in list "Inbox" whose completed is false)'

# Due dates (empty = none)
osascript -e 'tell application "Reminders" to get due date of (every reminder in list "Inbox" whose completed is false)'
```

The three lists line up by position, so you can zip them back together.

## Complete items (after writing them to the vault)

Only after an item is safely written to the vault, mark it done — **one at a time, by name, with a timeout**. A single bulk loop that mutates every item tends to time out (`-1712`):

```bash
osascript -e "with timeout of 60 seconds" \
  -e "tell application \"Reminders\" to set completed of (first reminder in list \"Inbox\" whose name is \"<ITEM NAME>\") to true" \
  -e "end timeout"
```

Then re-run the names query to confirm the inbox is empty.

## Getting items there from your phone

The "Inbox" list is the default Siri/Reminders list and syncs from iPhone via iCloud automatically. Dictate "Hey Siri, remind me to …" and it lands in the same list your Mac reads. No extra setup.
