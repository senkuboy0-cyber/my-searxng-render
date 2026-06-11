FROM searxng/searxng:latest

ENV SEARXNG_SETTINGS_PATH=/etc/searxng/settings.yml

COPY searxng/settings.yml /etc/searxng/settings.yml

EXPOSE 8080
