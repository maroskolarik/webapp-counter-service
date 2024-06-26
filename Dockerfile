ARG PYTHON_VERSION=3.12
FROM python:${PYTHON_VERSION}-alpine3.19 as base

# Prevents Python from writing pyc files.
ENV PYTHONDONTWRITEBYTECODE=1

# Keeps Python from buffering stdout and stderr to avoid situations where
# the application crashes without emitting any logs due to buffering.
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Create a non-privileged user that the app will run under.
# See https://docs.docker.com/go/dockerfile-user-best-practices/
ARG UID=10001
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    appuser

# Set appropriate permissions for the directory
RUN mkdir /data && chown -R appuser /data

# Download dependencies as a separate step to take advantage of Docker's caching.
# Leverage a cache mount to /root/.cache/pip to speed up subsequent builds.
# Leverage a bind mount to requirements.txt to avoid having to copy them into
# into this layer.
RUN --mount=type=cache,target=/root/.cache/pip \
    --mount=type=bind,source=requirements.txt,target=requirements.txt \
    python -m pip install -r requirements.txt

# Switch to the non-privileged user to run the application.
USER appuser

# Copy the source code(webapp.py) into the container.
COPY src/webapp.py .

# Expose the port that the application listens on.
# In most Unix-like operating systems, binding to ports below 1024 requires elevated privileges.
# This application runs on Docker as an appuser, which is restricted to binding to ports below 1024.
EXPOSE 8080

# Add simple healthcheck
HEALTHCHECK  --interval=30s --timeout=3s \
  CMD wget --no-verbose --tries=2 --spider http://localhost:8080/health || exit 1

# Run the application.Logs enabled to see the output logs
CMD ["gunicorn", "webapp:app", "--bind", "0.0.0.0:8080", "--access-logfile", "-", "--error-logfile", "-"]
