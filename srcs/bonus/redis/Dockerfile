# Use the penultimate stable version of Debian
FROM debian:bookworm

# Install Redis server
RUN apt-get update && apt-get install -y redis-server && rm -rf /var/lib/apt/lists/*

# Expose the default Redis port
EXPOSE 6379

# Start the Redis server
CMD ["redis-server"]
