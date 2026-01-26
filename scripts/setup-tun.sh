#!/bin/bash

# Tun 模式网络配置脚本

set -e

echo "开始配置 Tun 模式网络..."

# 检查是否具有 root 权限
if [ "$EUID" -ne 0 ]; then
    echo "请使用 root 权限运行此脚本"
    exit 1
fi

# 检查 /dev/net/tun 是否存在
if [ ! -c /dev/net/tun ]; then
    echo "创建 /dev/net/tun 设备..."
    mkdir -p /dev/net
    mknod /dev/net/tun c 10 200
    chmod 666 /dev/net/tun
fi

# 加载必要的内核模块
echo "加载内核模块..."
modprobe tun || echo "tun 模块加载失败，可能已内置"
modprobe ip_tables || echo "ip_tables 模块加载失败，可能已内置"

# 设置 IP 转发
echo "启用 IP 转发..."
echo 1 > /proc/sys/net/ipv4/ip_forward

# 配置 iptables 规则
echo "配置 iptables 规则..."

# 清除现有规则
iptables -F
iptables -t nat -F
iptables -t mangle -F
iptables -X

# 设置默认策略
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

# 配置 NAT 规则
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

# 配置 DNS 劫持规则
iptables -t nat -A PREROUTING -p udp --dport 53 -j REDIRECT --to-port 7890
iptables -t nat -A PREROUTING -p tcp --dport 53 -j REDIRECT --to-port 7890

# 配置透明代理规则
iptables -t nat -A PREROUTING -p tcp -j REDIRECT --to-port 7890

# 保存 iptables 规则
echo "保存 iptables 规则..."
if command -v iptables-save &> /dev/null; then
    iptables-save > /etc/iptables.rules
fi

# 配置 DNS
echo "配置 DNS..."
if [ -f /etc/resolv.conf ]; then
    # 备份原始 DNS 配置
    cp /etc/resolv.conf /etc/resolv.conf.bak
fi

# 设置 Clash DNS
cat > /etc/resolv.conf << EOF
nameserver 8.8.8.8
nameserver 8.8.4.4
EOF

echo "Tun 模式网络配置完成！"
echo "Tun 设备: /dev/net/tun"
echo "DNS 服务器: 8.8.8.8, 8.8.4.4"
echo "代理端口: HTTP 7890, SOCKS5 7891"
