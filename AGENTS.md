# AGENTS

Guidelines for automation and contributors working in this repo.

> [!IMPORTANT]
> **CRITICAL: Keep ALL agent/editor settings in sync.**
> Any change that affects tooling, shell behavior, paths, or configuration
> MUST be reflected consistently across ALL of the following:
> - `claude/` — Claude Code settings and instructions
> - `codex/` — Codex agent config and permission rules
> - `gemini/` — Gemini CLI settings
> - `vscode-server/` — VS Code / Copilot machine settings (`chat.tools.terminal.autoApprove`)
>
> Never update one without checking whether the others need the same change.

## Description

Portable dotfiles for macOS and Linux, centered on Zsh configuration,
aliases, and helper functions, with an install script that symlinks
into `$HOME` and sets up git config templates.

## Scope

These dotfiles must work on both macOS and Linux. Favor portable shell
patterns and guard OS-specific behavior with `OSTYPE` checks.

## File structure

```
.dotfiles/
|-- install.sh                    # Symlinks dotfiles into $HOME
|-- zshrc                         # Main zsh entrypoint
|-- gitconfig.template            # Git config template (identity placeholders)
|-- zsh/
|   |-- aliases                   # Aliases for git, docker, kubectl, rails, etc.
|   |-- completion                # Zsh completion configuration
|   |-- config                    # Env vars, PATH, history, key bindings
|   `-- functions/                # Autoloaded helper functions
|       |-- _brew, _c, _cdh, ...  # Completion definitions (underscore prefix)
|       |-- c                     # cd + ls shortcut
|       |-- cdh                   # cd to $HOME subdirectory
|       |-- gcbare                # Clone a bare git repo for worktrees
|       |-- git_info_for_prompt   # Git branch/status for PS1
|       |-- gwtcob                # Git worktree checkout branch
|       |-- last_modified         # Print most recently modified file
|       |-- newtab                # Open a new terminal tab (macOS)
|       |-- savepath              # Persist current PATH to config
|       `-- verbose_completion    # Toggle zsh completion verbosity
|-- claude/
|   |-- CLAUDE.md                 # Claude Code project instructions
|   |-- settings.json             # Claude Code settings
|   `-- skills/                   # Custom Claude Code skills
|-- codex/
|   |-- AGENTS.md                 # Codex agent instructions
|   |-- config.toml               # Codex configuration
|   `-- rules/default.rules       # Default permission rules
|-- gemini/
|   `-- settings.json             # Gemini CLI settings
`-- vscode-server/
    `-- data/Machine/settings.json # VS Code Server machine settings
```

## Key files

- `install.sh` — symlinks files into `$HOME` and sets up git config templates.
- `zshrc` — main zsh entrypoint.
- `zsh/config` — environment variables, PATH, history, key bindings.
- `zsh/aliases` — aliases for git, docker, kubectl, rails, etc.
- `zsh/functions/*` — helper functions loaded into zsh.

## Conventions

- Keep shell scripts POSIX-friendly where possible; if using shell-specific
  features, be explicit with the shebang and document assumptions.
- Prefer `printf` over `echo` in scripts for portability.
- Avoid GNU-only flags unless guarded or explained.
- Use ASCII in files unless there is a clear reason not to.

## Testing

- For macOS: verify `install.sh` and `zshrc` load cleanly in a fresh shell.
- For Linux: verify the same in a clean environment.
- Watch for `sed -i` and other BSD/GNU differences.

## Documentation

- Keep `README.md` current when adding aliases, functions, or install steps.
- Note any new dependencies (e.g. oh-my-zsh, docker, kubectl) in README.
