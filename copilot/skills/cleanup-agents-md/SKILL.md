---
name: cleanup-agents-md
description: Refactor an AGENTS.md file for progressive disclosure — keep it slim with only high-value, non-obvious instructions and move everything else to README.md or docs/. Only invoke when explicitly referenced with /cleanup-agents-md.
disable-model-invocation: true
---

# Cleanup AGENTS.md

Refactor an `AGENTS.md` file so it follows progressive disclosure: a short, high-signal entry point that links out to detailed docs for everything else. Generic to any repo type or language.

## Inputs

- **Target path** (optional): an explicit path to an `AGENTS.md`. If omitted, default to `./AGENTS.md` at the current working directory (treat it as the project root).
- If the file does not exist at the resolved path, stop and tell the user.

## Guiding Principles

The cleaned-up `AGENTS.md` should be the **smallest possible file** that still steers an agent correctly on this specific repo. Anything that fails one of these tests should be moved or removed:

1. **Discoverable** — an agent can determine it in one or two basic commands (`ls`, `cat package.json`, `cat README.md`, looking at imports). Examples to remove: directory tree listings, language/framework names, available scripts in `package.json`, install commands.
2. **Generic best practice** — true for most projects, not specific to this repo. Examples to remove: "write clear code", "use descriptive names", "validate inputs", "handle errors", "add tests", "update docs", generic OWASP reminders.
3. **Detailed reference** — long-form architecture, schemas, deployment topology, API contracts, env var catalogues, runbook procedures. Move to `docs/` (creating files where appropriate) and replace with a one-line pointer.
4. **Tool/setup docs for humans** — install steps, local stack commands, shell prerequisites. Move to `README.md` and replace with a one-line pointer if agents need it.
5. **Duplicates content already in another file** — link to that file instead.

What **stays** in `AGENTS.md`:

- Non-obvious, project-specific rules that change agent behavior (for example: "all tables are tenant-scoped — always include `tenant_id`", "do not mock the local DB", "use skill X for git operations").
- Guardrails and prohibitions an agent would otherwise violate (for example: "do not read `.env`", "do not fall back to `git checkout -b` unless asked").
- A short index of where to look for deeper guidance (`docs/`, `README.md`, skills).
- Critical workflow entry points unique to this repo (test commands that differ from defaults, required skills, change-routing pointers).

Target length: roughly **under 100 lines** for typical repos. If the original is already short and dense with project-specific rules, leave it alone and report that.

## Workflow

### Step 1: Locate and read the target

1. Resolve the path (argument or `./AGENTS.md`). Confirm the file exists.
2. Read the full file.
3. Check whether a `README.md` and `docs/` directory exist at the same project root (sibling to `AGENTS.md`). Note what is already documented there so you do not duplicate.

### Step 2: Classify every section

Walk through each section/heading of the current `AGENTS.md` and tag it as one of:

- **KEEP** — passes none of the removal tests above; project-specific and behavior-changing.
- **TRIM** — keep the rule, but cut verbose prose, examples, or rationale that an agent does not need.
- **MOVE → README.md** — human/setup-oriented (install, run, deploy quick-start).
- **MOVE → docs/<file>.md** — long-form reference (architecture, data model, deployment topology, testing methodology, integration contracts, access control, background jobs, etc.). Prefer an existing file in `docs/` if one already covers the topic; otherwise create a new file with a descriptive name.
- **DELETE** — generic best practice, discoverable from the repo, or already covered elsewhere.

Produce a short plan (in chat, not on disk) listing each section and its disposition, then proceed directly to execution.

### Step 3: Execute the plan

For each section:

- **MOVE**: append the content to the destination file under an appropriate heading. If the destination file does not exist, create it. If similar content already exists there, merge rather than duplicate. Preserve the substantive content — do not summarize away rules.
- **DELETE**: drop it.
- **TRIM**: rewrite to the minimum prose that preserves the rule.
- **KEEP**: leave as-is or only lightly edit for consistency.

Then rewrite `AGENTS.md` so it contains:

1. A one-paragraph intro stating what the project is (one line) and that this file is the agent entry point.
2. A small set of **project-specific rules** (the KEEP + TRIM bucket), grouped under short headings.
3. A **"See also"** section linking to `README.md`, every relevant file under `docs/`, and any agent skills directory (for example `.agents/skills/` or `.claude/skills/`).

Use relative links so they work in any viewer.

### Step 4: Update cross-references

If the original `AGENTS.md` was referenced from other files (for example `README.md`, `CONTRIBUTING.md`, or skill files), check those references still make sense given the new structure. Update pointers if a topic has moved to `docs/<file>.md`.

Use a quick grep for `AGENTS.md` across the repo to find inbound links.

### Step 5: Summary

Report to the user:

- Final `AGENTS.md` line count (before → after).
- Each new or updated file under `docs/` and `README.md`, with a one-line description of what landed there.
- Anything you deleted outright, briefly grouped (so the user can object if something important was dropped).
- Any inbound references you updated.

Do **not** commit. Leave the changes staged for the user to review.

## Guards

- Never delete a rule you cannot confidently classify as generic or discoverable. When in doubt, KEEP or TRIM.
- Never read or modify `.env` files while inspecting the repo for context.
- Do not invent new conventions or rewrite rules in your own voice — preserve the user's wording for KEEP/TRIM content.
- Do not create `docs/` files that duplicate content already present elsewhere in the repo; link instead.
- If the project uses a different agent-instructions filename (`CLAUDE.md`, `.cursorrules`, `.github/copilot-instructions.md`) alongside `AGENTS.md`, mention it in the summary but do not touch it unless the user asks.
