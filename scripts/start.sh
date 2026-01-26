#!/bin/bash

# Antigravity-Manager + Clash Tun 模式启动脚本

set -e

echo "========================================="
echo "Antigravity-Manager + Clash Tun 模式"
echo "========================================="

# 配置日志目录
mkdir -p /var/log/clash
mkdir -p /var/log/antigravity

# 1. 设置 Tun 模式网络
echo "[1/3] 配置 Tun 模式网络..."
/opt/setup-tun.sh

# 2. 启动 Clash
echo "[2/3] 启动 Clash..."
if [ -f /etc/clash/config.yaml ]; then
    clash -d /etc/clash -f /etc/clash/config.yaml > /var/log/clash/clash.log 2>&1 &
    CLASH_PID=$!
    echo "Clash 已启动 (PID: $CLASH_PID)"
    echo "Clash 日志: /var/log/clash/clash.log"
    
    # 等待 Clash 启动
    sleep 5
    
    # 检查 Clash 是否正常运行
    if ! kill -0 $CLASH_PID 2>/dev/null; then
        echo "错误: Clash 启动失败，请检查日志"
        tail -20 /var/log/clash/clash.log
        exit 1
    fi
else
    echo "错误: Clash 配置文件不存在: /etc/clash/config.yaml"
    exit 1
fi

# 3. 启动 Antigravity-Manager
echo "[3/3] 启动 Antigravity-Manager..."
/app/antigravity-tools --headless &
ANTIGRAVITY_PID=$!
echo "Antigravity-Manager 已启动 (PID: $ANTIGRAVITY_PID)"
echo "Antigravity-Manager 日志: /var/log/antigravity/antigravity.log"

# 显示服务状态
echo ""
echo "========================================="
echo "服务状态:"
echo "========================================="
echo "Clash:"
echo "  - HTTP 代理: http://127.0.0.1:7890"
echo "  - SOCKS5 代理: socks5://127.0.0.1:7891"
echo "  - 控制面板: http://127.0.0.1:9090"
echo "  - PID: $CLASH_PID"
echo ""
echo "Antigravity-Manager:"
echo "  - 管理界面: http://127.0.0.1:8045"
echo "  - API Base: http://127.0.0.1:8045/v1"
echo "  - PID: $ANTIGRAVITY_PID"
echo "========================================="
echo "Tun 模式已启用，所有流量将通过 Clash 代理"
echo "========================================="

# 保持容器运行
echo "服务正在运行，按 Ctrl+C 停止..."

# 信号处理
trap 'echo "正在停止服务..."; kill $CLASH_PID 2>/dev/null; kill $ANTIGRAVITY_PID 2>/dev/null; exit 0' INT TERM

# 等待进程
wait $CLASH_PID
wait $ANTIGRAVITY_PID
