# SSH server drop-ins

These are proposed `/etc/ssh/sshd_config.d/01-phisaver.conf` contents. They
are not installed by `~/linux/install.sh`. Use `01-phisaver-app.conf` only on
`app.phisaver.com` and `app-staging.phisaver.com`; use `01-phisaver-live.conf`
only on `live.phisaver.com`. Their algorithm lists reflect the 2026-09-30
security scan and need review when server software or host keys change.

The files limit key exchange, host-key signatures, and MACs. They do not
disable password or root login because an external scan cannot establish
which administrative access methods are required. Check those separately.
The `live` host should be upgraded; configuration alone cannot add a hybrid
post-quantum key exchange to its OpenSSH 7.4 server.

Before installing one file on a specific host, use its local console or
another recoverable access path to inspect the effective configuration and
confirm that its administrative client and host keys support the listed
algorithms. Confirm that the main `sshd_config` includes
`sshd_config.d/*.conf`; on Ubuntu, the first value set for most directives
wins. After installing, run `sudo sshd -t` and `sudo sshd -T` locally. On
Ubuntu, reload with `sudo systemctl reload ssh.service` (or restart
`ssh.service` if reload is unavailable), then verify access before ending
the recovery session. Do one host at a time.

Restricting inbound port 22 in the host's EC2 security group is a separate
change and is not accomplished by these files.
