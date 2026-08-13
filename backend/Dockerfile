# Use a fixed Python version so builds do not change unexpectedly
FROM python:3.11-slim

# Folder inside the container where the backend code will run
WORKDIR /usr/backend

# Python/container settings
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    VIRTUAL_ENV=/opt/venv \
    PATH="/opt/venv/bin:$PATH"

# Create a Python virtual environment inside the container
RUN python3 -m venv $VIRTUAL_ENV

# The FastAPI application listens on port 8000 inside the container
EXPOSE 8000

# Install Linux tools required by entrypoint.sh and PostgreSQL connectivity
RUN apt-get update \
    && apt-get install -y --no-install-recommends netcat-openbsd gcc postgresql \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages
COPY ./requirements.txt ./
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# Copy backend application source code into the container
COPY . .

# Run setup/start script before FastAPI starts
# Convert Windows line endings, then run setup/start script
RUN sed -i 's/\r$//' /usr/backend/entrypoint.sh \
    && chmod +x /usr/backend/entrypoint.sh

ENTRYPOINT ["/bin/sh", "/usr/backend/entrypoint.sh"]

# Start FastAPI
CMD ["uvicorn", "src.main:backend_app", "--host", "0.0.0.0", "--port", "8000", "--workers", "1"]