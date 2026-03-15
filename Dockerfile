FROM python:3.10-slim

LABEL maintainer="tether-research"
LABEL description="Tether: Autonomous Functional Play with Correspondence-Driven Trajectory Warping"

# Avoid interactive prompts during build
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies required by OpenCV and other packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    libgl1 \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Python dependencies first for better layer caching
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy project source code
COPY conf/ conf/
COPY prompts/ prompts/
COPY utils/ utils/
COPY *.py ./

# Create directories for runtime data
RUN mkdir -p data_real/demos data_real/runs cache

# Default command shows usage information
CMD ["python", "-c", "print('Tether: Autonomous Functional Play with Correspondence-Driven Trajectory Warping\\n\\nUsage:\\n  Single rollout:  python runner.py mode=single action=<action_name>\\n  Autonomous play: python runner.py mode=cycle\\n\\nNote: Requires GeoAware (port 50011) and MASt3R (port 50022) servers running on host.')"]
