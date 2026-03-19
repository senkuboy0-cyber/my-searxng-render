FROM searxng/searxng:latest
# Copy the settings file from the repository to the expected location in the container
COPY searxng/settings.yml /etc/searxng/settings.yml
EXPOSE 8080
CMD ["searxng"]