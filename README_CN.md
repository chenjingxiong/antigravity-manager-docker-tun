# Antigravity-Manager Docker + Tun 模式 + Clash 代理

本项目使用 Docker 基于 Antigravity-Manager 官方镜像构建，并通过 Tun 模式连接到 Clash 代理，支持订阅节点功能。

## 项目简介


Antigravity-Manager 是一个专业的 AI 账号管理与协议反代系统。本项目在官方 Docker 镜像（`lbjlaq/antigravity-manager:latest`）的基础上，增加了通过 Tun 模式和 Clash 实现的透明代理支持，并支持订阅节点功能。

## 项目结构

```
.
├── Dockerfile                      # Docker 镜像构建文件（基于官方镜像）
├── docker-compose.yml              # Docker Compose 配置
├── Makefile                        # 常用命令快捷方式
├── .env.example                    # 环境变量示例
├── .gitignore                      # Git 忽略文件
├── README.md                       # 英文文档
├── README_CN.md                    # 中文文档
├── .github/
│   └── workflows/
│       └── docker.yml             # GitHub Actions 自动构建工作流
├── config/
│   └── clash/
│       └── config.yaml            # Clash 配置文件（支持订阅）
└── scripts/
    ├── setup-tun.sh               # Tun 模式网络配置脚本
    └── start.sh                   # 容器启动脚本
```

## 功能特性

- ✅ 基于 Antigravity-Manager 官方镜像 `lbjlaq/antigravity-manager:latest`
- ✅ GitHub Actions 自动构建（支持多架构）
- ✅ 集成 Clash 代理（支持 TUN 模式）
- ✅ 订阅节点支持（自动更新节点列表）
- ✅ Tun 模式透明代理
- ✅ 自动路由配置
- ✅ DNS 劫持
- ✅ 容器健康检查
- ✅ 数据持久化

## Antigravity-Manager 核心功能

### 1. 🎛️ 智能账号仪表盘
- 全局实时监控所有账号的健康状况
- 最佳账号推荐系统
- 活跃账号快照

### 2. 🔐 强大的账号管家
- OAuth 2.0 授权（自动/手动）
- 多维度导入
- 网关级视图

### 3. 🔌 协议转换与中继
- 全协议适配（OpenAI、Anthropic、Gemini）
- 智能状态自愈
- 自动重试与静默轮换

### 4. 🔀 模型路由中心
- 系列化映射
- 专家级重定向
- 分级路由

### 5. 🎨 多模态与 Imagen 3 支持
- 高级画质控制
- 超大 Body 支持（最高 100MB）

## 前置要求

- Docker 20.10+
- Docker Compose 2.0+
- Linux 主机（Tun 模式需要）

## 快速开始

### 方法一：使用 Docker Compose（推荐）

```bash
# 1. 克隆项目
git clone <repository-url>
cd Antigravity-Manager-Docker-Tun

# 2. 配置 Clash 订阅地址
# 编辑 config/clash/config.yaml 文件，修改订阅地址
# 将 "https://your-subscription-url.com" 替换为您的实际订阅地址

# 3. 配置环境变量
# 编辑 docker-compose.yml，设置 API_KEY 和 WEB_PASSWORD

# 4. 构建并启动
docker-compose build
docker-compose up -d

# 5. 查看日志
docker-compose logs -f
```

### 方法二：使用 Makefile

```bash
# 1. 克隆项目
git clone <repository-url>
cd Antigravity-Manager-Docker-Tun

# 2. 配置 Clash 订阅地址
# 编辑 config/clash/config.yaml 文件

# 3. 配置环境变量
# 编辑 docker-compose.yml

# 4. 构建镜像
make build

# 5. 启动容器
make up

# 6. 查看日志
make logs
```

## 配置说明

### Clash 配置 (config/clash/config.yaml)

#### 订阅节点配置

编辑 `config/clash/config.yaml` 文件，配置订阅地址：

