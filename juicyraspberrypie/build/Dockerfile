ARG SPIGOT_VERSION=1.18.1
ARG RJUICE_TAG=v0.3
ARG RJUICE_VERSION=1.18.1

FROM alpine:latest AS builder
ARG SPIGOT_VERSION
ARG RJUICE_BRANCH

RUN apk add git openjdk17 maven

RUN mkdir /juicyraspberrypie
WORKDIR /juicyraspberrypie

RUN git clone https://hub.spigotmc.org/stash/scm/spigot/buildtools.git
RUN cd buildtools && mvn install
RUN java -jar buildtools/target/BuildTools.jar --rev $SPIGOT_VERSION

RUN git clone https://github.com/wensheng/JuicyRaspberryPie.git

RUN mvn install:install-file -Dfile=spigot-$SPIGOT_VERSION.jar -DgroupId=org.spigotmc -DartifactId=spigot -Dversion=$SPIGOT_VERSION-R0.1-SNAPSHOT -Dpackaging=jar

RUN cd JuicyRaspberryPie \
        && git checkout $RJUICE_TAG \
        && cd bukkit \
        && mvn dependency:build-classpath
RUN cd JuicyRaspberryPie \
        && git checkout $RJUICE_TAG \
        && cd bukkit \
        && mvn package

FROM alpine:latest
ARG SPIGOT_VERSION
ARG RJUICE_VERSION

RUN apk add openjdk17-jre

RUN mkdir -p /juicyraspberrypie/plugins
WORKDIR /juicyraspberrypie
COPY --from=builder /juicyraspberrypie/spigot-$SPIGOT_VERSION.jar /juicyraspberrypie
COPY --from=builder /juicyraspberrypie/JuicyRaspberryPie/bukkit/target/juicyraspberrypie-$RJUICE_VERSION.jar /juicyraspberrypie/plugins

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

ENTRYPOINT ["/juicyraspberrypie/start.sh"]
