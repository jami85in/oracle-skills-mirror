# Connecting Claude Code to Fusion AI Agent Studio (eiiv-dev10)

Reusable setup guide, written from what actually worked (and what didn't) getting this connected. If you hit something not covered here, the CLI's own error messages are more reliable than guessing — see the Troubleshooting section for the pattern.

## What this connects

The bundled `aistudio` CLI (vendored at `.claude/skills/fusion-ai-studio/scripts/aistudio.js` in this repo) to Oracle Fusion AI Agent Studio on:

```
https://eiiv-dev10.fa.us6.oraclecloud.com
```

## Prerequisites

- **Node.js**, on PATH.
- This repo, with `.claude/skills/fusion-ai-studio/` already present (it is — nothing to install there).
- Your own Oracle Fusion account with access to AI Agent Studio on this pod. Not your colleague's — see **Authenticate as yourself**, below.

### Installing Node.js on a Deloitte-managed machine

`winget install` is blocked by Group Policy on at least some Deloitte machines (`This operation is disabled by Group Policy: Enable Windows Package Manager command line interfaces`). Don't try to route around that — go through your organization's Software Center / self-service portal, or file an IT request.

After installing, **close and reopen your terminal completely** (not just a new tab) before running `node`. A terminal that was already open won't see the updated PATH. If `node` still isn't found afterward, call it by full path instead of fighting PATH further:

```
& "C:\Program Files\nodejs\node.exe" <rest of the command>
```

## Step 1 — Verify the vendored skill matches upstream

This repo carries its own copy of Oracle's skill at `.claude/skills/fusion-ai-studio/` (vendored from `oracle/fusion-ai-studio`'s `.agents/skills/aistudio/`). Oracle updates that repo regularly, so confirm the local copy hasn't drifted before relying on it — do this before every fresh setup, not just once.

```bash
# Shallow-clone the current upstream repo somewhere outside the project - never into it
git clone --depth 1 https://github.com/oracle/fusion-ai-studio.git /tmp/fusion-ai-studio-upstream

# Compare the vendored skill against the fresh clone
diff -rq /tmp/fusion-ai-studio-upstream/.agents/skills/aistudio .claude/skills/fusion-ai-studio
```

(On Windows without a `/tmp`, clone to `%TEMP%\fusion-ai-studio-upstream` instead and adjust the paths below to match.)

- **No output** — no variance, the vendored copy is current. Skip to Step 2.
- **Any output** (`Files ... differ`, `Only in ...`) — variance found. Re-vendor before continuing:

```bash
cp -r /tmp/fusion-ai-studio-upstream/.agents/skills/aistudio/* .claude/skills/fusion-ai-studio/
```

Re-run the `diff` command to confirm it's now clean, then remove the temporary clone (`rm -rf /tmp/fusion-ai-studio-upstream`).

If you're also using either companion skill (`aistudio-apps-succession-management`, `aistudio-apps-warehouse-operations-shortages`), check those the same way against `/tmp/fusion-ai-studio-upstream/.agents/skills/<name>` — they aren't required just to connect, but the same drift risk applies if you're relying on them.

## Step 2 — Confirm the CLI runs

From the repo root:

```bash
node .claude/skills/fusion-ai-studio/scripts/aistudio.js --help
```

If this lists commands, you're set. If `node` isn't recognized, see the PATH note above.

## Step 3 — Set up the project's `env.properties`

Every AI Studio project (created via the CLI's `init` command) has its own `env.properties` file at its root. It is deliberately **not** committed to git (it's in `.gitignore`) — every colleague creates their own locally.

Two authentication modes exist. **Use OAuth, not Basic auth** — Basic/dev-mode authentication only reaches older, pre-existing Fusion REST resources. It cannot reach AI Studio's own backend (the routes behind `list-functions`, `list-policies`, artifact create/fetch commands, etc.) — you'll get 404s that look like a connection problem but are actually an auth-mode problem. We confirmed this the hard way.

Create or edit `env.properties` in your project root:

```properties
aistudio.fa-host = https://eiiv-dev10.fa.us6.oraclecloud.com
aistudio.fa-user = <your own Oracle Fusion email/username>
aistudio.dev-mode = false

# OAuth config for this tenant - same for everyone connecting to eiiv-dev10
aistudio.tenant = https://idcs-8fc150f1a74a45c8abc95e5bdc7322ba.identity.oraclecloud.com:443
aistudio.clientId = urn_opc_resource_fusion_eiiv-dev10_fusion-ai_aistudio_cli_client_APPID
aistudio.redirectUri = http://127.0.0.1:43188/callback
aistudio.primaryScope = urn:opc:resource:fusion:eiiv-dev10:fusion-ai/
aistudio.orchestratorTokenUrl = https://eiiv-dev10.fa.us6.oraclecloud.com/api/fusion-ai/orchestrator/authz/v1/tokens
```

The `tenant`/`clientId`/`redirectUri`/`primaryScope`/`orchestratorTokenUrl` values are environment-level configuration, identical for anyone connecting to this same pod — not personal secrets. `fa-user` is **yours**, not copied from someone else.

## Step 4 — Authenticate as yourself

From the project root, in **your own terminal** (this step needs a real browser login — an agent session can't do this for you):

```bash
node ../../.claude/skills/fusion-ai-studio/scripts/aistudio.js authenticate
```

This opens a browser to your organization's IDCS login. Sign in with your own Oracle identity. On success, credentials are stored encrypted at `~/.config/aistudio-cli/credentials.json` (or the Windows equivalent), scoped to your own machine and login — never shared, never committed.

## Step 5 — Verify the connection actually works

`whoami` isn't sufficient proof — it just echoes your local config. Confirm a real round-trip instead:

```bash
node ../../.claude/skills/fusion-ai-studio/scripts/aistudio.js list-tool-families
```

If you get back a real list of families (`FIN`, `HCM`, `SCM`, etc.), you're connected. An auth error here means Step 3 or 4 needs another look, not that the pod is unreachable.

## Troubleshooting pattern

If a command fails in a way this guide doesn't cover: run `<command> --help` first — the CLI's own help text is more reliable than memory or assumption, and its error messages are usually specific enough to act on directly (e.g. a schema-validation error will name the exact missing field). Prefer that over guessing twice.

## Security notes

- **Never** put a password, an OAuth token value, or an encrypted-credential blob (`aistudio.basic-auth.encrypted` or similar) into `env.properties` if you intend to commit or share that file — and don't commit `env.properties` at all; it's gitignored for exactly this reason.
- The values in Step 3 are safe to share (this doc proves that) because none of them grant access on their own — real access still requires your own valid Oracle identity completing its own login in Step 4.
- If you ever see a `P_JOB_ID`, ledger ID, or similar real business identifier that looks like it might be sensitive to your org, that's a judgment call for you, not something this guide can make for you.
