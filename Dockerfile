FROM python:3.10-slim

# -------------------- Metadata --------------------
LABEL maintainer="tanmayghanwat17@gmail.com" \
      org.opencontainers.image.title="sn_ai_video_extract_audio" \
      org.opencontainers.image.description="Extract subtitles from videos using Whisper." \
      version="1.0"

# -------------------- Arguments / Env --------------------
ARG USER=appuser
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

# -------------------- System deps --------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        ffmpeg \
        git \
        curl \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# -------------------- Create user and workdir --------------------
RUN useradd -m -s /bin/bash ${USER}
WORKDIR /app
RUN chown ${USER}:${USER} /app

# -------------------- Install Python deps (cached layer) --------------------
COPY requirements.txt /app/requirements.txt
RUN pip install --upgrade pip setuptools wheel && \
    pip install --no-cache-dir --prefer-binary -r /app/requirements.txt

# -------------------- Application files --------------------
COPY . /app
RUN mkdir -p /app/Input /app/output && chown -R ${USER}:${USER} /app/Input /app/output

USER ${USER}

# -------------------- Entrypoint --------------------
CMD ["python", "extract_audio.py"]
