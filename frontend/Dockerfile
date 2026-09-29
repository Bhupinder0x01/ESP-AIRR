FROM ghcr.io/cirruslabs/flutter:stable

WORKDIR /src
COPY macless_haystack/ /src/

ARG BASE_HREF=/
RUN flutter pub get \
    && flutter test \
    && flutter build web --release --base-href "${BASE_HREF}"

# Retrieve the reproducible output with:
# docker build -f frontend/Dockerfile -t airtag-web .
# docker create --name airtag-web-export airtag-web
# docker cp airtag-web-export:/src/build/web ./build/web
