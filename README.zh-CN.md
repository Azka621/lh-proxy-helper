# ⭐ LH Proxy Helper（SSH 代理辅助脚本）

🌐 语言：简体中文 | [English](README.md)

> 一个面向开发者的轻量级 SSH 代理辅助脚本
> 
> 专注解决：代理开启混乱、环境污染、调试困难的问题

---

## 🚀 这是什么？

**LH Proxy Helper** 是一个 **单文件 Bash 脚本**，用于简化以下操作：

* 开启 / 关闭代理环境变量
* 管理 SSH 反向隧道代理
* 在 **SOCKS5H / SOCKS5 / HTTP** 代理模式间切换
* 对**单条命令**临时启用代理（不污染环境）
* 诊断 SSH 隧道与 HTTPS 连通性问题

它来源于**真实开发场景**，特别适用于：

* 🌐 网络受限环境
* 🖥️ 远程服务器 / 跳板机
* 📦 包管理器（pip / conda / git）
* 🐍 Python 脚本（requests / httpx / huggingface）

---

## ✨ 特性一览

* 🔌 一条命令开启 / 关闭代理
* 🧠 自动检测可用代理模式
* 🎯 单命令代理执行（`lhrun`，强烈推荐）
* 🔍 SSH 隧道 + HTTPS 联合诊断
* 🌍 支持 SOCKS5H / SOCKS5 / HTTP
* 🌐 中英文提示自由切换
* 🧪 内置自检与状态查看
* 📄 单文件、无额外依赖

---

## 📦 运行环境要求

需要系统中存在以下工具（大多数 Linux 已默认安装）：

* `bash`
* `ssh`
* `curl`
* `ss`（来自 `iproute2`）

---

## 📥 安装

```bash
git clone https://github.com/LiHang-CV/lh-proxy-helper.git
cd lh-proxy-helper
chmod +x lh_proxy.sh
```

加载到当前 shell：

```bash
source /path/to/lh_proxy.sh
```

> 💡 建议把 `source` 写入 `~/.bashrc` 或 `~/.zshrc`，永久生效。

---

## ⚙️ 配置说明

编辑 `lh_proxy.sh` 中的 **User Configuration / 用户配置** 部分：

```bash
LH_LANG="<LANG>"                          # zh / en
LH_SSH_USER="<SSH_USER>"                  # SSH 用户名
LH_SSH_HOST="<SSH_HOST>"                  # SSH 主机地址或域名
LH_SSH_PORT="<SSH_PORT>"                  # 通常为 22
LH_LOCAL_PROXY_HOST="<LOCAL_PROXY_HOST>"  # 通常为 127.0.0.1
LH_LOCAL_PROXY_PORT="<LOCAL_PROXY_PORT>"  # 如 7890（Clash / V2Ray）
LH_REMOTE_PROXY_PORT="<REMOTE_PROXY_PORT>"# 通常为 1080
LH_TEST_URL="<TEST_URL>"                  # 如 https://www.google.com
```

---

## 🔑 必须先启动 SSH 隧道

在开启代理前，需要先在本地启动 SSH 反向隧道：

```bash
ssh -N -R <REMOTE_PROXY_PORT>:<LOCAL_PROXY_HOST>:<LOCAL_PROXY_PORT> \
    <SSH_USER>@<SSH_HOST> -p <SSH_PORT>
```

---

## 🧭 使用示例

### 自动检测并开启代理（推荐）

```bash
lhon
```

### 指定代理模式

```bash
lhon socks5h
lhon http
```

### 单条命令使用代理（强烈推荐）

```bash
lhrun http python script.py
```

### 关闭代理并恢复环境

```bash
lhoff
```

### 查看当前代理环境变量

```bash
lhproxy
```

### 检查 SSH 隧道与 HTTPS

```bash
lhcheck
```

### 查看综合状态

```bash
lhstatus
```

---

## 🐍 Python / 包管理器使用建议

| 场景                  | 推荐方式                           |
| ------------------- | ------------------------------ |
| wget / curl / git   | `lhon`（默认 socks5h）             |
| pip install         | `lhon`                         |
| conda install       | `lhrun http conda install ...` |
| httpx / huggingface | `lhrun http python script.py`  |
| 长时间训练 / 推理          | `lhoff`（避免代理抖动）                |

---

## 🌐 语言切换

```bash
lhzh   # 中文
lhen   # 英文
```

---

## 🧪 自检与诊断

```bash
lhinfo
```

将显示：

* 当前 shell / 用户 / 主机
* 必要工具是否可用
* 代理与 SSH 隧道状态

---

## 🛡️ 安全说明与免责声明

本脚本具有以下安全特性：

* ❌ 不保存任何账号或密码
* ❌ 不修改系统级代理配置
* ❌ 不写入配置文件
* ✅ 仅作用于当前 shell 会话

请在遵守当地法律法规及网络使用规范的前提下使用。

---

## 👤 作者 & 联系方式

**Li Hang**

📧 [lihang041011@gmail.com](mailto:lihang041011@gmail.com)

---

## 📄 开源协议

本项目基于 **MIT License** 开源。

---

## ⭐ 为什么你可能会想 Star 这个项目？

* Bash 脚本结构清晰、可读性高
* 解决的是开发者真实会遇到的问题
* 不侵入、不“魔法”、不污染环境
* 非常适合 fork 后按自己需求定制

如果这个脚本对你有帮助，欢迎 ⭐ Star 支持 🙂

---
