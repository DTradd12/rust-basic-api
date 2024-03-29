# Stage 1: Building the Rust application
FROM rustlang/rust:nightly AS build

# Set the working directory
WORKDIR /basic-api

# Copy the source code and build files
COPY ./src ./src
COPY Cargo.toml .
COPY Cargo.lock .

# Build the application
RUN cargo build --locked --release

# Stage 2: Final application runtime
FROM debian:bullseye-slim AS final

# Create a non-privileged user that the app will run under.
ARG UID=10001
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    appuser

# Set the working directory
WORKDIR /app

# **Copy the built application from the build stage**
COPY --from=build /basic-api/target/release/basic-api /app/basic-api

# Copy SSL certificate file from the host machine to the Docker container
COPY cert.pem /etc/ssl/cert.pem

# Switch to non-root user
USER appuser

# Configure Rocket to listen on all interfaces.
ENV ROCKET_ADDRESS=0.0.0.0

# Expose the port that the application listens on
EXPOSE 9000

# Stage 3: final with volume mount
FROM final

CMD ["/app/basic-api"]