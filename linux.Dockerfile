FROM lacledeslan/steamcmd:linux as STEAMCMD

RUN echo "\n\nDownloading Valheim Dedicated Server via SteamCMD"; \
    mkdir --parents /output; \
    /app/steamcmd.sh +force_install_dir /output +login anonymous +app_update 896660 validate +quit;

#=======================================================================`
FROM debian:bookworm-slim

ARG BUILDNODE=unspecified
ARG BUILD_DATE
ARG SOURCE_COMMIT=unspecified
ARG TIMEZONE=UTC

ENV LANG=en_US.UTF-8
ENV LD_LIBRARY_PATH=./linux64:$LD_LIBRARY_PATH SteamAppId=892970

HEALTHCHECK NONE

RUN if [ -z "$BUILD_DATE" ]; then export BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ'); fi

LABEL org.opencontainers.image.title=" Valheim Dedicated Server" \
      org.opencontainers.image.description="Valheim dedicated server, optimized for LAN-party environments." \
      org.opencontainers.image.url="https://lacledeslan.com" \
      org.opencontainers.image.source="https://github.com/LacledesLAN/gamesvr-valheim" \
      org.opencontainers.image.created=$BUILD_DATE \
      org.opencontainers.image.revision=$SOURCE_COMMIT \
      org.opencontainers.image.vendor="Laclede's LAN"

RUN apt-get update && apt-get install -y --no-install-recommends --no-install-suggests \
        ca-certificates libatomic1 libpulse-dev libpulse0 locales locales-all tini tmux tzdata &&\
    apt-get clean &&\
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* &&\
    # locales
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen &&\
    dpkg-reconfigure --frontend=noninteractive locales &&\
    update-locale LANG=en_US.UTF-8 &&\
    # Timezone
    if [ ! -f "/usr/share/zoneinfo/${TIMEZONE}" ]; then echo "ERROR: Invalid timezone: ${TIMEZONE}" && exit 87; fi &&\
    ln -fs /usr/share/zoneinfo/$TIMEZONE /etc/localtime &&\
    dpkg-reconfigure --frontend noninteractive tzdata &&\
    # Tini
    chmod +x /usr/bin/tini &&\
    # User
    useradd --home /app --gid root --system VALHEIM &&\
        mkdir -p /app &&\
        chown VALHEIM:root -R /app;

# `RUN true` lines are work around for https://github.com/moby/moby/issues/36573
COPY --chown=VALHEIM:root --from=STEAMCMD /output /app
RUN true

USER VALHEIM

WORKDIR /app

CMD ["/bin/bash"]

ONBUILD USER root
