#!/bin/bash

# ------------------------------
# Docker Upload Script
# ------------------------------

# Load config values
if [ -f "./config.env" ]; then
    echo "📂 Loading config.env..."
    source ./config.env
else
    echo "❌ config.env not found!"
    exit 1
fi

# Required variables from config.env
: "${DOCKER_REGISTRY:?DOCKER_REGISTRY not set in config.env}"
: "${DOCKER_USER:?DOCKER_USER not set in config.env}"
: "${PROJECT_NAME:?PROJECT_NAME not set in config.env}"
: "${VERSION:?VERSION not set in config.env}"

IMAGE="$DOCKER_REGISTRY/$DOCKER_USER/$PROJECT_NAME:$VERSION"

echo "🐳 Building Docker image: $IMAGE"
docker build -t "$IMAGE" .

if [ $? -ne 0 ]; then
    echo "❌ Docker build failed"
    exit 1
fi

echo "🔑 Logging in to $DOCKER_REGISTRY..."
docker login "$DOCKER_REGISTRY" -u "$DOCKER_USER"

if [ $? -ne 0 ]; then
    echo "❌ Docker login failed"
    exit 1
fi

echo "📤 Pushing Docker image: $IMAGE"
docker push "$IMAGE"

if [ $? -ne 0 ]; then
    echo "❌ Docker push failed"
    exit 1
fi

echo "✅ Successfully uploaded $IMAGE"
