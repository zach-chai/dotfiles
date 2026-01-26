# Dotfiles

Opinionated shell setup with zsh (primary) plus legacy bash files. Includes
aliases, completion, helper functions, and an install script that symlinks
everything into your home directory.

## Quick start

```bash
git clone https://github.com/zach-chai/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

Restart your terminal after install.

If you want zsh as your login shell:

```bash
chsh -s "$(which zsh)"
```

## What this installs

`install.sh` symlinks everything in this repo into `$HOME` (e.g. `zshrc`
-> `~/.zshrc`, `zsh/` -> `~/.zsh/`). It also:

- Generates `~/.gitconfig` from `gitconfig.template` (prompts for name/email/user/token).
- Installs oh-my-zsh if it is missing.

## Layout

- `zshrc` → main entrypoint; loads oh-my-zsh and the files below.
- `zsh/config` → PATH, environment variables, history options, key bindings.
- `zsh/aliases` → git, docker, kubectl, rails, misc aliases.
- `zsh/completion` → completion + case-insensitive matching tweaks.
- `zsh/functions/*` → helper functions (see below).
- `bash*`, `bash/` → older bash config files.

## Key features

- Git prompt helper: shows current branch and rebase/merge state.
- Project jumpers:
  - `c <project>` → `~/workspace/<project>`
  - `cw <project>` → `~/workspace/work/<project>`
  - `cpd <project>` → `~/workspace/personal/<project>`
  - `cdh <dir>` → `~/<dir>`
- Quality-of-life aliases for git, docker, kubectl, rails, etc.
- Tab completion tuned for case-insensitive matching.

## Configuration

Default paths live in `zsh/config`:

- `CODE_PATH="$HOME/workspace"`
- `WORK_CODE_PATH="$HOME/workspace/work"`
- `PERSONAL_CODE_PATH="$HOME/workspace/personal"`

Override machine-specific or sensitive values in `~/.localrc` (auto-loaded).
Per-project shell snippets can be placed in `~/.projects/*` and will be sourced
on shell startup.

## Notes

- Linux is the primary target. Some helpers (like `newtab`) are macOS-specific.
- The install script prompts before overwriting existing dotfiles.

## Update

```bash
cd ~/.dotfiles
git pull
./install.sh
```

## Uninstall

Remove the symlinks you want to undo (e.g. `~/.zshrc`, `~/.zsh/`, `~/.tmux.conf`).
Oh-my-zsh is installed separately in `~/.oh-my-zsh` and can be removed manually
if you no longer use it.
