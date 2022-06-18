FROM alpine

RUN apk add openjdk8 expect

RUN mkdir /minecraft-server \
    && cd /minecraft-server \
    && wget https://maven.minecraftforge.net/net/minecraftforge/forge/1.16.5-36.2.34/forge-1.16.5-36.2.34-installer.jar
RUN cd /minecraft-server/ && java -jar forge-1.16.5-36.2.34-installer.jar --installServer .

COPY start.sh /minecraft-server/
COPY expect-stopserver /minecraft-server/
RUN chmod 755 /minecraft-server/start.sh \
    && chmod 755 /minecraft-server/expect-stopserver

RUN cd /minecraft-server/ && echo "eula=true" > eula.txt
RUN cd /minecraft-server && ./expect-stopserver

RUN cd /minecraft-server/mods && wget -O Pixelmon-1.16.5-9.0.2.jar https://dl.reforged.gg/3ztLCIB

ENTRYPOINT /minecraft-server/start.sh
