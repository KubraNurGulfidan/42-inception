NAME = inception
DATA_PATH = /home/$(USER)/data
COMPOSE_FILE = srcs/docker-compose.yml
COMPOSE = docker compose -f $(COMPOSE_FILE)

all: setup build up

setup:
	@echo "Creating data directories..."
	@mkdir -p $(DATA_PATH)/wordpress
	@mkdir -p $(DATA_PATH)/mariadb
	@echo "✔ Data directories created"

build: setup
	@echo "Building Docker images..."
	@$(COMPOSE) build
	@echo "✔ Build completed"

up:
	@echo "Starting containers..."
	@$(COMPOSE) up -d
	@echo "✔ All services started successfully!"
	@echo "Container status:"

start:
	@echo "Starting existing containers..."
	@$(COMPOSE) start
	@echo "✔ Containers started"
	@$(COMPOSE) ps

restart:
	@echo "Restarting containers..."
	@$(COMPOSE) restart
	@echo "✔ Containers restarted"
	@$(COMPOSE) ps

logs:
	@$(COMPOSE) logs

ps:
	@docker ps

status:
	@echo "=== Container Status ==="
	@$(COMPOSE) ps
	@echo "=== Docker Volumes ==="
	@docker volume ls | grep -E "wordpress|mariadb|srcs"
	@echo "=== Docker Networks ==="
	@docker network ls | grep -E "inception|srcs"

stop:
	@echo "Stopping containers..."
	@$(COMPOSE) stop
	@echo "✔ Containers stopped"

down:
	@echo "Stopping containers..."
	@$(COMPOSE) down
	@echo "✔ Containers stopped"

clean: down
	@echo "Cleaning Docker system..."
	@docker system prune -af --volumes
	@echo "Removing data directories..."
	@sudo rm -rf $(DATA_PATH)/wordpress
	@sudo rm -rf $(DATA_PATH)/mariadb
	@echo "✔ Clean completed"

fclean: clean
	@echo "Removing volumes and networks..."
	@docker volume rm wordpress mariadb 2>/dev/null || true
	@docker network rm inception 2>/dev/null || true
	@echo "✔ Full clean completed"

re: fclean all

.PHONY: all setup build up down start stop restart logs ps status clean fclean re