FROM searxng/searxng:latest
# Set environment variables
ENV SEARXNG_SETTINGS_PATH=/etc/searxng/settings.yml
# Copy custom settings
COPY searxng/settings.yml /etc/searxng/settings.yml
EXPOSE 8080
CMD ["searxng"]