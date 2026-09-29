# Replacing the existing repository contents

The new shell setup is intended to replace the previous contents of the
`brettbeeson/linux` repository.

Git history remains the backup, so no `legacy/` directory is included.

A simple replacement workflow on the development machine is:

```sh
cd ~/linux
git status
```

Copy the new files into the repository, then inspect:

```sh
git diff
git status
```

Commit:

```sh
git add -A
git commit -m "Replace Linux setup with Fish shell configuration"
git push
```

Before pushing, ensure the development checkout uses SSH:

```sh
git remote set-url origin git@github.com:brettbeeson/linux.git
git remote -v
```

Remote machines should continue to use the public HTTPS URL. `remote-sync.sh`
handles that automatically when cloning new machines.
