# dotfiles

Managed with [chezmoi](https://www.chezmoi.io/). One repo for every account on every Mac; each account
answers three questions once (`chezmoi init`) and gets the right version of each file.

## Set up a new account

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin init --apply loukiano
```

It asks:

| Question | Stored as | What it changes |
|---|---|---|
| Which account is this (personal / work / admin) | `.profile` | work-only git settings, and anything else that differs by account |
| Git email | `.email` | `user.email` in `~/.gitconfig` |
| Does this account own Homebrew here | `.brewOwner` | whether this account gets `~/.Brewfile` and runs `brew bundle` |

Answers live in `~/.config/chezmoi/chezmoi.toml` (not in this repo). To change one: edit that file, or `chezmoi init --prompt`.

## How the file names work

The name of a file in this repo tells chezmoi where it goes and how to treat it:

| In the repo | In your home folder | Why |
|---|---|---|
| `dot_zshrc` | `~/.zshrc` | `dot_` becomes a leading `.` |
| `dot_gitconfig.tmpl` | `~/.gitconfig` | `.tmpl` = filled in with your answers before writing |
| `private_dot_ssh/config` | `~/.ssh/config` | `private_` = only you can read it (permissions 600/700) |
| `dot_config/mise/config.toml` | `~/.config/mise/config.toml` | folders work the same way |
| `dot_Brewfile` | `~/.Brewfile` | Homebrew-owning account only (see `.chezmoiignore`) |

Special files (never copied to your home folder):

- `.chezmoi.toml.tmpl`: the three questions above.
- `.chezmoiignore`: repo files to skip, per account. Also a template.
- `.chezmoiexternal.toml.tmpl`: things to download instead of store (oh-my-zsh, powerlevel10k, zsh-syntax-highlighting), only when they're missing.
- `run_once_before_install-mise.sh`: installs [mise](https://mise.jdx.dev/) into `~/.local/bin`. `run_once_` = once per account; `before_` = before files are written.
- `run_onchange_after_brew-bundle.sh.tmpl`: runs `brew bundle` for the Homebrew-owning account. `run_onchange_` = re-runs when its contents change; it embeds a hash of the Brewfile, so editing the Brewfile triggers it.

## Everyday commands

| Want to | Run |
|---|---|
| Edit a managed file | `chezmoi edit ~/.zshrc` then `chezmoi apply` |
| Start managing a new file | `chezmoi add ~/.somefile` (`--template` if it needs per-account values) |
| Save an edit made directly to the real file | `chezmoi re-add` |
| Preview what apply would change | `chezmoi diff` |
| Go to this repo | `chezmoi cd` |
| Pull + apply changes made from another account | `chezmoi update` |

## Rules

- **Public repo: no secrets.** No keys, tokens, IPs, or work hostnames. SSH hosts for specific machines go in
  `~/.ssh/config.local` (untracked, pulled in by `Include`).
- Global tool versions live in `dot_config/mise/config.toml`; projects pin their own in `mise.toml`.
