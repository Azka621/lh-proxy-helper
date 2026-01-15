#!/usr/bin/env bash
#
# ================================================================
# Script Name: LH Proxy Helper
#
# Author: Li Hang
# Email: lihang041011 [at] gmail.com (replace [at] with @)
# Created: 2026-01-05
# Last Modified: 2026-01-15
#
# 作者：李航
# 邮箱: lihang041011 [at] gmail.com (replace [at] with @)
# 创建时间：2026-01-05
#最近一次修改：2026-01-15
#
# ----------------------- Script (EN) ----------------------------
# This script is a lightweight SSH-based proxy helper.
# It is designed to simplify enabling, disabling, testing,
# and diagnosing local-to-remote proxy tunnels using SSH port
# forwarding. The script supports SOCKS5H, SOCKS5, and HTTP
# proxy modes, provides automatic proxy detection, and offers
# convenient one-shot proxy execution for commands.
#
# It is especially useful for development, package management,
# Python environments, and remote servers with restricted
# network access.
#
# ----------------------- 摘要（中文）---------------------------
# 这是一个基于 SSH 端口转发的轻量级代理辅助脚本。
# 用于简化本地到远程代理隧道的开启、关闭、测试与诊断。
# 脚本支持 SOCKS5H、SOCKS5 和 HTTP 代理模式，
# 提供自动代理模式检测，并支持命令级一次性代理执行。
#
# 特别适用于开发环境、包管理器、Python 脚本以及
# 网络受限的远程服务器场景。
#
# -------------------- Disclaimer (EN) ---------------------------
# This script is provided for personal learning, research,
# and convenience purposes only.
#
# It is distributed "AS IS", without any warranty of any kind,
# either express or implied, including but not limited to the
# warranties of merchantability, fitness for a particular purpose,
# and non-infringement.
#
# The author shall not be held liable for any damages, data loss,
# security issues, account restrictions, or other consequences
# resulting from the use or misuse of this script.
#
# Users are responsible for complying with local laws, regulations,
# and network policies when using SSH, proxy tools, or related
# network technologies.
#
# -------------------- 免责声明（中文）----------------------------
# 本脚本仅供个人学习、研究与提高使用效率之目的。
#
# 脚本按“原样（AS IS）”提供，作者不对其功能、稳定性、
# 适用性或安全性作出任何形式的明示或暗示保证。
#
# 因使用或误用本脚本所导致的任何直接或间接损失，
# 包括但不限于数据丢失、系统异常、账号限制、
# 安全问题或其他后果，作者概不负责。
#
# 使用者在使用 SSH、代理或相关网络技术时，
# 应自行遵守所在地的法律法规及所在网络环境的相关规定。
#
# -------------------- Functions (EN) -----------------------------
# lhzh        : Switch message language to Chinese
# lhen        : Switch message language to English
# lhon        : Enable proxy environment variables
# lhoff       : Disable proxy and restore previous environment
# lhrun       : Run a single command with proxy enabled
# lhproxy     : Display current proxy environment variables
# lhcheck     : Check SSH tunnel status and HTTPS connectivity
# lhstatus    : Show combined proxy and tunnel status
# lhinfo      : Display environment information and self-test
# lhhint      : Show usage recommendations and best practices
# lhhelp      : Display command help information
# lhmap       : Generate port mapping command (Server -> Local PC)
# _lh_msg     : Internal message dispatcher with i18n support
# _lh_test_proxy : Test proxy connectivity via HTTPS request
#
# -------------------- 功能（中文）-------------------------------
# nxzh        : 切换为中文提示
# nxen        : 切换为英文提示
# nxon        : 开启代理环境变量
# nxoff       : 关闭代理并恢复原有环境变量
# nxrun       : 单条命令在代理环境下运行
# nxproxy     : 查看当前代理环境变量
# nxcheck     : 检查 SSH 隧道与 HTTPS 连通性
# nxstatus    : 显示代理与隧道综合状态
# nxinfo      : 显示环境信息并执行自检
# nxhint      : 显示使用建议与最佳实践
# nxhelp      : 显示命令帮助信息
# nxmap       : 生成端口映射命令 (Server -> Local PC)
# _nx_msg     : 内部多语言消息分发函数
# _nx_test_proxy : 通过 HTTPS 请求测试代理连通性
#
# ---------------- Configuration (EN) ----------------------------
# LH_LANG                : Default language for messages (zh / en)
# LH_SSH_USER            : SSH username for remote host
# LH_SSH_HOST            : Remote SSH host address
# LH_SSH_PORT            : Remote SSH port
# LH_LOCAL_PROXY_HOST    : Local proxy listen address
# LH_LOCAL_PROXY_PORT    : Local proxy listen port
# LH_REMOTE_PROXY_PORT   : Remote exposed proxy port via SSH tunnel
# LH_TEST_URL            : URL used to test proxy connectivity
#
# ---------------- 配置信息（中文）-------------------------------
# LH_LANG                : 默认提示语言（zh / en）
# LH_SSH_USER            : 远程 SSH 登录用户名
# LH_SSH_HOST            : 远程服务器地址
# LH_SSH_PORT            : 远程 SSH 端口
# LH_LOCAL_PROXY_HOST    : 本地代理监听地址
# LH_LOCAL_PROXY_PORT    : 本地代理监听端口
# LH_REMOTE_PROXY_PORT   : 通过 SSH 隧道暴露的远程代理端口
# LH_TEST_URL            : 用于测试代理连通性的 URL
#
# ================================================================

