.PHONY: help build up down restart logs ps shell test clean install update check status

# 默认目标
.DEFAULT_GOAL := help

# 颜色定义
GREEN  := \033[0;32m
YELLOW := \033[1;33m
RED    := \033[0;31m
BLUE   := \033[0;34m
NC     := \033[0m # No Color

help: ## 显示帮助信息
	@echo "$(BLUE)Antigravity-Manager Docker + Tun 模式 + Clash 代理$(NC)"
	@echo ""
	@echo "$(GREEN)可用命令:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(YELLOW)%-15s$(NC) %s\n", $$1, $$2}'

build: ## 构建 Docker 镜像
	@echo "$(BLUE)构建 Docker 镜像...$(NC)"
	docker-compose build

up: ## 启动容器（后台运行）
	@echo "$(BLUE)启动容器...$(NC)"
	docker-compose up -d
	@echo "$(GREEN)容器已启动！$(NC)"
	@echo "$(BLUE)查看日志: make logs$(NC)"

up-foreground: ## 启动容器（前台运行）
	@echo "$(BLUE)启动容器（前台模式）...$(NC)"
	docker-compose up

down: ## 停止并删除容器
	@echo "$(BLUE)停止并删除容器...$(NC)"
	docker-compose down
	@echo "$(GREEN)容器已停止！$(NC)"

restart: ## 重启容器
	@echo "$(BLUE)重启容器...$(NC)"
	docker-compose restart
	@echo "$(GREEN)容器已重启！$(NC)"

logs: ## 查看容器日志
	docker-compose logs -f

ps: ## 查看容器状态
	docker-compose ps

shell: ## 进入容器 Shell
	docker-compose exec antigravity-clash bash

test: ## 测试代理连接
	@echo "$(BLUE)测试 HTTP 代理...$(NC)"
	@curl -x http://localhost:7890 -I https://www.google.com || echo "$(YELLOW)HTTP 代理测试失败$(NC)"
	@echo ""
	@echo "$(BLUE)测试 SOCKS5 代理...$(NC)"
	@curl -x socks5://localhost:7891 -I https://www.google.com || echo "$(YELLOW)SOCKS5 代理测试失败$(NC)"
	@echo ""
	@echo "$(BLUE)测试 Antigravity-Manager 服务...$(NC)"
	@curl -f http://localhost:8045/api/health || echo "$(YELLOW)Antigravity-Manager 服务测试失败$(NC)"
	@echo ""
	@echo "$(BLUE)测试网络连接...$(NC)"
	@docker-compose exec antigravity-clash ping -c 4 8.8.8.8 || echo "$(YELLOW)网络连接测试失败$(NC)"

clean: ## 清理容器、镜像和数据
	@echo "$(YELLOW)警告: 这将删除所有容器、镜像和数据！$(NC)"
	@read -p "确定要继续吗？(y/N) " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		echo "$(BLUE)清理中...$(NC)"; \
		docker-compose down -v --rmi all --remove-orphans; \
		rm -rf data logs; \
		echo "$(GREEN)清理完成！$(NC)"; \
	else \
		echo "$(YELLOW)已取消$(NC)"; \
	fi

install: ## 初始化项目（创建必要的目录和配置文件）
	@echo "$(BLUE)初始化项目...$(NC)"
	mkdir -p data logs
	@if [ ! -f .env ]; then \
		echo "$(YELLOW)创建 .env 文件...$(NC)"; \
		cp .env.example .env; \
		echo "$(GREEN).env 文件已创建，请根据实际情况修改配置$(NC)"; \
	else \
		echo "$(YELLOW).env 文件已存在$(NC)"; \
	fi
	@echo "$(GREEN)初始化完成！$(NC)"
	@echo "$(BLUE)下一步:$(NC)"
	@echo "  1. 编辑 .env 文件配置 API_KEY 和 WEB_PASSWORD"
	@echo "  2. 编辑 config/clash/config.yaml 添加代理配置"
	@echo "  3. 运行 'make build' 构建镜像"
	@echo "  4. 运行 'make up' 启动容器"

status: ## 查看服务状态
	@echo "$(BLUE)容器状态:$(NC)"
	@docker-compose ps
	@echo ""
	@echo "$(BLUE)端口监听:$(NC)"
	@netstat -tuln | grep -E ':(8045|7890|7891|9090)' || echo "$(YELLOW)未检测到端口监听$(NC)"
	@echo ""
	@echo "$(BLUE)服务健康检查:$(NC)"
	@curl -f http://localhost:8045/api/health && echo "$(GREEN)✓ Antigravity-Manager 服务正常$(NC)" || echo "$(RED)✗ Antigravity-Manager 服务异常$(NC)"
	@curl -f http://localhost:9090 && echo "$(GREEN)✓ Clash 控制面板正常$(NC)" || echo "$(RED)✗ Clash 控制面板异常$(NC)"

check: ## 检查配置文件
	@echo "$(BLUE)检查配置文件...$(NC)"
	@if [ -f config/clash/config.yaml ]; then \
		echo "$(GREEN)✓ Clash 配置文件存在$(NC)"; \
	else \
		echo "$(RED)✗ Clash 配置文件不存在$(NC)"; \
	fi
	@if [ -f .env ]; then \
		echo "$(GREEN)✓ 环境变量文件存在$(NC)"; \
	else \
		echo "$(YELLOW)✗ 环境变量文件不存在$(NC)"; \
	fi
	@if [ -f Dockerfile ]; then \
		echo "$(GREEN)✓ Dockerfile 存在$(NC)"; \
	else \
		echo "$(RED)✗ Dockerfile 不存在$(NC)"; \
	fi
	@if [ -f docker-compose.yml ]; then \
		echo "$(GREEN)✓ docker-compose.yml 存在$(NC)"; \
	else \
		echo "$(RED)✗ docker-compose.yml 不存在$(NC)"; \
	fi

update: ## 更新镜像
	@echo "$(BLUE)更新镜像...$(NC)"
	docker-compose pull
	docker-compose up -d --build
	@echo "$(GREEN)更新完成！$(NC)"

rebuild: ## 强制重新构建镜像
	@echo "$(BLUE)强制重新构建镜像...$(NC)"
	docker-compose build --no-cache
	@echo "$(GREEN)重新构建完成！$(NC)"

logs-clash: ## 查看 Clash 日志
	docker-compose exec antigravity-clash tail -f /var/log/clash/clash.log

logs-antigravity: ## 查看 Antigravity-Manager 日志
	docker-compose exec antigravity-clash tail -f /var/log/antigravity/antigravity.log

clash-test: ## 测试 Clash 配置
	@echo "$(BLUE)测试 Clash 配置...$(NC)"
	docker-compose exec antigravity-clash clash -t -d /etc/clash
