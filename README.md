# Antigravity-Manager Docker + Tun Mode + Clash Proxy

This project builds Antigravity-Manager using Docker based on the official image `lbjlaq/antigravity-manager:latest`, and connects the Docker network through Tun mode using Clash proxy with subscription support.

## Project Overview

Antigravity-Manager is a professional AI account management and protocol reverse proxy system. This Docker deployment is based on the official Antigravity-Manager image, adding transparent proxy support via Tun mode and Clash, with subscription node support.

## Project Structure

```
.
├── Dockerfile                      # Docker image build file (based on official image)
├── docker-compose.yml              # Docker Compose configuration
├── Makefile                        # Command shortcuts
├── .env.example                    # Environment variables example
├── .gitignore                      # Git ignore file
├── README.md                       # English documentation
├── README_CN.md                    # Chinese documentation
├── .github/
│   └── workflows/
│       └── docker.yml             # GitHub Actions auto-build workflow
├── config/
│   └── clash/
│       └── config.yaml            # Clash configuration file (with subscription support)
└── scripts/
    ├── setup-tun.sh               # Tun mode network setup script
    └── start.sh                   # Container startup script
```

## Features

- ✅ Based on Antigravity-Manager official image `lbjlaq/antigravity-manager:latest`
- ✅ GitHub Actions auto-build (multi-architecture support)
- ✅ Integrated Clash proxy (with TUN mode support)
- ✅ Subscription node support (automatic node list updates)
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

### Method 1: Using Docker Compose (Recommended)

```bash
# 1. Clone the project
git clone <repository-url>
cd Antigravity-Manager-Docker-Tun

# 2. Configure Clash subscription URL
# Edit config/clash/config.yaml file, modify the subscription URL
# Replace "https://your-subscription-url.com" with your actual subscription URL

# 3. Configure environment variables
# Edit docker-compose.yml, set API_KEY and WEB_PASSWORD

# 4. Build and start
docker-compose build
docker-compose up -d

# 5. View logs
docker-compose logs -f
```

### Method 2: Using Makefile

```bash
# 1. Clone the project
git clone <repository-url>
cd Antigravity-Manager-Docker-Tun

# 2. Configure Clash subscription URL
# Edit config/clash/config.yaml file

# 3. Configure environment variables
# Edit docker-compose.yml

# 4. Build image
make build

# 5. Start container
make up

# 6. View logs
make logs
```

## Configuration

### Clash Configuration (config/clash/config.yaml)

#### Subscription Node Configuration

Edit `config/clash/config.yaml` file, configure subscription URL:

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

| Port | Usage | Description |
|------|--------|-------------|
| 8045 | Antigravity-Manager | Management UI and API Base |
| 7890 | HTTP Proxy | Clash HTTP proxy port |
| 7891 | SOCKS5 Proxy | Clash SOCKS5 proxy port |
| 9090 | Control Panel | Clash Web control panel |

## GitHub Actions Auto-Build

This project is configured with GitHub Actions workflow for automatic Docker image building and publishing.

### Trigger Conditions

- Push to `main` or `master` branch
- Create tags (e.g., `v1.0.0`)
- Pull requests targeting `main` or `master` branch
- Manual trigger (via GitHub Actions page)

### Build Features

- ✅ Multi-architecture support (linux/amd64, linux/arm64)
- ✅ Automatic push to GitHub Container Registry (ghcr.io)
- ✅ Automatic tag management (branch name, version, latest)
- ✅ Build cache acceleration
- ✅ Build summary generation

### Using Pre-built Images

If you don't want to build yourself, you can use the GitHub Actions built image:

```bash
# Use pre-built image
docker pull your-username/antigravity-manager-docker-tun:latest

# Update image address in docker-compose.yml
# image: your-username/antigravity-manager-docker-tun:latest
```

### Configure Docker Hub Credentials

Add the following Secrets in your GitHub repository settings:

1. Go to repository Settings → Secrets and variables → Actions
2. Add the following Secrets:
   - `DOCKER_USERNAME`: Docker Hub username
   - `DOCKER_PASSWORD`: Docker Hub access token (create at Docker Hub → Account Settings → Security → New Access Token)

### Build Status

Check the [GitHub Actions](../../actions) page for build status and history.

## Common Commands

### Using Makefile

```bash
# View all commands
make help

# Build image
make build

# Start container
make up

# Stop container
make down

# Restart container
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
# Start container
docker-compose up -d

# Stop container
docker-compose down

# Restart container
docker-compose restart

# View logs
docker-compose logs -f

# Enter container
docker-compose exec antigravity-clash bash

# View container status
docker-compose ps

# Rebuild image
docker-compose build --no-cache
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

### 4. Access Clash Control Panel

Browser open: http://localhost:9090

## Troubleshooting

### Tun Device Not Found

```bash
# Check Tun device
docker-compose exec antigravity-clash ls -l /dev/net/tun

# If not exists, check host Tun device
ls -l /dev/net/tun
```

### Clash Failed to Start

```bash
# View Clash logs
docker-compose exec antigravity-clash cat /var/log/clash/clash.log

# Check configuration file
docker-compose exec antigravity-clash clash -t -d /etc/clash
```

### Subscription Node Cannot Update

```bash
# Check if subscription URL is accessible
curl -I https://your-subscription-url.com

# View subscription update information in Clash logs
docker-compose logs -f antigravity-clash | grep subscription
```

### Network Issues

```bash
# Check iptables rules
docker-compose exec antigravity-clash iptables -t nat -L -n

# Check routing
docker-compose exec antigravity-clash ip route

# Test network connection
docker-compose exec antigravity-clash ping -c 4 8.8.8.8
```

### Proxy Connection Failed

1. Check if proxy server configuration is correct
2. Confirm proxy server is accessible
3. View Clash logs for detailed error messages
4. Test proxy connection:

```bash
curl -x http://localhost:7890 https://www.google.com
```

## How Tun Mode Works

1. **Tun Device**: Creates a virtual network interface (tun0)
2. **Traffic Hijacking**: Redirects all traffic to Tun device via iptables rules
3. **DNS Hijacking**: Intercepts DNS queries, resolves through proxy server
4. **Transparent Proxy**: All traffic automatically goes through proxy without application configuration

### Subscription Node Principle

1. **Auto Update**: Clash periodically fetches node list from subscription URL
2. **Health Check**: Periodically tests node availability
3. **Auto Select**: Automatically selects optimal node based on latency

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

Edit `config/clash/config.yaml`'s `rules` section:

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

A: Access Clash control panel at http://localhost:9090 to view real-time connections and traffic statistics.

### Q: Will data be lost after container restart?

A: No. Configuration and data directories are mounted to the host, restarting the container will not lose data.

### Q: How often are subscription nodes updated?

A: Default is every hour (3600 seconds), you can adjust the `interval` parameter in `config/clash/config.yaml`.

## License

MIT License

## Contributing

Welcome to submit Issues and Pull Requests!

## Contact

If you have any questions, please submit an Issue.
