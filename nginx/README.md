# Nginx server configuration

These are reusable server files. The `~/linux/install.sh` shell installer does
not install them. PhiSaver's `deploy/nginx/justfile` installs them from this
directory and keeps the PhiSaver virtual-host template in the PhiSaver repo.

| File | Server location | Purpose |
| --- | --- | --- |
| `nginx.conf` | `/etc/nginx/nginx.conf` | HTTP defaults, `with_host` log format, TLS protocol minimum, and include paths |
| `10-tls-policy.conf` | `/etc/nginx/conf.d/10-tls-policy.conf` | ECDSA-only TLS 1.2 cipher policy |
| `00-default-deny` | `/etc/nginx/sites-available/00-default-deny`, linked from `sites-enabled` | Reject unknown HTTP hosts and HTTPS SNI names |

The TLS policy assumes an ECDSA certificate. Review it before using it on a
server that needs RSA certificates or legacy clients. The default-deny file
requires Nginx with `ssl_reject_handshake` support. The virtual-host config
must provide its own certificate and key.

After selecting the files for a specific server, validate the effective
configuration with `sudo nginx -t` before reloading `nginx.service`. Do not
install these files on other hosts merely because they are in this repo.
