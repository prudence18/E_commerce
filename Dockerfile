# Use a base image with necessary dependencies
FROM alpine:latest

# Set the working directory
WORKDIR /app

# Copy your artifact into the container
COPY target/ /app

# Expose any required ports
EXPOSE 80
