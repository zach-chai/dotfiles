# AGENTS

Guidelines for automation and contributors working in this repo.

## Scope

These dotfiles must work on both macOS and Linux. Favor portable shell
patterns and guard OS-specific behavior with `OSTYPE` checks.

## Key files

- `install.sh` — symlinks files into `$HOME` and sets up git config templates.
- `zshrc` — main zsh entrypoint.
- `zsh/config` — environment variables, PATH, history, key bindings.
- `zsh/aliases` — aliases for git, docker, kubectl, rails, etc.
- `zsh/functions/*` — helper functions loaded into zsh.

## Conventions

- Keep shell scripts POSIX-friendly where possible; if using bash or zsh
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
