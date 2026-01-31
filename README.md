# Antigravity-Manager + Clash + mihomo

This project deploys Antigravity-Manager, Clash proxy, and mihomo Web UI using Docker Compose, with subscription node support.

## Project Overview

Antigravity-Manager is a professional AI account management and protocol reverse proxy system. This project uses the official Docker image, integrates Clash proxy (with TUN mode and subscription support), and uses mihomo as the Web management interface.

## Project Structure

```
.
├── docker-compose.yml              # Docker Compose configuration
├── Makefile                        # Command shortcuts
├── .env.example                    # Environment variables example
├── .gitignore                      # Git ignore file
├── README.md                       # English documentation
├── README_CN.md                    # Chinese documentation
└── config/
    └── clash/
        └── config.yaml            # Clash configuration file (with subscription support)
```

## Features

- ✅ Uses Antigravity-Manager official image `lbjlaq/antigravity-manager:latest`
- ✅ Integrated Clash proxy (with TUN mode support)
- ✅ Subscription node support (automatic node list updates)
- ✅ mihomo Web UI (acd) for visual management
- ✅ Tun mode transparent proxy
- ✅ Auto route configuration
- ✅ DNS hijacking
- ✅ Container health check
- ✅ Data persistence

## Antigravity-Manager Features

### 1. Smart Account Dashboard
- Global real-time monitoring of all accounts
- Smart recommendation for best account
- Active account snapshot

### 2. Powerful Account Management
- OAuth 2.0 authorization (auto/manual)
- Multi-dimensional import
- Gateway-level view

### 3. Protocol Conversion & Relay
- Multi-protocol support (OpenAI, Anthropic, Gemini)
- Smart self-healing
- Auto retry and silent rotation

### 4. Model Routing Center
- Series mapping
- Expert-level redirection
- Tiered routing

### 5. Multimodal & Imagen 3 Support
- Advanced quality control
- Super body support (up to 100MB)

## Prerequisites

- Docker 20.10+
- Docker Compose 2.0+
- Linux host (Tun mode requires)

## Quick Start

### 1. Clone the Project

```bash
git clone <repository-url>
cd Antigravity-Manager-Docker-Tun
```

### 2. Configure Clash Subscription URL

Edit [`config/clash/config.yaml`](config/clash/config.yaml) file, modify the subscription URL:

```yaml
proxy-providers:
  subscription:
    type: http
    url: "https://your-subscription-url.com"  # Replace with your subscription URL
    interval: 3600  # Update every hour
    path: ./providers/subscription.yaml
    health-check:
      enable: true
      interval: 600
      url: http://www.gstatic.com/generate_204
```

### 3. Configure Environment Variables

Edit [`docker-compose.yml`](docker-compose.yml:17), set API_KEY and WEB_PASSWORD:

```yaml
environment:
  - LOG_LEVEL=info
  - API_KEY=your-secret-key  # [Important] Please set your security key
  - WEB_PASSWORD=your-login-password  # Optional, Web UI login password
```

### 4. Start Services

```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f
```

## Configuration

### Clash Configuration (config/clash/config.yaml)

#### Subscription Node Configuration

Edit [`config/clash/config.yaml`](config/clash/config.yaml) file, configure subscription URL:

```yaml
proxy-providers:
  subscription:
    type: http
    url: "https://your-subscription-url.com"  # Replace with your subscription URL
    interval: 3600  # Update every hour
    path: ./providers/subscription.yaml
    health-check:
      enable: true
      interval: 600
      url: http://www.gstatic.com/generate_204
```

#### Manual Proxy Configuration (Optional)

If you don't want to use subscription, you can manually configure proxies:

```yaml
proxies:
  - name: "MyProxy"
    type: http  # Supports http, ss, vmess, trojan, etc.
    server: your-proxy-server.com
    port: 8080
    username: your-username
    password: your-password
```

Main configuration options:

- `port`: HTTP proxy port (default 7890)
- `socks-port`: SOCKS5 proxy port (default 7891)
- `tun.enable`: Enable Tun mode
- `tun.device`: Tun device name (default tun0)
- `proxy-providers`: Subscription node configuration
- `proxies`: Manual proxy configuration
- `rules`: Traffic rules

### Antigravity-Manager Configuration

Antigravity-Manager uses environment variables for configuration:

