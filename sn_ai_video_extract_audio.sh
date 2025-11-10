#!/bin/bash

echo "==================================="
echo "Video Audio Extraction Application"
echo "==================================="

# Check if input file exists
INPUT_FILE="input_sn_ai_video_extract_audio.txt"

if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Input file '$INPUT_FILE' not found!"
    exit 1
fi

echo "Input file found: $INPUT_FILE"
echo ""

# Build Docker image
echo "Building Docker image..."
docker build -t sn_ai_video_extract_audio .

if [ $? -ne 0 ]; then
    echo "Error: Docker build failed!"
    exit 1
fi

echo "Docker image built successfully!"
echo ""

# Read paths from input file
VIDEO_PATH=$(grep "video_path" "$INPUT_FILE" | cut -d':' -f2- | xargs)
SUBTITLE_PATH=$(grep "subtitle_path" "$INPUT_FILE" | cut -d':' -f2- | xargs)
OUTPUT_PATH=$(grep "output_path" "$INPUT_FILE" | cut -d':' -f2- | xargs)

echo "Configuration:"
echo "  Video: $VIDEO_PATH"
echo "  Subtitle: $SUBTITLE_PATH"
echo "  Output: $OUTPUT_PATH"
echo ""

# Run Docker container
echo "Starting Docker container..."
docker run --rm \
    -v "$(pwd)/Input:/app/Input:ro" \
    -v "$(pwd)/output:/app/output" \
    sn_ai_video_extract_audio

if [ $? -eq 0 ]; then
    echo ""
    echo "==================================="
    echo "Processing completed successfully!"
    echo "==================================="
else
    echo ""
    echo "Error: Processing failed!"
    exit 1
fi
