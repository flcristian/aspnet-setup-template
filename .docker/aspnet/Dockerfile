# .docker/aspnet/Dockerfile
# Get global arguments
ARG USERNAME=dotnet
ARG GROUPNAME=dotnet
ARG USER_ID=1000
ARG GROUP_ID=1000
ARG ENVIRONMENT
ARG BUILD_DATE
ARG REVISION

# Base image
FROM mcr.microsoft.com/dotnet/sdk:9.0-alpine

# Labels
LABEL maintainer="flcristian (qflorescucristian@gmail.com)"
LABEL org.opencontainers.image.created=${BUILD_DATE}
LABEL org.opencontainers.image.revision=${REVISION}
LABEL org.opencontainers.image.title=".NET Development Image"
LABEL org.opencontainers.image.description="Development-friendly .NET Docker image"

# Set local arguments
ARG USERNAME
ARG GROUPNAME
ARG USER_ID
ARG GROUP_ID
ARG ENVIRONMENT

# Set environment variables
ENV USERNAME=${USERNAME:-dotnet}
ENV GROUPNAME=${GROUPNAME:-dotnet}
ENV USER_ID=${USER_ID:-1000}
ENV GROUP_ID=${GROUP_ID:-1000}
ENV ENVIRONMENT=${ENVIRONMENT:-production}
ENV ASPNETCORE_ENVIRONMENT=${ENVIRONMENT:-production}
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1
ENV DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1
ENV NUGET_XMLDOC_MODE=skip

# Install required packages and create user
RUN apk add --no-cache curl && \
    addgroup -g ${GROUP_ID} ${GROUPNAME} && \
    adduser -D -u ${USER_ID} -G ${GROUPNAME} ${USERNAME}

# Create necessary directories and set permissions
RUN mkdir -p /app /app/tmp && \
    chown -R ${USERNAME}:${GROUPNAME} /app

# Set working directory
WORKDIR /app

# Copy the application files from the correct context
COPY --chown=${USERNAME}:${GROUPNAME} ../../ .

# Expose ports
EXPOSE 8080

# Healthcheck
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
    CMD curl -f http://localhost:8080/health || exit 1

# Run the app with watch
CMD find . -name "*.csproj" -type f -exec dotnet watch run --project {} \;