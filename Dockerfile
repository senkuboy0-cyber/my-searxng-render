FROM python:3.12-slim AS pybuilder
RUN pip install --no-cache-dir --target=/pypackages fastapi uvicorn httpx

FROM searxng/searxng:latest

COPY --from=pybuilder /pypackages /pypackages

ENV PYTHONPATH="/pypackages"
ENV SEARXNG_PORT=8080
ENV SEARXNG_SETTINGS_PATH=/etc/searxng/settings.yml

COPY searxng/settings.yml /etc/searxng/settings.yml
COPY app.py /app.py
COPY start.sh /start.sh

RUN chmod +x /start.sh && \
    chmod 644 /etc/searxng/settings.yml && \
    mkdir -p /var/cache/searxng && \
    chmod 777 /var/cache/searxng

EXPOSE 10000
CMD ["/start.sh"]
