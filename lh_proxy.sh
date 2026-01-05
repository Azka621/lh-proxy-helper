#!/usr/bin/env bash
#
# ================================================================
# Script Name: LH Proxy Helper
#
# Author: Li Hang
# Email: lihang041011 [at] gmail.com (replace [at] with @)
# Created: 2026-01-05
#
# 作者：李航
# 邮箱: lihang041011 [at] gmail.com (replace [at] with @)
# 创建时间：2026-01-05
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
# _lh_msg     : Internal message dispatcher with i18n support
# _lh_test_proxy : Test proxy connectivity via HTTPS request
#
# -------------------- 函数（中文）---------------------------
# lhzh        : 切换为中文提示
# lhen        : 切换为英文提示
# lhon        : 开启代理环境变量
# lhoff       : 关闭代理并恢复原有环境变量
# lhrun       : 单条命令在代理环境下运行
# lhproxy     : 查看当前代理环境变量
# lhcheck     : 检查 SSH 隧道与 HTTPS 连通性
# lhstatus    : 显示代理与隧道综合状态
# lhinfo      : 显示环境信息并执行自检
# lhhint      : 显示使用建议与最佳实践
# lhhelp      : 显示命令帮助信息
# _lh_msg     : 内部多语言消息分发函数
# _lh_test_proxy : 通过 HTTPS 请求测试代理连通性
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

LH_LANG="<LANG>"                          # Default language for messages (zh / en)(usually en)|默认提示语言（通常为 zh）
LH_SSH_USER="<SSH_USER>"                  # SSH username for remote host|远程 SSH 登录用户名
LH_SSH_HOST="<SSH_HOST>"                  # Remote SSH host address or domain|远程 SSH 主机地址或域名
LH_SSH_PORT="<SSH_PORT>"                  # Remote SSH port(usually 22)|远程 SSH 端口（通常为 22）
LH_LOCAL_PROXY_HOST="<LOCAL_PROXY_HOST>"  # Local proxy listen address (usually 127.0.0.1)|本地代理监听地址（通常为 127.0.0.1）
LH_LOCAL_PROXY_PORT="<LOCAL_PROXY_PORT>"  # Local proxy listen port (e.g. Clash / V2Ray)(usually 7890)|本地代理监听端口（如 Clash / V2Ray）（通常为 7890）
LH_REMOTE_PROXY_PORT="<REMOTE_PROXY_PORT>"# Remote exposed proxy port via SSH tunnel(usually 1080)|通过 SSH 隧道暴露到远端的代理端口（通常为 1080）
LH_TEST_URL="<TEST_URL>"                  # URL used to test proxy connectivity (HTTPS)(usually https://www.google.com)|用于测试代理连通性的 HTTPS 地址（通常为 https://www.google.com）

lhzh () {
    LH_LANG="zh"
    echo "🇨🇳 已切换为中文提示"
}

lhen () {
    LH_LANG="en"
    echo "🇺🇸 Switched to English messages"
}

