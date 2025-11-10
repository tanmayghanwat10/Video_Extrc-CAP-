FROM python:3.10-windowsservercore

# Add metadata labels
LABEL maintainer="tanmayghanwat17@gmail.com" \
      description="Video subtitle extraction using Whisper AI" \
      version="1.0"

# Download and install FFmpeg for Windows
RUN powershell -Command \
    Invoke-WebRequest -Uri https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip -OutFile ffmpeg.zip ; \
    Expand-Archive ffmpeg.zip -DestinationPath C:\ ; \
    Move-Item C:\ffmpeg-*\bin\ffmpeg.exe C:\Windows\System32\ ; \
    Remove-Item ffmpeg.zip ; \
    Remove-Item -Recurse C:\ffmpeg-*

# Set working directory
WORKDIR /app

# Install Python dependencies first (better layer caching)
COPY requirements.txt .
RUN pip install --no-cache-dir --trusted-host pypi.python.org --trusted-host files.pythonhosted.org --trusted-host pypi.org -r requirements.txt && \
    rm -rf ~/.cache/pip

# Create necessary directories
RUN mkdir -p /video /subtitles /output

# Copy application files
COPY extract_audio.py .
COPY input_sn_ai_video_extract_audio.txt .

# Volume mount points
VOLUME ["/video", "/subtitles", "/output"]

# Healthcheck to verify the container is ready
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python -c "import os; exit(0 if os.path.exists('/app/extract_audio.py') else 1)"

# Set Python to run in unbuffered mode (better logging)
ENV PYTHONUNBUFFERED=1

# Run the application
CMD ["python", "extract_audio.py"]