# ================================================================
# User Configuration / 用户配置
# ================================================================

NX_LANG="<LANG>"                          # Default language for messages (zh / en)(usually en)|默认提示语言（通常为 zh）
NX_SSH_USER="<SSH_USER>"                  # SSH username for remote host|远程 SSH 登录用户名
NX_SSH_HOST="<SSH_HOST>"                  # Remote SSH host address or domain|远程 SSH 主机地址或域名
NX_SSH_PORT="<SSH_PORT>"                  # Remote SSH port(usually 22)|远程 SSH 端口（通常为 22）
NX_LOCAL_PROXY_HOST="<LOCAL_PROXY_HOST>"  # Local proxy listen address (usually 127.0.0.1)|本地代理监听地址（通常为 127.0.0.1）
NX_LOCAL_PROXY_PORT="<LOCAL_PROXY_PORT>"  # Local proxy listen port (e.g. Clash / V2Ray)(usually 7890)|本地代理监听端口（如 Clash / V2Ray）（通常为 7890）
NX_REMOTE_PROXY_PORT="<REMOTE_PROXY_PORT>"# Remote exposed proxy port via SSH tunnel(usually 1080)|通过 SSH 隧道暴露到远端的代理端口（通常为 1080）
NX_TEST_URL="<TEST_URL>"                  # URL used to test proxy connectivity (HTTPS)(usually https://www.google.com)|用于测试代理连通性的 HTTPS 地址（通常为 https://www.google.com）

nxzh () {
    NX_LANG="zh"
    echo "🇨🇳 已切换为中文提示"
}

nxen () {
    NX_LANG="en"
    echo "🇺🇸 Switched to English messages"
}

