#!/bin/bash
set -euo pipefail

# Simple entrypoint that supports two modes:
# MODE=web  -> run Flask web UI (webapp/app.py)
# MODE=cli  -> run extract_audio.py directly
# Default: web

MODE=${MODE:-web}

case "$MODE" in
  web)
    echo "Starting web server (Flask) on port 5000..."
    # Prefer Gunicorn if available for production-like behavior
    if command -v gunicorn >/dev/null 2>&1; then
      exec gunicorn -w 1 -b 0.0.0.0:5000 webapp.app:app
    else
      exec python webapp/app.py
    fi
    ;;
  cli)
    echo "Running CLI extraction: python extract_audio.py"
    exec python extract_audio.py
    ;;
  shell)
    echo "Opening shell - any scripts you add under /app/scripts are available"
    exec /bin/bash
    ;;
  *)
    echo "Unknown MODE: $MODE"
    exit 2
    ;;
esac
