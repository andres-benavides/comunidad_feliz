#!/bin/bash

set -e

echo "Starting containers in background..."
docker compose up -d

echo "Waiting for services to be ready..."
sleep 10

echo "Project is up and running."
