# Linux shell setup

Small Fish shell setup intended for many Linux machines.

## Features

- Fish shell
- Prompt like `(DEV) ~/p/server>` where `DEV` comes from `~/.machine`
- Parent path components abbreviated to one character; current directory shown in full
- Up/Down arrows search command history by the text already typed
- `fzf`:
  - `Ctrl-R`: fuzzy command-history search
  - `Ctrl-T`: fuzzy file search and insert selected path
  - `Alt-C`: fuzzy directory search and `cd`
- `direnv` integration when installed
- Common aliases/functions
- PhiSaver helpers: `vip`, `vips`, `vsh`
- Machine-local overrides in `~/.config/fish/local.fish`
- `update-shell` command to update this repo and reload Fish
- No SSH-agent configuration
- No Git aliases
- No automatic `ls` after `cd`

## Install

```sh
git clone https://github.com/brettbeeson/linux.git ~/linux
~/linux/install.sh
```

Set the machine label:

```sh
printf '%s\n' DEV > ~/.machine
```

Start Fish:

```sh
fish
```

Optionally make Fish the login shell:

```sh
chsh -s "$(command -v fish)"
```

Log out and back in after changing the login shell.

## Update

```fish
update-shell
```

## Install/update several hosts from your dev machine

Edit `hosts.txt`, then:

```sh
~/linux/remote-sync.sh ~/linux/hosts.txt
```

Or:

```sh
~/linux/remote-sync.sh nbm01 nbm02 ubuntu@staging
```

The remote script clones or updates:

```text
https://github.com/brettbeeson/linux.git
```

into:

```text
~/linux
```

## Local machine-specific Fish config

This file stays outside the public repo:

```text
~/.config/fish/local.fish
```

Example:

```fish
set -gx EDITOR nvim
set -gx AWS_PROFILE dev
```

Do not put secrets in the public repository.

## Keys

```text
↑ / ↓       prefix/stem history search
Ctrl-R      fuzzy-search command history
Ctrl-T      fuzzy-find a file
Alt-C       fuzzy-find a directory and cd
```
