# escape=`
FROM lacledeslan/steamcmd:linux as STEAMCMD

RUN echo "\n\nDownloading Valheim Dedicated Server via SteamCMD"; `
    mkdir --parents /output; `
    /app/steamcmd.sh +force_install_dir /output +login anonymous +app_update 896660 validate +quit;

#=======================================================================`
FROM debian:bookworm-slim

ARG BUILDNODE=unspecified
ARG SOURCE_COMMIT=unspecified

HEALTHCHECK NONE

RUN apt-get update && apt-get install -y --no-install-recommends --no-install-suggests `
        ca-certificates libatomic1 libpulse-dev libpulse0 locales locales-all tini tmux &&`
    apt-get clean &&`
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*;

ENV LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8

# Set up Enviornment
RUN useradd --home /app --gid root --system VALHEIM &&`
    mkdir -p /app &&`
    chown VALHEIM:root -R /app;

# `RUN true` lines are work around for https://github.com/moby/moby/issues/36573
COPY --chown=VALHEIM:root --from=STEAMCMD /output /app
RUN true

USER VALHEIM

WORKDIR /app

CMD ["/bin/bash"]

ONBUILD USER root
