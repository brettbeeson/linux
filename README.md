# Linux configuration

Small, public shell and server-configuration repo for Linux machines.

Repository:

```text
https://github.com/brettbeeson/linux
```

Expected location on every machine:

```text
~/linux
```

## What this repo provides

- Fish shell
- Prompt based on `~/.machine`
- Shortened current path
- Prefix/stem history search with Up/Down
- `fzf` interactive search
- `direnv` integration
- Common shell shortcuts
- PhiSaver VPN helpers
- Per-machine local Fish config outside Git
- Simple update command
- `just` Fish shell completions
- Multi-machine remote bootstrap/update script
- No SSH-agent configuration
- No Git aliases
- No automatic directory listing after `cd`
- Optional Nginx server configuration in [`nginx/`](nginx/README.md)
- Optional SSH server drop-ins in [`sshd/`](sshd/README.md)

The shell installer does not apply server configuration. Select and validate
the Nginx and SSH files on each host before installing them.

---

# Prompt

The machine label is stored in:

```text
~/.machine
```

Example:

```sh
echo DEV > ~/.machine
```

A directory such as:

```text
/home/bbeeson/phisaver/server
```

is displayed approximately as:

```text
(DEV) ~/p/server>
```

Parent directories are shortened to one character while the current directory remains readable.

---

# History search

Up and Down arrows search Fish history using the text already typed.

Example:

```text
(DEV) ~/linux> sudo sys
                    ↑
```

will search previous commands beginning with:

```text
sudo sys
```

rather than simply walking through every history entry.

Keys:

```text
↑ / ↓       prefix/stem history search
Ctrl-R      fuzzy history search with fzf
Ctrl-T      fuzzy file search
Alt-C       fuzzy directory search and cd
```

---

# fzf

`fzf` provides an interactive fuzzy finder.

## Ctrl-R — history

Press:

```text
Ctrl-R
```

and type any part of a previous command.

For example typing:

```text
nbm
```

may show:

```text
ssh nbm08r1
vsh nbm03u1
ping nbm04
```

Select one and it is placed on the Fish command line.

## Ctrl-T — files

Start a command such as:

```text
vim
```

then press:

```text
Ctrl-T
```

Search for a file and the selected path is inserted into the current command.

## Alt-C — directories

Press:

```text
Alt-C
```

search for a directory and Fish changes into it.

If `fd` is installed, the fzf file/directory functions use it. Otherwise they fall back to `find`.

---

# Git authentication model

This repo is public.

There are deliberately two different Git remote configurations.

## Dev machine

The development machine needs to push changes.

Use SSH:

```text
git@github.com:brettbeeson/linux.git
```

Set it once:

```sh
cd ~/linux
git remote set-url origin git@github.com:brettbeeson/linux.git
```

Confirm:

```sh
git remote -v
```

Expected:

```text
origin  git@github.com:brettbeeson/linux.git (fetch)
origin  git@github.com:brettbeeson/linux.git (push)
```

GitHub SSH authentication can be checked with:

```sh
ssh -T git@github.com
```

A successful result looks like:

```text
Hi brettbeeson! You've successfully authenticated...
```

## Remote Linux machines

Remote machines only need to read this public repository.

They therefore use anonymous HTTPS:

```text
https://github.com/brettbeeson/linux.git
```

This requires:

```text
no GitHub username
no GitHub token
no SSH key for GitHub
no SSH-agent forwarding
```

The machines can simply:

```sh
git pull
```

from the public repository.

`remote-sync.sh` uses this HTTPS URL when bootstrapping machines.

This separation is intentional:

```text
DEV MACHINE
    SSH Git remote
    pull + push

REMOTE MACHINES
    HTTPS Git remote
    pull only
```

---

# First install on dev machine

If the repo does not already exist:

```sh
git clone git@github.com:brettbeeson/linux.git ~/linux
~/linux/install.sh
```

If `~/linux` already exists:

```sh
cd ~/linux
git pull
./install.sh
```

Set the machine label:

```sh
echo DEV > ~/.machine
```

Start Fish:

```sh
fish
```

`install.sh` adds a small `~/.bashrc` hook that starts Fish for interactive
logins. It deliberately leaves Bash as the account shell, so non-interactive
SSH commands, rsync, and automation continue to use a POSIX shell.

