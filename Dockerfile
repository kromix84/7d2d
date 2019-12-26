FROM ubuntu:latest
MAINTAINER kromix84@gmail.com

# Install dependencies
RUN dpkg --add-architecture i386 && \
        apt-get update && \
        apt-get install -y --no-install-recommends --no-install-suggests \
        lib32stdc++6 \
        lib32gcc1 \
        xmlstarlet \
        make \
        gcc \
        wget \
        telnet \
        pulseaudio \
        ca-certificates
# pulseaudio was a possible fix, still testing, might remove

# Create workspace for server
WORKDIR /home/steam

# Downloading Steam cmd
RUN wget http://media.steampowered.com/installer/steamcmd_linux.tar.gz
RUN mkdir ./bin && tar -zxf steamcmd_linux.tar.gz -C ./bin

# Downloading 7Days Server
RUN mkdir -p /home/steam/server
RUN /home/steam/bin/steamcmd.sh \
        +login anonymous \
        +force_install_dir /home/steam/server \
        +app_update 294420 \
        +quit

# Cleanup junk
RUN apt-get remove --purge -y \
        && apt-get clean autoclean \
        && apt-get autoremove -y \
        && rm -rf /var/lib/apt/lists/*

# Saves Directory
RUN mkdir -p /root/.local/share/7DaysToDie/Saves

# Expose ports
EXPOSE 8080/tcp 8081/tcp
EXPOSE 26900-26902 26900-26902/udp

# Starting server on docker start
CMD export LD_LIBRARY_PATH=/home/steam/server && \
    /home/steam/server/7DaysToDieServer.x86_64 \
        -configfile=/home/steam/server/serverconfig.xml \
        -logfile /home/steam/server/output.log \
        -quit -batchmode -nographics -dedicated $@
