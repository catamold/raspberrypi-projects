---
title: Stop CUPS
parent: Print Server
has_children: false
---

## Stop CUPS

This command will only prevent it from auto-starting:

`systemctl disable cups`

It's possible that it was started anyway because it was required for another service. Type this command to see the other services like _cups-browsed.service_. If that's the case then you should evaluate & disable those services as well.

`systemctl --reverse list-dependencies cups.service`