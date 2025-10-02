#!/bin/bash

set -e

echo "Running tests from api_comunidad..."
docker compose exec api_comunidad sh -c "RAILS_ENV=test bundle exec rspec"


