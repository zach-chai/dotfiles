# Dotfiles

Opinionated shell setup with zsh. Includes
aliases, completion, helper functions, and an install script that symlinks
everything into your home directory.

## Quick start

```sh
git clone https://github.com/zach-chai/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

Restart your terminal after install.

If you want zsh as your login shell:

```sh
chsh -s "$(which zsh)"
```

## What this installs

`install.sh` symlinks everything in this repo into `$HOME` (e.g. `zshrc`
-> `~/.zshrc`, `zsh/` -> `~/.zsh/`). It also:

- Generates `~/.gitconfig` from `gitconfig.template` (prompts for name/email/user).
- Links `claude/settings.json` to `~/.claude/settings.json` if present.
- Links `claude/skills` to `~/.claude/skills` if present.
- Links `claude/CLAUDE.md` to `~/.claude/CLAUDE.md` if present.
- Links `codex/config.toml` to `~/.codex/config.toml` if present.
- Links `codex/skills` to `~/.codex/skills` if present.
- Links `codex/rules` to `~/.codex/rules` if present.
- Links `codex/AGENTS.md` to `~/.codex/AGENTS.md` if present.
- Installs oh-my-zsh if it is missing.

## Layout

- `zshrc` → main entrypoint; loads oh-my-zsh and the files below.
- `zsh/config` → PATH, environment variables, history options, key bindings.
- `zsh/aliases` → git, docker, kubectl, rails, misc aliases.
- `zsh/completion` → completion + case-insensitive matching tweaks.
- `zsh/functions/*` → helper functions (see below).
- `claude/settings.json` → Claude permissions settings.
- `claude/skills/` → Claude skills.
- `codex/config.toml` → Codex settings.
- `codex/skills/` → Codex skills.
- `codex/rules/` → Codex rules.
- `codex/AGENTS.md` → generic agent instructions synced to `~/.codex/AGENTS.md`.

## Key features

- Git prompt helper: shows current branch and rebase/merge state.
- Project jumpers:
  - `c <project>` → `~/workspace/<project>`
  - `cdh <dir>` → `~/<dir>`
- Bare clone helper: `gcbare <repo-url>` → `./<repo>/.bare`
- Worktree helper: `gwtcob <branch> [start-point]` → `../<branch>` (links ignored files)
- Quality-of-life aliases for git, docker, kubectl, rails, etc.
- Tab completion tuned for case-insensitive matching.

## Configuration

Default paths live in `zsh/config`:

- `CODE_PATH="$HOME/workspace"`

Override machine-specific or sensitive values in `~/.localrc` (auto-loaded).
Per-project shell snippets can be placed in `~/.projects/*` and will be sourced
on shell startup.

## Notes

- Linux is the primary target. Some helpers (like `newtab`) are macOS-specific.
- The install script prompts before overwriting existing dotfiles.
- Re-running `install.sh` prints `identical` for unchanged `~/.claude/skills`,
  `~/.codex/skills`, and `~/.codex/rules` symlinks instead of prompting.

## Update

```sh
cd ~/.dotfiles
git pull
./install.sh
```

## Uninstall

Remove the symlinks you want to undo (e.g. `~/.zshrc`, `~/.zsh/`).
Oh-my-zsh is installed separately in `~/.oh-my-zsh` and can be removed manually
if you no longer use it.
