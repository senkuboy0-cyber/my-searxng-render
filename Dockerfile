FROM searxng/searxng:latest

ENV SEARXNG_SETTINGS_PATH=/etc/searxng/settings.yml
ENV SEARXNG_BASE_URL="/"

COPY searxng/settings.yml /etc/searxng/settings.yml

EXPOSE 7860

CMD ["searxng"]