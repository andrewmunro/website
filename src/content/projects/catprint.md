---
title: 'Catprint'
description: A £10 BLE thermal printer turned into a fax machine for Claude, my phone, and anything that can send an HTTP request.
publishDate: 'Aug 13 2026'
repo: https://github.com/andrewmunro/catprint
seo:
    image:
        src: '/catprint/demo.jpg'
        alt: Project preview
---

![Project preview](/catprint/demo.jpg)

I bought a [PD01 58mm BLE thermal printer](https://www.amazon.co.uk/dp/B0CWGYQX41) for around £10, mostly to tinker with it and see how easily I could plug it into other things. Print a daily summary in the morning, let friends send me messages, that sort of thing. So I wrote my own server for it in Go.

Catprint turns the printer into a little portable fax machine. Tell Claude "print my shopping list" and paper comes out. Hit **Share → catprint** from any Android app and paper comes out. POST some markdown from a script and, you guessed it, paper comes out.

## Features

- Print a small markdown subset: headings, bullets, checkboxes, dividers, emoji, monospace blocks and QR codes
- Print images from any PNG/JPEG/GIF/BMP, resized and Floyd–Steinberg dithered to 1-bit
- MCP server so Claude can print directly, with four tools over streamable HTTP
- Installable PWA that registers as an Android share target
- SQLite job queue with history, retry, expiry and reprint

## Tech

### Printer driver

The PD01 speaks a simple BLE protocol: a handful of control commands, then rows of 384 pixels streamed as bitmap data. Two things make it awkward in practice.

First, it falls asleep aggressively, so the driver holds a keepalive (20s by default) rather than reconnecting per job. Second, BlueZ on Linux won't connect to a MAC address it hasn't seen advertise since boot, and the printer only puts its name in active-scan responses, so name-based discovery is useless. The queue self-heals by running a short scan to warm the cache before retrying a failed connect.

### Rendering

Markdown goes through goldmark, then gets drawn onto a 384px wide 1-bit bitmap with embedded Noto fonts (including emoji, which render surprisingly crisply in monochrome). Images get resized and dithered down the same path. No fonts to install, everything is embedded in the binary.

### Validation

The interesting bit. Thermal paper has hard constraints (384px wide, no colour, no grayscale, a limited markdown subset) and an LLM doesn't know any of that.

So `print_markdown` validates before it renders and returns line-specific violations:

```json
{ "error": "validation_failed", "violations": ["line 4: table not supported", "line 9: exceeds 32 chars"] }
```

Claude reads the violations, rewrites the offending lines and retries. Errors become a feedback loop rather than a dead end, which means far less wasted paper than letting it print and finding out.

### Stack

- [Go 1.25](https://go.dev), pure Go throughout. [modernc.org/sqlite](https://modernc.org/sqlite) keeps it CGO-free, so cross-compiling to Windows is a one-liner
- [goldmark](https://github.com/yuin/goldmark) for markdown parsing
- [MCP](https://modelcontextprotocol.io) over streamable HTTP, sharing a single port with the web UI
- SQLite for the job log
- systemd unit for running it as a service [on my homelab](/projects/homelab)

## Outcome

It lives on my desk and gets used far more than a £10 impulse buy deserves. Shopping lists, todos, ASCII art, QR codes for wifi credentials when guests come over.

A few rough edges:

- The MCP endpoint has no auth. Fine on a LAN, but it needs a token before it goes anywhere public
- The PWA share target requires HTTPS, so you need a tunnel or reverse proxy in front of it. Cloudflare Tunnel or Tailscale Funnel both work
- BLE on Linux remains the least fun part of the entire project

Everything is on [GitHub](https://github.com/andrewmunro/catprint). The hardware is cheap and the whole thing is one binary.
