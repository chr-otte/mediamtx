# --- Stage 1: The Builder ---
# We use the official Go image to compile the source code
FROM golang:1.23-alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the source code from your Windows machine to the container
COPY . .

# Download dependencies and compile the code
# CGO_ENABLED=0 creates a static binary that works anywhere
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux go build -o mediamtx .

# --- Stage 2: The Runner ---
# We use a tiny Alpine Linux image to run the server
FROM alpine:latest

# Install basic certificates (needed for HTTPS/RTSP)
RUN apk add --no-cache ca-certificates

WORKDIR /

# Copy the compiled program and the config file from the Builder stage
COPY --from=builder /app/mediamtx .
COPY --from=builder /app/mediamtx.yml .

# Open the necessary ports
EXPOSE 8554 1935 8888 8889

# Run the program
ENTRYPOINT ["./mediamtx"]