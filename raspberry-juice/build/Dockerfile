ARG SPIGOT_VERSION=1.12.2
ARG RJUICE_BRANCH=1_12_1
ARG RJUICE_VERSION=1.12.1

FROM alpine AS builder
ARG SPIGOT_VERSION
ARG RJUICE_BRANCH

RUN apk add git openjdk8 maven

RUN mkdir /raspberryjuice
WORKDIR /raspberryjuice

RUN git clone https://hub.spigotmc.org/stash/scm/spigot/buildtools.git
RUN cd buildtools && mvn install
RUN java -jar buildtools/target/BuildTools.jar --rev $SPIGOT_VERSION

RUN git clone https://github.com/zhuowei/RaspberryJuice.git
RUN cd RaspberryJuice && git checkout $RJUICE_BRANCH && mvn install

FROM alpine
ARG SPIGOT_VERSION
ARG RJUICE_VERSION

RUN apk add openjdk8-jre

RUN mkdir -p /raspberryjuice/plugins
WORKDIR /raspberryjuice
COPY --from=builder /raspberryjuice/spigot-$SPIGOT_VERSION.jar /raspberryjuice
COPY --from=builder /raspberryjuice/RaspberryJuice/target/raspberryjuice-$RJUICE_VERSION.jar /raspberryjuice/plugins

RUN echo "eula=true" > eula.txt
RUN echo "[]" > banned-ips.json
RUN echo "[]" > banned-players.json
RUN echo "[]" > ops.json
RUN echo "[]" > usercache.json
RUN echo "[]" > whitelist.json

RUN echo '#!/bin/sh' > start.sh \
	&& echo 'cd "$(dirname "$0")"' >> start.sh \
	&& echo "exec java -Xms3G -Xmx3G -XX:+UseG1GC -XX:+UnlockExperimentalVMOptions -XX:MaxGCPauseMillis=100 -XX:+DisableExplicitGC -XX:TargetSurvivorRatio=90 -XX:G1NewSizePercent=50 -XX:G1MaxNewSizePercent=80 -XX:G1MixedGCLiveThresholdPercent=50 -XX:+AlwaysPreTouch -jar spigot-$SPIGOT_VERSION.jar" >> start.sh \
	&& chmod 755 start.sh

ENTRYPOINT ["/raspberryjuice/start.sh"]
