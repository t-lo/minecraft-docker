FROM alpine:3.21

ARG pack_id version_id

RUN apk add openjdk21-jre rsync

RUN mkdir /minecraft-server \
    && cd /minecraft-server \
    && wget https://api.feed-the-beast.com/v1/modpacks/public/modpack/${pack_id}/${version_id}/server/linux \
       -O serverinstall_${pack_id}_${version_id} \
    && chmod 755 serverinstall_${pack_id}_${version_id} 

RUN cd /minecraft-server \
    && ./serverinstall_${pack_id}_${version_id} -auto -no-java \
    && echo "eula=true" > eula.txt

COPY entry.sh /
RUN chmod 755 /entry.sh
ENTRYPOINT [ "/entry.sh" ]
