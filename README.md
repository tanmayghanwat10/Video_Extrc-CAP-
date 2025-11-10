# sn_ai_video_extract_audio
# sn_ai_video_extract_audio

A Dockerized video moderator application that extracts subtitles (speech-to-text) from video files using OpenAI's Whisper model. The application runs entirely within a Docker container, making it platform-independent and easy to deploy.

## 🎯 Features

- Extracts audio from video files
- Generates subtitles using AI-powered speech-to-text
- Fully Dockerized for platform independence
- Records execution timestamps
- Outputs SRT format subtitles

## 📋 Prerequisites

- Docker installed on your system (if using Docker)
- Python 3.10+ for local runs
- FFmpeg installed and available on PATH (required by ffmpeg-python)

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/tanmayghanwat10/Video_Extrc-CAP-.git
cd Video_Extrc-CAP-
```

### 2. Configure Input File

Edit `input_sn_ai_video_extract_audio.txt` with your file paths:

```text
video_path: /path/to/your/video.mp4
subtitle_path: /path/to/output/subtitles.srt
output_path: /path/to/output/output.txt
keep_audio: false    # set to true to preserve extracted audio at ./output/extracted_audio.wav
```

### Local (Windows) / Virtualenv Quick Start

If you prefer to run locally on Windows (recommended for development), follow these steps in PowerShell:

```powershell
# create and activate a virtual environment
python -m venv venv
.\venv\Scripts\Activate.ps1

# install dependencies
pip install -r requirements.txt

# edit `input_sn_ai_video_extract_audio.txt` to point to your video file in `Input/` and desired outputs
# example values (relative to repository root):
# video_path: ./Input/your_video.mp4
# subtitle_path: ./output/subtitles.srt
# output_path: ./output/output.txt
# keep_audio: true  # set to true to keep extracted audio (output/extracted_audio.wav)

# run the script
python extract_audio.py
```

Outputs will be written to the `output/` directory:

- `subtitles.srt` — generated subtitles in SRT format
- `output.txt` — start/end timestamps of the run
- `extracted_audio.wav` — extracted WAV audio (kept only if `keep_audio: true`)

The script now supports a `keep_audio` flag in `input_sn_ai_video_extract_audio.txt` to control whether the extracted audio file is removed after transcription. By default the README example sets it to `false` to save disk space; set it to `true` if you want to keep the audio file for inspection or further processing.

### Docker Usage on Windows (Primary Method)

The application is designed to run in Docker for maximum compatibility. For Windows users:

1. Install [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop)
2. Make sure Docker Desktop is running
3. Open PowerShell and run:

```powershell
# Run the application using PowerShell script
.\run_video_extract.ps1
```

The shell script will:
1. Check for the input configuration file
2. Build the Docker image if needed
3. Run the container with proper volume mounts
4. Process the video and generate subtitles

#### Manual Docker Commands (if needed)

You can also run the Docker commands manually:

```bash
# Build the image
docker build -t video_extrc_cap .

# Run the container
docker run --rm \
  -e MODE=cli \
  -v "$(pwd)/input_sn_ai_video_extract_audio.txt:/app/input_sn_ai_video_extract_audio.txt:ro" \
  -v "$(pwd)/Input:/app/Input" \
  -v "$(pwd)/output:/app/output" \
  video_extrc_cap

# Run the web UI (exposes port 5000)
docker run --rm -p 5000:5000 \
  -e MODE=web \
  -v "$(pwd)/input_sn_ai_video_extract_audio.txt:/app/input_sn_ai_video_extract_audio.txt:ro" \
  -v "$(pwd)/Input:/app/Input" \
  -v "$(pwd)/output:/app/output" \
  video_extrc_cap
```

### Notes

- Ensure `ffmpeg` is installed and available on your system path for audio extraction to work.
- Whisper may download model weights the first time it runs. That may take extra time and disk space.

### License & Attribution
- Tanmay Ghanwat
