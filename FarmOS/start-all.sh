#!/usr/bin/env bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "===================================="
echo "Starting farmOS Backend..."
echo "===================================="
cd "$DIR/farmOS"
docker compose up -d

echo "===================================="
echo "farmOS Backend is running at:"
echo "  http://localhost:8000"
echo "  http://localhost"
echo "  Username: admin"
echo "  Password: admin"
echo "===================================="

echo ""
echo "===================================="
echo "Starting farmOS Field Kit..."
echo "===================================="
cd "$DIR/field-kit"
echo "Field Kit will be available at: http://localhost:8080"
npm start