- `API_KEY`: Required. API key for AI request authentication
- `WEB_PASSWORD`: Optional. Web UI login password
- `PORT`: Service port (default 8045)
- `LOG_LEVEL`: Log level (debug, info, warn, error)

## Port Mapping

| Port | Service | Description |
|------|--------|-------------|
| 8045 | Antigravity-Manager | Management UI and API Base |
| 7890 | Clash HTTP Proxy | Clash HTTP proxy port |
| 7891 | Clash SOCKS5 Proxy | Clash SOCKS5 proxy port |
| 9090 | Clash Control Panel | Clash RESTful API port |
| 8080 | mihomo Web UI | mihomo Web management interface |

## Access Services

After starting services, you can access:

- **Antigravity-Manager**: http://localhost:8045
- **mihomo Web UI**: http://localhost:8080
- **Clash Control Panel**: http://localhost:9090 (accessed via mihomo)

### Using mihomo to Configure Proxy

1. Visit http://localhost:8080
2. Click "Connect" button to connect to Clash (default address: `http://clash:9090`)
3. In mihomo, you can:
   - View subscription nodes
   - Test node latency
   - Switch proxy nodes
   - View traffic statistics
   - Manage proxy rules

## Common Commands

### Using Makefile

```bash
# View all commands
make help

# Start containers
make up

# Stop containers
make down

# Restart containers
make restart

# View logs
make logs

# View container status
make ps

# Enter container
make shell

# Clean all data
make clean
```

### Using Docker Compose

```bash
# Start containers
docker-compose up -d

# Stop containers
docker-compose down

# Restart containers
docker-compose restart

# View logs
docker-compose logs -f

# Enter container
docker-compose exec antigravity-manager bash

# View container status
docker-compose ps
```

## Verify Service

### 1. Check Container Status

```bash
docker-compose ps
```

### 2. Test HTTP Proxy

```bash
curl -x http://localhost:7890 https://www.google.com
```

### 3. Access Antigravity-Manager Web UI

Browser open: http://localhost:8045

### 4. Access mihomo Web UI

Browser open: http://localhost:8080

## Usage Examples

### How to use with Claude Code CLI?

1. Start Antigravity-Manager and enable service in "API Proxy" page.
2. Run in terminal:
```bash
export ANTHROPIC_API_KEY="sk-antigravity"
export ANTHROPIC_BASE_URL="http://127.0.0.1:8045"
claude
```

### How to use with Kilo Code?

1. **Protocol Selection**: Recommend using **Gemini protocol**.
2. **Base URL**: Fill in `http://127.0.0.1:8045`.
3. **Note**:
    - **OpenAI Protocol Limitation**: When Kilo Code uses OpenAI mode, its request path will stack to produce non-standard paths like `/v1/chat/completions/responses`, causing Antigravity to return 404. Therefore, please select Gemini mode after filling in Base URL.
    - **Model Mapping**: Model names in Kilo Code may not match Antigravity default settings. If you encounter connection issues, please set custom mappings in "Model Mapping" page and check **log files** for debugging.

### How to use in Python?

```python
import openai

client = openai.OpenAI(
    api_key="sk-antigravity",
    base_url="http://127.0.0.1:8045/v1"
)

response = client.chat.completions.create(
    model="gemini-3-flash",
    messages=[{"role": "user", "content": "Hello, please introduce yourself"}]
)
print(response.choices[0].message.content)
```

### How to use Image Generation (Imagen 3)?

#### Method 1: OpenAI Images API (Recommended)

```python
import openai

client = openai.OpenAI(
    api_key="sk-antigravity",
    base_url="http://127.0.0.1:8045/v1"
)

# Generate image
response = client.images.generate(
    model="gemini-3-pro-image",
    prompt="A futuristic city, cyberpunk, neon lights",
    size="1920x1080",      # Supports arbitrary WIDTHxHEIGHT format, automatically calculates aspect ratio
    quality="hd",          # "standard" | "hd" | "medium"
    n=1,
    response_format="b64_json"
)

# Save image
import base64
image_data = base64.b64decode(response.data[0].b64_json)
with open("output.png", "wb") as f:
    f.write(image_data)
```

## Troubleshooting

### Tun Device Not Found

