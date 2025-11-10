import os
import sys
import whisper
import ffmpeg
from datetime import datetime

def log_time(output_path, time_str, mode='a'):
    """Write timestamp to output file"""
    with open(output_path, mode) as f:
        f.write(time_str + '\n')

def extract_audio_from_video(video_path, audio_path):
    """Extract audio from video file using ffmpeg"""
    try:
        print(f"Extracting audio from: {video_path}")
        (
            ffmpeg
            .input(video_path)
            .output(audio_path, acodec='pcm_s16le', ac=1, ar='16000')
            .overwrite_output()
            .run(capture_stdout=True, capture_stderr=True)
        )
        print(f"Audio extracted to: {audio_path}")
        return True
    except ffmpeg.Error as e:
        print(f"Error extracting audio: {e.stderr.decode()}")
        return False

def generate_subtitles(audio_path, subtitle_path):
    """Generate subtitles using Whisper speech-to-text"""
    try:
        print("Loading Whisper model...")
        model = whisper.load_model("base")
        
        print("Transcribing audio...")
        result = model.transcribe(audio_path)
        
        # Generate SRT format subtitles
        with open(subtitle_path, 'w', encoding='utf-8') as f:
            for i, segment in enumerate(result['segments'], start=1):
                start_time = format_timestamp(segment['start'])
                end_time = format_timestamp(segment['end'])
                text = segment['text'].strip()
                
                f.write(f"{i}\n")
                f.write(f"{start_time} --> {end_time}\n")
                f.write(f"{text}\n\n")
        
        print(f"Subtitles generated: {subtitle_path}")
        return True
    except Exception as e:
        print(f"Error generating subtitles: {str(e)}")
        return False

def format_timestamp(seconds):
    """Convert seconds to SRT timestamp format (HH:MM:SS,mmm)"""
    hours = int(seconds // 3600)
    minutes = int((seconds % 3600) // 60)
    secs = int(seconds % 60)
    millis = int((seconds % 1) * 1000)
    return f"{hours:02d}:{minutes:02d}:{secs:02d},{millis:03d}"

def read_config(config_path):
    """Read configuration from input file"""
    config = {}
    try:
        with open(config_path, 'r') as f:
            for line in f:
                line = line.strip()
                if ':' in line:
                    key, value = line.split(':', 1)
                    config[key.strip()] = value.strip()
        return config
    except Exception as e:
        print(f"Error reading config: {str(e)}")
        return None

def main():
    # Read configuration
    config_path = 'input_sn_ai_video_extract_audio.txt'
    config = read_config(config_path)
    
    if not config:
        print("Failed to read configuration file")
        sys.exit(1)
    
    video_path = config.get('video_path')
    subtitle_path = config.get('subtitle_path')
    output_path = config.get('output_path')
    # Optional: whether to keep the extracted audio file. Set to 'true' to keep.
    keep_audio = config.get('keep_audio', 'false').lower() == 'true'
    
    if not all([video_path, subtitle_path, output_path]):
        print("Missing required configuration parameters")
        sys.exit(1)
    
    # Record start time
    start_time = datetime.now()
    start_time_str = start_time.strftime('%d/%m/%Y %H:%M:%S')
    log_time(output_path, start_time_str, mode='w')
    
    print(f"=== Starting Video Audio Extraction ===")
    print(f"Start Time: {start_time_str}")
    
    # Extract audio
    temp_audio = 'output/extracted_audio.wav'
    if not extract_audio_from_video(video_path, temp_audio):
        print("Failed to extract audio")
        sys.exit(1)
    
    # Generate subtitles
    if not generate_subtitles(temp_audio, subtitle_path):
        print("Failed to generate subtitles")
        sys.exit(1)
    
    # Record end time
    end_time = datetime.now()
    end_time_str = end_time.strftime('%d/%m/%Y %H:%M:%S')
    log_time(output_path, end_time_str)
    
    # Calculate execution time
    execution_time = (end_time - start_time).total_seconds()
    
    print(f"End Time: {end_time_str}")
    print(f"=== Total Execution Time: {execution_time:.2f} seconds ===")
    
    # Cleanup (remove temp audio unless user asked to keep it)
    if os.path.exists(temp_audio) and not keep_audio:
        os.remove(temp_audio)
    elif os.path.exists(temp_audio) and keep_audio:
        print(f"Extracted audio saved at: {temp_audio}")

if __name__ == '__main__':
    main()