# GitHub 仓库设置指南

## 步骤 1：创建 GitHub 仓库

1. 访问 https://github.com/new
2. 填写仓库信息：
   - Repository name: `antigravity-manager-docker-tun`
   - Description: `Antigravity-Manager Docker with Clash TUN mode and subscription support`
   - Public/Private: 根据需要选择
   - 勾选 "Add a README file"（可选，因为已有 README.md）
3. 点击 "Create repository"

## 步骤 2：配置 Docker Hub 凭证

在 GitHub 仓库设置中添加 Secrets：

1. 进入仓库的 **Settings** → **Secrets and variables** → **Actions**
2. 点击 **New repository secret**
3. 添加以下 Secrets：
   - **Name**: `DOCKER_USERNAME`
     - **Value**: 您的 Docker Hub 用户名（例如：`chenjingxiong`）
   - **Name**: `DOCKER_PASSWORD`
     - **Value**: Docker Hub 访问令牌（在 Docker Hub → Account Settings → Security → New Access Token 创建）

## 步骤 3：推送代码到 GitHub

仓库创建完成后，在项目目录执行：

```bash
cd d:/Quant_Code/AI相关项目/Antigravity-Manager-Docker-Tun
git push -u origin main
```

## 步骤 4：配置 Docker Hub（可选）

如果您想使用自定义的 Docker Hub 镜像名称，需要修改以下文件：

### 修改 GitHub Actions 工作流

编辑 `.github/workflows/docker.yml`，修改镜像名称：

```yaml
env:
  IMAGE_NAME: antigravity-manager-docker-tun  # 修改为您的镜像名称
```

### 修改 docker-compose.yml

编辑 `docker-compose.yml`，修改镜像地址：

```yaml
services:
  antigravity-clash:
    image: chenjingxiong/antigravity-manager-docker-tun:latest  # 修改为您的镜像地址
```

## 步骤 5：验证 GitHub Actions

1. 访问 GitHub 仓库的 **Actions** 页面
2. 查看 Docker 构建工作流是否自动触发
3. 等待构建完成（首次构建可能需要几分钟）
4. 构建成功后，镜像将自动推送到 Docker Hub

## 步骤 6：使用预构建镜像

构建成功后，可以直接使用预构建的镜像：

```bash
docker pull chenjingxiong/antigravity-manager-docker-tun:latest
```

## 常见问题

### Q: GitHub Actions 构建失败？

A: 检查以下内容：
1. Secrets 是否正确配置（DOCKER_USERNAME 和 DOCKER_PASSWORD）
2. Docker Hub 访问令牌是否有写入权限
3. 查看 Actions 日志获取详细错误信息

### Q: 如何查看构建状态？

A: 访问 GitHub 仓库的 Actions 页面，查看最新的工作流运行状态。

### Q: 如何手动触发构建？

A: 在 GitHub 仓库的 Actions 页面，选择 "Build and Push Docker Image" 工作流，点击 "Run workflow" 按钮。

### Q: 如何使用不同的镜像名称？

A: 修改 `.github/workflows/docker.yml` 中的 `IMAGE_NAME` 环境变量。

## 下一步

仓库创建并推送成功后，GitHub Actions 将自动构建和推送 Docker 镜像。您可以在 Docker Hub 查看您的镜像。
