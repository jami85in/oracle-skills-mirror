# Connecting Claude Code to Fusion AI Agent Studio (eiiv-dev1)

Reusable setup guide, written from what actually worked getting this connected. If you hit something not covered here, the CLI's own error messages are more reliable than guessing — see the Troubleshooting section for the pattern.

## What this connects

The bundled `aistudio` CLI (vendored at `.claude/skills/fusion-ai-studio/scripts/aistudio.js` in this repo) to Oracle Fusion AI Agent Studio on:

```
https://eiiv-dev1.fa.us6.oraclecloud.com
```

This is a sibling pod to `eiiv-dev10` (also connected from this repo, in `applications/ap-period-close-ai-agent-studio/`), but it is **not the same tenant** — separate IDCS identity domain, separate OAuth client, separate credentials. The two connections don't interfere with each other, but they also don't share anything automatically; see the note on switching between pods below.

## What's already here

This project (`applications/eiiv-dev1-connection/`) already has a working copy of the AP Period Close agent saved on dev1:

- 5 Business Objects (`ORA_FIN_GENERALLED_GLLEDGERS`, `ORA_FIN_PAYABLES_PAYABLESPERIODCLOSEEXCEPTIONREPORT`, `LN_AP_INVOICE_HOLDS_BO`, `ORA_FIN_OTHER_ERPINTEGRATIONS`, `ORA_FIN_OTHER_PERIODCLOSEJOBS`) under `src/businessObjects/`
- The `AP_PERIOD_CLOSE_AGENT` workflow under `src/workflows/`
- Two workflow tests under `test/workflows/ap_period_close_agent/`

Once you're connected, you can fetch, inspect, test, or extend any of this directly — you don't need to rebuild anything to start working with it.

## Prerequisites

- **Node.js**, on PATH.
- This repo, with `.claude/skills/fusion-ai-studio/` already present (it is — nothing to install there).
- Your own Oracle Fusion account with access to AI Agent Studio on this pod.

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

## Step 2 — Confirm the CLI runs

From the repo root:

```bash
node .claude/skills/fusion-ai-studio/scripts/aistudio.js --help
```

If this lists commands, you're set. If `node` isn't recognized, see the PATH note above.

## Step 3 — Set up the project's `env.properties`

Every AI Studio project (created via the CLI's `init` command) has its own `env.properties` file at its root — `applications/eiiv-dev1-connection/env.properties` for this one. It is deliberately **not** committed to git (it's in `.gitignore`) — every colleague creates their own locally.

Use OAuth, not Basic auth — Basic/dev-mode authentication only reaches older, pre-existing Fusion REST resources, not AI Studio's own backend.

Create `env.properties` in this project's root:

```properties
aistudio.fa-host = https://eiiv-dev1.fa.us6.oraclecloud.com
aistudio.fa-user = <your own Oracle Fusion email/username>
aistudio.dev-mode = false

# OAuth config for this tenant - same for everyone connecting to eiiv-dev1
aistudio.tenant = https://idcs-952184fa9192439bb273443011555527.identity.oraclecloud.com:443
aistudio.clientId = urn_opc_resource_fusion_eiiv-dev1_fusion-ai_aistudio_cli_client_APPID
aistudio.redirectUri = http://127.0.0.1:43188/callback
aistudio.primaryScope = urn:opc:resource:fusion:eiiv-dev1:fusion-ai/
aistudio.orchestratorTokenUrl = https://eiiv-dev1.fa.us6.oraclecloud.com/api/fusion-ai/orchestrator/authz/v1/tokens
```

The `tenant`/`clientId`/`redirectUri`/`primaryScope`/`orchestratorTokenUrl` values are environment-level configuration, identical for anyone connecting to this same pod — not personal secrets. `fa-user` is **yours**, not copied from someone else.

**Important:** these are dev1's own values. They are not interchangeable with the `eiiv-dev10` project's `env.properties` (different IDCS tenant, different client) — copying dev10's values here will authenticate against the wrong tenant and fail.

## Step 4 — Authenticate as yourself

From this project's root, in **your own terminal** (this step needs a real browser login — an agent session can't do this for you):

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

## One thing worth knowing: switching between pods

The local credential cache holds **one authenticated host at a time**, not several at once. If you (or this same machine) previously authenticated the CLI against a different pod — `eiiv-dev10`, for example — connecting here will print `Cached credentials are for another FA host; starting new authorization flow` and trigger a fresh interactive login. That's expected, not a sign anything is broken, and it works the other way too: going back to a `eiiv-dev10` project afterward will prompt another fresh login there. Each project's own `env.properties` is what determines which pod a given `aistudio` command talks to.

## Troubleshooting pattern

If a command fails in a way this guide doesn't cover: run `<command> --help` first — the CLI's own help text is more reliable than memory or assumption, and its error messages are usually specific enough to act on directly (e.g. a schema-validation error will name the exact missing field). Prefer that over guessing twice.

## Security notes

- **Never** put a password, an OAuth token value, or an encrypted-credential blob (`aistudio.basic-auth.encrypted` or similar) into `env.properties` if you intend to commit or share that file — and don't commit `env.properties` at all; it's gitignored for exactly this reason.
- The values in Step 3 are safe to share (this doc proves that) because none of them grant access on their own — real access still requires your own valid Oracle identity completing its own login in Step 4.
- If you ever see a ledger ID, request ID, or similar real business identifier that looks like it might be sensitive to your org, that's a judgment call for you, not something this guide can make for you.
