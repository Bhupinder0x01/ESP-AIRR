FROM python:3.12-slim

# This image deliberately uses the source copied into the build context.  Do
# not pull upstream at startup: that would silently discard this repository's
# Apple-authentication compatibility fixes.
ENV TERM=xterm \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1
WORKDIR /app

COPY endpoint/requirements.txt /app/endpoint/requirements.txt
RUN apt-get update \
    && apt-get install -y --no-install-recommends nano \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r /app/endpoint/requirements.txt

COPY endpoint /app/endpoint

EXPOSE 6176
CMD ["python", "-u", "/app/endpoint/mh_endpoint.py"]
