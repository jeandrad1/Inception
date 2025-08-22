# Define the compose file path
COMPOSE_FILE = srcs/docker-compose.yml

# Default command: builds and starts everything
all: up

# Build and start containers in detached mode
up:
    @echo "Building and starting services..."
    docker-compose -f $(COMPOSE_FILE) up --build -d

# Stop and remove containers
down:
    @echo "Stopping and removing services..."
    docker-compose -f $(COMPOSE_FILE) down

# Stop containers and remove volumes (all data will be lost)
clean:
    @echo "Stopping services and deleting all data..."
    docker-compose -f $(COMPOSE_FILE) down --volumes

# Rebuild everything from scratch
re: clean all

# Declare targets that are not files
.PHONY: all up down clean re