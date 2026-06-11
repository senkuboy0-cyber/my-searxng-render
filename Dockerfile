FROM searxng/searxng:latest

ENV SEARXNG_SETTINGS_PATH=/etc/searxng/settings.yml

COPY searxng/settings.yml /etc/searxng/settings.yml

RUN chmod 644 /etc/searxng/settings.yml && \
    mkdir -p /var/cache/searxng && \
    chmod 777 /var/cache/searxng

EXPOSE 10000