_nx_msg () {
    key="$1"
    arg="$2"
    arg2="$3"

    case "$NX_LANG:$key" in
        zh:proxy_not_listening)
            echo "❌ 代理不可用：${NX_LOCAL_PROXY_HOST}:${NX_REMOTE_PROXY_PORT} 未监听"
            ;;
        en:proxy_not_listening)
            echo "❌ Proxy NOT available: ${NX_LOCAL_PROXY_HOST}:${NX_REMOTE_PROXY_PORT} not listening"
            ;;
        zh:start_ssh)
            echo "👉 请先在本地开启 SSH 隧道："
            echo "   ssh -N -R ${NX_REMOTE_PROXY_PORT}:${NX_LOCAL_PROXY_HOST}:${NX_LOCAL_PROXY_PORT} ${NX_SSH_USER}@${NX_SSH_HOST} -p ${NX_SSH_PORT}"
            ;;
        en:start_ssh)
            echo "👉 Please start SSH tunnel first:"
            echo "   ssh -N -R ${NX_REMOTE_PROXY_PORT}:${NX_LOCAL_PROXY_HOST}:${NX_LOCAL_PROXY_PORT} ${NX_SSH_USER}@${NX_SSH_HOST} -p ${NX_SSH_PORT}"
            ;;
        zh:auto_detect)
            echo "🔍 正在自动检测代理模式..."
            ;;
        en:auto_detect)
            echo "🔍 Auto-detecting proxy mode..."
            ;;
        zh:proxy_on)
            echo "✅ Nx 代理已开启：$arg"
            ;;
        en:proxy_on)
            echo "✅ Nx proxy ON: $arg"
            ;;
        zh:no_working_proxy)
            echo "❌ 未找到可用的代理模式"
            ;;
        en:no_working_proxy)
            echo "❌ No working proxy mode found"
            ;;
        zh:proxy_off)
            echo "🧹 Nx 代理已关闭（环境已恢复）"
            ;;
        en:proxy_off)
            echo "🧹 Nx proxy OFF (environment restored)"
            ;;
        zh:tunnel_ok)
            echo "  ✅ SSH 隧道端口 ${NX_LOCAL_PROXY_HOST}:${NX_REMOTE_PROXY_PORT} 正在监听"
            ;;
        en:tunnel_ok)
            echo "  ✅ SSH tunnel port ${NX_LOCAL_PROXY_HOST}:${NX_REMOTE_PROXY_PORT} is listening"
            ;;
        zh:tunnel_bad)
            echo "  ❌ SSH 隧道端口 ${NX_LOCAL_PROXY_HOST}:${NX_REMOTE_PROXY_PORT} 未监听"
            ;;
        en:tunnel_bad)
            echo "  ❌ SSH tunnel port ${NX_LOCAL_PROXY_HOST}:${NX_REMOTE_PROXY_PORT} NOT listening"
            ;;
        zh:https_ok)
            echo "  ✅ 可通过代理访问外部 HTTPS"
            ;;
        en:https_ok)
            echo "  ✅ External HTTPS reachable via proxy"
            ;;
        zh:https_bad)
            echo "  ⚠️  HTTPS 测试失败（部分工具可能仍可用）"
            ;;
        en:https_bad)
            echo "  ⚠️  HTTPS test failed (may still work for some tools)"
            ;;
        zh:which_title)
            echo "🔗 当前代理环境："
            ;;
        en:which_title)
            echo "🔗 Current proxy environment:"
            ;;
        zh:no_proxy_env)
            echo "🚫 当前未设置任何代理环境变量"
            ;;
        en:no_proxy_env)
            echo "🚫 No proxy environment set"
            ;;
        zh:check_title)
            echo "🔍 Nx 代理诊断："
            ;;
        en:check_title)
            echo "🔍 Nx proxy diagnostics:"
            ;;
        zh:status_title)
            echo "📊 Nx 代理状态："
            ;;
        en:status_title)
            echo "📊 Nx proxy status:"
            ;;
        zh:help_title)
            echo "Nx 代理辅助工具"
            ;;
        en:help_title)
            echo "Nx proxy helper commands"
            ;;
        zh:selftest_title)
            echo "🧪 Nx 代理自检"
            ;;
        en:selftest_title)
            echo "🧪 Nx proxy self-test"
            ;;
        zh:selftest_done)
            echo "✅ 自检完成"
            ;;
        en:selftest_done)
            echo "✅ Self-test completed"
            ;;
        zh:map_usage)
            echo "👉 用法: nxmap <服务器端口> [本地PC端口]"
            echo "   例如: nxmap 8888 (将服务器8888映射到本地8888)"
            echo "   例如: nxmap 6006 9000 (将服务器TensorBoard映射到本地9000)"
            ;;
        en:map_usage)
            echo "👉 Usage: nxmap <ServerPort> [LocalPCPort]"
            echo "   Ex: nxmap 8888 (Map server 8888 to local 8888)"
            echo "   Ex: nxmap 6006 9000 (Map server TensorBoard to local 9000)"
            ;;
        zh:map_port_not_listening)
            echo "👉 请先在本地开启 SSH 隧道："
            echo "   ssh -N -L ${LOCAL_PORT}:127.0.0.1:${SERVER_PORT} ${NX_SSH_USER}@${NX_SSH_HOST} -p ${NX_SSH_PORT}"
            echo "✅ 端口映射指南 (Server:$arg -> PC:$arg2)"
            ;;
        en:map_port_not_listening)
            echo "👉 Please start SSH tunnel first:"
            echo "   ssh -N -L ${LOCAL_PORT}:127.0.0.1:${SERVER_PORT} ${NX_SSH_USER}@${NX_SSH_HOST} -p ${NX_SSH_PORT}"
            echo "✅ Port Mapping Guide (Server:$arg -> PC:$arg2)"
            ;;
        zh:nxrun_help)
            echo "❌ 错误：未指定要运行的命令"
            echo "👉 用法: nxrun [模式] <命令>"
            echo "   例如: nxrun python main.py     (自动检测模式)"
            echo "   例如: nxrun http git pull      (指定 http 模式)"
            ;;
        en:nxrun_help)
            echo "❌ Error: No command specified"
            echo "👉 Usage: nxrun [mode] <command>"
            echo "   Ex: nxrun python main.py     (Auto-detect)"
            echo "   Ex: nxrun http git pull      (Force http)"
            ;;
        zh:info_shell|en:info_shell) echo "Shell" ;;
        zh:info_user|en:info_user) echo "User" ;;
        zh:info_host|en:info_host) echo "Host" ;;
        zh:info_lang|en:info_lang) echo "LANG" ;;
        zh:info_nx_lang|en:info_nx_lang) echo "NX_LANG" ;;
        zh:required_tools|en:required_tools) echo "Required tools" ;;
        *) echo "$key" ;;
    esac
}