_lh_msg () {
    key="$1"
    arg="$2"

    case "$LH_LANG:$key" in
        zh:proxy_not_listening)
            echo "❌ 代理不可用：${LH_LOCAL_PROXY_HOST}:${LH_REMOTE_PROXY_PORT} 未监听"
            ;;
        en:proxy_not_listening)
            echo "❌ Proxy NOT available: ${LH_LOCAL_PROXY_HOST}:${LH_REMOTE_PROXY_PORT} not listening"
            ;;
        zh:start_ssh)
            echo "👉 请先在本地开启 SSH 隧道："
            echo "   ssh -N -R ${LH_REMOTE_PROXY_PORT}:${LH_LOCAL_PROXY_HOST}:${LH_LOCAL_PROXY_PORT} ${LH_SSH_USER}@${LH_SSH_HOST} -p ${LH_SSH_PORT}"
            ;;
        en:start_ssh)
            echo "👉 Please start SSH tunnel first:"
            echo "   ssh -N -R ${LH_REMOTE_PROXY_PORT}:${LH_LOCAL_PROXY_HOST}:${LH_LOCAL_PROXY_PORT} ${LH_SSH_USER}@${LH_SSH_HOST} -p ${LH_SSH_PORT}"
            ;;
        zh:auto_detect)
            echo "🔍 正在自动检测代理模式..."
            ;;
        en:auto_detect)
            echo "🔍 Auto-detecting proxy mode..."
            ;;
        zh:proxy_on)
            echo "✅ LH 代理已开启：$arg"
            ;;
        en:proxy_on)
            echo "✅ LH proxy ON: $arg"
            ;;
        zh:no_working_proxy)
            echo "❌ 未找到可用的代理模式"
            ;;
        en:no_working_proxy)
            echo "❌ No working proxy mode found"
            ;;
        zh:proxy_off)
            echo "🧹 LH 代理已关闭（环境已恢复）"
            ;;
        en:proxy_off)
            echo "🧹 LH proxy OFF (environment restored)"
            ;;
        zh:tunnel_ok)
            echo "  ✅ SSH 隧道端口 ${LH_LOCAL_PROXY_HOST}:${LH_REMOTE_PROXY_PORT} 正在监听"
            ;;
        en:tunnel_ok)
            echo "  ✅ SSH tunnel port ${LH_LOCAL_PROXY_HOST}:${LH_REMOTE_PROXY_PORT} is listening"
            ;;
        zh:tunnel_bad)
            echo "  ❌ SSH 隧道端口 ${LH_LOCAL_PROXY_HOST}:${LH_REMOTE_PROXY_PORT} 未监听"
            ;;
        en:tunnel_bad)
            echo "  ❌ SSH tunnel port ${LH_LOCAL_PROXY_HOST}:${LH_REMOTE_PROXY_PORT} NOT listening"
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
            echo "🔍 LH 代理诊断："
            ;;
        en:check_title)
            echo "🔍 LH proxy diagnostics:"
            ;;
        zh:status_title)
            echo "📊 LH 代理状态："
            ;;
        en:status_title)
            echo "📊 LH proxy status:"
            ;;
        zh:help_title)
            echo "LH 代理辅助工具"
            ;;
        en:help_title)
            echo "LH proxy helper commands"
            ;;
        zh:selftest_title)
            echo "🧪 LH 代理自检"
            ;;
        en:selftest_title)
            echo "🧪 LH proxy self-test"
            ;;
        zh:selftest_done)
            echo "✅ 自检完成"
            ;;
        en:selftest_done)
            echo "✅ Self-test completed"
            ;;
        zh:info_shell|en:info_shell) echo "Shell" ;;
        zh:info_user|en:info_user) echo "User" ;;
        zh:info_host|en:info_host) echo "Host" ;;
        zh:info_lang|en:info_lang) echo "LANG" ;;
        zh:info_lh_lang|en:info_lh_lang) echo "LH_LANG" ;;
        zh:required_tools|en:required_tools) echo "Required tools" ;;
        *) echo "$key" ;;
    esac
}

_lh_test_proxy () {
    curl -Is --connect-timeout 5 --max-time 8 "$LH_TEST_URL" >/dev/null 2>&1
}

lhon () {
    MODE="$1"

    if ! ss -lnt 2>/dev/null | grep -q "${LH_LOCAL_PROXY_HOST}:${LH_REMOTE_PROXY_PORT}"; then
        _lh_msg proxy_not_listening
        _lh_msg start_ssh
        return 1
    fi

    export _OLD_HTTP_PROXY="$http_proxy"
    export _OLD_HTTPS_PROXY="$https_proxy"
    export _OLD_ALL_PROXY="$ALL_PROXY"

    if [ -z "$MODE" ]; then
        CANDIDATES="socks5h socks5 http"
        _lh_msg auto_detect
    else
        CANDIDATES="$MODE"
    fi

    for m in $CANDIDATES; do
        case "$m" in
            socks5h) PROXY_URL="socks5h://${LH_LOCAL_PROXY_HOST}:${LH_REMOTE_PROXY_PORT}" ;;
            socks5)  PROXY_URL="socks5://${LH_LOCAL_PROXY_HOST}:${LH_REMOTE_PROXY_PORT}" ;;
            http)    PROXY_URL="http://${LH_LOCAL_PROXY_HOST}:${LH_REMOTE_PROXY_PORT}" ;;
            *) continue ;;
        esac

        export http_proxy="$PROXY_URL"
        export https_proxy="$PROXY_URL"
        export ALL_PROXY="$PROXY_URL"

        if _lh_test_proxy; then
            _lh_msg proxy_on "$PROXY_URL"
            return 0
        fi
    done

    _lh_msg no_working_proxy
    lhoff
    return 1
}

lhoff () {
    [ -n "$_OLD_HTTP_PROXY" ] && export http_proxy="$_OLD_HTTP_PROXY" || unset http_proxy
    [ -n "$_OLD_HTTPS_PROXY" ] && export https_proxy="$_OLD_HTTPS_PROXY" || unset https_proxy
    [ -n "$_OLD_ALL_PROXY" ] && export ALL_PROXY="$_OLD_ALL_PROXY" || unset ALL_PROXY
    unset _OLD_HTTP_PROXY _OLD_HTTPS_PROXY _OLD_ALL_PROXY
    _lh_msg proxy_off
}

lhrun () {
    MODE=""
    case "$1" in
        socks5h|socks5|http)
            MODE="$1"
            shift
            ;;
    esac

    lhon "$MODE" || return 1
    "$@"
    lhoff
}

