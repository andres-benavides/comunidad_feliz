#!/usr/bin/env bash
set -e

SERVICE="api_comunidad"

echo "Building and starting containers..."
docker compose up -d --build

echo "Waiting a moment for services..."
sleep 8

echo "Creating, migrating and seeding (development)..."
docker compose exec -T "$SERVICE" bash -lc "bin/rails db:create db:migrate db:seed"

echo "Done."
