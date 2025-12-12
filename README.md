# Inception

Infrastructure with Docker and Docker Compose for deploying a complete web application in containers.

## Description

Project that configures a complete development and production environment using Docker and Docker Compose. It implements a stack of modern technologies to serve scalable web applications with multiple services (web server, database, application).

## Architecture

The project implements a microservices architecture with the following components:

- **Web Server (Nginx):** Reverse proxy and web server
- **Database (MariaDB):** Relational database
- **Application (WordPress):** Content management system or custom web application

## Features

- Isolated Docker containers for each service
- Orchestration with Docker Compose
- Docker networks for inter-service communication
- Persistent volumes for data
- Configurable environment variables
- SSL/TLS configuration
# Inception

Docker Compose stack to deploy a WordPress site with MariaDB, Nginx and several optional (bonus) services.

This README documents the actual commands and configuration used by the `Makefile` and `srcs/docker-compose.yml` in this folder.

**Key points:**
- The project uses `srcs/docker-compose.yml` as the compose file and reads runtime variables from the repository `.env` file.
- There are core services (WordPress, MariaDB, Nginx, Redis) and bonus services (FTP, static site, Adminer, Portainer). Bonus services are activated with Docker Compose profiles.

## Project structure

```
inception/
├── Makefile
├── srcs/
│   ├── docker-compose.yml
│   ├── requirements/
│   │   ├── nginx/
│   │   ├── mariadb/
│   │   └── wordpress/
│   └── bonus/
└── .env              # environment variables used by the stack
```

## Services (as defined in `srcs/docker-compose.yml`)

- `wordpress` — PHP/WordPress (build: `./requirements/wordpress`). Uses `wordpress_data` volume and depends on `db` and `redis`.
- `db` — MariaDB (build: `./requirements/mariadb`). Uses `db_data` volume.
- `nginx` — Reverse proxy (build: `./requirements/nginx`). Exposes port `443`.
- `redis` — Redis cache (built from `./bonus/redis`). Included as a dependency for WordPress.

Bonus (profile-protected) services — started only when profiles are enabled (see Makefile `all` target):
- `ftp` — FTP server (build: `./bonus/ftp`). Binds host folder `/home/jeandrad/data/wordpress` into the container and exposes ports `21` and passive range `21100-21110`.
- `static_site` — Static site container (build: `./bonus/static-site`).
- `adminer` — DB admin tool exposed on port `8080`.
- `portainer` — Portainer UI exposed on port `9443` and using `portainer_data` volume.

## Makefile targets (exact commands)

- `make all` — Start all services, including bonus ones:
	`docker compose --env-file .env -f srcs/docker-compose.yml --profile "*" up --build -d`
- `make up` — Start only core services (no profiles):
	`docker compose --env-file .env -f srcs/docker-compose.yml up --build -d`
- `make down` — Stop and remove all containers (core + bonus):
	`docker compose --env-file .env -f srcs/docker-compose.yml --profile "*" down --volumes`
- `make clean` — Stop and remove containers, volumes and images:
	`docker compose --env-file .env -f srcs/docker-compose.yml --profile "*" down --volumes --rmi all`
- `make logs` — Follow logs for all services:
	`docker compose --env-file .env -f srcs/docker-compose.yml logs -f`

Run these targets from the `inception/` repository root.

## Required environment variables

Place a `.env` file in the `inception/` folder. The compose files reference these variables (example names used in `docker-compose.yml`):

```
MYSQL_ROOT_PASSWORD=your_root_password
MYSQL_DATABASE=wordpress_db
MYSQL_USER=wp_user
MYSQL_PASSWORD=wp_pass
MARIADB_ADMIN_USER=admin_user
MARIADB_ADMIN_PASSWORD=admin_pass
DOMAIN_NAME=example.com
WP_ADMIN_USER=admin
WP_ADMIN_PASSWORD=admin_password
```

Adjust values to your environment before running `make up` or `make all`.

## Volumes and host paths

The compose file uses bind-mounted local volumes. By default the following host paths are referenced:

- `wordpress_data` -> host: `/home/jeandrad/data/wordpress` (bind mounted)
- `db_data` -> host: `/home/jeandrad/data/mariadb` (bind mounted)
- `portainer_data` -> host: `/home/jeandrad/data/portainer` (bind mounted)

If you run this on another machine, either create these host directories with appropriate permissions or edit `srcs/docker-compose.yml` to point the volumes to locations that exist on your host.

Note: the `ftp` bonus service also mounts `/home/jeandrad/data/wordpress` directly to serve site files over FTP.

## Ports

- Core services:
	- `nginx`: `443:443` (HTTPS). Nginx serves the site and should be configured with certificates via the Nginx requirement folder.
	- MariaDB: not published to host (internal network only)

- Bonus services (only when started via `make all` / profiles):
	- `ftp`: `21` and passive range `21100-21110`
	- `adminer`: `8080`
	- `portainer`: `9443`
    - `redis` : `6379`
    - `static-site`

## Profiles and bonus services

The compose file uses Docker Compose profiles for optional services. The Makefile's `all` target runs with `--profile "*"` to enable those services. If you use `make up`, only core services (no `profiles`) are started.

## Useful commands (manual Docker Compose equivalents)

- Start core services:
	`docker compose --env-file .env -f srcs/docker-compose.yml up --build -d`
- Start core + bonus services:
	`docker compose --env-file .env -f srcs/docker-compose.yml --profile "*" up --build -d`
- Stop and remove (including volumes):
	`docker compose --env-file .env -f srcs/docker-compose.yml --profile "*" down --volumes`
- View logs:
	`docker compose --env-file .env -f srcs/docker-compose.yml logs -f`

## Notes and recommendations

- Ensure the `.env` file is present and contains all variables referenced by the compose file before launching the stack.
- Create the host directories used by bind mounts (`/home/jeandrad/data/...`) and set correct permissions for your UID/GID.
- When moving the project to another host, update the `device` paths in the `volumes` section of `srcs/docker-compose.yml` or create matching directories.
- Use `make logs` to follow combined service logs and troubleshoot issues.

---

Last updated: 2025