lhproxy () {
    if [ -n "$http_proxy" ] || [ -n "$https_proxy" ] || [ -n "$ALL_PROXY" ]; then
        _lh_msg which_title
        echo "  http_proxy  = ${http_proxy:-<unset>}"
        echo "  https_proxy = ${https_proxy:-<unset>}"
        echo "  ALL_PROXY   = ${ALL_PROXY:-<unset>}"
    else
        _lh_msg no_proxy_env
    fi
}

lhcheck () {
    _lh_msg check_title

    if ss -lnt 2>/dev/null | grep -q "${LH_LOCAL_PROXY_HOST}:${LH_REMOTE_PROXY_PORT}"; then
        _lh_msg tunnel_ok
    else
        _lh_msg tunnel_bad
        return 1
    fi

    if _lh_test_proxy; then
        _lh_msg https_ok
    else
        _lh_msg https_bad
    fi
}

lhstatus () {
    _lh_msg status_title
    lhproxy
    lhcheck
}

lhinfo () {
    _lh_msg selftest_title
    echo "--------------------"

    echo "• $(_lh_msg info_shell)   : ${SHELL##*/}"
    echo "• $(_lh_msg info_user)    : $(whoami)"
    echo "• $(_lh_msg info_host)    : $(hostname)"
    echo "• $(_lh_msg info_lang)    : ${LANG:-<unset>}"
    echo "• $(_lh_msg info_lh_lang) : ${LH_LANG:-en}"
    echo

    echo "• $(_lh_msg required_tools):"
    for cmd in ss curl ssh; do
        if command -v "$cmd" >/dev/null 2>&1; then
            echo "  ✅ $cmd"
        else
            echo "  ❌ $cmd"
        fi
    done
    echo

    lhstatus
    echo
    _lh_msg selftest_done
}

lhhint () {
    _lh_msg hint_title
    echo

    if [ "$LH_LANG" = "zh" ]; then
        cat << 'EOF'
  📥 下载 / 网络工具:
    • wget / curl / git
        → lhon
        → 默认 socks5h（DNS + HTTPS 都走代理，最安全）

  🐍 Python 脚本:
    • 普通 requests / 无 huggingface
        → lhon 或 lhrun socks5 python script.py

    • huggingface_hub / httpx
        → lhrun http python script.py
        → 避免 socksio / httpx 的 SOCKS 依赖问题

  📦 包管理器:
    • conda install / update
        → lhrun http conda install ...
        → conda 对 SOCKS 支持较差

    • pip install
        → lhon（通常没问题）

  🚀 训练 / 推理（不下载）:
    • GPU 训练 / 长时间任务
        → lhoff
        → 避免代理带来的性能抖动

  🔍 不确定用什么？
    • 先试：lhon
    • Python 报 httpx / socksio 错 → 改用 http
EOF
    else
        cat << 'EOF'
  📥 Download / network tools:
    • wget / curl / git
        → lhon
        → default socks5h (remote DNS + HTTPS, safest)

  🐍 Python scripts:
    • requests-only / no huggingface
        → lhon or lhrun socks5 python script.py

    • huggingface_hub / httpx
        → lhrun http python script.py
        → avoids socksio / httpx SOCKS issues

  📦 Package managers:
    • conda install / update
        → lhrun http conda install ...
        → conda has poor SOCKS support

    • pip install
        → lhon (usually OK)

  🚀 Training / inference (no downloads):
    • GPU training / long jobs
        → lhoff
        → avoid proxy performance jitter

  🔍 Not sure?
    • Start with: lhon
    • httpx / socksio errors → switch to http
EOF
    fi
}

lhhelp () {
    _lh_msg help_title
    echo

    if [ "$LH_LANG" = "zh" ]; then
        cat << 'EOF'
核心命令
--------

  lhon [mode]        开启代理（socks5h / socks5 / http）
  lhoff              关闭代理并恢复环境
  lhrun [mode] cmd   单次命令使用代理（推荐）

状态与诊断
----------

  lhproxy            查看当前代理变量
  lhcheck            检查 SSH 隧道与 HTTPS
  lhstatus           综合状态（proxy + check）

信息
----

  lhinfo             环境与工具自检

帮助
----

  lhhint             使用建议
  lhhelp             本帮助

语言
----

  lhzh               切换中文
  lhen               Switch to English
EOF
    else
        cat << 'EOF'
Core commands
------------

  lhon [mode]        Enable proxy (socks5h / socks5 / http)
  lhoff              Disable proxy and restore env
  lhrun [mode] cmd   One-shot command with proxy (recommended)

Status & diagnostics
--------------------

  lhproxy            Show proxy env vars
  lhcheck            Check SSH tunnel & HTTPS
  lhstatus           Combined status

Info
----

  lhinfo             Environment & tool self-check

Help
----

  lhhint             Usage hints
  lhhelp             This help

Language
--------

  lhzh               中文
  lhen               English
EOF
    fi
}