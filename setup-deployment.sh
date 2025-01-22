#!/bin/bash

# Check if .env file exists
if [ ! -f .env ]; then
    echo "Copying .env.example to .env..."
    cp .env.example .env
    echo
    echo "WARNING: Please configure your .env file before running this script!"
    echo
    exit 1
fi

# Read components from .env file
DOCKER_USER=$(grep DOCKER_USER .env | cut -d '=' -f2 | tr -d ' ')
COMPOSE_PROJECT_NAME=$(grep COMPOSE_PROJECT_NAME .env | cut -d '=' -f2 | tr -d ' ')

# Construct IMAGE_NAME
IMAGE_NAME="${DOCKER_USER}/${COMPOSE_PROJECT_NAME}-web-api"

# Execute docker build
docker build -t "${IMAGE_NAME}:latest" \
    -f .docker/aspnet/Dockerfile \
    --build-arg USER_ID=1000 \
    --build-arg GROUP_ID=1000 \
    --build-arg ENVIRONMENT=development .

# Push the image
docker push "${IMAGE_NAME}:latest"

# Copy .env file to deployment directory
cp .env .deployment/.env

echo "Build completed successfully!"