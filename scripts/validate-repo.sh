#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

echo "=== Project Hestia Repository Validation ==="

echo
echo "[1/4] Checking Compose syntax..."

if command -v docker >/dev/null 2>&1; then
    docker compose \
        --env-file .env.example \
        -f compose/compose.yaml \
        config --quiet

    echo "PASS: Compose configuration is valid."
else
    echo "SKIP: Docker not installed."
fi

echo
echo "[2/4] Checking for production secret files..."

if find . \
    -path './.git' -prune -o \
    \( -name 'secrets.yml' -o \
       -name 'secrets.yaml' -o \
       -name '.env' \) \
    -print | grep -q .; then

    echo "FAIL: Production secret file found inside repository."
    exit 1
fi

echo "PASS: No production secret files found."

echo
echo "[3/4] Checking for common credential patterns..."

if grep -RniE \
    --exclude-dir=.git \
    --exclude='*.example.yml' \
    --exclude='*.example.yaml' \
    --exclude='.env.example' \
    --exclude='validate-repo.sh' \
    --exclude='*.md' \
    --exclude='validate-repo.sh' \
    --exclude='*.md' \
    '(password|passwd|bearer[[:space:]]+[A-Za-z0-9]|api[_-]?key:[[:space:]]+[A-Za-z0-9])' \
    .; then

    echo
    echo "WARNING: Review matches above before publishing."
else
    echo "PASS: No obvious embedded credentials detected."
fi

echo
echo "[4/4] Git status..."
git status --short

echo
echo "Validation complete."