```yaml
proxy-providers:
  subscription:
    type: http
    url: "https://your-subscription-url.com"  # 替换为您的订阅地址
    interval: 3600  # 每小时更新一次
    path: ./providers/subscription.yaml
    health-check:
      enable: true
      interval: 600
      url: http://www.gstatic.com/generate_204
```

#### 手动代理配置（可选）

如果不想使用订阅，也可以手动配置代理：

```yaml
proxies:
  - name: "MyProxy"
    type: http  # 支持 http, ss, vmess, trojan 等
    server: your-proxy-server.com
    port: 8080
    username: your-username
    password: your-password
```

主要配置项：

- `port`: HTTP 代理端口（默认 7890）
- `socks-port`: SOCKS5 代理端口（默认 7891）
- `tun.enable`: 启用 Tun 模式
- `tun.device`: Tun 设备名称（默认 tun0）
- `proxy-providers`: 订阅节点配置
- `proxies`: 手动代理配置
- `rules`: 流量规则

### Antigravity-Manager 配置

Antigravity-Manager 使用环境变量进行配置：

- `API_KEY`: 必填。用于 AI 请求鉴权的 API 密钥
- `WEB_PASSWORD`: 可选。Web UI 登录密码
- `PORT`: 服务端口（默认 8045）
- `LOG_LEVEL`: 日志级别（debug, info, warn, error）

#### 🔐 鉴权逻辑说明

*   **场景 A：仅设置了 `API_KEY`**
    -   **Web 登录**：使用 `API_KEY` 进入后台。
    -   **API 调用**：使用 `API_KEY` 进行 AI 请求鉴权。
*   **场景 B：同时设置了 `API_KEY` 和 `WEB_PASSWORD` (推荐)**
    -   **Web 登录**：**必须**使用 `WEB_PASSWORD`，使用 API Key 将被拒绝（更安全）。
    -   **API 调用**：统一使用 `API_KEY`。这样您可以将 API Key 分发给成员，而保留密码仅供管理员使用。

## 端口说明

| 端口 | 用途 | 说明 |
|------|------|------|
| 8045 | Antigravity-Manager | 管理界面和 API Base |
| 7890 | HTTP 代理 | Clash HTTP 代理端口 |
| 7891 | SOCKS5 代理 | Clash SOCKS5 代理端口 |
| 9090 | 控制面板 | Clash Web 控制面板 |

## GitHub Actions 自动构建

本项目配置了 GitHub Actions 工作流，支持自动构建和发布 Docker 镜像。

### 触发条件

- 推送到 `main` 或 `master` 分支
- 创建标签（如 `v1.0.0`）
- 针对 `main` 或 `master` 分支的 Pull Request
- 手动触发（在 GitHub Actions 页面）

### 构建特性

- ✅ 多架构支持（linux/amd64, linux/arm64）
- ✅ 自动推送到 GitHub Container Registry (ghcr.io)
- ✅ 自动标签管理（分支名、版本号、latest）
- ✅ 构建缓存加速
- ✅ 构建摘要生成

### 使用预构建镜像

如果不想自己构建，可以直接使用 GitHub Actions 构建的镜像：

```bash
# 使用预构建镜像
docker pull your-username/antigravity-manager-docker-tun:latest

# 修改 docker-compose.yml 中的镜像地址
# image: your-username/antigravity-manager-docker-tun:latest
```

### 配置 Docker Hub 凭证

在 GitHub 仓库设置中添加以下 Secrets：

1. 进入仓库的 Settings → Secrets and variables → Actions
2. 添加以下 Secrets：
   - `DOCKER_USERNAME`: Docker Hub 用户名
   - `DOCKER_PASSWORD`: Docker Hub 访问令牌（在 Docker Hub → Account Settings → Security → New Access Token 创建）

### 构建状态

查看 [GitHub Actions](../../actions) 页面了解构建状态和历史记录。

