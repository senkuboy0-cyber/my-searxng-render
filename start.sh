#!/bin/sh
SEARXNG_PORT=8080 /usr/local/searxng/dockerfiles/docker-entrypoint.sh &
python3 /app.py