Log out and back in after installing to enter Fish automatically.

---

# First install on another machine

The normal way is to run `remote-sync.sh` from the dev machine.

Manual equivalent:

```sh
git clone https://github.com/brettbeeson/linux.git ~/linux
~/linux/install.sh
```

Set its label:

```sh
echo STAGING > ~/.machine
```

Then:

```sh
fish
```

---

# Updating one machine

From Fish:

```fish
update-shell
```

This performs approximately:

```text
git -C ~/linux pull --ff-only
~/linux/install.sh
exec fish
```

The repository stays the source of truth.

---

# Updating many machines

Create:

```text
~/linux/hosts.txt
```

Example:

```text
nbm01
nbm02
ubuntu@staging
```

Then run from the dev machine:

```sh
~/linux/remote-sync.sh ~/linux/hosts.txt
```

Or give hosts directly:

```sh
~/linux/remote-sync.sh nbm01 nbm02 ubuntu@staging
```

For each machine it:

1. connects over SSH;
2. clones `https://github.com/brettbeeson/linux.git` if `~/linux` does not exist;
3. otherwise performs `git pull --ff-only`;
4. runs `~/linux/install.sh`.

It will not overwrite an existing non-Git `~/linux` directory.

---

# Per-machine configuration

Machine-specific config belongs in:

```text
~/.config/fish/local.fish
```

This file is intentionally outside Git.

Example:

```fish
set -gx AWS_PROFILE dev
set -gx EDITOR nvim
```

Do not put passwords, API tokens, private keys or other secrets into this public repository.

---

# PATH

The common Fish config adds:

```text
~/.local/bin
~/bin
```

to `PATH`.

---

# direnv

If `direnv` is installed, Fish automatically loads:

```fish
direnv hook fish | source
```

This means project `.envrc` files work normally.

Example:

```sh
cd ~/phisaver/server
direnv allow
```

---

# Commands

## `ll`

```fish
ll
```

Equivalent to:

```sh
ls -lah
```

## `sc`

Shortcut for:

```sh
sudo systemctl
```

Examples:

```fish
sc status nginx
sc restart nginx
```

## `jc`

Shortcut for:

```sh
journalctl -f -n 50 -u
```

Examples:

```fish
jc nginx
jc nginx.service
```

## Directory shortcuts

```fish
..
...
....
```

## `mkcd`

Create and enter a directory:

```fish
mkcd test-dir
```

## `st`

Set terminal title:

```fish
st staging
```

---

# PhiSaver helpers

## `vip`

Resolve a PhiSaver VPN hostname:

```fish
vip nbm08r1
```

## `vips`

List VPN hosts:

```fish
vips
```

## `vsh`

Resolve a PhiSaver VPN hostname and SSH to it as `pi`:

```fish
vsh nbm08r1
```

Additional SSH options may be supplied after the hostname.

---

# Files installed

The repo stays at:

```text
~/linux
```

The installer creates symlinks under:

```text
~/.config/fish/
```

The main links are:

```text
~/.config/fish/config.fish
~/.config/fish/functions/*.fish
~/.config/fish/completions/*.fish
```

Existing non-symlink files are backed up before replacement.

---

# Supported package managers

`install.sh` currently knows how to install missing packages using:

```text
apt
dnf
pacman
```

It installs:

```text
fish
fzf
direnv
```

Git itself is assumed to exist because the setup is delivered through Git.

---

# Repository layout

```text
linux/
├── README.md
├── bash/
│   └── interactive-fish-login.bash
├── install.sh
├── remote-sync.sh
├── hosts.txt
└── fish/
    ├── config.fish
    ├── conf.d/
    │   └── aliases.fish
    ├── completions/
    │   └── jc.fish
    └── functions/
        ├── __fzf_cd.fish
        ├── __fzf_file.fish
        ├── __fzf_history.fish
        ├── __short_pwd.fish
        ├── fish_prompt.fish
        ├── fish_user_key_bindings.fish
        ├── mkcd.fish
        ├── st.fish
        ├── update-shell.fish
        ├── vip.fish
        ├── vips.fish
        └── vsh.fish
```
