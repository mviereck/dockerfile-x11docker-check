# x11docker/check
# 
# Run several security and privacy checks in a docker container on X

FROM debian:jessie
RUN apt-get update
RUN apt-get install -y \
    feh \
    kaptain \
    libcap2-bin \
    libpulse0 \
    alsa-utils \
    mesa-utils \
    mesa-utils-extra \
    mousepad \
    pulseaudio \
    vgrabbj \
    wmctrl \
    x11-apps \
    x11-xkb-utils \
    x11-utils \
    x11-xserver-utils \
    xboard \
    xclip \
    xdotool \
    xfce4-terminal \
    xinput \
    xterm \
    xrestop \
    xtrace \
    xwit

# install glxspheres
RUN apt-get install -y wget && \
    wget https://downloads.sourceforge.net/project/virtualgl/2.6.1/virtualgl_2.6.1_amd64.deb -O /opt/virtualgl.deb && \
    cd /opt && dpkg -i ./virtualgl.deb && \
    apt-get remove -y wget && apt-get autoremove -y
ENV PATH=$PATH:/opt/VirtualGL/bin

RUN mkdir -p /opt/bin

# POC to read GPU VRAM
# thanks to https://hsmr.cc/palinopsia/
COPY palinopsia.cpp /opt/
RUN apt-get install -y g++ libsdl2-dev libsdl2-2.0-0 && \
    g++ /opt/palinopsia.cpp -std=c++11 `pkg-config --libs --cflags sdl2` -o /opt/bin/palinopsia && \
    apt-get remove -y g++ libsdl2-dev && \
    apt-get -y autoremove

COPY bin/* /opt/bin/
ENV PATH=$PATH:/opt/bin

RUN chmod +x  /opt/bin/* ;\
    chmod u+s /sbin/capsh

CMD containercheck.kaptn
