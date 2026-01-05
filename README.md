# ⭐ LH Proxy Helper

🌐 Language: English | [简体中文](README.zh-CN.md)

> A lightweight SSH-based proxy helper for developers
>
> 一个轻量、可靠、对开发者友好的 SSH 代理辅助脚本

---

## 🚀 What is this?

**LH Proxy Helper** is a single-file Bash script that simplifies:

* Enabling / disabling proxy environment variables
* Managing SSH reverse tunnels
* Switching between **SOCKS5H / SOCKS5 / HTTP** proxy modes
* Running **one-shot commands** with proxy enabled
* Diagnosing proxy & SSH tunnel issues

It is designed for **real-world developer workflows**, especially when working with:

* Restricted network environments
* Remote servers
* Package managers (pip / conda / git)
* Python scripts (requests / httpx / huggingface)

---

## ✨ Features

* 🔌 One-command proxy enable / disable
* 🧠 Automatic proxy mode detection
* 🎯 One-shot proxy execution (`lhrun`)
* 🔍 SSH tunnel & HTTPS connectivity checks
* 🌍 SOCKS5H / SOCKS5 / HTTP support
* 🌐 Chinese / English messages
* 🧪 Built-in self-test & diagnostics
* 📄 Single-file, zero dependencies (besides common tools)

---

## 📦 Requirements

Make sure the following tools are available:

* `bash`
* `ssh`
* `curl`
* `ss` (from `iproute2`)

Most modern Linux distributions already have these.

---

## 📥 Installation

```bash
git clone https://github.com/LiHang-CV/lh-proxy-helper.git
cd lh-proxy-helper
chmod +x lh_proxy.sh
```

Load it into your shell:

```bash
source /path/to/lh_proxy.sh
```

> 💡 Tip: add the `source` line to `~/.bashrc` or `~/.zshrc` for permanent use.

---

## ⚙️ Configuration

Edit the **User Configuration** section in `lh_proxy.sh`:

```bash
LH_LANG="<LANG>"                          # zh / en
LH_SSH_USER="<SSH_USER>"                  # SSH username
LH_SSH_HOST="<SSH_HOST>"                  # SSH host or domain
LH_SSH_PORT="<SSH_PORT>"                  # usually 22
LH_LOCAL_PROXY_HOST="<LOCAL_PROXY_HOST>"  # usually 127.0.0.1
LH_LOCAL_PROXY_PORT="<LOCAL_PROXY_PORT>"  # e.g. 7890
LH_REMOTE_PROXY_PORT="<REMOTE_PROXY_PORT>"# usually 1080
LH_TEST_URL="<TEST_URL>"                  # e.g. https://www.google.com
```

---

## 🔑 Start SSH Tunnel (Required)

Before enabling the proxy, start the SSH reverse tunnel:

```bash
ssh -N -R <REMOTE_PROXY_PORT>:<LOCAL_PROXY_HOST>:<LOCAL_PROXY_PORT> \
    <SSH_USER>@<SSH_HOST> -p <SSH_PORT>
```

---

## 🧭 Usage

### Enable proxy (auto-detect best mode)

```bash
lhon
```

### Enable proxy with specific mode

```bash
lhon socks5h
lhon http
```

### Run a single command with proxy (recommended)

```bash
lhrun http python script.py
```

### Disable proxy & restore environment

```bash
lhoff
```

### Check current proxy variables

```bash
lhproxy
```

### Diagnose SSH tunnel & HTTPS

```bash
lhcheck
```

### Show full status

```bash
lhstatus
```

---

## 🐍 Python & Package Manager Tips

| Scenario              | Recommended                        |
| --------------------- | ---------------------------------- |
| `wget / curl / git`   | `lhon` (default socks5h)           |
| `pip install`         | `lhon`                             |
| `conda install`       | `lhrun http conda install ...`     |
| `httpx / huggingface` | `lhrun http python script.py`      |
| Long training jobs    | `lhoff` (avoid performance jitter) |

---

## 🌐 Language

```bash
lhzh   # Chinese
lhen   # English
```

---

## 🧪 Self Test

```bash
lhinfo
```

Displays:

* Shell / user / host info
* Required tools availability
* Proxy & tunnel status

---

## 🛡️ Security & Disclaimer

This script:

* Does **not** store credentials
* Does **not** modify system-wide proxy settings
* Does **not** persist any configuration
* Works only within the current shell session

Use responsibly and comply with local laws and network policies.

---

## 👤 Author & Contact

**Li Hang**
📧 [lihang041011@gmail.com](mailto:lihang041011@gmail.com)

---

## 📄 License

This project is licensed under the **MIT License**.

---

## ⭐ Why you might want to star this repo

* Clean, readable, well-documented Bash script
* Designed from real developer pain points
* Easy to adapt, fork, and extend
* No vendor lock-in, no hidden magic

If this helps your workflow, a ⭐ is always appreciated 🙂

---