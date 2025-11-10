# sn_ai_video_extract_audio

A Dockerized video subtitle extraction application that extracts subtitles (speech-to-text) from video files using OpenAI's Whisper model. The application runs entirely within a Docker container, making it platform-independent and easy to deploy.

## 🎯 Features

- Extracts audio from video files
- Generates subtitles using AI-powered speech-to-text
- Fully Dockerized for platform independence
- Records execution timestamps
- Outputs SRT format subtitles

## 📋 Prerequisites

- Docker installed on your system

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/tanmayghanwat10/Video_Extrc-CAP-.git
cd Video_Extrc-CAP-
```

### 2. Configure Input File

Edit `input_sn_ai_video_extract_audio.txt` with your file paths:

```text
video_path : ./Input/sample_3_caption.mp4
subtitle_path : ./output/subtitles.srt
output_path : ./output/output.txt
```

### 3. Run the Application

Execute the shell script:

```bash
./sn_ai_video_extract_audio.sh
```

The script will:
1. Check for the input configuration file
2. Build the Docker image
3. Run the container with proper volume mounts
4. Process the video and generate subtitles

### Manual Docker Commands

You can also run the Docker commands manually:

```bash
# Build the image
docker build -t sn_ai_video_extract_audio .

# Run the container
docker run --rm \
  -v "$(pwd)/Input:/app/Input:ro" \
  -v "$(pwd)/output:/app/output" \
  sn_ai_video_extract_audio
```

### Output

Outputs will be written to the `output/` directory:

- `subtitles.srt` — generated subtitles in SRT format
- `output.txt` — start/end timestamps of the run (two lines: start time, end time)

### Notes

- Whisper may download model weights the first time it runs. That may take extra time and disk space.
- The application is designed to run in Docker for maximum compatibility.

### License & Attribution
- Tanmay Ghanwat
