FROM python:3.11-slim

# Prevent Python from writing pyc files and buffering stdout
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Expose port for SSE transport
EXPOSE 8000

# Run in SSE mode using the MCP CLI
# This ensures a web server starts on port 8000, preventing health check failures
CMD ["mcp", "run", "youtube_mcp_server.py", "--transport", "sse", "--port", "8000", "--host", "0.0.0.0"]