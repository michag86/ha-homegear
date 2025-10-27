FROM homegear/homegear:latest

# Install additional dependencies
RUN apt-get update
RUN apt-get install -y vim rsync cron

# Copy scripts
COPY backup.sh /backup.sh
COPY restore.sh /restore.sh
COPY entrypoint.sh /entrypoint.sh

# Make scripts executable
RUN chmod +x /backup.sh
RUN chmod +x /restore.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/bin/bash", "-c", "/entrypoint.sh"]
