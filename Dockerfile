FROM python:3.11-slim

WORKDIR /app

# Install system dependencies if needed (e.g., for git or other tools)
# RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

# Copy requirements first for cache efficiency
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy source code
COPY youtube_mcp_server.py .
COPY pyproject.toml .

# Force unbuffered output for Python
ENV PYTHONUNBUFFERED=1

# Expose the standard port
EXPOSE 8000

# Run with uvicorn
# We use the 'app' object exposed in youtube_mcp_server.py (which is mcp.sse_app)
CMD ["uvicorn", "youtube_mcp_server:app", "--host", "0.0.0.0", "--port", "8000"]
