FROM ubuntu:24.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    dpkg-dev libglib2.0-bin nodejs gjs gnome-shell gir1.2-adw-1 xvfb xauth shellcheck \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /source
COPY src/ ./src/
COPY icons/ ./icons/
COPY schemas/ ./schemas/
COPY LICENSE README.md ./
COPY packaging/ ./packaging/
ARG PACKAGE_VERSION=0.1.0~ubuntu24.04-1
RUN PACKAGE_VERSION="$PACKAGE_VERSION" bash packaging/build-deb.sh

CMD ["bash", "-c", "cp /packages/*.deb /out/"]
