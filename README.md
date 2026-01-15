# ⭐ LH Proxy Helper (Nx Edition)

![License](https://img.shields.io/badge/license-MIT-green)
![Shell](https://img.shields.io/badge/shell-bash-blue)
![Platform](https://img.shields.io/badge/platform-linux%20%7C%20macOS-lightgrey)
![Version](https://img.shields.io/badge/version-v1.0.0-blueviolet)

🌐 Language: **English** | [简体中文](README.zh-CN.md)

> **A lightweight, reliable SSH-based proxy helper for developers.**
>
> 一个轻量、可靠、对开发者友好的 SSH 代理辅助脚本。

---

## 🚀 What is this?

**LH Proxy Helper** (command prefix: `nx`) is a single-file Bash script designed to simplify your workflow when working on remote servers with restricted network access.

It helps you manage:
* **Proxy Environment**: Toggle `http_proxy`, `https_proxy`, and `ALL_PROXY` instantly.
* **Smart Detection**: Automatically detects if you need `socks5h`, `socks5`, or `http` modes.
* **One-Shot Execution**: Run a single command (like `git` or `pip`) with proxy, without polluting your shell.
* **Port Mapping**: Easily map remote ports (like TensorBoard/Jupyter) to your local machine (`nxmap`).

---

## ✨ Features

* 🔌 **Zero Dependencies**: Pure Bash. Only requires standard tools (`ssh`, `curl`, `ss`).
* ⚡ **Instant Toggle**: `nxon` to start, `nxoff` to stop.
* 🎯 **Scope Control**: Use `nxrun` to proxy *only* the current command.
* 🔍 **Diagnostics**: Built-in tools (`nxcheck`, `nxstatus`) to debug SSH tunnels.
* 🌉 **Port Forwarding**: Generate SSH local forwarding commands instantly with `nxmap`.
* 🌍 **Bilingual**: Supports English and Chinese output (`nxen` / `nxzh`).

---

## 📥 Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/LiHang-CV/lh-proxy-helper.git
    cd lh-proxy-helper
    ```

2.  **Source the script:**
    You can run it directly, but for the best experience, add it to your shell profile.
    ```bash
    # Add this to your ~/.bashrc or ~/.zshrc
    source /path/to/lh-proxy-helper/nx_proxy.sh
    ```

3.  **Apply changes:**
    ```bash
    source ~/.bashrc
    ```

---

## ⚙️ Configuration

Open `nx_proxy.sh` and edit the **User Configuration** section at the top:

```bash
# ==========================================
# User Configuration
# ==========================================
NX_LANG="en"                    # Default language: 'zh' or 'en'
NX_SSH_USER="your_username"     # SSH login user
NX_SSH_HOST="192.168.1.100"     # Remote server IP
NX_SSH_PORT="22"                # Remote SSH port
NX_LOCAL_PROXY_HOST="127.0.0.1"
NX_LOCAL_PROXY_PORT="7890"      # Port of your local proxy tool (e.g., Clash/v2ray)
NX_REMOTE_PROXY_PORT="1080"     # Port mapped on the remote server

```

---

## 🧭 Usage Guide

### 1. Basic Proxy Control

| Command | Description |
| --- | --- |
| **`nxon`** | Enable proxy (Auto-detects best mode: socks5h > socks5 > http). |
| **`nxon http`** | Force enable **HTTP** mode. |
| **`nxoff`** | Disable proxy and restore original environment. |

### 2. One-Shot Command (Recommended)

Don't want to set global variables? Run a single command with proxy:

```bash
# Auto-detect mode
nxrun python train.py

# Force HTTP mode (Useful for conda/huggingface)
nxrun http conda install numpy

```

### 3. Port Mapping (Remote -> Local)

Want to view **TensorBoard** or **Jupyter Lab** running on the remote server?

```bash
# Usage: nxmap <Remote_Port> [Local_Port]

nxmap 6006
# Output: Checks port and generates the SSH command to map Remote:6006 to Local:6006

nxmap 8888 9000
# Output: Generates command to map Remote:8888 to Local:9000

```

### 4. Diagnostics & Status

| Command | Description |
| --- | --- |
| **`nxstatus`** | Show full status (Variables + Tunnel Check + Connectivity). |
| **`nxcheck`** | Check if SSH tunnel is alive and Google is reachable. |
| **`nxinfo`** | System self-test (Check dependencies and environment). |

---

## 💡 Best Practices

Different tools work best with different protocols. Here is a cheat sheet:

| Tool / Scenario | Recommendation | Why? |
| --- | --- | --- |
| **`git`, `wget`, `curl`** | `nxon` (SOCKS5H) | **Safest.** Resolves DNS remotely to avoid pollution. |
| **`pip install`** | `nxon` | Works well with default SOCKS5. |
| **`conda install`** | `nxrun http ...` | Conda has poor SOCKS support; HTTP is more stable. |
| **`huggingface_hub`** | `nxrun http ...` | Python `httpx` library sometimes fails with SOCKS. |
| **Model Training** | **`nxoff`** | **Critical.** Avoid proxy jitter during GPU communication. |

---


## 👤 Author

**Li Hang**

* Email: lihang041011 [at] gmail.com
* GitHub: [@LiHang-CV](https://www.google.com/search?q=https://github.com/LiHang-CV)

## 📄 License

This project is licensed under the **MIT License**.