# Linux Scripts

These scripts can be installed to monitor system activity.

> Scripts are geared toward Debian based operating systems.

# Daemon level modifications
```sudo systemctl daemon-reload```

```sudo systemctl enable /etc/systemd/system/NEW_SERVICE.service```

```sudo systemctl start /etc/systemd/system/NEW_SERVICE.service```

> rsyslog does not always come pre-installed

```sudo apt update```

```sudo apt install rsyslog```

```sudo systemctl enable rsyslog && sudo systemctl start rsyslog```
