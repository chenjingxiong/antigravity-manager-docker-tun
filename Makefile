.PHONY: help up down restart logs ps shell clean

# 默认目标
.DEFAULT_GOAL := help

# 颜色定义
GREEN  := \033[0;32m
YELLOW := \033[1;33m
RED    := \033[0;31m
BLUE   := \033[0;34m
NC     := \033[0m # No Color

help: ## 显示帮助信息
	@echo "$(BLUE)Antigravity-Manager + Clash + metacubexd$(NC)"
	@echo ""
	@echo "$(GREEN)可用命令:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(YELLOW)%-15s$(NC) %s\n", $$1, $$2}'

up: ## 启动所有服务（后台运行）
	@echo "$(BLUE)启动所有服务...$(NC)"
	docker-compose up -d
	@echo "$(GREEN)服务已启动！$(NC)"
	@echo "$(BLUE)查看日志: make logs$(NC)"
	@echo ""
	@echo "$(BLUE)访问服务:$(NC)"
	@echo "  - Antigravity-Manager: http://localhost:8045"
	@echo "  - metacubexd: http://localhost:8080"

down: ## 停止并删除所有容器
	@echo "$(BLUE)停止并删除所有容器...$(NC)"
	docker-compose down
	@echo "$(GREEN)容器已停止！$(NC)"

restart: ## 重启所有容器
	@echo "$(BLUE)重启所有容器...$(NC)"
	docker-compose restart
	@echo "$(GREEN)容器已重启！$(NC)"

logs: ## 查看所有容器日志
	docker-compose logs -f

logs-antigravity: ## 查看 Antigravity-Manager 日志
	docker-compose logs -f antigravity-manager

logs-clash: ## 查看 Clash 日志
	docker-compose logs -f clash

logs-metacubexd: ## 查看 metacubexd 日志
	docker-compose logs -f metacubexd

ps: ## 查看容器状态
	docker-compose ps

shell-antigravity: ## 进入 Antigravity-Manager 容器 Shell
	docker-compose exec antigravity-manager bash

shell-clash: ## 进入 Clash 容器 Shell
	docker-compose exec clash bash

shell-metacubexd: ## 进入 metacubexd 容器 Shell
	docker-compose exec metacubexd sh

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

status: ## 查看服务状态
	@echo "$(BLUE)容器状态:$(NC)"
	@docker-compose ps
	@echo ""
	@echo "$(BLUE)端口监听:$(NC)"
	@netstat -tuln | grep -E ':(8045|7890|7891|9090|8080)' || echo "$(YELLOW)未检测到端口监听$(NC)"
	@echo ""
	@echo "$(BLUE)服务健康检查:$(NC)"
	@curl -f http://localhost:8045/api/health && echo "$(GREEN)✓ Antigravity-Manager 服务正常$(NC)" || echo "$(RED)✗ Antigravity-Manager 服务异常$(NC)"
	@curl -f http://localhost:8080 && echo "$(GREEN)✓ metacubexd 正常$(NC)" || echo "$(RED)✗ metacubexd 异常$(NC)"
	@curl -f http://localhost:9090 && echo "$(GREEN)✓ Clash RESTful API 正常$(NC)" || echo "$(RED)✗ Clash RESTful API 异常$(NC)"

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
	@if [ -f docker-compose.yml ]; then \
		echo "$(GREEN)✓ docker-compose.yml 存在$(NC)"; \
	else \
		echo "$(RED)✗ docker-compose.yml 不存在$(NC)"; \
	fi

test: ## 测试代理连接
	@echo "$(BLUE)测试 HTTP 代理...$(NC)"
	@curl -x http://localhost:7890 -I https://www.google.com || echo "$(YELLOW)HTTP 代理测试失败$(NC)"
	@echo ""
	@echo "$(BLUE)测试 SOCKS5 代理...$(NC)"
	@curl -x socks5://localhost:7891 -I https://www.google.com || echo "$(YELLOW)SOCKS5 代理测试失败$(NC)"
	@echo ""
	@echo "$(BLUE)测试 Antigravity-Manager 服务...$(NC)"
	@curl -f http://localhost:8045/api/health || echo "$(YELLOW)Antigravity-Manager 服务测试失败$(NC)"
