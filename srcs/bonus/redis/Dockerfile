# Use the penultimate stable version of Debian
FROM debian:bookworm

# Install Redis server
RUN apt-get update && apt-get install -y redis-server && rm -rf /var/lib/apt/lists/*

# Expose the default Redis port
EXPOSE 6379

# Start the Redis server binding to all networks interfaces and disabling its default protected mode so other containers have access
CMD ["redis-server", "--bind", "0.0.0.0", "--protected-mode", "no"]
