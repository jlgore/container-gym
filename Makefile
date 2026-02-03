# Container Gym Makefile

# Variables
COMPOSE = docker compose
GYMCTL_IMAGE = ghcr.io/shart-cloud/gymctl:latest
CONTAINER_NAME = container-gym

.PHONY: help up down shell clean status logs pull

help: ## Show this help message
	@echo "Container Gym - Available Commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

build: ## Build gymctl image locally
	@echo "Building gymctl image from source..."
	$(COMPOSE) build

up: ## Start container gym environment
	@echo "Building and starting Container Gym..."
	$(COMPOSE) up -d --build
	@echo ""
	@echo "Container Gym is running!"
	@echo "Connect with: make shell"

down: ## Stop container gym environment
	@echo "Stopping Container Gym..."
	$(COMPOSE) down

shell: ## Connect to gymctl container
	@echo "Connecting to Container Gym..."
	@echo "Type 'gymctl list' to see available exercises"
	@docker exec -it $(CONTAINER_NAME) /bin/bash

status: ## Show container status
	@echo "Container Gym Status:"
	$(COMPOSE) ps

logs: ## Show container logs
	$(COMPOSE) logs -f gymctl

clean: ## Clean up volumes and containers
	@echo "Cleaning up Container Gym..."
	$(COMPOSE) down -v
	@echo "Cleaned up all containers and volumes"

restart: down up ## Restart container gym

# Development commands
dev-shell: ## Start shell with live code mount
	docker run -it --rm \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-v gym-progress:/home/gymuser/.gym \
		-v ./workspace:/workspace \
		-w /workspace \
		container-gym-gymctl /bin/bash

test-exercise: ## Test a specific exercise (use EXERCISE=name)
	@if [ -z "$(EXERCISE)" ]; then \
		echo "Usage: make test-exercise EXERCISE=jerry-root-container"; \
		exit 1; \
	fi
	@docker exec -it $(CONTAINER_NAME) gymctl start $(EXERCISE)

# Docker-in-Docker mode
dind-up: ## Start with Docker-in-Docker
	@echo "Starting Container Gym with Docker-in-Docker..."
	$(COMPOSE) --profile dind up -d
	@echo ""
	@echo "DinD mode enabled. Connect with: make dind-shell"

dind-shell: ## Connect to gymctl with DinD
	@echo "Connecting to Container Gym (DinD mode)..."
	@echo "Docker daemon available at tcp://dind:2375"
	@docker exec -it -e DOCKER_HOST=tcp://dind:2375 $(CONTAINER_NAME) /bin/bash