#!/usr/bin/env bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Stopping farmOS containers..."
cd "$DIR/farmOS"
docker compose stop

echo "Stopping any running Field Kit Vite dev server on port 8080..."
lsof -ti :8080 | xargs kill -9 2>/dev/null || true

echo "All farmOS services stopped."
