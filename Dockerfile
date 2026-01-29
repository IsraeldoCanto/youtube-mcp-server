FROM python:3.11-slim

# Prevent Python from writing pyc files and buffering stdout
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Install system dependencies if needed (e.g. for building some python packages)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Expose port (adjust if needed, usually MCP runs over usage of stdio or specific port if configured)
# For web-based MCP (SSE), port 8000 is common.
EXPOSE 8000

# Command to run the application
# Adjust "youtube_mcp_server.py" if the main entry point is different
CMD ["python", "youtube_mcp_server.py"]