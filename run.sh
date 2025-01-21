#!/bin/bash
docker compose down -f docker-compose.development.yaml -v
docker compose -f docker-compose.development.yaml up -d