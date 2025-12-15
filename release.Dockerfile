# Start with the official image
FROM bluenviron/mediamtx:latest

# Copy your configuration file
COPY mediamtx.yml /mediamtx.yml

# Copy your certificates
COPY server.crt /server.crt
COPY server.key /server.key

# Expose necessary ports (TCP and UDP)
EXPOSE 8554
EXPOSE 1935
EXPOSE 8888
EXPOSE 8889
EXPOSE 8189/udp