# Penultimate stable version of Debian
FROM debian:bookworm

# Install curl to download the binary
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Download the pre-compiled Portainer binary for Linux AMD64
RUN curl -L -o /tmp/portainer.tar.gz https://github.com/portainer/portainer/releases/download/2.19.4/portainer-2.19.4-linux-amd64.tar.gz \
    && tar -C /opt -xzf /tmp/portainer.tar.gz \
    && rm /tmp/portainer.tar.gz

# The Portainer binary will be at /opt/portainer/portainer
# It requires the /data volume for its persistent data and the docker socket.
CMD ["/opt/portainer/portainer", "--data", "/data", "--host", "unix:///var/run/docker.sock"]
