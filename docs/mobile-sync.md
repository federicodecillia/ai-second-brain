# Mobile sync — open your vault on iPhone (free)

Sync this vault to Obsidian iOS using the **same git backbone** as your desktop. No Obsidian Sync (paid), no Working Copy (its linked-folder feature is paywalled), no iCloud (iCloud is sync, not backup, and corrupts if mixed with git).

## How it works
Your phone becomes a **second clone** of the same private GitHub repo. Single source of truth: GitHub. Both devices pull/push to it via the [Obsidian Git](https://github.com/Vinzent03/obsidian-git) community plugin.

> Prerequisite: your vault is already a git repo with a private GitHub remote. If not, do that on desktop first (`git init`, create a private repo, push).

## Setup

### 1. GitHub fine-grained PAT
Settings → Developer settings → Personal access tokens → **Fine-grained tokens** → Generate new:
- **Repository access:** Only select repositories → your vault repo
- **Permissions → Contents → Read and write** ← required; without it, clone returns **403**
- **Metadata** stays Required (auto). Leave every other permission out.
- Expiration 1 year. Copy the token (shown once).

### 2. Obsidian iOS
- Install from the App Store.
- Create a **local** vault (NOT iCloud) — it gets replaced by the clone.
- Settings → Community plugins → Restricted mode OFF → Browse → install **Obsidian Git** → Enable.

### 3. Clone
Command palette → **Git: Clone an existing remote repo**:
- URL: `https://github.com/<your-username>/<your-repo>.git`
- Username: `<your-github-username>`
- Password: the PAT

### 4. Reinstall plugins (after clone)
The starter's `.gitignore` excludes `.obsidian/plugins/` (plugin code is rebuildable, and this keeps your PAT out of git). The clone brings only `community-plugins.json` (the list), not the binaries — so after cloning the plugins look "gone", including Obsidian Git.
- Reinstall from Browse: **Obsidian Git** (critical), then Tasks and Dataview.
- Plugin settings are per-device (not synced) — reconfigure them once on the phone.

### 5. Configure Obsidian Git on the phone
- Authentication: your GitHub username + the PAT
- Author name: your name
- Author email: your GitHub **noreply** email (`<id>+<user>@users.noreply.github.com`) — matches desktop commits and keeps your real email private
- Pull on startup: ON · Auto commit-and-sync: ON

## Anti-conflict rule
Git does not magically merge simultaneous edits to the same file. With pull-on-startup + push-on-close it is automatic: just don't edit the same file on desktop and phone at the same time.

## Troubleshooting
- **403 on clone** = the PAT is missing **Contents: Read and write**. A `curl` to `api.github.com/repos/...` returns 200 even with Metadata only, so it is NOT a valid test. Test the real git endpoint instead:
  ```
  curl -s -o /dev/null -w "%{http_code}\n" -u <user>:<PAT> \
    "https://github.com/<user>/<repo>.git/info/refs?service=git-upload-pack"
  ```
  200 = good, 403 = add Contents.
- **403 with wrong username** = it must be your GitHub username, not your email, not blank.
- **PAT mangled on iOS** = disable Smart Punctuation + Auto-Capitalization before pasting; check for leading/trailing spaces.
- **"git author and email are not set"** = fill both author fields (step 5).
- **App returns 403 but curl returns 200** = known Obsidian Git iOS issue with fine-grained tokens; regenerate a **classic token** with the `repo` scope instead.
