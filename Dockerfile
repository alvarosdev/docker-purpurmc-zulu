# -- Build ---
FROM azul/zulu-openjdk-debian:17-latest AS build
LABEL Sebas Álvaro <https://asgg.cl>

ARG TARGETARCH
ARG MCVERSION=1.19.3

RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/minecraft

RUN rm /opt/minecraft/purpurmc.jar || true
COPY ./getpurpurserver.sh /getpurpurserver.sh
RUN chmod +x /getpurpurserver.sh && \
    /getpurpurserver.sh ${MCVERSION}

# --- Runtime ---
FROM azul/zulu-openjdk-debian:17-latest AS runtime
RUN apt-get update && apt-get install -y \
    curl \
    jq \
    && rm -rf /var/lib/apt/lists/*

ARG TARGETARCH
ARG GOSUVERSION=1.16
ARG RCON_CLI_VER=1.6.0

RUN set -eux && \
    curl -fsSL "https://github.com/tianon/gosu/releases/download/${GOSUVERSION}/gosu-${TARGETARCH}" -o /usr/bin/gosu && \
    chmod +x /usr/bin/gosu && \
    gosu nobody true

WORKDIR /data
COPY --from=build /opt/minecraft/purpurmc.jar /opt/minecraft/purpurmc.jar

ADD https://github.com/itzg/rcon-cli/releases/download/${RCON_CLI_VER}/rcon-cli_${RCON_CLI_VER}_linux_${TARGETARCH}.tar.gz /tmp/rcon-cli.tgz
RUN tar -x -C /usr/local/bin -f /tmp/rcon-cli.tgz rcon-cli && \
    rm /tmp/rcon-cli.tgz

VOLUME "/data"

EXPOSE 25565/tcp
EXPOSE 25565/udp

ARG memory_size=1G
ENV MEMORYSIZE=$memory_size

ARG java_flags="--add-modules=jdk.incubator.vector -Dlog4j2.formatMsgNoLookups=true -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=mcflags.emc.gs -Dcom.mojang.eula.agree=true"
ENV JAVAFLAGS=$java_flags

ARG papermc_flags="--nojline"
ENV PAPERMC_FLAGS=$papermc_flags

ARG purpurmc_flags="-DPurpur.IReallyDontWantSpark=true"
ENV PURPURMC_FLAGS=$purpurmc_flags

WORKDIR /data

COPY /docker-entrypoint.sh /opt/minecraft
RUN chmod +x /opt/minecraft/docker-entrypoint.sh

# Entrypoint
ENTRYPOINT ["/opt/minecraft/docker-entrypoint.sh"]