```bash
# Check Tun device
docker-compose exec clash ls -l /dev/net/tun

# If not exists, check host Tun device
ls -l /dev/net/tun
```

### Clash Failed to Start

```bash
# View Clash logs
docker-compose logs clash

# Check configuration file
docker-compose exec clash clash -t -d /root/.config/clash
```

### Subscription Node Cannot Update

```bash
# Check if subscription URL is accessible
curl -I https://your-subscription-url.com

# View subscription update information in Clash logs
docker-compose logs -f clash | grep subscription
```

### mihomo Cannot Connect to Clash

1. Check if Clash container is running: `docker-compose ps`
2. Check if Clash control panel port is open: `docker-compose logs clash`
3. Confirm Clash address in mihomo: `http://clash:9090`

### Network Issues

```bash
# Check iptables rules
docker-compose exec clash iptables -t nat -L -n

# Check routing
docker-compose exec clash ip route

# Test network connection
docker-compose exec clash ping -c 4 8.8.8.8
```

### Proxy Connection Failed

1. Check if proxy server configuration is correct
2. Confirm proxy server is accessible
3. View Clash logs for detailed error messages
4. Test proxy connection:

```bash
curl -x http://localhost:7890 https://www.google.com
```

## How It Works

### Tun Mode Principle

1. **Tun Device**: Creates a virtual network interface (tun0)
2. **Traffic Hijacking**: Redirects all traffic to Tun device via iptables rules
3. **DNS Hijacking**: Intercepts DNS queries, resolves through proxy server
4. **Transparent Proxy**: All traffic automatically goes through proxy without application configuration

### Subscription Node Principle

1. **Auto Update**: Clash periodically fetches node list from subscription URL
2. **Health Check**: Periodically tests node availability
3. **Auto Select**: Automatically selects optimal node based on latency

### mihomo Principle

mihomo is a React-based Clash Web UI that manages proxy configuration and status through Clash RESTful API.

### Traffic Flow

```
Application → Tun Device → Clash → Subscription Node → Target Server
```

## Important Notes

1. **Permission Requirements**: Tun mode requires privileged mode and NET_ADMIN capability
2. **Host Requirements**: Tun mode only works on Linux hosts
3. **Proxy Configuration**: Must configure Clash proxy server or subscription URL correctly
4. **Firewall**: Ensure firewall allows relevant ports
5. **Performance**: Tun mode has some performance overhead
6. **Security**: Do not store sensitive information in configuration files

## Security Recommendations

1. Do not store sensitive information in configuration files
2. Use environment variables for passwords and keys
3. Regularly update images and dependencies
4. Limit container network access
5. Use strong passwords for control panel
6. Do not use default configuration in production

## Advanced Configuration

### Custom Rules

Edit [`config/clash/config.yaml`](config/clash/config.yaml)'s `rules` section:

```yaml
rules:
  # Direct connection to mainland China IP
  - GEOIP,CN,DIRECT

  # Direct connection to LAN
  - IP-CIDR,192.168.0.0/16,DIRECT

  # Specific domain via proxy
  - DOMAIN-SUFFIX,google.com,PROXY

  # Other traffic via proxy
  - MATCH,PROXY
```

### Multiple Subscriptions

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

## FAQ

### Q: What's the difference between Tun mode and normal proxy mode?

A: Tun mode is transparent proxy, all traffic automatically goes through proxy without application configuration. Normal proxy mode requires applications to manually configure proxy address.

### Q: How to use on Windows?

A: Tun mode only supports Linux. On Windows, you can use WSL2 or use normal proxy mode.

### Q: How to view proxy traffic?

A: Access mihomo Web UI at http://localhost:8080 to view real-time connections and traffic statistics.

### Q: Will data be lost after container restart?

A: No. Configuration and data directories are mounted to the host, restarting the container will not lose data.

### Q: How often are subscription nodes updated?

A: Default is every hour (3600 seconds), you can adjust the `interval` parameter in [`config/clash/config.yaml`](config/clash/config.yaml:24).

### Q: What's the difference between mihomo and Clash control panel?

A: mihomo is a more user-friendly Web UI providing visual proxy management interface. Clash control panel is the official RESTful API port, and mihomo communicates with Clash through this port.

## License

MIT License

## Contributing

Welcome to submit Issues and Pull Requests!

## Contact

If you have any questions, please submit an Issue.
