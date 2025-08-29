FROM python:3.12-slim-bookworm

WORKDIR /app

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Install system dependencies including VS Code Server requirements
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        git \
        sudo \
        libstdc++6 \
        libx11-6 \
        libxkbfile1 \
        libsecret-1-0 \
        libnss3 \
        wget \
        gnupg \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Install VS Code Server (code-server)
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Create a non-root user for code-server (better security)
RUN useradd -m -s /bin/bash coder && \
    echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/coder && \
    chmod 0440 /etc/sudoers.d/coder

# Create workspace directory and set permissions
RUN mkdir -p /home/coder/workspace && \
    chown -R coder:coder /home/coder

# Switch to non-root user
USER coder
WORKDIR /home/coder

# Set up code-server configuration
RUN mkdir -p .config/code-server && \
    echo "bind-addr: 0.0.0.0:8080\nauth: password\npassword: mypassword123\ncert: false" > .config/code-server/config.yaml

# Expose code-server port
EXPOSE 8080

# Start code-server with the workspace directory
CMD ["code-server", "--auth", "password", "--bind-addr", "0.0.0.0:8080", "/home/coder/workspace"]