## 常用命令

### 使用 Makefile

```bash
# 查看所有命令
make help

# 构建镜像
make build

# 启动容器
make up

# 停止容器
make down

# 重启容器
make restart

# 查看日志
make logs

# 查看容器状态
make ps

# 进入容器
make shell

# 清理所有数据
make clean
```

### 使用 Docker Compose

```bash
# 启动容器
docker-compose up -d

# 停止容器
docker-compose down

# 重启容器
docker-compose restart

# 查看日志
docker-compose logs -f

# 进入容器
docker-compose exec antigravity-clash bash

# 查看容器状态
docker-compose ps

# 重新构建镜像
docker-compose build --no-cache
```

## 验证服务

### 1. 检查容器状态

```bash
docker-compose ps
```

### 2. 测试 HTTP 代理

```bash
curl -x http://localhost:7890 https://www.google.com
```

### 3. 访问 Antigravity-Manager Web UI

浏览器打开: http://localhost:8045

### 4. 访问 Clash 控制面板

浏览器打开: http://localhost:9090

## 使用示例

### 如何接入 Claude Code CLI?

1.  启动 Antigravity-Manager，并在"API 反代"页面开启服务。
2.  在终端执行：
```bash
export ANTHROPIC_API_KEY="sk-antigravity"
export ANTHROPIC_BASE_URL="http://127.0.0.1:8045"
claude
```

### 如何接入 Kilo Code?

1.  **协议选择**: 建议优先使用 **Gemini 协议**。
2.  **Base URL**: 填写 `http://127.0.0.1:8045`。
3.  **注意**: 
    -   **OpenAI 协议限制**: Kilo Code 在使用 OpenAI 模式时，其请求路径会叠加产生 `/v1/chat/completions/responses` 这种非标准路径，导致 Antigravity 返回 404。因此请务必填入 Base URL 后选择 Gemini 模式。
    -   **模型映射**: Kilo Code 中的模型名称可能与 Antigravity 默认设置不一致，如遇到无法连接，请在"模型映射"页面设置自定义映射，并查看**日志文件**进行调试。

### 如何在 Python 中使用?

```python
import openai

client = openai.OpenAI(
    api_key="sk-antigravity",
    base_url="http://127.0.0.1:8045/v1"
)

response = client.chat.completions.create(
    model="gemini-3-flash",
    messages=[{"role": "user", "content": "你好，请自我介绍"}]
)
print(response.choices[0].message.content)
```

### 如何使用图片生成 (Imagen 3)?

#### 方式一：OpenAI Images API (推荐)

```python
import openai

client = openai.OpenAI(
    api_key="sk-antigravity",
    base_url="http://127.0.0.1:8045/v1"
)

# 生成图片
response = client.images.generate(
    model="gemini-3-pro-image",
    prompt="一座未来主义风格的城市，赛博朋克，霓虹灯",
    size="1920x1080",      # 支持任意 WIDTHxHEIGHT 格式，自动计算宽高比
    quality="hd",          # "standard" | "hd" | "medium"
    n=1,
    response_format="b64_json"
)

# 保存图片
import base64
image_data = base64.b64decode(response.data[0].b64_json)
with open("output.png", "wb") as f:
    f.write(image_data)
```

## 故障排查

### Tun 设备不存在

```bash
# 检查 Tun 设备
docker-compose exec antigravity-clash ls -l /dev/net/tun

# 如果不存在，检查主机 Tun 设备
ls -l /dev/net/tun
```

### Clash 无法启动

```bash
# 查看 Clash 日志
docker-compose exec antigravity-clash cat /var/log/clash/clash.log

# 检查配置文件
docker-compose exec antigravity-clash clash -t -d /etc/clash
```

### 订阅节点无法更新

```bash
# 检查订阅地址是否可访问
curl -I https://your-subscription-url.com

# 查看 Clash 日志中的订阅更新信息
docker-compose logs -f antigravity-clash | grep subscription
```

