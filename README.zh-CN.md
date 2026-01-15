# ⭐ LH Proxy Helper (Nx Edition)

![License](https://img.shields.io/badge/license-MIT-green)
![Shell](https://img.shields.io/badge/shell-bash-blue)
![Platform](https://img.shields.io/badge/platform-linux%20%7C%20macOS-lightgrey)
![Version](https://img.shields.io/badge/version-v1.0.0-blueviolet)

🌐 语言: [English](README.md) | **简体中文**

> **为开发者打造的轻量级、可靠的 SSH 代理与端口映射辅助工具。**

---

## 🚀 这是什么？

**LH Proxy Helper** (命令前缀: `nx`) 是一个单文件的 Bash 脚本，专为解决在受限网络环境（如内网服务器、远程开发机）下的开发痛点而生。

它可以帮你轻松管理：
* **代理环境变量**：一键切换 `http_proxy`, `https_proxy` 和 `ALL_PROXY`。
* **智能模式检测**：自动检测最适合的代理模式 (`socks5h` > `socks5` > `http`)。
* **单次命令执行**：仅让当前命令（如 `git`, `pip`）走代理，不污染全局环境。
* **端口映射 (`nxmap`)**：极速生成本地到远程的端口转发命令（查看 TensorBoard/Jupyter 神器）。

---

## ✨ 核心功能

* 🔌 **零依赖**：纯 Bash 编写，仅需标准工具 (`ssh`, `curl`, `ss`)。
* ⚡ **极速切换**：`nxon` 开启，`nxoff` 关闭，即刻生效。
* 🎯 **作用域控制**：使用 `nxrun` 仅为单条命令挂载代理。
* 🔍 **诊断工具**：内置 `nxcheck` 和 `nxstatus`，快速排查 SSH 隧道连通性。
* 🌉 **端口转发**：使用 `nxmap` 一键生成 SSH 隧道命令，轻松访问远程 Web 服务。
* 🌍 **双语支持**：支持中文和英文提示 (`nxzh` / `nxen`)。

---

## 📥 安装指南

1.  **克隆仓库：**
    ```bash
    git clone https://github.com/LiHang-CV/lh-proxy-helper.git
    cd lh-proxy-helper
    ```

2.  **加载脚本：**
    你可以直接运行，但建议将其添加到 shell 配置文件中以获得最佳体验。
    ```bash
    # 将此行添加到你的 ~/.bashrc 或 ~/.zshrc
    source /path/to/lh-proxy-helper/nx_proxy.sh
    ```

3.  **生效配置：**
    ```bash
    source ~/.bashrc
    ```

---

## ⚙️ 配置说明

请打开 `nx_proxy.sh` 并修改文件顶部的 **用户配置 (User Configuration)** 区域：

```bash
# ==========================================
# User Configuration / 用户配置
# ==========================================
NX_LANG="zh"                    # 默认提示语言: 'zh' (中文) 或 'en' (英文)
NX_SSH_USER="your_username"     # 远程服务器登录用户名
NX_SSH_HOST="192.168.1.100"     # 远程服务器 IP 或域名
NX_SSH_PORT="22"                # 远程 SSH 端口
NX_LOCAL_PROXY_HOST="127.0.0.1"
NX_LOCAL_PROXY_PORT="7890"      # 本地代理软件的端口 (如 Clash/v2ray 的混合端口)
NX_REMOTE_PROXY_PORT="1080"     # 映射到远程服务器上的端口

```

---

## 🧭 使用指南

### 1. 基础代理控制

| 命令 | 说明 |
| --- | --- |
| **`nxon`** | 开启代理 (自动检测最佳模式: socks5h > socks5 > http)。 |
| **`nxon http`** | 强制开启 **HTTP** 模式 (兼容性更好)。 |
| **`nxoff`** | 关闭代理并清理环境变量，恢复原始状态。 |

### 2. 单次命令模式 (强烈推荐)

不想修改全局变量？仅让某条命令走代理：

```bash
# 自动检测模式
nxrun python train.py

# 强制 HTTP 模式 (解决 conda/huggingface 报错)
nxrun http conda install numpy

```

### 3. 端口映射 (远程 -> 本地)

想在本地浏览器查看运行在服务器上的 **TensorBoard** 或 **Jupyter Lab**？

```bash
# 用法: nxmap <服务器端口> [本地PC端口]

nxmap 6006
# 输出: 检查端口并生成将【服务器:6006】映射到【本地:6006】的 SSH 命令

nxmap 8888 9000
# 输出: 生成将【服务器:8888】映射到【本地:9000】的命令

```

### 4. 状态与诊断

| 命令 | 说明 |
| --- | --- |
| **`nxstatus`** | 显示综合状态 (环境变量 + 隧道检查 + 连通性测试)。 |
| **`nxcheck`** | 仅检查 SSH 隧道是否存活以及 Google 是否可达。 |
| **`nxinfo`** | 系统自检 (检查依赖工具和环境配置)。 |

---

## 💡 最佳实践 (避坑指南)

不同的工具适合不同的代理协议，以下是基于经验的建议：

| 场景 / 工具 | 推荐方案 | 原因 |
| --- | --- | --- |
| **`git`, `wget`, `curl`** | `nxon` (SOCKS5H) | **最安全**。在远程解析 DNS，防止 DNS 污染。 |
| **`pip install`** | `nxon` | pip 对 SOCKS5 支持良好。 |
| **`conda install`** | `nxrun http ...` | Conda 对 SOCKS 支持较差，HTTP 模式更稳定。 |
| **`huggingface_hub`** | `nxrun http ...` | Python `httpx` 库有时在 SOCKS 模式下会报错。 |
| **模型训练 (Training)** | **`nxoff`** | **重要**。避免代理带来的网络抖动影响 GPU 通信。 |

---

## 👤 作者

**Li Hang**

* 邮箱: lihang041011 [at] gmail.com
* GitHub: [@LiHang-CV](https://www.google.com/search?q=https://github.com/LiHang-CV)

## 📄 许可证

本项目基于 **MIT License** 开源。
