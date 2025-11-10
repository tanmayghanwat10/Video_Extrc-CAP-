FROM python:3.10-slim

# -------------------- Metadata --------------------
LABEL maintainer="tanmayghanwat17@gmail.com" \
      org.opencontainers.image.title="sn_ai_video_extract_audio" \
      org.opencontainers.image.description="Extract subtitles from videos using Whisper; supports CLI and web modes." \
      version="1.0"

# -------------------- Arguments / Env --------------------
ARG USER=appuser
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    POETRY_VIRTUALENVS_CREATE=false

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
RUN chmod +x /app/sn_ai_video_extract_audio.sh || true
RUN mkdir -p /app/scripts && chown -R ${USER}:${USER} /app/scripts /app/Input /app/output

# -------------------- Expose ports and volumes --------------------
EXPOSE 5000
VOLUME ["/app/Input", "/app/output", "/app/scripts"]

# -------------------- Entrypoint --------------------
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

USER ${USER}
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["--help"]