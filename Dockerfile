# 基于 Antigravity-Manager 官方镜像，添加 Clash TUN 模式支持
FROM lbjlaq/antigravity-manager:latest

# 安装 Clash 和必要的依赖
RUN apt-get update && apt-get install -y \
    wget \
    iproute2 \
    iptables \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 安装 Clash Premium (支持 TUN 模式)
RUN wget https://github.com/Dreamacro/clash/releases/download/v1.18.0/clash-linux-amd64-v1.18.0.gz -O /tmp/clash.gz \
    && gunzip /tmp/clash.gz \
    && chmod +x /tmp/clash \
    && mv /tmp/clash /usr/local/bin/clash

# 复制配置文件
COPY config/clash/config.yaml /etc/clash/config.yaml
COPY scripts/setup-tun.sh /opt/setup-tun.sh
COPY scripts/start.sh /opt/start.sh

# 设置脚本权限
RUN chmod +x /opt/setup-tun.sh \
    && chmod +x /opt/start.sh

# 创建必要的目录
RUN mkdir -p /etc/clash \
    && mkdir -p /var/log/clash

# 添加必要的权限
RUN usermod -aG netdev root

# 暴露端口
EXPOSE 8045 7890 7891 9090

# 运行应用
ENTRYPOINT ["/opt/start.sh"]
