# Define the compose file path
COMPOSE_FILE = srcs/docker-compose.yml

# Starts all services, including the bonus ones
all:
    docker-compose -f srcs/docker-compose.yml --profile "*" up --build -d

# Starts only the core services (default behavior)
up:
    docker-compose -f srcs/docker-compose.yml up --build -d

# Starts the core services AND the bonus services
bonus:
    docker-compose -f srcs/docker-compose.yml --profile bonus up --build -d

# Stops and removes all containers (core and bonus)
down:
    docker-compose -f srcs/docker-compose.yml --profile "*" down --volumes

# Cleans the system by removing all containers, networks, volumes, and images
clean:
    docker-compose -f srcs/docker-compose.yml --profile "*" down --volumes --rmi all

# Shows the logs for all running services
logs:
    docker-compose -f srcs/docker-compose.yml logs -f

.PHONY: all