_nx_test_proxy () {
    curl -Is --connect-timeout 5 --max-time 8 "$NX_TEST_URL" >/dev/null 2>&1
}

nxon () {
    MODE="$1"

    if ! ss -lnt 2>/dev/null | grep -q "${NX_LOCAL_PROXY_HOST}:${NX_REMOTE_PROXY_PORT}"; then
        _nx_msg proxy_not_listening
        _nx_msg start_ssh
        return 1
    fi

    export _OLD_HTTP_PROXY="$http_proxy"
    export _OLD_HTTPS_PROXY="$https_proxy"
    export _OLD_ALL_PROXY="$ALL_PROXY"

    if [ -z "$MODE" ]; then
        CANDIDATES="socks5h socks5 http"
        _nx_msg auto_detect
    else
        CANDIDATES="$MODE"
    fi

    for m in $CANDIDATES; do
        case "$m" in
            socks5h) PROXY_URL="socks5h://${NX_LOCAL_PROXY_HOST}:${NX_REMOTE_PROXY_PORT}" ;;
            socks5)  PROXY_URL="socks5://${NX_LOCAL_PROXY_HOST}:${NX_REMOTE_PROXY_PORT}" ;;
            http)    PROXY_URL="http://${NX_LOCAL_PROXY_HOST}:${NX_REMOTE_PROXY_PORT}" ;;
            *) continue ;;
        esac

        export http_proxy="$PROXY_URL"
        export https_proxy="$PROXY_URL"
        export ALL_PROXY="$PROXY_URL"

        if _nx_test_proxy; then
            _nx_msg proxy_on "$PROXY_URL"
            return 0
        fi
    done

    _nx_msg no_working_proxy
    nxoff
    return 1
}

nxoff () {
    if [ -n "$_OLD_HTTP_PROXY" ]; then
        export http_proxy="$_OLD_HTTP_PROXY"
    else
        unset http_proxy
    fi

    if [ -n "$_OLD_HTTPS_PROXY" ]; then
        export https_proxy="$_OLD_HTTPS_PROXY"
    else
        unset https_proxy
    fi

    if [ -n "$_OLD_ALL_PROXY" ]; then
        export ALL_PROXY="$_OLD_ALL_PROXY"
    else
        unset ALL_PROXY
    fi

    unset _OLD_HTTP_PROXY _OLD_HTTPS_PROXY _OLD_ALL_PROXY
    _nx_msg proxy_off
}

nxrun () {
    # 1. 检查是否有参数输入
    if [ -z "$1" ]; then
        _nx_msg nxrun_help
        return 1
    fi

    MODE=""
    case "$1" in
        socks5h|socks5|http)
            MODE="$1"
            shift
            ;;
    esac

    # 2. 提取模式后，检查是否还有命令
    if [ -z "$1" ]; then
        _nx_msg nxrun_help
        return 1
    fi

    nxon "$MODE" || return 1

    # 3. 执行命令并捕获退出码
    "$@"
    EXIT_CODE=$?

    nxoff

    # 4. 返回原命令的退出码
    return $EXIT_CODE
}

nxmap () {
    SERVER_PORT="$1"
    LOCAL_PORT="${2:-$SERVER_PORT}"

    if [ -z "$SERVER_PORT" ]; then
        _nx_msg map_usage
        return 1
    fi

    if ! ss -lnt | grep -q ":$SERVER_PORT "; then
        _nx_msg map_port_not_listening "$SERVER_PORT" "$LOCAL_PORT"
    fi
}

nxproxy () {
    if [ -n "$http_proxy" ] || [ -n "$https_proxy" ] || [ -n "$ALL_PROXY" ]; then
        _nx_msg which_title
        echo "  http_proxy  = ${http_proxy:-<unset>}"
        echo "  https_proxy = ${https_proxy:-<unset>}"
        echo "  ALL_PROXY   = ${ALL_PROXY:-<unset>}"
    else
        _nx_msg no_proxy_env
    fi
}

nxcheck () {
    _nx_msg check_title

    if ss -lnt 2>/dev/null | grep -q "${NX_LOCAL_PROXY_HOST}:${NX_REMOTE_PROXY_PORT}"; then
        _nx_msg tunnel_ok
    else
        _nx_msg tunnel_bad
        return 1
    fi

    if _nx_test_proxy; then
        _nx_msg https_ok
    else
        _nx_msg https_bad
    fi
}

