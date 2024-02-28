#!/bin/bash

cd "$(dirname "$0")/.."

docker-compose build app

docker tag "dev-build_app" "evilgenius13/manatrends:latest"

docker push "evilgenius13/manatrends:latest"