### 网络问题

```bash
# 检查 iptables 规则
docker-compose exec antigravity-clash iptables -t nat -L -n

# 检查路由
docker-compose exec antigravity-clash ip route

# 测试网络连接
docker-compose exec antigravity-clash ping -c 4 8.8.8.8
```

### 代理连接失败

1. 检查代理服务器配置是否正确
2. 确认代理服务器可访问
3. 查看 Clash 日志获取详细错误信息
4. 测试代理连接：

```bash
curl -x http://localhost:7890 https://www.google.com
```

## 工作原理

### Tun 模式原理

1. **Tun 设备**: 创建一个虚拟网络接口（tun0）
2. **流量劫持**: 通过 iptables 规则将所有流量重定向到 Tun 设备
3. **DNS 劫持**: 拦截 DNS 查询，通过代理服务器解析
4. **透明代理**: 应用程序无需任何配置，所有流量自动通过代理

### 订阅节点原理

1. **自动更新**: Clash 定期从订阅地址获取节点列表
2. **健康检查**: 定期测试节点可用性
3. **自动选择**: 根据延迟自动选择最优节点

### 流量流程

```
应用程序 → Tun 设备 → Clash → 订阅节点 → 目标服务器
```

## 注意事项

1. **权限要求**: Tun 模式需要特权模式和 NET_ADMIN 能力
2. **主机要求**: Tun 模式仅在 Linux 主机上可用
3. **代理配置**: 必须正确配置 Clash 代理服务器或订阅地址才能使用
4. **防火墙**: 确保防火墙允许相关端口
5. **性能**: Tun 模式会有一定的性能开销
6. **安全**: 不要在配置文件中明文存储敏感信息

## 安全建议

1. 不要在配置文件中明文存储敏感信息
2. 使用环境变量存储密码和密钥
3. 定期更新镜像和依赖
4. 限制容器网络访问
5. 使用强密码保护控制面板
6. 不要在生产环境中使用默认配置

## 高级配置

### 自定义规则

编辑 `config/clash/config.yaml` 的 `rules` 部分：

```yaml
rules:
  # 直连中国大陆 IP
  - GEOIP,CN,DIRECT
  
  # 直连局域网
  - IP-CIDR,192.168.0.0/16,DIRECT
  
  # 特定域名走代理
  - DOMAIN-SUFFIX,google.com,PROXY
  
  # 其他流量走代理
  - MATCH,PROXY
```

### 多订阅配置

```yaml
proxy-providers:
  subscription1:
    type: http
    url: "https://subscription1-url.com"
    interval: 3600
    path: ./providers/subscription1.yaml
    
  subscription2:
    type: http
    url: "https://subscription2-url.com"
    interval: 3600
    path: ./providers/subscription2.yaml

proxy-groups:
  - name: "PROXY"
    type: select
    use:
      - subscription1
      - subscription2
    proxies:
      - DIRECT
```

## 常见问题

### Q: Tun 模式和普通代理模式有什么区别？

A: Tun 模式是透明代理，应用程序无需任何配置，所有流量自动通过代理。普通代理模式需要应用程序手动配置代理地址。

### Q: 如何在 Windows 上使用？

A: Tun 模式仅支持 Linux。在 Windows 上可以使用 WSL2 或使用普通代理模式。

### Q: 如何查看代理流量？

A: 访问 Clash 控制面板 http://localhost:9090，可以查看实时连接和流量统计。

### Q: 容器重启后数据会丢失吗？

A: 不会。配置和数据目录已挂载到宿主机，重启容器不会丢失数据。

### Q: 订阅节点多久更新一次？

A: 默认每小时更新一次（3600 秒），可以在 `config/clash/config.yaml` 中调整 `interval` 参数。

## 许可证

MIT License

## 贡献

欢迎提交 Issue 和 Pull Request！

## 联系方式

如有问题，请提交 Issue。