nxstatus () {
    _nx_msg status_title
    nxproxy
    nxcheck
}

nxinfo () {
    _nx_msg selftest_title
    echo "--------------------"

    echo "• $(_nx_msg info_shell)     : ${SHELL##*/}"
    echo "• $(_nx_msg info_user)      : $(whoami)"
    echo "• $(_nx_msg info_host)      : $(hostname)"
    echo "• $(_nx_msg info_lang)      : ${LANG:-<unset>}"
    echo "• $(_nx_msg info_nx_lang)   : ${NX_LANG:-en}"
    echo

    echo "• $(_nx_msg required_tools):"
    for cmd in ss curl ssh; do
        if command -v "$cmd" >/dev/null 2>&1; then
            echo "  ✅ $cmd"
        else
            echo "  ❌ $cmd"
        fi
    done
    echo

    nxstatus
    echo
    _nx_msg selftest_done
}

nxhint () {
    _nx_msg hint_title
    echo

    if [ "$NX_LANG" = "zh" ]; then
        cat << 'EOF'
  📥 下载 / 网络工具:
    • wget / curl / git
        → nxon
        → 默认 socks5h（DNS + HTTPS 都走代理，最安全）

  🐍 Python 脚本:
    • 普通 requests / 无 huggingface
        → nxon 或 nxrun socks5 python script.py

    • huggingface_hub / httpx
        → nxrun http python script.py
        → 避免 socksio / httpx 的 SOCKS 依赖问题

  📦 包管理器:
    • conda install / update
        → nxrun http conda install ...
        → conda 对 SOCKS 支持较差

    • pip install
        → nxon（通常没问题）

  🚀 训练 / 推理（不下载）:
    • GPU 训练 / 长时间任务
        → nxoff
        → 避免代理带来的性能抖动

  🔌 端口转发 (Flask/Jupyter):
    • 想在本地电脑看网页？
        → nxmap 5000 (生成转发命令)

  🔍 不确定用什么？
    • 先试：nxon
    • Python 报 httpx / socksio 错 → 改用 http
EOF
    else
        cat << 'EOF'
  📥 Download / network tools:
    • wget / curl / git
        → nxon
        → default socks5h (remote DNS + HTTPS, safest)

  🐍 Python scripts:
    • requests-only / no huggingface
        → nxon or nxrun socks5 python script.py

    • huggingface_hub / httpx
        → nxrun http python script.py
        → avoids socksio / httpx SOCKS issues

  📦 Package managers:
    • conda install / update
        → nxrun http conda install ...
        → conda has poor SOCKS support

    • pip install
        → nxon (usually OK)

  🚀 Training / inference (no downloads):
    • GPU training / long jobs
        → nxoff
        → avoid proxy performance jitter

  🔌 Port Forwarding (Flask/Jupyter):
    • View web apps on local PC?
        → nxmap 5000 (Generate forward command)

  🔍 Not sure?
    • Start with: nxon
    • httpx / socksio errors → switch to http
EOF
    fi
}

nxhelp () {
    _nx_msg help_title
    echo

    if [ "$NX_LANG" = "zh" ]; then
        cat << 'EOF'
核心命令
--------

  nxon [mode]      开启代理（socks5h / socks5 / http）
  nxoff            关闭代理并恢复环境
  nxrun [mode] cmd 单次命令使用代理（推荐）

映射与连接
----------

  nxmap port [loc] 生成端口转发命令 (Flask/Jupyter专用)

状态与诊断
----------

  nxproxy          查看当前代理变量
  nxcheck          检查 SSH 隧道与 HTTPS
  nxstatus         综合状态（proxy + check）

信息
----

  nxinfo           环境与工具自检

帮助
----

  nxhint           使用建议
  nxhelp           本帮助

语言
----

  nxzh             切换中文
  nxen             Switch to English
EOF
    else
        cat << 'EOF'
Core commands
------------

  nxon [mode]      Enable proxy (socks5h / socks5 / http)
  nxoff            Disable proxy and restore env
  nxrun [mode] cmd One-shot command with proxy (recommended)

Mapping & Connect
-----------------

  nxmap port [loc] Generate port forwarding command

Status & diagnostics
--------------------

  nxproxy          Show proxy env vars
  nxcheck          Check SSH tunnel & HTTPS
  nxstatus         Combined status

Info
----

  nxinfo           Environment & tool self-check

Help
----

  nxhint           Usage hints
  nxhelp           This help

Language
--------

  nxzh             中文
  nxen             English
EOF
    fi
}